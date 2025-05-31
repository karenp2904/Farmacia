"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const ProductController_1 = __importDefault(require("../controllers/ProductController"));
const router = (0, express_1.Router)();
router.get('/products', ProductController_1.default.getAllProducts);
router.get('/products/:id', ProductController_1.default.getProductById);
router.post('/products', ProductController_1.default.createProduct);
router.put('/products/:id', ProductController_1.default.updateProduct);
router.delete('/products/:id', ProductController_1.default.deleteProduct);
router.get('/products', ProductController_1.default.getAllProducts); // Obtener todos los productos
router.get('/products/category/:category', ProductController_1.default.getProductsByCategory); // Obtener productos por categoría
router.get('/products/search', ProductController_1.default.searchProduct); // Buscar producto
router.get('/products/expiring', ProductController_1.default.getProductsExpiringThisYear); // Productos próximos a vencer
exports.default = router;
