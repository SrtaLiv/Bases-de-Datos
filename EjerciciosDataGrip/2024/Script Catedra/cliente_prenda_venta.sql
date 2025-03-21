-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

-- tables
-- Table: P5P2E5_CLIENTE
CREATE TABLE P5P2E5_CLIENTE (
    id_cliente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    estado char(5)  NOT NULL,
    CONSTRAINT PK_P5P2E5_CLIENTE PRIMARY KEY (id_cliente)
);

-- Table: P5P2E5_FECHA_LIQ
CREATE TABLE P5P2E5_FECHA_LIQ (
    dia_liq int  NOT NULL,
    mes_liq int  NOT NULL,
    cant_dias int  NOT NULL,
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq,mes_liq)
);

-- Table: P5P2E5_PRENDA
CREATE TABLE P5P2E5_PRENDA (
    id_prenda int  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    tipo varchar(40)  NOT NULL,
    categoria varchar(80)  NOT NULL,
    CONSTRAINT PK_P5P2E5_PRENDA PRIMARY KEY (id_prenda)
);

-- Table: P5P2E5_VENTA
CREATE TABLE P5P2E5_VENTA (
    id_venta int  NOT NULL,
    descuento decimal(10,2)  NOT NULL,
    fecha timestamp  NOT NULL,
    id_prenda int  NOT NULL,
    id_cliente int  NOT NULL,
    CONSTRAINT PK_P5P2E5_VENTA PRIMARY KEY (id_venta)
);

-- foreign keys
-- Reference: FK_P5P2E5_VENTA_CLIENTE (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES P5P2E5_CLIENTE (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E5_VENTA_PRENDA (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_PRENDA
    FOREIGN KEY (id_prenda)
    REFERENCES P5P2E5_PRENDA (id_prenda)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

INSERT INTO P5P2E5_CLIENTE (id_cliente, apellido, nombre, estado) VALUES
(1, 'Gomez', 'Juan', 'A'),
(2, 'Perez', 'Ana', 'A'),
(3, 'Lopez', 'Carlos', 'A');

INSERT INTO P5P2E5_FECHA_LIQ (dia_liq, mes_liq, cant_dias) VALUES
(15, 5, 1),
(20, 5, 2),
(25, 5, 1);

INSERT INTO P5P2E5_PRENDA (id_prenda, precio, descripcion, tipo, categoria) VALUES
(1, 100.00, 'Camiseta deportiva', 'Ropa', 'Deportiva'),
(2, 50.00, 'Pantalón jeans', 'Ropa', 'Casual'),
(3, 75.00, 'Chaqueta de cuero', 'Ropa', 'Formal');

-- Venta en una fecha de liquidación con descuento mayor al 30%
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES
(1, 35.00, '2024-05-15 10:00:00', 1, 1);

-- Venta en una fecha de liquidación con descuento menor al 30%
-- Esta debería fallar debido al disparador
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES
(2, 40.00, '2024-05-15 10:00:00', 2, 2);

-- Venta en una fecha que no es de liquidación con cualquier descuento
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES
(3, 15.00, '2024-05-10 10:00:00', 3, 3);


INSERT INTO P5P2E5_FECHA_LIQ (dia_liq, mes_liq, cant_dias) VALUES
(324, 7, 8),
(23, 12, 9),
(324, 12, 2);


INSERT INTO P5P2E5_PRENDA (id_prenda, precio, descripcion, tipo, categoria) VALUES
(999, 100.00, 'Camiseta deportiva', 'Ropa', 'oferta');
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES
(45, 35.00, '2024-05-15 10:00:00', 999, 999);

INSERT INTO P5P2E5_PRENDA (id_prenda, precio, descripcion, tipo, categoria) VALUES
(999, 100.00, 'Camiseta deportiva', 'Ropa', 'oferta');
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES
(46, 0, '2024-02-15 10:00:00', 999, 1);