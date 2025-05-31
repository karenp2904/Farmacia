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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ProductService_1 = __importDefault(require("../services/ProductService"));
class ProductController {
    getAllProducts(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const products = yield ProductService_1.default.getAllProducts();
                res.json(products);
            }
            catch (error) {
                res.status(500).send('Error al obtener productos');
            }
        });
    }
    getProductById(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = req.params;
            try {
                const product = yield ProductService_1.default.getProductById(Number(id));
                if (!product) {
                    res.status(404).send('Producto no encontrado');
                }
                else {
                    res.json(product);
                }
            }
            catch (error) {
                res.status(500).send('Error al obtener el producto');
            }
        });
    }
    createProduct(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const product = req.body;
            try {
                const newProduct = yield ProductService_1.default.createProduct(product);
                res.status(201).json(newProduct);
            }
            catch (error) {
                res.status(500).send('Error al crear el producto');
            }
        });
    }
    updateProduct(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = req.params;
            const product = req.body;
            try {
                const updatedProduct = yield ProductService_1.default.updateProduct(Number(id), product);
                if (!updatedProduct) {
                    res.status(404).send('Producto no encontrado');
                }
                else {
                    res.json(updatedProduct);
                }
            }
            catch (error) {
                res.status(500).send('Error al actualizar el producto');
            }
        });
    }
    deleteProduct(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = req.params;
            try {
                const success = yield ProductService_1.default.deleteProduct(Number(id));
                if (success) {
                    res.status(204).send();
                }
                else {
                    res.status(404).send('Producto no encontrado');
                }
            }
            catch (error) {
                res.status(500).send('Error al eliminar el producto');
            }
        });
    }
    // Obtener productos por categoría
    getProductsByCategory(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const { category } = req.params;
            try {
                const products = yield ProductService_1.default.getProductsByCategory(category);
                res.json(products);
            }
            catch (error) {
                res.status(500).send('Error al obtener productos por categoría');
            }
        });
    }
    // Buscar un producto por nombre
    searchProduct(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const { query } = req.query;
            try {
                const products = yield ProductService_1.default.searchProduct(String(query));
                res.json(products);
            }
            catch (error) {
                res.status(500).send('Error al buscar producto');
            }
        });
    }
    // Obtener productos que vencen este año
    getProductsExpiringThisYear(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const products = yield ProductService_1.default.getProductsExpiringThisYear();
                res.json(products);
            }
            catch (error) {
                res.status(500).send('Error al obtener productos próximos a vencer');
            }
        });
    }
}
exports.default = new ProductController();
