import { Pool } from 'pg';
import { Product } from '../models/Product';

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'farmalider',
  password: 'karen',
  port: 5432,
});

pool.on('error', (err) => {
  console.error('Error en la base de datos', err);
});

export class ProductService {
  async getAllProducts(): Promise<Product[]> {
    const result = await pool.query(`
      SELECT 
        p.id,
        p.name,
        p.category,
        p.presentation,
        p.units,
        p.expiration_date,
        p.description,
        p.active_ingredient,
        p.brand,
        p.image,
        json_agg(
          json_build_object(
            'presentacion', pp.presentacion,
            'precio', pp.precio
          )
        ) AS price
      FROM products p
      LEFT JOIN product_prices pp ON p.id = pp.product_id
      GROUP BY p.id
      ORDER BY p.created_at DESC;
    `);

    return result.rows;
  }

  


  async getProductById(id: number): Promise<Product> {
    const result = await pool.query(`
      SELECT 
        p.id,
        p.name,
        p.category,
        p.presentation,
        p.units,
        p.expiration_date,
        p.description,
        p.active_ingredient,
        p.brand,
        p.image,
        json_agg(
          json_build_object(
            'presentacion', pp.presentacion,
            'precio', pp.precio
          )
        ) AS price
      FROM products p
      LEFT JOIN product_prices pp ON p.id = pp.product_id
      WHERE p.id = $1
      GROUP BY p.id
    `, [id]);

    return result.rows[0] ?? null;
  }

  async createProduct(product: Product): Promise<Product> {
  const {
    name, category, presentation, units, expiration_date,
    description, active_ingredient, brand, image, presentation_prices
  } = product;

  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    // Insertar el producto en la tabla 'products'
    const result = await client.query(`
      INSERT INTO products (
        name, category, presentation, units, expiration_date,
        description, active_ingredient, brand, image
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING id
    `, [
      name,
      category,
      presentation,
      units,
      expiration_date,
      description ?? null,
      active_ingredient ?? null,
      brand ?? null,
      image ?? null,
    ]);

    const productId = result.rows[0].id;

    // Insertar los precios por presentación
    for (const price of presentation_prices) {
      await client.query(`
        INSERT INTO product_prices (product_id, presentacion, precio)
        VALUES ($1, $2, $3)
      `, [productId, price.presentacion, price.precio]);
    }

    await client.query('COMMIT');

    // Devuelve el producto recién creado con los precios
    return await this.getProductById(productId);
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}



  async updateProduct(id: number, product: Product): Promise<Product | null> {
    const {
      name, category, presentation, units, expiration_date,
      description, active_ingredient, brand, image, presentation_prices
    } = product;

    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      // Actualizar el producto
      await client.query(`
        UPDATE products
        SET name = $1, category = $2, presentation = $3, units = $4, expiration_date = $5,
            description = $6, active_ingredient = $7, brand = $8, image = $9
        WHERE id = $10
      `, [
        name,
        category,
        presentation,
        units,
        expiration_date,
        description ?? null,
        active_ingredient ?? null,
        brand ?? null,
        image ?? null,
        id
      ]);

      // Eliminar precios anteriores
      await client.query(`DELETE FROM product_prices WHERE product_id = $1`, [id]);

      // Insertar los nuevos precios
      for (const p of presentation_prices) {
        await client.query(`
          INSERT INTO product_prices (product_id, presentacion, precio)
          VALUES ($1, $2, $3)
        `, [id, p.presentacion, p.precio]);
      }

      await client.query('COMMIT');
      return await this.getProductById(id); // para devolver el actualizado
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }
  
