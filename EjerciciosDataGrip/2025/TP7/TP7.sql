CREATE VIEW Distribuidor_200 AS
SELECT id_distribuidor, nombre, tipo
FROM unc_esq_peliculas.distribuidor
WHERE id_distribuidor > 200;

CREATE VIEW Departamento_dist_200 AS
SELECT id_departamento, nombre, id_ciudad, jefe_departamento
FROM unc_esq_peliculas.departamento
WHERE id_distribuidor > 200;

-- a. Discuta si las vistas son actualizables o no y justifique.
-- PRIMER VIEW:
-- Es actualizable ya que contiene las PK entera, no contiene ufncion de agrupacion, no tiene
-- distinct ni subconsulta

-- SEGUNDA VIEW:
--  A departamento le falta su otra PK id_distribuidor, por lo tanto le faltan PK

-- b. Considere que algunos registros de la tabla Distribuidor son:
-- id_distribuidor | nombre | direccion | telefono | tipo
-- 1049 | distribuidor 1049 | Doro | 7312893 | N
-- 1050 | Distribuidor 1050 | Lakadjs | 563424 | N


CREATE VIEW Distribuidor_1000 AS
SELECT *
FROM unc_esq_peliculas.distribuidor d
WHERE id_distribuidor > 1000;

-- Si se ejecuta la siguiente sentencia:
INSERT INTO Distribuidor_1000 VALUES (1050, 'NuevoDistribuidor 1050',
                                      'Montiel 340', '569842-264', 'N');

-- Indique y justifique la opción correcta:
-- A. Falla porque la vista no es actualizable.
-- B. Falla porque si bien la vista es actualizable viola una restricción de foreign key.
-- C. Falla porque si bien la vista es actualizable viola una restricción de primary key.
-- D. Procede exitosamente.

-- C, el INSERT intenta insertar un registro con id_distribuidor = 1050, y ese ID ya existe en la tabla base

------------------------------------------------------------------------------------------------------------------------

-- Ejercicio 2
-- Considere el esquema de la BD unc_esq_peliculas:
-- 1. Escriba las sentencias de creación de cada una de las vistas solicitadas en cada caso.

-- 2. Indique si para el estandar SQL y/o Postgresql dicha vista es actualizable o no, si es de
-- Proyección-Selección (una tabla) o Proyección-Selección-Ensamble (más de una
-- tabla). Justifique cada respuesta.
--
-- 1. Cree una vista EMPLEADO_DIST que liste el nombre, apellido, sueldo, y fecha_nacimiento de
-- los empleados que pertenecen al distribuidor cuyo identificador es 20.

CREATE VIEW EMPLEADO_DIST AS
SELECT nombre, apellido, sueldo, fecha_nacimiento
FROM unc_esq_peliculas.empleado e
WHERE id_distribuidor = 20;

CREATE TABLE tabla AS
SELECT * FROM unc_esq_peliculas.empleado;

-- no es actualizable, falta seleccionar la PK

-- 2. Sobre la vista anterior defina otra vista EMPLEADO_DIST_2000 con el nombre, apellido y
-- sueldo de los empleados que cobran más de 2000.

CREATE VIEW EMPLEADO_DIST_2000 AS
SELECT nombre, apellido, sueldo
FROM unc_esq_peliculas.empleado e
WHERE sueldo > 2000;
-- No es actualizable por la misma razon anterior. No respeta la VISTA KEY PRESERVED
-- Es de Proyeccion-Seleccion

-- 3. Sobre la vista EMPLEADO_DIST cree la vista EMPLEADO_DIST_20_70 con aquellos
-- empleados que han nacido en la década del 70 (entre los años 1970 y 1979).
CREATE VIEW EMPLEADO_DIST_20_70 AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST
 WHERE extract(year from fecha_nacimiento) BETWEEN 1970 AND 1979;
--No es actulaizable, misma razon anterior
-- proyeccion-seleccion

-- 4. Cree una vista PELICULAS_ENTREGADA que contenga el código de la película y la cantidad de
-- unidades entregadas.
CREATE VIEW PELICULAS_ENTREGADAS AS
SELECT codigo_pelicula, cantidad
FROM unc_46203524.renglon_entrega;
-- no es actualizable, falta la pk nro_entrega
-- proyeccion-seleccion

