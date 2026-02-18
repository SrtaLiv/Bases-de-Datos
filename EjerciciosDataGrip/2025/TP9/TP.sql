SELECT i.id_institucion, nombre_institucion, count(*), i.id_director
FROM unc_esq_voluntario.institucion i JOIN unc_esq_voluntario.voluntario v
ON (i.id_institucion = v.id_institucion)
GROUP BY i.id_institucion;

-- Esto esta permitidio, aunq los atributos no esten en el group by ya que
-- son de la tabla INSTITUCION, y el group by esta con esa tabla. Por lo que
-- no genera ambiguedad. Si hiciera v.nombre_institucion ahi SI, pq estoy usando
-- la tabla voluntario

SELECT i.id_institucion, nombre_institucion, count(*), i.id_director, v.nombre
FROM unc_esq_voluntario.institucion i JOIN unc_esq_voluntario.voluntario v
ON (i.id_institucion = v.id_institucion)
GROUP BY i.id_institucion, v.nombre;
-- aca si en el group by, agrego algo del voluntario ahi si me permitiria

SELECT i.id_institucion, nombre_institucion, count(*), i.id_director, v.nombre, v.apellido
FROM unc_esq_voluntario.institucion i JOIN unc_esq_voluntario.voluntario v
ON (i.id_institucion = v.id_institucion)
GROUP BY i.id_institucion, v.nombre;
-- aca NO me deja!, solo permite agregar atributos de mas en la primer tabla del select

SELECT v.nombre, i.nombre_institucion
FROM unc_esq_voluntario.institucion i JOIN unc_esq_voluntario.voluntario v
ON (i.id_institucion = v.id_institucion)
GROUP BY v.id_institucion, v.nombre, i.id_institucion;
-- aca si me deja, pq estoy agregando un atributo de institucion, y en group
-- by tengo algo de institucion. Si saco el i.id_institucion no me dejaria


--------------------------------------------------

-- Ejercicio 1
--
--
-- Se desea obtener un listado de todos los voluntarios incluyendo
-- identificador de voluntario, nombre, apellido, email, identificador de institución,
-- horas aportadas y por cada voluntario el total de horas aportadas por todos los voluntarios de su misma institución.
-- Ordenado por el total de horas aportadas por institución en orden descendente.
SELECT v.nombre, v.apellido, v.e_mail,  v.nro_voluntario,
sum(v.horas_aportadas) OVER (PARTITION BY v.id_institucion) as total_horas_de_todos_los_voluntarios_x_institucion
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i
USING (id_institucion)
ORDER BY total_horas_de_todos_los_voluntarios_x_institucion DESC;

-- sum(v.horas_aportadas) OVER (PARTITION BY v.id_institucion) as total_horas_de_todos_los_voluntarios_x_institucion
-- quiere decir: quiero ver la suma de cada v.horas_aportadas, y tambien ver por voluntarios de su misma institucion
-- parecido a un group by pero sin agrupar por cada fila



-- Ejercicio 2
-- Se desea obtener un listado de todos los voluntarios incluyendo su identificador, nombre, apellido, y la tarea que
-- desempeñan. Además, se requiere calcular un ranking por tarea, que indique la posición de cada voluntario dentro
-- de su tarea según la cantidad de horas aportadas, ubicando en los primeros puestos a quienes más horas han contribuido.

SELECT v.nro_voluntario, v.nombre, v.apellido, t.id_tarea,  t.nombre_tarea,  -- si querés mostrar el nombre
rank() OVER (PARTITION BY t.id_tarea ORDER BY v.horas_aportadas DESC) as ranking_por_tarea
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.tarea t
USING (id_tarea)
ORDER BY
  t.id_tarea, ranking_por_tarea;

-- Ejercicio 3
-- Utilizando la consulta anterior, cómo se modificaría para obtener sólo aquellos voluntarios que aportan más
-- horas por tarea.

SELECT * FROM (
SELECT nro_voluntario, nombre, apellido, id_tarea, horas_aportadas,
   rank() OVER (partition by id_tarea ORDER BY horas_aportadas DESC) AS ranking
FROM unc_esq_voluntario.voluntario) as v WHERE ranking = 1

-- Ejercicio 4
--
--
-- Se desea obtener un informe con la cantidad de voluntarios agrupada a distintos niveles geográficos: por continente,
-- por país y por ciudad. Probar variantes de GROUPING SETS, CUBE, y ROLLUP.

--ROLLUP
SELECT  c.id_continente, p.id_pais, d.ciudad, COUNT(*) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i
USING (id_institucion)
JOIN unc_esq_voluntario.direccion d
USING (id_direccion)
JOIN unc_esq_voluntario.pais p
USING (id_pais)
JOIN unc_esq_voluntario.continente c
USING ( id_continente)
GROUP BY ROLLUP (c.id_continente, p.id_pais, d.ciudad );

--GROUPING SETS
SELECT  c.id_continente, p.id_pais, d.ciudad, COUNT(*) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i
USING (id_institucion)
JOIN unc_esq_voluntario.direccion d
USING (id_direccion)
JOIN unc_esq_voluntario.pais p
USING (id_pais)
JOIN unc_esq_voluntario.continente c
USING ( id_continente)
-- WHERE c.id_continente IS NOT NULL AND p.id_pais IS NOT NULL AND d.ciudad IS NOT NULL
GROUP BY GROUPING SETS ((c.id_continente), (p.id_pais), (d.ciudad), ())
ORDER BY c.id_continente, p.id_pais, d.ciudad;

-- cube, te da todas las pobiles cobinaciones ej:

SELECT
  COALESCE(CAST(c.id_continente AS TEXT), 'Total Continente') AS continente,
  COALESCE(p.id_pais, 'Total País') AS pais,
  COALESCE(d.ciudad, 'Total Ciudad') AS ciudad,
  COUNT(*) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i USING (id_institucion)
JOIN unc_esq_voluntario.direccion d USING (id_direccion)
JOIN unc_esq_voluntario.pais p USING (id_pais)
JOIN unc_esq_voluntario.continente c USING (id_continente)
GROUP BY CUBE (c.id_continente, p.id_pais, d.ciudad)
ORDER BY continente, pais, ciudad;
-- continenete
-- ccontinente + país + ciudad
-- contienne + pais
-- continente + ciudad
-- país + ciudad
-- solo país, solo ciudad, solo continente

--Ejercicio 5
-- Se desea obtener un listado de todos los voluntarios que incluya su número de voluntario, el
-- identificador de la tarea que realiza, y la cantidad de horas aportadas. Además, se requiere calcular el promedio
-- de horas aportadas por tarea y, para cada voluntario, la diferencia entre sus horas aportadas y ese promedio.

-- nro_voluntario | id_tarea | horas_aportadas | promedio_horas_tarea | dif_horas_aportadas_promedio

SELECT v.nro_voluntario, v.id_tarea, v.horas_aportadas,
avg(v.horas_aportadas) OVER (PARTITION BY v.id_tarea) as promedio_horas_tarea,
v.horas_aportadas - avg(v.horas_aportadas) OVER (PARTITION BY v.id_tarea) AS dif_horas_aportadas_promedio
FROM unc_esq_voluntario.voluntario v;