  async updateField(id: number, field: string, value: any): Promise<Product | null> {
    const client = await pool.connect();
    const allowedFields = [
      'name', 'category', 'presentation', 'units',
      'expiration_date', 'description', 'active_ingredient',
      'brand', 'image'
    ];

    if (!allowedFields.includes(field)) {
      throw new Error(`Campo no permitido: ${field}`);
    }

    try {
      await client.query('BEGIN');

      const updateQuery = `UPDATE products SET ${field} = $1 WHERE id = $2`;
      const result = await client.query(updateQuery, [value, id]);

      if (result.rowCount === 0) {
        await client.query('ROLLBACK');
        return null; // Producto no encontrado
      }

      await client.query('COMMIT');
      return await this.getProductById(id);
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }


  async decreaseStock(client: any, productId: number, quantity: number) {
    await client.query(
      `UPDATE products SET stock = stock - $1 WHERE id = $2 AND stock >= $1`,
      [quantity, productId]
    );
  }


  async deleteProduct(id: number): Promise<boolean> {
    const result = await pool.query('DELETE FROM products WHERE id = $1 RETURNING id', [id]);
    return result.rows.length > 0;
  }

  async getProductStock(id: number): Promise<number | undefined> {
    const result = await pool.query('SELECT units FROM products WHERE id = $1', [id]);
    return result.rows[0]?.units;
  }

  async getPresentationPrice(id: number, presentationType: string): Promise<number | null> {
    const result = await pool.query(`SELECT presentation_prices FROM products WHERE id = $1`, [id]);
    const prices = result.rows[0]?.presentation_prices;

    return prices?.[presentationType] ?? null;
  }

  // Otros métodos (por categoría, búsqueda, vencimientos...) los puedes ajustar igual eliminando "unit_price"
  async getProductsExpiringThisYear() {
    const res = await pool.query(`
      ${this.getProductBaseQuery}
      WHERE p.expiration_date IS NOT NULL
        AND p.expiration_date >= CURRENT_DATE
        AND EXTRACT(YEAR FROM p.expiration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
      GROUP BY p.id
      ORDER BY EXTRACT(MONTH FROM p.expiration_date), p.expiration_date;
    `);
    return res.rows;
  }



  async getExpiredProducts() {
    const res = await pool.query(`
      ${this.getProductBaseQuery}
      WHERE p.expiration_date IS NOT NULL
        AND p.expiration_date < CURRENT_DATE
      GROUP BY p.id
      ORDER BY p.expiration_date ASC;
    `);
    return res.rows;
  }


  async getProductsExpiringThisMonth() {
    const res = await pool.query(`
      ${this.getProductBaseQuery}
      WHERE p.expiration_date IS NOT NULL
        AND p.expiration_date >= CURRENT_DATE
        AND EXTRACT(YEAR FROM p.expiration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM p.expiration_date) = EXTRACT(MONTH FROM CURRENT_DATE)
      GROUP BY p.id
      ORDER BY p.expiration_date ASC;
    `);
    return res.rows;
  }


  
  async searchProduct(query: string): Promise<Product[]> {
    if (!query || query.trim() === '') return [];

    const res = await pool.query(`
      SELECT 
        p.id,
        p.name,
        p.category,
        p.presentation,
        p.units,
        p.expiration_date,
        p.description,
        p.active_ingredient,
        p.brand,
        p.image,
        json_agg(
          json_build_object(
            'presentacion', pp.presentacion,
            'precio', pp.precio
          )
        ) AS presentation_prices
      FROM products p
      LEFT JOIN product_prices pp ON p.id = pp.product_id
      WHERE p.name ILIKE $1
      GROUP BY p.id
      ORDER BY p.created_at DESC
    `, [`%${query}%`]);

    return res.rows;
  }

  async getProductsByCategory(category: string): Promise<Product[]> {
    if (!category || category.trim() === '') return [];

    const res = await pool.query(`
      SELECT 
        p.id,
        p.name,
        p.category,
        p.presentation,
        p.units,
        p.expiration_date,
        p.description,
        p.active_ingredient,
        p.brand,
        p.image,
        json_agg(
          json_build_object(
            'presentacion', pp.presentacion,
            'precio', pp.precio
          )
        ) AS presentation_prices
      FROM products p
      LEFT JOIN product_prices pp ON p.id = pp.product_id
      WHERE p.category = $1
      GROUP BY p.id
      ORDER BY p.created_at DESC
    `, [category]);

    return res.rows;
  }


  async testConnection() {
    try {
      const client = await pool.connect();
      const res = await client.query('SELECT NOW()');
      console.log('Conexión exitosa a la base de datos:', res.rows[0]);
      client.release();
    } catch (error) {
      console.error('Error al conectar a la base de datos:', error);
    }
  }

  private getProductBaseQuery = `
  SELECT 
    p.id,
    p.name,
    p.category,
    p.presentation,
    p.units,
    p.expiration_date,
    p.description,
    p.active_ingredient,
    p.brand,
    p.image,
    json_agg(
      json_build_object(
        'presentacion', pp.presentacion,
        'precio', pp.precio
      )
    ) AS price
  FROM products p
  LEFT JOIN product_prices pp ON p.id = pp.product_id
`;

}

export default new ProductService();
