--16 INCOMPLETO

--1) Seleccione el identificador y nombre de todas las instituciones que son Fundaciones.(V)--
SELECT id_institucion, nombre_institucion
FROM unc_esq_voluntario.institucion
WHERE nombre_institucion LIKE 'FUNDACION%';

--5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen coordinador.(V)
SELECT apellido, id_tarea
FROM unc_esq_voluntario.voluntario
WHERE id_coordinador IS NULL;
--si fuese que NO es null puedo hacer IS NOT NULL


--9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
--+51. Coloque el encabezado de las columnas de los títulos 'Apellido y Nombre' y 'Dirección de mail' (V)
SELECT telefono ,concat(nombre, ', ', apellido, ', ' ,e_mail) AS datos FROM voluntario WHERE telefono LIKE '+51%';


--11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios nacidos desde 1990. (V)
SELECT min(horas_aportadas), max(horas_aportadas), avg(horas_aportadas) FROM voluntario WHERE fecha_nacimiento >= '1990-01-01';

--15. ¿Cuántos cumpleaños de voluntarios hay cada mes?
SELECT
    to_char(fecha_nacimiento, 'Month') AS nombre_mes,
    COUNT(nro_voluntario) AS cumpleaños_por_mes
FROM voluntario
GROUP BY date_part('month', fecha_nacimiento), nombre_mes
ORDER BY date_part('month', fecha_nacimiento);

--16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?
SELECT id_institucion, count(nro_voluntario) as cant_voluntarios FROM voluntario GROUP BY id_institucion;

SELECT id_institucion, COUNT(*) AS cant_voluntarios
FROM voluntario
GROUP BY id_institucion
HAVING COUNT(*) >= (
    SELECT COUNT(*)
    FROM voluntario
    GROUP BY id_institucion
    ORDER BY COUNT(*) DESC
    LIMIT 1 OFFSET 1
)
ORDER BY cant_voluntarios  DESC
LIMIT 2;
