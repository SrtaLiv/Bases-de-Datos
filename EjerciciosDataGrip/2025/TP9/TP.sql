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
-- horas aportadas y por cada voluntario el total de horas aportadas por todos los voluntarios de su misma institución. Ordenado por el total de horas aportadas por institución en orden descendente.
