-- “en cada sucursal rural y por cada categoría
-- pueden haber como máximo 50 productos”

CREATE ASSERTION
CHECK NOT EXISTS(
SELECT 1
FROM SUCURSAL s
JOIN PRODUCTOS_X_SUCURSAL p
USING (cod_sucursal)
WHERE sucursal_rural = TRUE
GROUP BY p.tipo_categoria, p.cod_categoria, p.cod_sucursal
HAVING count(nro_producto) > 50
)



-- Last modification date: 2023-05-28 00:42:39.743

-- tables
-- Table: CATEGORIA
CREATE TABLE CATEGORIA (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (tipo_categoria,cod_categoria)
);

-- Table: PRODUCTO
CREATE TABLE PRODUCTO (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    descripcion varchar(30)  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria)
);

-- Table: PRODUCTOS_X_SUCURSAL
CREATE TABLE PRODUCTOS_X_SUCURSAL (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    cod_sucursal int  NOT NULL,
    CONSTRAINT PK_PRODUCTOS_X_SUCURSAL PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria,cod_sucursal)
);

-- Table: SUCURSAL
CREATE TABLE SUCURSAL (
    cod_sucursal int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sucursal_rural boolean  NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (cod_sucursal)
);

-- foreign keys
-- Reference: FK_PRODUCTOS_X_SUCURSAL_PRODUCTO (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_PRODUCTOS_X_SUCURSAL_PRODUCTO
    FOREIGN KEY (nro_producto, tipo_categoria, cod_categoria)
    REFERENCES PRODUCTO (nro_producto, tipo_categoria, cod_categoria)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PRODUCTOS_X_SUCURSAL_SUCURSAL (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_PRODUCTOS_X_SUCURSAL_SUCURSAL
    FOREIGN KEY (cod_sucursal)
    REFERENCES SUCURSAL (cod_sucursal)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PRODUCTO_CATEGORIA (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_CATEGORIA
    FOREIGN KEY (tipo_categoria, cod_categoria)
    REFERENCES CATEGORIA (tipo_categoria, cod_categoria)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.
 ---------

-- PREGUNTA 6
--FK_VISITA_LABORATORIO
--ON UPDATE RESTRICT
--ON DELETE RESTRICT

--FK_VISITA_MEDICO
--ON UPDATE RESTRICT
--ON DELETE RESTRICT

DELETE FROM MEDICO WHERE tipo_doc = ‘PAS’; --PROCEDE

UPDATE MEDICO SET nro_doc = 33376 WHERE nro_doc =12376; --procede

DELETE FROM MEDICO WHERE tipo_doc = ‘DNI’
AND nro_doc =’32456’; --falla

DELETE FROM VISITA WHERE id_lab = 1; --procede

UPDATE MEDICO SET nro_doc = 33376 WHERE
nro_doc =34266; --falla

DELETE FROM LABORATORIO WHERE id_lab=2; --falla

UPDATE LABORATORIO SET id_lab = 8 WHERE
id_lab = 3; -- falla