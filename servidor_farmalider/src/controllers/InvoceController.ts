// controllers/invoiceController.ts
import { Request, Response } from 'express';
import invoiceService from '../services/InvoceService';

 class InvoiceController {
  async createInvoice(req: Request, res: Response): Promise<void> {
    try {
      const invoice = await invoiceService.createInvoice(req.body);
      res.status(201).json(invoice);
    } catch (err) {
      console.error('Error al crear la factura:', err);
      res.status(500).json({ error: 'Error al crear la factura' });
    }
  }

  async getAllInvoices(_req: Request, res: Response): Promise<void> {
    try {
      const invoices = await invoiceService.getAllInvoices();
      res.status(200).json(invoices);
    } catch (err) {
      console.error('Error al obtener facturas:', err);
      res.status(500).json({ error: 'Error al obtener facturas' });
    }
  }
}

export default new InvoiceController();
