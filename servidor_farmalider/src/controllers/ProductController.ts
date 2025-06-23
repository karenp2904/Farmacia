import { Request, Response } from 'express';
import { Product } from '../models/Product';
import ProductService from '../services/ProductService';

class ProductController {
  async getAllProducts(_req: Request, res: Response): Promise<void> {
    try {
      const products = await ProductService.getAllProducts();
      console.log(products)
      res.status(200).json(products);
    } catch (error) {
      res.status(500).send('Error al obtener productos');
    }
  }

  async getProductById(req: Request, res: Response): Promise<void> {
    const { id } = req.params;
    try {
      const product = await ProductService.getProductById(Number(id));
      if (!product) {
        res.status(404).send('Producto no encontrado');
      } else {
        res.status(200).json(product);
      }
    } catch (error) {
      res.status(500).send('Error al obtener el producto');
    }
  }

  async createProduct(req: Request, res: Response): Promise<void> {
    const product: Product = req.body;
    try {
      const newProduct = await ProductService.createProduct(product);
      res.status(200).json(newProduct);
    } catch (error) {
      res.status(500).send('Error al crear el producto');
    }
  }

  async updateProduct(req: Request, res: Response): Promise<void> {
    const { id } = req.params;
    const product: Product = req.body;
    try {
      const updatedProduct = await ProductService.updateProduct(Number(id), product);
      if (!updatedProduct) {
        res.status(404).send('Producto no encontrado');
      } else {
        res.status(200).json(updatedProduct);
      }
    } catch (error) {
      res.status(500).send('Error al actualizar el producto');
    }
  }
  
  async updateField(req: Request, res: Response): Promise<void> {
    const { id, field, value } = req.body;
    
    if (!id || !field || typeof value === 'undefined') {
      res.status(400).send('Datos incompletos');
      return;
    }
    
    try {
      const updated = await ProductService.updateField(Number(id), field, value);
      if (!updated) {
        res.status(404).send('Producto no encontrado');
      } else {
        res.status(200).json(updated);
      }
    } catch (error) {
      console.error('Error al actualizar campo:', error);
      res.status(500).send('Error del servidor');
    }
  }

  async deleteProduct(req: Request, res: Response): Promise<void> {
    const { id } = req.params;
    try {
      const success = await ProductService.deleteProduct(Number(id));
      if (success) {
        res.status(204).send();
      } else {
        res.status(404).send('Producto no encontrado');
      }
    } catch (error) {
      res.status(500).send('Error al eliminar el producto');
    }
  }

  async getProductStock(req: Request, res: Response): Promise<void> {
    const { id } = req.params;
    try {
      const stock = await ProductService.getProductStock(Number(id));
      if (stock !== undefined) {
        res.status(200).json({ stock });
      } else {
        res.status(404).send('Producto no encontrado');
      }
    } catch (error) {
      res.status(500).send('Error al verificar stock');
    }
  }

  // Obtener productos por categoría
  async getProductsByCategory(req: Request, res: Response): Promise<void> {
    const { category } = req.params;
    try {
      const products = await ProductService.getProductsByCategory(category);
      res.status(200).json(products);
    } catch (error) {
      res.status(500).send('Error al obtener productos por categoría');
    }
  }

  // Buscar un producto por nombre
  async searchProduct(req: Request, res: Response): Promise<void> {
    const { query } = req.query;
    
    if (!query) {
      res.status(400).send('Se requiere un término de búsqueda');
      return;
    }

    try {
      const products = await ProductService.searchProduct(String(query));
      
      if (products.length === 0) {
        res.status(404).send('No se encontraron productos');
      } else {
        res.status(200).json(products);
      }
    } catch (error) {
      console.error(error);  // Para el desarrollo, puedes registrar el error en la consola
      res.status(500).send('Error al buscar producto');
    }
  }


  async getProductsExpiringThisYear(_req: Request, res: Response): Promise<void> {
    try {
      const products = await ProductService.getProductsExpiringThisYear();
      if (!products || products.length === 0) {
        res.status(404).json({ message: 'No hay productos que venzan este año.' });
        return;
      }
      res.status(200).json(products);
    } catch (error) {
      console.error('Error en getProductsExpiringThisYear:', error);
      res.status(500).json({
        message: 'Error del servidor al obtener productos a vencer',
        error: (error as Error).message,
        stack: (error as Error).stack,
      });
    }
  }
  
  async getProductsExpiringThisMonth(_req: Request, res: Response): Promise<void> {
    try {
      const products = await ProductService.getProductsExpiringThisMonth();
      if (!products || products.length === 0) {
        res.status(404).json({ message: 'No hay productos que venzan este mes.' });
        return;
      }
      res.status(200).json(products);
    } catch (error) {
      console.error('Error en getProductsExpiringThisMonth:', error);
      res.status(500).json({
        message: 'Error del servidor al obtener productos a vencer',
        error: (error as Error).stack,
      });
    }
  }
  
  async getProductsExpired(_req: Request, res: Response): Promise<void> {
    try {
      const products = await ProductService.getExpiredProducts();
      if (!products || products.length === 0) {
        res.status(404).json({ message: 'No hay productos que vencieron.' });
        return;
      }
      res.status(200).json(products);
    } catch (error) {
      console.error('Error en getProductsExpired:', error);
      res.status(500).json({
        message: 'Error del servidor al obtener productos vencidos',
        error: (error as Error).stack,
      });
    }
  }
  
    
  
  

}

export default new ProductController();
