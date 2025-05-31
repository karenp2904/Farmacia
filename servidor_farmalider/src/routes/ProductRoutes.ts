import { Router } from 'express';
import ProductController from '../controllers/ProductController';
import  InvoiceController  from '../controllers/InvoceController';

const router = Router();

// Rutas estáticas primero
router.get('/products', ProductController.getAllProducts);
router.get('/products/alerts', ProductController.getProductsExpiringThisYear);
router.get('/products/expired', ProductController.getProductsExpired);
router.get('/products/expiringMonth', ProductController.getProductsExpiringThisMonth);
router.get('/products/search', ProductController.searchProduct);
router.get('/products/category/:category', ProductController.getProductsByCategory);

// Rutas dinámicas después
router.get('/products/:id', ProductController.getProductById);
router.post('/products/create', ProductController.createProduct);
router.put('/products/update/:id', ProductController.updateProduct);
router.delete('/products/delete/:id', ProductController.deleteProduct);
router.get('/products/stock/:id', ProductController.getProductStock);


//factura

router.post('/invoces/add', InvoiceController.createInvoice)
router.get('/invoces/all', InvoiceController.getAllInvoices)
export default router;
