-- Ejercicio 1
-- Con el comando EXPLAIN explique cómo transformó la consulta el optimizador de PostgreSQL armando el query plan
-- en cada una de las sentencias:
--
-- a) Listado de las entregas que poseen las película de terror (esquema Películas)

SET ENABLE_SETSCAN = ON;


EXPLAIN ANALYZE SELECT p.titulo, e.nro_entrega
FROM unc_esq_peliculas.pelicula p, unc_esq_peliculas.renglon_entrega re, unc_esq_peliculas.entrega e
WHERE p.codigo_pelicula = re.codigo_pelicula
AND re.nro_entrega = e. nro_entrega
AND genero = 'Terror';

-- Planning Time: 0.598 ms
-- Execution Time: 2.352 ms

-- CON INDICE:
-- Planning Time: 0.612 ms
-- Execution Time: 2.530 ms

EXPLAIN ANALYZE SELECT p.titulo, e.nro_entrega
FROM unc_esq_peliculas.pelicula p
JOIN unc_esq_peliculas.renglon_entrega re
   USING (codigo_pelicula)
JOIN unc_esq_peliculas.entrega e
USING (nro_entrega)
WHERE p.codigo_pelicula = re.codigo_pelicula
AND re.nro_entrega = e. nro_entrega
AND genero = 'Terror';

-- Planning Time: 1.023 ms
-- Execution Time: 5.900 ms

-- CON INDICE
-- Planning Time: 0.603 ms
-- Execution Time: 2.490 ms


CREATE TABLE pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;

CREATE TABLE entrega AS
SELECT * FROM unc_esq_peliculas.entrega;

CREATE TABLE renglon_entrega AS
SELECT * FROM unc_esq_peliculas.renglon_entrega;

-- creando indice
CREATE INDEX idx_genero ON unc_46203524.pelicula(genero);

-- los problemas de la consulta original es que puede gnerar ambiguedad por las columnas sin preifijo, y
-- los joins son implicitos, es menos claro

-- b) Listado de los datos de contacto (nombre, apellido, email y teléfono) de todos los voluntarios que hayan
-- desarrollado tareas de hasta 5000 hs (max_horas - min_horas) y que las hayan finalizado antes del 24/07/1998
-- (esquema Voluntario).

EXPLAIN ANALYZE SELECT  V.nombre, V.apellido, V.e_mail, V.telefono
FROM unc_esq_voluntario.voluntario V
WHERE V.nro_voluntario IN (SELECT H.nro_voluntario
                    FROM unc_esq_voluntario.historico H
                    WHERE H.fecha_fin < to_date('1998-07-24', 'yyyy-mm-dd') AND
                    H.id_tarea IN (SELECT T.id_tarea
                                   FROM unc_esq_voluntario.tarea T
                                   WHERE (T.max_horas - T.min_horas) <= 5000));

-- Planning Time: 0.565 ms
-- Execution Time: 0.633 ms
SET enable_seqscan = off;

EXPLAIN ANALYZE SELECT  V.nombre, V.apellido, V.e_mail, V.telefono
FROM unc_esq_voluntario.voluntario V
JOIN  unc_esq_voluntario.historico H
USING (nro_voluntario)
JOIN unc_esq_voluntario.tarea T ON H.id_tarea = T.id_tarea
WHERE H.fecha_fin < to_date('1998-07-24', 'yyyy-mm-dd')
  AND (T.max_horas - T.min_horas) <= 5000;

-- Planning Time: 0.385 ms
-- Execution Time: 0.438 ms
<
>