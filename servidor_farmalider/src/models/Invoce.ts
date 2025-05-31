// models/Invoice.ts
export interface InvoiceItem {
  product_id: number;
  quantity: number;
  presentation: string;
  unit_price: number;
}

export interface Invoice {
  id?: number;
  customer_name: string;
  total_amount: number;
  items: InvoiceItem[];
  created_at?: string;
}
