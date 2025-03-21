--2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan aportes. Ordene el resultado por nombre de institución.

SELECT nombre_institucion as nombre, count(nro_voluntario) as cant_voluntarios FROM unc_esq_voluntario.institucion i
LEFT JOIN unc_esq_voluntario.voluntario v ON i.id_institucion = v.id_institucion
GROUP BY i.nombre_institucion
ORDER BY i.nombre_institucion;

--2.2. Determine la cantidad de coordinadores en cada país, agrupados por nombre de
-- país y nombre de continente. Etiquete la primer columna como 'Número de coordinadores'&;'

SELECT p.nombre_pais AS nombre_pais,
        c.nombre_continente AS  nombre_continente,
        COUNT(v.id_coordinador) AS nro_coord
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion ins ON v.id_institucion = ins.id_institucion
JOIN unc_esq_voluntario.direccion di ON ins.id_direccion = di.id_direccion
JOIN unc_esq_voluntario.pais p ON di.id_pais = p.id_pais
JOIN unc_esq_voluntario.continente c ON p.id_continente = c.id_continente
WHERE v.id_coordinador IS NOT NULL
GROUP BY p.nombre_pais, c.nombre_continente;

--2.3. Escriba una consulta para mostrar el apellido, nombre y fecha de nacimiento de}
--cualquier voluntario que trabaje en la misma institución que el Sr. de apellido Zlotkey.
--Excluya del resultado a Zlotkey.
SELECT nombre, apellido, fecha_nacimiento FROM unc_esq_voluntario.voluntario
WHERE id_institucion =
    (SELECT id_institucion FROM unc_esq_voluntario.voluntario WHERE apellido = 'Zlotkey') AND
    apellido != 'Zlotkey'
