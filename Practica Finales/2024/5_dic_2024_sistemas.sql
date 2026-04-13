-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-11-23 03:09:32.821

-- tables
-- Table: Agricultor
CREATE TABLE Agricultor (
                            ID_Agricultor serial  NOT NULL,
                            Nombre varchar(100)  NOT NULL,
                            Email varchar(100)  NOT NULL,
                            Telefono varchar(15)  NULL,
                            Fecha_registro date  NULL,
                            CONSTRAINT Agricultores_pk PRIMARY KEY (ID_Agricultor)
);

-- Table: Cosecha
CREATE TABLE Cosecha (
                         ID_Cultivo int  NOT NULL,
                         Nro_cosecha int  NOT NULL,
                         Fecha_Cosecha date  NOT NULL,
                         Cantidad_cosechada decimal(10,2)  NOT NULL,
                         Precio_estimado decimal(10,2)  NOT NULL,
                         CONSTRAINT Cosechas_pk PRIMARY KEY (ID_Cultivo,Nro_cosecha)
);

-- Table: Cultivo
CREATE TABLE Cultivo (
                         ID_Cultivo serial  NOT NULL,
                         Nombre_cultivo varchar(100)  NOT NULL,
                         Tipo varchar(50)  NOT NULL,
                         Fecha_siembra date  NOT NULL,
                         ID_agricultor int  NULL,
                         CONSTRAINT Cultivos_pk PRIMARY KEY (ID_Cultivo)
);

-- Table: Inventario
CREATE TABLE Inventario (
                            ID_Cultivo int  NOT NULL,
                            ID_Proveedor int  NOT NULL,
                            Cantidad_recibida decimal(10,2)  NOT NULL,
                            Fecha_recepcion date  NOT NULL,
                            CONSTRAINT Inventario_pk PRIMARY KEY (ID_Cultivo,ID_Proveedor)
);

-- Table: Proveedor
CREATE TABLE Proveedor (
                           ID_Proveedor serial  NOT NULL,
                           Nombre varchar(100)  NOT NULL,
                           Rubro varchar(100)  NOT NULL,
                           Telefono varchar(15)  NULL,
                           Email varchar(100)  NULL,
                           CONSTRAINT Proveedores_pk PRIMARY KEY (ID_Proveedor)
);

-- Table: Venta
CREATE TABLE Venta (
                       ID_Cultivo int  NOT NULL,
                       Nro_cosecha int  NOT NULL,
                       Fecha_Venta date  NOT NULL,
                       Cantidad_vendida decimal(10,2)  NOT NULL,
                       Precio_unitario decimal(10,2)  NOT NULL,
                       CONSTRAINT Ventas_pk PRIMARY KEY (Fecha_Venta,Nro_cosecha,ID_Cultivo)
);

-- foreign keys
-- Reference: FK_cosecha_cultivo (table: Cosecha)
ALTER TABLE Cosecha ADD CONSTRAINT FK_cosecha_cultivo
    FOREIGN KEY (ID_Cultivo)
        REFERENCES Cultivo (ID_Cultivo)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_cultivo_agricultor (table: Cultivo)
ALTER TABLE Cultivo ADD CONSTRAINT FK_cultivo_agricultor
    FOREIGN KEY (ID_agricultor)
        REFERENCES Agricultor (ID_Agricultor)
        ON DELETE  SET NULL
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_cultivo (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_cultivo
    FOREIGN KEY (ID_Cultivo)
        REFERENCES Cultivo (ID_Cultivo)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_proveedor (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_proveedor
    FOREIGN KEY (ID_Proveedor)
        REFERENCES Proveedor (ID_Proveedor)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_venta_cosecha (table: Venta)
ALTER TABLE Venta ADD CONSTRAINT FK_venta_cosecha
    FOREIGN KEY (ID_Cultivo, Nro_cosecha)
        REFERENCES Cosecha (ID_Cultivo, Nro_cosecha)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

-- 1.a) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
-- declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
-- tablas/atributos necesarios.

-- - Controlar que los proveedores tengan registrado un teléfono o un email.

-- Seleccione la opción que considera correcta, de acuerdo a lo solicitado y justifique claramente (debajo de la
-- pregunta -- 1.c )
-- a. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (Telefono IS NULL OR Email IS NULL); NO

--ejemplo: TELEFONO = NULL  EMAIL = NULL F O V = PASARIA. ASI Q INCORRECTO

-- b. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (Telefono IS NULL AND Email IS NULL);

--ejemplo: TELEFONO = NULL  EMAIL = NULL F O V = PASARIA. ASI Q INCORRECTO

-- c. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (Telefono IS NOT NULL OR Email IS NOT NULL);

--ejemplo: TELEFONO = NULL  EMAIL = NULL F O V = NO PASARIA. ASI Q ES CORRECTO!
--
--
-- d. Ninguna de las opciones

-- e. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (Telefono IS NOT NULL AND Email IS NOT NULL); -- INCORRECTO PQ SOLO NECESITAMOS 1 Q NO SEA NULL

-- f. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (NOT EXISTS (SELECT 1 from PROVEEDOR
-- WHERE Telefono IS NOT NULL OR Email IS NOT NULL)); -- CREO Q ES CORRECTO TAMIEN
-- correccion gptiana: el f no es calido en sql estandar, pq los check oslo revisan la fila actual.

--
-- g. ALTER
-- TABLE Proveedor
-- ADD CONSTRAINT chk_contacto
-- CHECK (NOT EXISTS (SELECT 1 from PROVEEDOR
-- WHERE Telefono IS NULL AND Email IS NULL)); -- INCORERCTO


-- 1.b) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
-- declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
-- tablas/atributos necesarios.

