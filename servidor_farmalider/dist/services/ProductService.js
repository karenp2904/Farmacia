"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const pg_1 = require("pg");
const pool = new pg_1.Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'farmalider',
    password: 'karen',
    port: 5432,
});
class ProductService {
    getAllProducts() {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield pool.query(`
      SELECT p.id, p.name, p.category, p.presentation, p.units, p.unit_price, p.expiration_date, p.created_at
      FROM products p
      ORDER BY p.created_at DESC;
    `);
            return result.rows;
        });
    }
    getProductById(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield pool.query('SELECT * FROM products WHERE id = $1', [id]);
            if (result.rows.length === 0)
                return null;
            return result.rows[0];
        });
    }
    createProduct(product) {
        return __awaiter(this, void 0, void 0, function* () {
            const { name, category, presentation, units, unit_price, expiration_date } = product;
            const result = yield pool.query(`INSERT INTO products (name, category, presentation, units, unit_price, expiration_date)
      VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`, [name, category, presentation, units, unit_price, expiration_date]);
            return result.rows[0];
        });
    }
    updateProduct(id, product) {
        return __awaiter(this, void 0, void 0, function* () {
            const { name, category, presentation, units, unit_price, expiration_date } = product;
            const result = yield pool.query(`UPDATE products
      SET name = $1, category = $2, presentation = $3, units = $4, unit_price = $5, expiration_date = $6
      WHERE id = $7 RETURNING *`, [name, category, presentation, units, unit_price, expiration_date, id]);
            if (result.rows.length === 0)
                return null;
            return result.rows[0];
        });
    }
    deleteProduct(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield pool.query('DELETE FROM products WHERE id = $1 RETURNING id', [id]);
            return result.rows.length > 0;
        });
    }
    // Obtener productos por categoría
    getProductsByCategory(category) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield pool.query(`
      SELECT id, name, category, presentation, units, unit_price, expiration_date, 
             description, active_ingredient, brand
      FROM products
      WHERE category = $1;
    `, [category]);
            return res.rows;
        });
    }
    // Buscar productos por nombre
    searchProduct(query) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield pool.query(`
      SELECT id, name, category, presentation, units, unit_price, expiration_date, 
             description, active_ingredient, brand
      FROM products
      WHERE name ILIKE $1;  -- Busca de manera insensible a mayúsculas/minúsculas
    `, [`%${query}%`]);
            return res.rows;
        });
    }
    // Obtener productos que vencen este año
    getProductsExpiringThisYear() {
        return __awaiter(this, void 0, void 0, function* () {
            const currentYear = new Date().getFullYear();
            const res = yield pool.query(`
      SELECT id, name, category, presentation, units, unit_price, expiration_date, 
             description, active_ingredient, brand
      FROM products
      WHERE expiration_date IS NOT NULL 
      AND EXTRACT(YEAR FROM expiration_date) = $1;
    `, [currentYear]);
            return res.rows;
        });
    }
}
exports.default = new ProductService();