-- 5. Cree una vista ACCION_2000 con el código, el titulo el idioma y el formato de las películas del
-- género ‘Acción’ entregadas en el año 2006.
CREATE VIEW ACCION_2000 AS
SELECT codigo_pelicula, cantidad
FROM unc_46203524.renglon_entrega;
--Es actualizable para postgresql
--Es de Proyeccion-Seleccion

-- 6. Cree una vista DISTRIBUIDORAS_ARGENTINA con los datos completos de las distribuidoras
-- nacionales y sus respectivos departamentos.
CREATE VIEW DISTRIBUIDORAS_ARGENTINA AS
SELECT    n.id_distribuidor,
    n.nro_inscripcion,
    n.encargado,
    n.id_distrib_mayorista,
    dep.id_departamento
FROM unc_esq_peliculas.distribuidor d
JOIN unc_esq_peliculas.departamento dep
ON dep.id_distribuidor = d.id_distribuidor
JOIN unc_esq_peliculas.nacional n ON d.id_distribuidor = n.id_distribuidor
WHERE tipo = 'N';

-- Para postgresql no estructuralmente, ya que en el from hay 2 tablas
-- Es de Proyeccion-Seleccion-Esamble

-- 7. De la vista anterior cree la vista Distribuidoras_mas_2_emp con los datos completos de las
-- distribuidoras cuyos departamentos tengan más de 2 empleados.
CREATE VIEW DISTRIBUIDORAS_MAS_2_EMPLEADOS AS
    SELECT *
    FROM DISTRIBUIDORAS_ARGENTINA da
    WHERE (
        SELECT count(id_empleado)
        FROM DISTRIBUIDORAS_ARGENTINA da
        INNER JOIN unc_esq_peliculas.empleado e
        ON da.id_departamento= e.id_departamento AND da.id_distribuidor= e.id_distribuidor) >2;

SELECT *
FROM DISTRIBUIDORAS_MAS_2_EMPLEADOS;

--No es actualizable porque la vista anterior no es
--Es de Proyeccion-Seleccion

-- 8. Cree la vista PELI_ARGENTINA con los datos completos de las productoras y las películas que
-- fueron producidas por empresas productoras de nuestro país.
CREATE VIEW PELI_ARGENTINA AS
    SELECT pr.codigo_productora,
           pr.id_ciudad,
           pr.nombre_productora,
           p.titulo,
           p.idioma,
           p.genero,
           p.formato,
           p.codigo_pelicula
    FROM unc_esq_peliculas.empresa_productora pr
    JOIN unc_esq_peliculas.pelicula p
    USING (codigo_productora)
    JOIN unc_esq_peliculas.ciudad c
    USING (id_ciudad)
    JOIN unc_esq_peliculas.pais pa
    USING (id_pais)
    WHERE pa.nombre_pais ILIKE 'argentina'
;

SELECT * FROM PELI_ARGENTINA;

--No es actualizable porque involucra en el select mas de una tabla
--Es de Proyeccion-Seleccion


-- 9. De la vista anterior cree la vista ARGENTINAS_NO_ENTREGADA para las películas producidas
-- por empresas argentinas pero que no han sido entregadas
CREATE or replace VIEW ARGENTINAS_NO_ENTREGADA AS
    SELECT *
    FROM PELI_ARGENTINA p
    WHERE NOT EXISTS (
        SELECT e.codigo_pelicula
        FROM unc_esq_peliculas.renglon_entrega e
        WHERE p.codigo_pelicula= e.codigo_pelicula
    );
-- no es actualizable, hay subconsultas
-- proyecion - seleccion

SELECT * FROM ARGENTINAS_NO_ENTREGADA;

-- 10. Cree una vista PRODUCTORA_MARKETINERA con las empresas productoras que hayan
-- entregado películas a TODOS los distribuidores.
CREATE OR REPLACE VIEW PRODUCTORA_MARKETINERA AS
SELECT *
FROM unc_esq_peliculas.empresa_productora em
WHERE EXISTS(
    SELECT 1
    FROM unc_esq_peliculas.pelicula p2
    JOIN unc_esq_peliculas.empresa_productora p3
    USING (codigo_productora)
);

