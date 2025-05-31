export interface Product {
  id: number;
  name: string;
  category: string;
  presentation: string;
  units: number;
  expiration_date?: string;
  description?: string;
  active_ingredient?: string;
  brand?: string;
  image?: string;
  presentation_prices: {
    presentacion: string;
    precio: number;
  }[];
}
