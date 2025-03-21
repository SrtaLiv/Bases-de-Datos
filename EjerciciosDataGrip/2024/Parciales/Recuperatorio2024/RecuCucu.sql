/*
 Utilizando el esquema unc_esq_peliculas escriba una consulta SQL optimizada que liste identificadores y nombres de las distintas ciudades
 que tienen departamentos de los distribuidores de las direcciones que comienzan con 'Gar'.
 Utilice al menos una subconsulta con el operador EXISTS.
 */

 SELECT id_ciudad, nombre_ciudad FROM unc_esq_peliculas.ciudad c
 WHERE EXISTS(
     SELECT 1
     FROM unc_esq_peliculas.distribuidor d
     JOIN unc_esq_peliculas.departamento dep ON d.id_distribuidor = dep.id_distribuidor
     WHERE dep.id_ciudad = c.id_ciudad
     AND upper(d.direccion) like 'GAR&');

/*
Utilizando el esquema unc_esq_peliculas. Cual es el genero que más películas tiene?
 */

SELECT genero, COUNT(codigo_pelicula) AS cantidad_peliculas
FROM unc_esq_peliculas.pelicula
GROUP BY genero
ORDER BY cantidad_peliculas DESC
LIMIT 1;


/*
 pregunta 5 acciones
USUARIO PK

 USUARIO_GESTION
 DELETE CASCADE
 UPDATE RESTRICT

 USUARIO_ASIGNACION
 DELETE RESTRICT
 UPDATE RESTRICT

 --SI ES DESDE LA PK SE SUELE PODER AUNQ TENGA REFERENCIAS, SI ES DESDE LA FK ESTA MAS DIFICIL.

 1 falso, se eliminan los usurios que tambien son referenciados
 2 FALSE, GESTIONES ES DELETE CASCADE PERO ASIGNACION TIENE DELETE RESTRICT
 3 FALSO, NO FALLA!
 4 FALSO
 5 VERDAD - ES FALSO
 6 FALSO, PK NO PUEDE SER NULL
 7 VERDADERO, PK NO PUEDE SER NULL

 */
-- Crear la tabla usuario


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Crear la tabla P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo INT NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    autor VARCHAR(30) NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Crear la tabla P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo INT NOT NULL,
    idioma CHAR(2) NOT NULL,
    cod_palabra INT NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo, idioma, cod_palabra)
);

-- Crear la tabla P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma CHAR(2) NOT NULL,
    cod_palabra INT NOT NULL,
    descripcion VARCHAR(25) NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma, cod_palabra)
);

-- Añadir la clave foránea FK_P5P1E1_CONTIENE_ARTICULO con ON DELETE RESTRICT
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    ON DELETE restrict
    ON UPDATE CASCADE ;


--RESTRICT:
DELETE FROM P5P1E1_ARTICULO WHERE id_articulo = 1; --Falla al eliminar la PK pq en CONTIENE hay RESTRICT, TIENE REFERENCIAS.
DELETE FROM P5P1E1_CONTIENE WHERE id_articulo = 1; -- Procede porque el delete es RESTRICT pero lo eliminamos unicamente los de tabla con FK. En articulo no paso nada.

UPDATE P5P1E1_ARTICULO SET id_articulo = 4 WHERE id_articulo = 2; --FALLA
UPDATE P5P1E1_CONTIENE SET id_articulo = 4 WHERE id_articulo = 2; --FALLA

--CASCADE:
DELETE FROM P5P1E1_ARTICULO WHERE id_articulo = 1; -- PROCEDE al eliminar la PK pq en CONTIENE hay CASCADE, se elimina en ambas tablas
DELETE FROM P5P1E1_CONTIENE WHERE id_articulo = 2; --Procede, pero solo se elimina en su propia tabla.

UPDATE P5P1E1_ARTICULO SET id_articulo = 4 WHERE id_articulo = 2; --PROCEDE y se ve reflejado en ambas tablas
UPDATE P5P1E1_CONTIENE SET id_articulo = 2 WHERE id_articulo = 1; --falla

SELECT * FROM P5P1E1_ARTICULO;
SELECT * FROM P5P1E1_CONTIENE;

-- Inserción de datos en la tabla P5P1E1_ARTICULO
INSERT INTO P5P1E1_ARTICULO (id_articulo, titulo, autor) VALUES
(1, 'Introducción a PostgreSQL', 'Juan Perez'),
(2, 'Bases de Datos Avanzadas', 'Maria Lopez'),
(3, 'SQL para Principiantes', 'Carlos García');

-- Inserción de datos en la tabla P5P1E1_PALABRA
INSERT INTO P5P1E1_PALABRA (idioma, cod_palabra, descripcion) VALUES
('EN', 101, 'Database'),
('EN', 102, 'Table'),
('ES', 201, 'Base de Datos'),
('ES', 202, 'Tabla');

-- Inserción de datos en la tabla P5P1E1_CONTIENE
INSERT INTO P5P1E1_CONTIENE (id_articulo, idioma, cod_palabra) VALUES
(1, 'EN', 101),
(1, 'ES', 201),
(2, 'EN', 102),
(2, 'ES', 202),
(3, 'EN', 101),
(3, 'ES', 201);
