// services/InvoiceService.ts
import { Pool } from 'pg';
import { Invoice, InvoiceItem } from '../models/Invoce';

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'farmalider',
  password: 'karen',
  port: 5432,
});

export class InvoiceService {
  async createInvoice(invoice: Invoice): Promise<Invoice> {
    const client = await pool.connect();

    try {
      await client.query('BEGIN');

      const result = await client.query(`
        INSERT INTO invoices (customer_name, total_amount)
        VALUES ($1, $2)
        RETURNING id, created_at
      `, [invoice.customer_name, invoice.total_amount]);

      const invoiceId = result.rows[0].id;
      const createdAt = result.rows[0].created_at;

      for (const item of invoice.items) {
        await client.query(`
          INSERT INTO invoice_items (invoice_id, product_id, quantity, presentation, unit_price)
          VALUES ($1, $2, $3, $4, $5)
        `, [invoiceId, item.product_id, item.quantity, item.presentation, item.unit_price]);

        // Descontar del stock del producto
        await client.query(`
          UPDATE products SET units = units - $1 WHERE id = $2
        `, [item.quantity, item.product_id]);
      }

      await client.query('COMMIT');

      return { ...invoice, id: invoiceId, created_at: createdAt };
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  async getAllInvoices(): Promise<Invoice[]> {
    const result = await pool.query(`
      SELECT * FROM invoices ORDER BY created_at DESC
    `);

    const invoices: Invoice[] = [];

    for (const row of result.rows) {
      const itemsResult = await pool.query(`
        SELECT product_id, quantity, presentation, unit_price
        FROM invoice_items
        WHERE invoice_id = $1
      `, [row.id]);

      invoices.push({
        id: row.id,
        customer_name: row.customer_name,
        total_amount: row.total_amount,
        created_at: row.created_at,
        items: itemsResult.rows,
      });
    }

    return invoices;
  }
}

export default new InvoiceService();
