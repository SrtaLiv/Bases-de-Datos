--Ejercicio 1
--Consultas con anidamiento (usando IN, NOT IN, EXISTS, NOT EXISTS):

--1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante el año 2006. (P)
SELECT p.titulo
FROM unc_esq_peliculas.pelicula p
JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
WHERE e.fecha_entrega BETWEEN '2006-01-01' AND '2006-12-31'
AND p.idioma = 'Inglés';

--1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor nacional. Trate de resolverlo utilizando ensambles.(P)
SELECT count(p.codigo_pelicula)
FROM unc_esq_peliculas.pelicula p
JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
JOIN unc_esq_peliculas.distribuidor d ON e.id_distribuidor = d.id_distribuidor
WHERE e.fecha_entrega BETWEEN '2006-01-01' AND '2006-12-31'
AND d.tipo LIKE 'N';

--1.3. Indicar los departamentos que no posean empleados
-- cuya diferencia de sueldo máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
--(P) (Probar con 10% para que retorne valores)
SELECT *
FROM unc_esq_peliculas.departamento dep
WHERE (id_distribuidor, id_departamento) NOT IN

SELECT distinct id_distribuidor, id_departamento
FROM unc_esq_peliculas.empleado em
JOIN unc_esq_peliculas.tarea t USING (id_tarea)
WHERE (t.sueldo_maximo - t.sueldo_minimo) <=
      (t.sueldo_maximo * 0.4);


--1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos departamentos de Argentina y donde el jefe de
-- departamento posee una comisión de más del 10% de la que posee su empleado a cargo.

--PARA UNIR 2 TABLAS PONGO TODAS LAS PRIMARY KEY DE EMPLEADO, NO SOLA 1 CON TODAS LAS PRIMARY Y FK
SELECT nombre, apellido
FROM unc_esq_peliculas.empleado e
WHERE (id_departamento, id_distribuidor) IN
    (SELECT d.id_departamento, d.id_distribuidor
     FROM unc_esq_peliculas.empleado jefe
    JOIN unc_esq_peliculas.departamento d ON (jefe.id_empleado =
    d.jefe_departamento) JOIN unc_esq_peliculas.ciudad c USING (id_ciudad)
    JOIN unc_esq_peliculas.pais p USING (id_pais)
    WHERE upper(p.nombre_pais) = 'ARGENTINA' AND
     (jefe.porc_comision) > (e.porc_comision * 1.1 ))