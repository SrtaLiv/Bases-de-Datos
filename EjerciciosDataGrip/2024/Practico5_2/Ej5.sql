-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

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
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq, mes_liq)
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

    /*
A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.
B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
D. Las prendas de categoría ‘oferta’ no tienen descuentos.
     */

--respuestas
--A Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.
ALTER TABLE P5P2E5_VENTA
ADD CONSTRAINT descuento
CHECK ( descuento BETWEEN 0 AND 100);

--B QUE NO EXISTAN DESCUENTOS MENORES A 30% Y ESTEN FECHA DE LIQUIDACION
CREATE ASSERTION VENTA
ADD CONSTRAINT descuento
CHECK (NOT EXIST(
       SELECT 1
       FROM venta
       WHERE descuento < 30
       AND fecha IN (
       select dia_liq from FECHA_LIQ)
))

--C Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
ALTER TABLE P5P2E5_FECHA_LIQ
ADD CONSTRAINT LIQ_5DIAS
CHECK (
       (mes_liq = 7 AND cant_dias <= 5) OR
    (mes_liq = 12 AND cant_dias <= 5) OR
    (mes_liq <> 7 AND mes_liq <> 12)
    );

--d
ALTER TABLE p5p2e5_prenda ADD CONSTRAINT CK_prenda_en_oferta
    CHECK(
        NOT EXISTS(
            SELECT 1
            FROM p5p2e5_prenda p
            JOIN p5p2e5_venta v ON p.id_prenda = v.id_prenda
            WHERE p.categoria = 'oferta'
            AND
            v.descuento > 0
        )
    )
;