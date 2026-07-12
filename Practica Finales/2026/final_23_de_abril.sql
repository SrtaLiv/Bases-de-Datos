-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-04-21 18:43:25.567

-- tables
-- Table: AREA_CONOCIMIENTO
CREATE TABLE AREA_CONOCIMIENTO (
                                   area char(5)  NOT NULL,
                                   nombre varchar(50)  NOT NULL,
                                   descripcion varchar(200)  NOT NULL,
                                   ubicacion varchar(30)  NULL,
                                   CONSTRAINT PK_AREA_CONOCIMIENTO PRIMARY KEY (area)
);

-- Table: EJEMPLAR
CREATE TABLE EJEMPLAR (
                          nro_libro int  NOT NULL,
                          area char(5)  NOT NULL,
                          nro_ejemplar int  NOT NULL,
                          estado_ejemplar varchar(10)  NOT NULL,
                          CONSTRAINT PK_EJEMPLAR PRIMARY KEY (nro_ejemplar,nro_libro,area)
);

-- Table: LIBRO
CREATE TABLE LIBRO (
                       nro_libro int  NOT NULL,
                       area char(5)  NOT NULL,
                       titulo varchar(100)  NOT NULL,
                       resumen varchar(500)  NOT NULL,
                       autor varchar(50)  NOT NULL,
                       editorial varchar(30)  NOT NULL,
                       anio_publicacion int  NOT NULL,
                       CONSTRAINT PK_LIBRO PRIMARY KEY (nro_libro,area)
);

-- Table: PRESTAMO
CREATE TABLE PRESTAMO (
                          nro_usuario int  NOT NULL,
                          nro_libro int  NOT NULL,
                          area char(5)  NOT NULL,
                          nro_ejemplar int  NOT NULL,
                          fecha_retiro date  NOT NULL,
                          fecha_devolucion date  NULL,
                          situacion char(1)  NOT NULL,
                          CONSTRAINT PK_PRESTAMO PRIMARY KEY (fecha_retiro,nro_ejemplar,area,nro_libro,nro_usuario)
);

-- Table: USUARIO
CREATE TABLE USUARIO (
                         nro_usuario int  NOT NULL,
                         apell_nombre varchar(50)  NOT NULL,
                         e_mail varchar(50)  NOT NULL,
                         telefono varchar(20)  NOT NULL,
                         fecha_alta date  NOT NULL,
                         categoria char(1)  NULL,
                         institucion varchar(30)  NOT NULL,
                         CONSTRAINT PK_USUARIO PRIMARY KEY (nro_usuario)
);

-- foreign keys
-- Reference: FK_EJEMPLAR_LIBRO (table: EJEMPLAR)
ALTER TABLE EJEMPLAR ADD CONSTRAINT FK_EJEMPLAR_LIBRO
    FOREIGN KEY (nro_libro, area)
        REFERENCES LIBRO (nro_libro, area)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_LIBRO_AREA_CONOCIMIENTO (table: LIBRO)
ALTER TABLE LIBRO ADD CONSTRAINT FK_LIBRO_AREA_CONOCIMIENTO
    FOREIGN KEY (area)
        REFERENCES AREA_CONOCIMIENTO (area)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_PRESTAMO_EJEMPLAR (table: PRESTAMO)
ALTER TABLE PRESTAMO ADD CONSTRAINT FK_PRESTAMO_EJEMPLAR
    FOREIGN KEY (nro_ejemplar, nro_libro, area)
        REFERENCES EJEMPLAR (nro_ejemplar, nro_libro, area)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_PRESTAMO_USUARIO (table: PRESTAMO)
ALTER TABLE PRESTAMO ADD CONSTRAINT FK_PRESTAMO_USUARIO
    FOREIGN KEY (nro_usuario)
        REFERENCES USUARIO (nro_usuario)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.


-- El esquema de creación de las tablas se encuentra en este link.
--
-- Se debe incorporar la siguiente regla del negocio sobre el esquema dado:
--
-- cada usuario no puede tener más de 3 préstamos activos.
--
-- a) Implemente dicha restriccion de manera declarativa
--
-- b) Proponga una solucion completa para que mediante trigger en PostgreSQL permita controlar adecuadamente la regla.

--Prestamo -> UPDATE, INSERT (nro_usuario, situacion)

CREATE FUNCTION fn_limite_prestamos_x_usuario()
    RETURNS TRIGGER AS $$
    DECLARE cantMaxima int;
BEGIN
    SELECT count(*) INTO cantMaxima
    FROM PRESTAMO
    WHERE situacion = 'A'
    AND nro_usuario = new.nro_usuario
    GROUP BY nro_usuario;

    IF cantMaxima >= 3 THEN RAISE EXCEPTION 'EL USUARIO' , new.nro_usuario , 'NO PUEDE TENER MAS DE 3 PRESTAMOS ACTIVOS';
    end if;
    return new;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER tr_limite
    BEFORE INSERT OR UPDATE of situacion, nro_usuario ON PRESTAMO
    FOR EACH ROW
    EXECUTE FUNCTION fn_limite_prestamos_x_usuario();

-- A) Considere que deben definirse las siguientes restricciones sobre el esquema dado, incluya su implementación
-- completa según el estándar SQL con el recurso declarativo más restrictivo posible y justifique:
--
--1) Los usuarios no pertenecientes a la UNICEN que posean categoría estudiante pueden retirar
-- sólo hasta 10 ejemplares de libros en el mismo mes calendario.

