-- Utilizando el esquema unc_esq_peliculas. Cual es el resultado correcto que indica las tres tareas que tienen la
-- mayor diferencia entre sueldo máximo y mínimo, y además que el sueldo mínimo sea menor a 5500.

SELECT t.id_tarea, (t.sueldo_maximo - t.sueldo_minimo) as diferencia
FROM unc_esq_peliculas.tarea t
WHERE t.sueldo_minimo < 5500
ORDER BY diferenci
    º
LIMIT 3;

--Utilizando el esquema unc_esq_peliculas escriba la consulta SQL que liste los identificadores de tareas y
-- nombre de tarea de aquellas tareas cuyo sueldo máximo supere los 13000 y que han sido realizadas por
-- empleados de los departamentos de la calle ‘Dakuktaa’ . Utilice en al menos una subconsulta el operador EXISTS.

SELECT t.id_tarea, t.nombre_tarea
FROM unc_esq_peliculas.tarea t
WHERE t.sueldo_maximo > 13000
AND EXISTS(
    SELECT 1
    FROM unc_esq_peliculas.empleado e
    JOIN unc_esq_peliculas.departamento d USING (id_departamento, id_distribuidor)
    WHERE t.id_tarea = e.id_tarea
    AND d.calle = 'Dakuktaa'
)


-- Utilizando el esquema de películas unc_esq_peliculas, cuales son los identificadores de los 3 empleados más
-- jovenes que han participado en departamentos cuyos distribuidores han tenido más de 5 entregas tomando los
-- años 2012 y 2013

SELECT e.id_empleado
FROM unc_esq_peliculas.empleado e
JOIN unc_esq_peliculas.departamento d
USING (id_distribuidor)
WHERE d.id_distribuidor IN (
    SELECT  en.id_distribuidor
    from unc_esq_peliculas.entrega en
    WHERE EXTRACT(YEAR FROM en.fecha_entrega) BETWEEN 2012 AND 2013
    GROUP BY en.id_distribuidor
    HAVING COUNT(*) > 5
)
ORDER BY e.fecha_nacimiento DESC
LIMIT 3;

-- utilice el recurso mas conveniente para retornar todos los datos de las areas de investigacion
-- que no posean investigadores de un proyecto (campo descripcion de proyecto) dada por parametro

CREATE OR REPLACE FUNCTION FN_DATOS_AREA_INVESTIACION_SIN_INVESTIGADOR()
RETURNS TABLE (cod_area INT, descripcion VARCHAR, investigacion_aplicada BOOLEAN) AS $$
BEGIN
    RETURN QUERY
    SELECT a.cod_area, a.descripcion, a._investigacion_aplicada
    FROM unc_46203524.area_investigacion a
    WHERE NOT EXISTS(
        SELECT 1
        FROM "Tudai25".unc_41099363.trabaja_en t
        INNER JOIN proyecto p USING (id_proyecto)
        INNER JOIN investigador USING (cod_proyecto)
        WHERE p.descripcion = descripcion_proyecto
        AND t.cod_area = a.cod_area
    );
END;
    $$
LANGUAGE plpgsql;