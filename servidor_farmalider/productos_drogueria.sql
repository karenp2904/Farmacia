
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Dolex', 'Analgésico', 'Caja', 25, '2025-12-20',
        'Alivia dolores leves y fiebre.', 'Paracetamol', 'GSK', 'dolex.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 8500);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 500);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Dolex Gripa', 'Antigripal', 'Caja', 20, '2025-11-10',
        'Para síntomas de la gripa.', 'Paracetamol, Clorfenamina', 'GSK', 'dolex_gripa.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 9700);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 600);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Cetirizina', 'Antialérgico', 'Frasco', 10, '2026-02-18',
        'Alivia alergias e irritaciones.', 'Cetirizina diclorhidrato', 'Genfar', 'cetirizina.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Frasco', 10500);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 800);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Acetaminofén MK', 'Analgésico', 'Caja', 30, '2025-08-15',
        'Alivia dolor y fiebre.', 'Acetaminofén', 'MK', 'acetaminofen_mk.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 7000);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 400);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Ibuprofeno', 'Antiinflamatorio', 'Caja', 20, '2026-01-10',
        'Antiinflamatorio y analgésico.', 'Ibuprofeno', 'MK', 'ibuprofeno.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 8600);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 450);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Loratadina', 'Antialérgico', 'Caja', 15, '2025-09-22',
        'Para rinitis y urticaria.', 'Loratadina', 'Genfar', 'loratadina.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 7400);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 480);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Buscapina', 'Antiespasmódico', 'Caja', 18, '2025-10-30',
        'Alivia cólicos y espasmos.', 'Hioscina N-butilbromuro', 'Sanofi', 'buscapina.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 9600);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 530);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Sal de frutas Lua', 'Antiácido', 'Caja', 20, '2026-03-12',
        'Para la acidez estomacal.', 'Bicarbonato de sodio', 'Lua', 'sal_lua.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 7800);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 390);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Diclofenaco', 'Antiinflamatorio', 'Caja', 16, '2026-04-05',
        'Tratamiento del dolor y fiebre.', 'Diclofenaco sódico', 'Genfar', 'diclofenaco.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 8900);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 440);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Vitamina C Redoxon', 'Suplemento', 'Tubito', 12, '2026-05-10',
        'Refuerza el sistema inmune.', 'Ácido ascórbico', 'Bayer', 'redoxon.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Tubito', 11500);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 1000);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto11', 'Medicamento', 'Caja', 20, '2026-06-20',
        'Descripción del Producto11', 'Ingrediente11', 'Marca11', 'producto11.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6000);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 600);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto12', 'Medicamento', 'Caja', 20, '2026-06-21',
        'Descripción del Producto12', 'Ingrediente12', 'Marca12', 'producto12.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6100);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 610);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto13', 'Medicamento', 'Caja', 20, '2026-06-22',
        'Descripción del Producto13', 'Ingrediente13', 'Marca13', 'producto13.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6200);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 620);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto14', 'Medicamento', 'Caja', 20, '2026-06-23',
        'Descripción del Producto14', 'Ingrediente14', 'Marca14', 'producto14.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6300);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 630);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto15', 'Medicamento', 'Caja', 20, '2026-06-24',
        'Descripción del Producto15', 'Ingrediente15', 'Marca15', 'producto15.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6400);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 640);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto16', 'Medicamento', 'Caja', 20, '2026-06-25',
        'Descripción del Producto16', 'Ingrediente16', 'Marca16', 'producto16.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6500);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 650);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto17', 'Medicamento', 'Caja', 20, '2026-06-26',
        'Descripción del Producto17', 'Ingrediente17', 'Marca17', 'producto17.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6600);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 660);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto18', 'Medicamento', 'Caja', 20, '2026-06-27',
        'Descripción del Producto18', 'Ingrediente18', 'Marca18', 'producto18.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6700);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 670);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto19', 'Medicamento', 'Caja', 20, '2026-06-28',
        'Descripción del Producto19', 'Ingrediente19', 'Marca19', 'producto19.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6800);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 680);
INSERT INTO products (name, category, presentation, units, expiration_date, description, active_ingredient, brand, image)
VALUES ('Producto20', 'Medicamento', 'Caja', 20, '2026-06-29',
        'Descripción del Producto20', 'Ingrediente20', 'Marca20', 'producto20.png');INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Caja', 6900);INSERT INTO product_prices (product_id, presentacion, precio) VALUES (currval('products_id_seq'), 'Unidad', 690);