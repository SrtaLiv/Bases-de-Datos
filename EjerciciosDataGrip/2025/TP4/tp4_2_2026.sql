/*Ejercicio 1
Consultas con anidamiento (usando IN, NOT IN, EXISTS, NOT EXISTS):
1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante
el año 2006. (P)
1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
nacional. Trate de resolverlo utilizando ensambles.(P)
1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
(P) (Probar con 10% para que retorne valores)
1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)
1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
jefe) se encuentren en la Argentina.
1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos
departamentos de Argentina y donde el jefe de departamento posee una comisión de más
del 10% de la que posee su empleado a cargo.*/

1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante
el año 2006. (P)
SELECT codigo_pelicula
FROM peliculas
WHERE codigo_pelicula
IN
(
    SELECT codigo_pelicula
    FROM PELICULA
    WHERE IDIOMA = 'INGLES'
    WHERE nro_entrega
    IN
    (
        SELECT nro_entrega n
        FROM entrega
        WHERE extract(year from fecha_entrega) = 2006
        and n.nro_entrega = p.nro_entrega
    )
)

--1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
-- nacional. Trate de resolverlo utilizando ensambles.(P)
SELECT sum(cantidad) -- OR COUNT(codigo_pelicula)?
FROM renglon_entrega
JOIN ENTREGA USING (nro_entrega)
JOIN distribuidor USING (id_distribuidor)
WHERE EXTRACT(YEAR FROM fecha_entrega) = 2006
AND tipo = 'N'

SELECT count(*) -- OR COUNT(codigo_pelicula)?
FROM renglon_entrega
         JOIN ENTREGA USING (nro_entrega)
         JOIN distribuidor USING (id_distribuidor)
WHERE EXTRACT(YEAR FROM fecha_entrega) = 2006
  AND tipo = 'N'


 --   1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
--máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
SELECT id_departamento
FROM DEPARTAMENTO d
WHERE NOT EXISTS(
    SELECT 1
    FROM EMPLEADO e
    JOIN TAREA t
    JOIN tarea t ON e.id_tarea = t.id_tarea
    WHERE d.id_departamento = e.id_departamento

          AND e.id_distribuidor = d.id_distribuidor
    AND  (sueldo_maximo - sueldo_minimo) < sueldo_maximo * 0.40
)

-- 1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)
SELECT p.codigo_pelicula
FROM pelicula p
WHERE NOT EXISTS (
    SELECT 1
    FROM renglon_entrega r
             JOIN entrega e
                  ON r.nro_entrega = e.nro_entrega
             JOIN distribuidor d
                  ON e.id_distribuidor = d.id_distribuidor
    WHERE r.codigo_pelicula = p.codigo_pelicula
      AND d.tipo = 'N'
);
)

--1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
--jefe) se encuentren en la Argentina.

SELECT DISTINCT em.*
FROM empleado em
WHERE EXISTS (
    SELECT 1
    FROM empleado e
    WHERE e.id_jefe = em.id_empleado
)
  AND EXISTS (
    SELECT 1
    FROM departamento d
             JOIN ciudad c ON d.id_ciudad = c.id_ciudad
             JOIN pais p ON c.id_pais = p.id_pais
    WHERE d.id_departamento = em.id_departamento
      AND d.id_distribuidor = em.id_distribuidor
      AND UPPER(p.nombre_pais) = 'ARGENTINA'
);

--1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos
--departamentos de Argentina y donde el jefe de departamento posee una comisión de más
--del 10% de la que posee su empleado a cargo
--
SELECT apellido, nombre
FROM EMPLEADOS E
JOIN DEPARTAMENTO d USING (id_departamento, id_distribuidor)
JOIN CIUDAD USING (id_ciudad)
JOIN PAIS USING(id_pais)
WHERE nombre_pais = 'ARGENTINA'
AND EXISTS(
    SELECT 1
    FROM EMPLEADO jefe
    WHERE e.jefe_departamento = jefe.id_jefe
    AND jefe.porc_comision > 0.10 * e.porc_comision
)

--Consultas que involucran agrupamiento:
--1.7. Indicar la cantidad de películas entregadas a partir del 2010, por género.
select count(distinct p.codigo_pelicula)
from renglon_entrega r
join pelicula p on p.codigo_pelicula = r.codigo_pelicula
join entrega e using (nro_entrega)
where extract(year from e.fecha_entrega) >= 2010
group by p.genero

--1.8. Realizar un resumen de entregas por día, indicando el video club al cual se le
-- realizó la entrega y la cantidad entregada. Ordenar el resultado por fecha.
SELECT

-- Ejercicio 2
-- Considere la base de Voluntarios del Práctico 3 y resuelva las siguientes consultas (pueden
-- Involucrar anidamiento y/o agrupamiento).
-- 2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan
-- aportes. Ordene el resultado por nombre de institución.
SELECT id_institucion, nombre, count(nro_voluntarios)
FROM institucion i
JOIN voluntario v
USING (id_institucion)

