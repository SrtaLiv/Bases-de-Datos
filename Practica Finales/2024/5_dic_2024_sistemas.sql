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

--2.b) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
-- actualizable en PostgreSQL, siempre que sea posible:

-- - V2: que contenga para cada cosecha con al menos 3 ventas realizadas, el identificador de la cosecha, la
-- cantidad total vendida y la fecha de la última venta registrada.

CREATE VIEW V2 AS
SELECT nro_cosecha, id_cultivo,
       SUM(cantidad_vendida) AS total_vendido,
       MAX(fecha_venta) AS ultima_venta
FROM venta
GROUP BY nro_cosecha,id_cultivo
HAVING COUNT(*) >= 3;

-- a. no es automáticamente actualizable al incluir agrupamiento en su definición CORRECTO
-- b. ninguna de las opciones
-- c. la cláusula HAVING incluida no permite asegurar que solo se incluyan cosechas con al menos tres ventas
-- realizadas
-- d. calcula incorrectamente la fecha de la última venta registrada y de la fecha de la última venta
-- registrada porque no incluye una cláusula WHERE para filtrar valores nulos
-- e. resulta automáticamente actualizable en PostgreSQL
-- f. no resuelve lo requerido debido a que la cantidad total vendida y la fecha de la última venta registrada
-- no se asocian adecuadamente a cada cosecha diferente
-- g. calcula correctamente la cantidad total vendida y la fecha de la última venta registrada por cada
-- cosecha diferente cCORRECTO
-- h. mediante la cláusula HAVING se asegura que solo se incluyan cosechas con al menos tres ventas
-- realizadas CORRECTO
-- i. resulta automáticamente actualizable para el estándar SQL
-- j. puede convertirse en actualizable si se elimina la cláusula HAVING

--2.c) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
-- actualizable en PostgreSQL, siempre que sea posible, y que se verifique que no haya migración de tuplas de la
-- vista:. Resuelva según lo solicitado y justifique su solución.

-- - V3: que contenga los datos de los cultivos que han tenido el mayor promedio de cantidad vendida el año
-- actual.

CREATE VIEW V3 AS
    SELECT *
    FROM cultivo
    WHERE ID_Cultivo IN (
        SELECT ID_Cultivo
        FROM Venta
        WHERE extract(YEAR FROM Fecha_Venta) = extract(YEAR FROM CURRENT_DATE)
        GROUP BY ID_Cultivo
        HAVING avg(Cantidad_vendida)  = ( -- CALCULA EL PROMEDIO DE LOS CULTIVOS
            SELECT MAX(promedio) -- OBTIENE EL MAYOR PROMEDIO
            FROM (
                     SELECT AVG(v2.Cantidad_vendida) AS promedio
                     FROM Venta v2
                     WHERE EXTRACT(YEAR FROM v2.Fecha_Venta) = EXTRACT(YEAR FROM CURRENT_DATE)
                     GROUP BY v2.ID_Cultivo
                 ) sub
        )
        )

--     3) Para el esquema dado, se ha creado la tabla cultivos_agricultor donde se requiere registrar la siguiente
-- información para todos los agricultores que están registrados en la base:
--
-- id_agricultor, nombre, fecha_registro, cantidad_cultivos, fecha_ultima_siembra
--
-- donde, para cada agricultor:
-- - cantidad_cultivos corresponde a la cantidad de cultivos que registra
-- - fecha_ultima_siembra es la fecha correspondiente a la última siembra que realizó

-- Nota: en caso que un agricultor no registre cultivos, se deberá indicar apropiadamente.

-- a) Implemente el método más adecuado en PostgreSQL que permita completar dicha tabla con la información
-- de todos los agricultores a partir de los datos existentes en la base. Explique su solución e incluya la sentencia
-- que debería utilizar un usuario para la ejecución del mismo.
-- Nota: no puede utilizar sentencias de bucle (for, loop, etc.) para resolverlo.

CREATE TABLE cultivos_agricultor as table agricultor;

ALTER TABLE cultivos_agricultor
    ADD COLUMN cantidad_cultivos decimal,
    ADD COLUMN fecha_ultima_siembra DATE;

INSERT INTO cultivos_agricultor (
    id_agricultor,
    nombre,
    fecha_registro,
    cantidad_cultivos,
    fecha_ultima_siembra
)
SELECT
    a.id_agricultor,
    a.nombre,
    a.fecha_registro,
    COUNT(c.id_cultivo) AS cantidad_cultivos,
    MAX(c.fecha_siembra) AS fecha_ultima_siembra
FROM agricultor a
         LEFT JOIN cultivo c
                   ON a.id_agricultor = c.id_agricultor
GROUP BY a.id_agricultor, a.nombre, a.fecha_registro;

--3.b) Indique y justifique todos los eventos críticos necesarios para mantener los datos actualizados en la tabla
-- cultivos_agricultor cuando se produzcan actualizaciones en la base. Incluya la declaración de los triggers
-- correspondientes en PostgreSQL y escriba la implementación de la/s función/es requerida/s para operaciones
-- de insert.

--debo tener en cuenta cuando se agreguen en la tabla de Agricultos y la de Cultivo.
-- Si insertan cultivos, cambia el count y quiza el MAX
CREATE OR REPLACE FUNCTION tr_ej_3_b()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE cultivos_agricultor
    SET cantidad_cultivos = (
    SELECT count(*)
    FROM cultivo c
    where new.id_agricultor
    = c.id_agricultor
    ),
        fecha_ultima_siembra = (
            SELECT max(Fecha_siembra)
            FROM cultivo c
            where new.id_agricultor
                      = c.id_agricultor
            )
    WHERE id_agricultor = NEW.id_agricultor;
    RETURN NEW;
end;
$$
language plpgsql;

CREATE TRIGGER tr_ej_3b
BEFORE INSERT ON cultivo
FOR EACH ROW EXECUTE FUNCTION tr_ej_3_b()

CREATE TRIGGER tr_ej_3b
    BEFORE INSERT ON agricultor
    FOR EACH ROW EXECUTE FUNCTION tr_ej_3_b()

--4) Dada la siguiente vista creada en PostgreSQL

create view V_Ventas_Cosecha as
select v.*, c.Fecha_Cosecha, c.Cantidad_cosechada
from Venta v join Cosecha using (ID_Cultivo, Nro_cosecha)
where Cantidad_vendida > 10000 ;