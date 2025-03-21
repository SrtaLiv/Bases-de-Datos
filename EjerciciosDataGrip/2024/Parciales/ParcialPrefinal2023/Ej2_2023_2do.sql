-- reemplazar xxxxxx por su número de legajo;

-- Table: CATEGORIA
CREATE TABLE unc_188_CATEGORIA (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_xxxxxx_CATEGORIA PRIMARY KEY (tipo_categoria,cod_categoria)
);

-- Table: PRODUCTO
CREATE TABLE unc_188_PRODUCTO (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    descripcion varchar(30)  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    CONSTRAINT PK_xxxxxx_PRODUCTO PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria)
);

-- Table: PRODUCTOS_X_SUCURSAL
CREATE TABLE unc_188_PRODUCTOS_X_SUCURSAL (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    cod_sucursal int  NOT NULL,
    CONSTRAINT PK_xxxxxx_PRODUCTOS_X_SUCURSAL PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria,cod_sucursal)
);

-- Table: SUCURSAL
CREATE TABLE unc_188_SUCURSAL (
    cod_sucursal int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sucursal_rural boolean  NOT NULL,
    CONSTRAINT PK_xxxxxx_SUCURSAL PRIMARY KEY (cod_sucursal)
);

-- Reference: FK_PRODUCTOS_X_SUCURSAL_PRODUCTO (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE unc_188_PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_xxxxxx_PRODUCTOS_X_SUCURSAL_PRODUCTO
    FOREIGN KEY (nro_producto, tipo_categoria, cod_categoria)
    REFERENCES unc_188_PRODUCTO (nro_producto, tipo_categoria, cod_categoria);

-- Reference: FK_PRODUCTOS_X_SUCURSAL_SUCURSAL (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE unc_188_PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_xxxxxx_PRODUCTOS_X_SUCURSAL_SUCURSAL
    FOREIGN KEY (cod_sucursal)
    REFERENCES unc_188_SUCURSAL (cod_sucursal);

-- Reference: FK_PRODUCTO_CATEGORIA (table: PRODUCTO)
ALTER TABLE unc_188_PRODUCTO ADD CONSTRAINT FK_xxxxxx_PRODUCTO_CATEGORIA
    FOREIGN KEY (tipo_categoria, cod_categoria)
    REFERENCES unc_188_CATEGORIA (tipo_categoria, cod_categoria);

-- Datos

INSERT INTO unc_188_CATEGORIA (tipo_categoria, cod_categoria, descripcion)
VALUES
  ('K0W',49,'est'), ('M5G',92,'massa lobortis'),  ('K1J',43,'elementum at,'),  ('K5G',84,'nibh. Aliquam'),  ('B5D',60,'lacinia mattis. Integer'),
  ('Y5P',48,'luctus'),  ('P2U',76,'tellus eu'),  ('Y6X',52,'elit. Curabitur sed'),  ('O4G',11,'imperdiet non,'),  ('V9B',96,'sem semper erat,');

INSERT INTO unc_188_SUCURSAL (cod_sucursal, nombre, calle, numero, sucursal_rural)
VALUES
  (1,'Mira Battle','Calle 1', 2322, 'Yes'),  (2,'Otto Mcclain','Calle 2', 2328,'No'),  (3,'Ishmael Poole','Calle 3', 2321,'No'),  (4,'Dale Cochran','Calle 4', 232,'Yes'),  (5,'Holly Douglas','Calle 5', 2322,'Yes'),
  (6,'Kylee Horn','Calle 6', 2333,'No'),  (7,'Abra Hickman','Calle 7', 2324,'Yes'),  (8,'Eaton Brady','Calle 8', 2772,'Yes'),  (9,'Judah Maldonado','Calle 9', 9232,'Yes'),  (10,'Rebekah Benton','Calle 10', 2322,'Yes'),
  (11,'Armand Vance','Calle 11', 3232,'Yes'),  (12,'Amaya Jefferson','Calle 12', 4232,'Yes'),  (13,'Mohammad Ramsey','Calle 13', 6232,'Yes'),  (14,'Clarke Ferguson','Calle 14', 2342,'Yes'),  (15,'Herrod Ortega','Calle 15', 2392,'No');

INSERT INTO unc_188_PRODUCTO (tipo_categoria, cod_categoria, nro_producto, descripcion, precio)
VALUES
('Y6X', 52, 1, 'Producto 1', round((Random()*100000)::decimal,2)), ('P2U', 76, 2, 'Producto 2', round((Random()*100000)::decimal,2)), ('B5D', 60, 3, 'Producto 3', round((Random()*100000)::decimal,2)),
 ('K5G', 84, 4, 'Producto 4', round((Random()*100000)::decimal,2)), ('Y6X', 52, 5, 'Producto 5', round((Random()*100000)::decimal,2)), ('O4G', 11, 6, 'Producto 6', round((Random()*100000)::decimal,2)),
 ('V9B', 96, 7, 'Producto 7', round((Random()*100000)::decimal,2)), ('K0W', 49, 8, 'Producto 8', round((Random()*100000)::decimal,2)), ('K5G', 84, 9, 'Producto 9', round((Random()*100000)::decimal,2)),
 ('Y6X', 52, 10, 'Producto 10', round((Random()*100000)::decimal,2)), ('K5G', 84, 11, 'Producto 11', round((Random()*100000)::decimal,2)), ('K0W', 49, 12, 'Producto 12', round((Random()*100000)::decimal,2)),
 ('V9B', 96, 13, 'Producto 13', round((Random()*100000)::decimal,2)), ('M5G', 92, 14, 'Producto 14', round((Random()*100000)::decimal,2)), ('Y5P', 48, 15, 'Producto 15', round((Random()*100000)::decimal,2)),
 ('K1J', 43, 16, 'Producto 16', round((Random()*100000)::decimal,2)), ('K5G', 84, 17, 'Producto 17', round((Random()*100000)::decimal,2)), ('B5D', 60, 18, 'Producto 18', round((Random()*100000)::decimal,2)),
 ('K5G', 84, 19, 'Producto 19', round((Random()*100000)::decimal,2)), ('O4G', 11, 20, 'Producto 20', round((Random()*100000)::decimal,2)), ('Y5P', 48, 21, 'Producto 21', round((Random()*100000)::decimal,2)),
 ('B5D', 60, 22, 'Producto 22', round((Random()*100000)::decimal,2)), ('O4G', 11, 23, 'Producto 23', round((Random()*100000)::decimal,2)), ('Y5P', 48, 24, 'Producto 24', round((Random()*100000)::decimal,2)),
 ('M5G', 92, 25, 'Producto 25', round((Random()*100000)::decimal,2)), ('Y5P', 48, 26, 'Producto 26', round((Random()*100000)::decimal,2)), ('Y5P', 48, 27, 'Producto 27', round((Random()*100000)::decimal,2)),
 ('V9B', 96, 28, 'Producto 28', round((Random()*100000)::decimal,2)), ('V9B', 96, 29, 'Producto 29', round((Random()*100000)::decimal,2)), ('V9B', 96, 30, 'Producto 30', round((Random()*100000)::decimal,2));

INSERT INTO unc_188_PRODUCTOS_X_SUCURSAL (tipo_categoria, cod_categoria, nro_producto, cod_sucursal)
VALUES
('M5G', 92, 14, 10),('K1J', 43, 16, 4),('Y5P', 48, 15, 1),('B5D', 60, 3, 3),('K5G', 84, 4, 4),('K0W', 49, 12, 6),('V9B', 96, 28, 3),('V9B', 96, 29, 6),('V9B', 96, 7, 10),('Y6X', 52, 10, 5),
('O4G', 11, 6, 2),('Y5P', 48, 24, 8),('O4G', 11, 20, 8),('Y6X', 52, 10, 9),('K5G', 84, 4, 8),('V9B', 96, 29, 1),('M5G', 92, 25, 8),('K0W', 49, 8, 3),('V9B', 96, 29, 9),('B5D', 60, 18, 2),
('B5D', 60, 22, 9),('K5G', 84, 19, 10),('Y6X', 52, 1, 2),('O4G', 11, 23, 2),('B5D', 60, 22, 5),('K5G', 84, 4, 1),('Y5P', 48, 27, 9),('V9B', 96, 13, 1),('B5D', 60, 22, 10),('M5G', 92, 25, 6),('Y5P', 48, 15, 9),
('V9B', 96, 29, 4),('K0W', 49, 12, 5),('K1J', 43, 16, 9),('K5G', 84, 19, 7),('Y5P', 48, 26, 8),('V9B', 96, 7, 4),('Y5P', 48, 27, 7),('K5G', 84, 19, 3),('V9B', 96, 28, 10),('O4G', 11, 23, 7),('O4G', 11, 6, 6),
('V9B', 96, 30, 1),('Y5P', 48, 21, 10),('Y5P', 48, 15, 6),('V9B', 96, 7, 2),('O4G', 11, 23, 3),('O4G', 11, 20, 3),('Y5P', 48, 26, 6),('Y5P', 48, 15, 5),('V9B', 96, 30, 7),('Y5P', 48, 21, 2),('K5G', 84, 4, 2),
('K5G', 84, 11, 4),('V9B', 96, 7, 6),('O4G', 11, 23, 4),('Y6X', 52, 10, 7),('V9B', 96, 28, 6),('B5D', 60, 3, 2),('B5D', 60, 18, 1),('K5G', 84, 9, 8),('Y5P', 48, 26, 1),('O4G', 11, 23, 1),('M5G', 92, 14, 6),
('O4G', 11, 6, 1),('Y6X', 52, 5, 7),('V9B', 96, 7, 5),('P2U', 76, 2, 3),('B5D', 60, 3, 4),('B5D', 60, 22, 2),('Y6X', 52, 1, 7),('V9B', 96, 29, 5),('K0W', 49, 8, 6),('O4G', 11, 20, 2),('K5G', 84, 19, 9),
('Y5P', 48, 26, 2),('P2U', 76, 2, 8),('V9B', 96, 30, 2),('K5G', 84, 4, 7),('M5G', 92, 14, 8),('Y5P', 48, 24, 2),('B5D', 60, 3, 9),('V9B', 96, 7, 1),('B5D', 60, 3, 1),('Y6X', 52, 1, 3),('K5G', 84, 11, 6),
('P2U', 76, 2, 9),('Y6X', 52, 10, 10),('B5D', 60, 3, 5),('Y6X', 52, 1, 5),('Y6X', 52, 10, 1),('V9B', 96, 13, 6),('K5G', 84, 9, 4),('V9B', 96, 13, 8),('O4G', 11, 20, 7),('B5D', 60, 18, 5),('V9B', 96, 30, 3),
('Y5P', 48, 15, 4),('B5D', 60, 22, 7),('Y5P', 48, 21, 8),('K5G', 84, 11, 9),('K5G', 84, 9, 2),('P2U', 76, 2, 2),('V9B', 96, 13, 4),('O4G', 11, 6, 5),('K0W', 49, 12, 7),('Y6X', 52, 5, 9),('Y6X', 52, 5, 1),
('M5G', 92, 25, 2),('M5G', 92, 14, 9),('O4G', 11, 6, 4),('V9B', 96, 30, 6),('Y5P', 48, 27, 5),('O4G', 11, 6, 10),('Y6X', 52, 1, 10),('Y5P', 48, 26, 3),('Y6X', 52, 5, 2),('P2U', 76, 2, 10),('Y5P', 48, 15, 10),
('K5G', 84, 11, 10),('Y6X', 52, 5, 6),('Y5P', 48, 24, 6),('P2U', 76, 2, 7),('K5G', 84, 17, 2),('V9B', 96, 13, 7),('Y5P', 48, 26, 9),('Y5P', 48, 15, 8),('K0W', 49, 12, 8),('Y5P', 48, 15, 7),('B5D', 60, 18, 4),
('O4G', 11, 20, 4),('K5G', 84, 4, 5),('O4G', 11, 6, 3),('V9B', 96, 29, 8),('O4G', 11, 6, 7),('Y6X', 52, 1, 8),('K5G', 84, 17, 8),('O4G', 11, 23, 10),('Y6X', 52, 1, 4),('K1J', 43, 16, 8),('V9B', 96, 29, 10),
('K1J', 43, 16, 7);