-- Ejercicio 3
-- Analice cuáles serían los controles y el comportamiento ante actualizaciones sobre las
-- vistas EMPLEADO_DIST, EMPLEADO_DIST_2000 y EMPLEADO_DIST_20_70 (agregue
-- las columnas necesarias para que las vistas sean actualizables) creadas en el ej. 2, si las
-- mismas están definidas con WITH CHECK OPTION LOCAL o CASCADE en cada una de
-- ellas. Evalúe todas las alternativas.

CREATE or replace VIEW EMPLEADO_DIST AS
SELECT nombre, apellido, sueldo, fecha_nacimiento, e.id_empleado
FROM unc_46203524.empleado e
WHERE id_distribuidor = 20;

CREATE or replace VIEW EMPLEADO_DIST_2000 AS
SELECT nombre, apellido, sueldo, e.id_empleado
FROM unc_46203524.empleado e
WHERE sueldo > 2000;

CREATE or replace VIEW EMPLEADO_DIST_20_70 AS
SELECT nombre, apellido, sueldo, id_empleado
FROM EMPLEADO_DIST
WHERE extract(year from fecha_nacimiento) BETWEEN 1970 AND 1979;

SELECT * FROM unc_46203524.empleado_dist_20_70;

CREATE TABLE empleado AS
SELECT * FROM unc_46203524.empleado;

-- CASCADED: Chequea la integridad sobre la vista y cualquiera dependeinte de ella.
-- LOCAL: Chequea la integridad solo de la vista

-- En empleado_dist tiene de dependiente a EMPLEADO_DIST_20_70
-- EMPLEADO DIST: 99 FILAS
-- EMPLEADO_20_70: 36 FILAS

-- PRUEBA INSERT:
--1597,Oscar A.,Toro ,,3325.00,Toro@gmail.com,1978-12-17,219-9951,6487,77,72,30510

INSERT INTO empleado (id_empleado, nombre, apellido, porc_comision, sueldo, e_mail, fecha_nacimiento, telefono,
                      id_tarea,id_departamento, id_distribuidor, id_jefe)
VALUES (1597,'oLIVIA', 'Todesco',3325.00, 30,'Toro2@gmail.com',
        '1978-12-17','219-9951',6487,77,20,30510
);

INSERT INTO empleado (id_empleado, nombre, apellido, porc_comision, sueldo, e_mail, fecha_nacimiento, telefono,
                      id_tarea,id_departamento, id_distribuidor, id_jefe)
VALUES (15973,'panchito', 'mayo',3325.00, 30,'Toro2@gmail.com',
        '1978-12-17','219-9951',6487,77,20,30510
);

SELECT * FROM unc_46203524.empleado WHERE empleado.nombre ILIKE 'OLIVIA';
SELECT * FROM unc_46203524.empleado_dist;
SELECT * FROM unc_46203524.empleado_dist_20_70;

-- Se insertaron, y se actualizaron haciendo desde empleado! ahora probare insertar desde la VISTA

DELETE FROM unc_46203524.empleado_dist WHERE empleado_dist.nombre ILIKE 'OLIVIA';

-- resultado: se elimino desde todas las tablas, dist_20_70 y dist, y la tabla empleado

-- y si quiero INSERTAR desde la vista?!
INSERT INTO empleado_dist (nombre, apellido, sueldo, fecha_nacimiento, id_empleado)
VALUES ('Prueba', 'Vista', 4000, '1975-05-01', 2025);
SELECT * FROM unc_46203524.empleado WHERE empleado.nombre ILIKE 'PRUEBA';

-- si inserta! no insertaria si faltaran columnas importantes, ej que fecha nacimiento sea obligatoria y no este,
-- ahora probaremos quitar algunas columnas a ver que pasa!

INSERT INTO unc_46203524.empleado_dist_20_70 (nombre, apellido, sueldo, id_empleado)
VALUES ('CARMEN', 'ASD', 121, 1239123);
-- FALLA! Porque falta POR EJEMPLO la columna fecha nacimiento que es obligatoria jeje