-- - Verificar que la cantidad total vendida de cada cosecha no exceda la cantidad cosechada de la misma.

a. ALTER TABLE venta add constraint check_fecha_siembra
CHECK (not exists ( select 1 from cosecha c join venta v using (id_cultivo)
group by id_cultivo
having SUM(v.cantidad_vendida) > c.cantidad_cosechada ) );

b. CREATE ASSERTION check_fecha_siembra
CHECK ( not exists ( select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
group by id_cultivo, nro_cosecha
having SUM(v.cantidad_vendida) > c.cantidad_cosechada ) );

c. CREATE ASSERTION check_fecha_siembra
CHECK (not exists ( select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
where SUM(v.cantidad_vendida) > c.cantidad_cosechada
group by nro_cosecha ) );

d. Ninguna de las opciones
e. CREATE ASSERTION check_fecha_siembra
CHECK ( exists ( select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
group by id_cultivo, nro_cosecha
having SUM(v.cantidad_vendida) <= c.cantidad_cosechada ) );

f. CREATE ASSERTION check_fecha_siembra
CHECK (not exists ( select 1 from cosecha c join venta v using (id_cultivo)
group by id_cultivo
having SUM(v.cantidad_vendida) > c.cantidad_cosechada ) );

g. ALTER TABLE cosecha add constraint check_fecha_siembra
CHECK (not exists ( select 1 from cosecha c join venta v using (nro_cosecha)
group by nro_cosecha
having SUM(v.cantidad_vendida) <= c.cantidad_cosechada ) );


--1.c) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
-- declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
-- tablas/atributos necesarios.

-- - Para cada cultivo, los números de cosecha deben reflejar el orden cronológico de las fechas de cosecha; es
-- decir, un número de cosecha mayor debe corresponder a una fecha de cosecha posterior para el mismo cultivo.

-- para la consigna necesito la tabla Cosecha, con el nro_cosecha y fecha_cosecha. Dicho en otras palabras

CREATE ASSERTION ck_cosecha
CHECK (
    NOT EXISTS(
        SELECT 1
        FROM Cosecha c1
         JOIN Cosecha c2
        on c1.id_cultivo = c2.id_cultivo
        WHERE c1.Nro_cosecha > c2.Nro_cosecha
        AND c1.Fecha_Cosecha <= c2.Fecha_Cosecha

    )
    )
)

-- c1: id: 1 fecha 1/02/2026
-- c2: id: 2 fecha 1/01/2026

--chequear que no exista ningun nro_cosecha mayor si este mismo tiene una fecha_cosecha menor a otras cosechas

       --no queremos que pase esto:
-- c1: id: 2 fecha 1/01/2026
-- c2: id: 1 fecha 1/02/2026

-------------------------

-- 2.a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
-- -- actualizable en PostgreSQL, siempre que sea posible:

-- - V1: que contenga los datos de los cultivos sembrados durante el corriente año que no registren inventario de
-- productos adquiridos al proveedor ‘AgroPlus’.

-- Considerando la siguiente definición para V1, seleccione la/s afirmación/es que considere correcta/s respecto
-- de esta vista (Nota: tenga en cuenta que las opciones incorrectamente seleccionadas pueden restar puntaje) y
-- justifíquela/s claramente (debajo de la pregunta 2.c).

CREATE VIEW V1 AS
SELECT * FROM cultivo
WHERE EXTRACT(YEAR FROM fecha_siembra) = EXTRACT(YEAR FROM CURRENT_DATE)
  AND id_cultivo IN ( SELECT id_cultivo FROM inventario
                                                 JOIN proveedor using (id_proveedor)
                      WHERE nombre <> 'AgroPlus' );

-- a, no es actualizbale pq trae +1 tabla. C0RRECTO
-- b, falso porque si cumple lo requerido
-- c, falso
-- d, falso
-- e, falso
-- f, correcto
-- g, falso
-- h, correcto
-- i,
-- j, falso

-- CORRECCION:
-- d, hay q cambiar IN po rNOT IN y <> por =
-- e, correcta
-- f, correcta
-- g, correcta