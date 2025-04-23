Set SEARCH_PATH = unc_esq_voluntario;
Set SEARCH_PATH = unc_esq_peliculas;

--1. Seleccione el identificador y nombre de todas las instituciones que son Fundaciones.(V)
SELECT id_institucion, nombre_institucion
FROM unc_esq_voluntario.institucion
WHERE nombre_institucion LIKE 'FUNDACION%';

-- 2 Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos
-- los departamentos.(P)
Set SEARCH_PATH = unc_esq_peliculas;

SELECT id_departamento, id_distribuidor FROM unc_esq_peliculas.departamento;
SELECT * FROM unc_esq_peliculas.departamento;

-- 5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen
-- coordinador.(V)
Set SEARCH_PATH = unc_esq_voluntario;

SELECT apellido, id_tarea FROM voluntario WHERE id_coordinador IS NULL;

-- 9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
-- +51. Coloque el encabezado de las columnas de los títulos 'Apellido y Nombre' y 'Dirección
-- de mail'. (V)
SELECT concat(apellido, ' ', nombre, ' ') AS "Apellido y nombre",
e_mail AS "Direccion de mail"
FROM voluntario
WHERE telefono LIKE '+51%';

-- 11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios
-- nacidos desde 1990. (V)
SELECT min(horas_aportadas), max(horas_aportadas), avg(horas_aportadas)
FROM voluntario
WHERE fecha_nacimiento >= '1990-01-01';
select horas_aportadas, fecha_nacimiento from voluntario WHERE fecha_nacimiento >= '1990-01-01';

-- PENDIENTES:
-- 3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231,
-- ordenados por apellido y nombre.(P)
-- 4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de
-- comisión.(P)
-- 6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono.
-- (P)
-- 7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo
-- sueldo sea superior a $ 1000. (P)
-- 8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)


-- 10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
-- el apellido (concatenados y separados por una coma) y su fecha de cumpleaños (solo el
-- día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)
SELECT nombre AS " ", apellido as " ",
CONCAT(
    DATE_PART('day', fecha_nacimiento), ', ',
    DATE_PART('month', fecha_nacimiento)
  ) AS "Fecha de nacimiento"
from empleado
order by "Fecha de nacimiento" asc;

SELECT
  nombre AS "Nombre",
  apellido AS "Apellido",
  CONCAT(EXTRACT(DAY FROM fecha_nacimiento), ', ', EXTRACT(MONTH FROM fecha_nacimiento)) AS "Fecha de nacimiento"
FROM empleado
ORDER BY "Fecha de nacimiento" ASC
;

-- elect (nombre','apellido) as "Nombre, Apellido", (extract(DAY FROM fecha_nacimiento) ', 'extract(MONTH FROM fecha_nacimiento)) as "fecha de cumpleaños"
-- from empleado;
-- select nombre, fecha_nacimiento FROM empleado ORDER BY fecha_nacimiento ASC


-- 12. Listar la cantidad de películas que hay por cada idioma. (P)
SELECT count(codigo_pelicula), idioma FROM pelicula
GROUP BY idioma;

-- 13. Calcular la cantidad de empleados por departamento. (P)
select count(id_empleado), id_departamento
from empleado
group by id_departamento;

-- 14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas,
-- NO cantidad de películas entregadas).
SELECT codigo_pelicula FROM renglon_entrega WHERE nro_entega >= 3 AND nro_entrega <= 5;

-- 15. ¿Cuántos cumpleaños de voluntarios hay cada mes?
SELECT count(fecha_nacimiento), extract(month from fecha_nacimiento) AS "MES" FROM voluntario
GROUP BY (extract(month from fecha_nacimiento))
ORDER BY "MES";

-- 16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?
-- ordena de mayor a menor → primero aparecen las que tienen más voluntarios (¡lo que necesitamos!).
SELECT id_institucion, COUNT(*) AS cantidad_voluntarios
FROM voluntario
GROUP BY id_institucion
ORDER BY cantidad_voluntarios DESC
LIMIT 2;

-- 17. ¿Cuáles son los id de ciudades que tienen más de un departamento?
SELECT id_ciudad FROM departamento
GROUP BY (id_ciudad)
HAVING count(*) > 1;

-- 18. ¿Cuáles son los distribuidores con más de 3 departamentos?
SELECT id_distribuidor
FROM departamento
GROUP BY id_distribuidor
HAVING COUNT(*) > 3;

-- 19. Seleccionar la cantidad de empleados por jefe
SELECT count(id_empleado), id_jefe FROM empleado
WHERE id_jefe IS NOT NULL;

SELECT count(id_empleado), id_jefe FROM empleado
WHERE id_jefe IS NOT NULL
GROUP BY id_jefe


-- 20. Seleccionar aquellos departamentos donde el sueldo promedio supere los 4500$

SELECT id_departamento
FROM empleado
group by id_departamento
HAVING avg(sueldo)
 > 4500