-- USUARIO -> Categoria 'E', Institucion = 'Unicen'
-- PRESTAMO -> nro_libro, area, nro_ejemplar < 10

-- chequear que no existan usuarios que no sean de unicen, categroia estudiante con mas de 10 ejemplares en el mismo mes
SELECT 1
FROM USUARIO
JOIN PRESTAMO USING(nro_usuario)
WHERE categoria = 'E'
AND institucion = 'Unicen'
AND situacion = 'A'
group by nro_usuario, extract(MONTH FROM fecha_retiro)
having count(nro_ejemplar) >= 10;

CREATE ASSERTION CK_LIMITE_EJEMPLARES(
       CHECK(
       NOT EXISTS(
           SELECT 1
            FROM USUARIO
            JOIN PRESTAMO USING(nro_usuario)
            WHERE categoria = 'E'
            AND institucion = 'Unicen'
            AND situacion = 'A'
            group by nro_usuario, extract(MONTH FROM fecha_retiro)
            having count(nro_ejemplar) > 10;
        )
       )
)

--ejemplar
--nro_libro, area, nro_ejemplar
-- 1, 'A', 3
--2, 'B', 4
--2, 'B', 5

-- prestamo
--nro_usuario, nro_libro, area, nro_ejemplar, fecha_retiro, situacon
-- 1, 1, A, 3, DICIEMBRE, A
-- 1, 2, B, 4, ENERO, A
-- 1, 2, B, 5, ENERO, A

--NRO_USUARIO, FECHA_RETIRO
-- 1, DICIMEMBRE = COUNT EJEMPLAR 1 -> ESTE PASA
-- 1, ENERO = COUNT EJEMPLAR 2 -> ESTE NO PASA

CRE

--El esquema de creación de las tablas se encuentra en este link.

a) Para las vistas que se indican sobre el esquema dado, se requiere en cada caso completar adecuadamente l
       os espacios con .…..... en la implementación provista en PostgreSQL (sin modificarla):
vista1, que contenga los datos de los usuarios que tienen más de 3 préstamos activos sin fecha de devolución establecida.

CREATE VIEW vista1 AS
SELECT *
FROM USUARIO u
WHERE EXISTS (
    SELECT nro_usuario
    FROM PRESTAMO p
    WHERE situacion = 'A'
    AND p.nro_usuario = u.nro_usuario
    AND fecha_devolucion IS NULL
    GROUP BY p.nro_usuario
    HAVING count(*) > 3
    );


vista2, que contenga todos los números de usuario junto con el total de préstamos que tienen activos y la última fecha de retiro de un ejemplar.

CREATE VIEW vista2 AS
SELECT u.nro_usuario, count(*) as total_prestamos_activos, max(fecha_retiro) as ultima_fecha_retiro  ----
FROM USUARIO u
JOIN PRESTAMO p USING(nro_usuario)
WHERE situacion = 'A'
GROUP BY nro_usuario;

-- b) Discuta si las vistas anteriores resultan automáticamente actualizables en PostgreSQL. En caso que no, detalle por qué y explique cómo implementar actualizaciones.
-- vista1: No es automáticamente actualizable, ya que aunque selecciona datos de una sola tabla, la condición depende de
-- una subconsulta con agrupamiento y función de agregación sobre PRESTAMO.
--
-- vista2: No es automáticamente actualizable porque involucra un JOIN entre USUARIO y PRESTAMO,
-- agrupamiento y funciones de agregación COUNT y MAX.

-- Para permitir actualizaciones sobre estas vistas se podrían definir triggers INSTEAD OF sobre la vista,
-- indicando manualmente qué operaciones deben realizarse sobre las tablas base.

-- --
-- D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
-- claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
-- artículos que contengan hasta 10 palabras claves.

--
-- ARTICULO, nacionalida = "A" UPDATE
-- CONTIENE, id_articulo, INSERT, UPDATE

CREATE FUNCTION limit_arg() RETURNS TRIGGER AS $$
DECLARE
    nacion varchar;
    cantMax int;

BEGIN
    SELECT a.nacionalidad into nacion
    FROM p5p1e1_articulo a
    WHERE p5p1e1_articulo.id_articulo = new.id_articulo;

    IF (nacion = 'Argentina') THEN
        SELECT count(*) INTO cantMax
        FROM p5p1e1_articulo a
        JOIN public.p5p1e1_contiene p5p1e1c on a.id_articulo = p5p1e1c.id_articulo
        WHERE a.id_articulo = new.id_articulo
        group by autor;
    if cantMax >= 10 THEN RAISE EXCEPTION 'EL AUTOR NO PUEDE TENER MAS DE 10 PALABRAS CLAVES POR ARTICULO';
    END IF;
    end if;
end;
$$

create trigger tr_limite
BEFORE INSERT OR UPDATE of id_articulo ON p5p1e1_contiene FOR EACH ROW
    EXECUTE FUNCTION limit_arg();

create trigger tr_limite
    BEFORE INSERT OR UPDATE of nacionalidad ON p5p1e1_articulo FOR EACH ROW
EXECUTE FUNCTION limit_arg();