-- LUEGO PROBEMOS SI AL INSERTAR ALGO QUE ESTA FUERA DE LA FECHA QUE ESTABLECIO LA VISTA "HIJA"
-- ES DECIR NO CUMPLIR EL RANGO ED FECHA QUE TIENE DIST_20_70
INSERT INTO empleado_dist (nombre, apellido, sueldo, fecha_nacimiento, id_empleado)
VALUES ('Prueba2', 'Vista', 4000, '1935-05-01', 212025);

SELECT * FROM unc_46203524.empleado WHERE empleado.nombre ILIKE 'PRUEBA2';
-- si lo inserta, pq no estamos modificando desde la hija. Que pasa ahora si modificamosd esde dist_20_70

INSERT INTO empleado_dist_20_70 (nombre, apellido, sueldo, id_empleado)
VALUES ('Prueba3', 'Vista', 4000, '1935-05-01', 212026);
-- asi, no inserta por la fecha. Falla

-- TODAS LAS PRUEBAS DE ARRIBA FUERON CON CASCADED POR DEFECTO, AHORA PROBAREMOS CON LOCAL
-- ELIMINAMOS LAS TABLAS Y LE AGREGAMOS LA RESTRICCION DE INTEGRIDAD

CREATE or replace VIEW EMPLEADO_DIST_2000 AS
SELECT nombre, apellido, sueldo, e.id_empleado, e.id_distribuidor
FROM unc_46203524.empleado e
WHERE sueldo > 2000
WITH LOCAL CHECK OPTION ;

CREATE  OR REPLACE VIEW empleado_dist AS
SELECT * FROM empleado
WHERE id_distribuidor = 20;

CREATE OR REPLACE VIEW empleado_dist_20_70 AS
SELECT * FROM empleado_dist
WHERE EXTRACT(YEAR FROM fecha_nacimiento) BETWEEN 1970 AND 1979
WITH LOCAL CHECK OPTION;

INSERT INTO empleado_dist_20_70
(nombre, apellido, sueldo, fecha_nacimiento, id_empleado, id_distribuidor)
VALUES ('Local', 'Test', 4500, '1979-01-01', 222223, 21);
-- PASA


-- YA ENTENDI! PUSE LOCAL CHECK OPTION EN EL PADRE, SI SE LO SACO AHI SI ME DEJARIA INSERTAR
-- CON ID DISTRIBUIDOR 21!! :D (ANTEs)


------------------------------------------------------------------------------------------------------------
-- EJERCICIO 4
------------------------------------------------------------------------------------------------------------


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

-- Transformar en actualizables para PostgreSQL las siguientes vistas:

CREATE VIEW V1
AS SELECT
FROM unc_46203524.p5p1e1_articulo
WHERE EXTRACT(year from fecha_publicacion) > 2015;
-- esta vista no es actualizable ya que para que lo sea debe haber una unica tabla en el from, y tampoco puede haber
-- un JOIN

-- OPCION 2 CON TRIGGER
CREATE OR REPLACE VIEW V1_TRIGGER AS
SELECT a.id_articulo, a.titulo, a.autor, c.idioma, c.cod_palabra
FROM P5P1E1_ARTICULO a
JOIN P5P1E1_CONTIENE c ON a.id_articulo = c.id_articulo;

CREATE OR REPLACE FUNCTION actualizar_v1()
RETURNS TRIGGER AS $$
BEGIN
     UPDATE P5P1E1_ARTICULO
    SET titulo = NEW.titulo, autor = NEW.autor
    WHERE id_articulo = NEW.id_articulo;

    RETURN NEW;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER v1_update
INSTEAD OF UPDATE ON V1
FOR EACH ROW
EXECUTE FUNCTION actualizar_v1();

CREATE VIEW V2
AS SELECT
FROM p5p2e3_articulo JOIN p5p2e3_contiene
WHERE idioma, cod_palabra IN (SELECT idioma, cod_palabra
FROM p5p2e3_palabra
WHERE lower(descripcion) like ‘%bases de datos%’)