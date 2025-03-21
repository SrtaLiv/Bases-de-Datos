--Seleccionar todos los voluntarios que aportan la mínima cantidad de horas:
SELECT nombre, apellido
FROM
voluntario
WHERE horas_aportadas = (SELECT MIN(horas_aportadas)
FROM voluntario);

--Instituciones donde la mínima cantidad de horas que aportan sus voluntarios es mayor que
-- la mínima cantidad de horas que aportan los de la institución 40.
SELECT ins.id_instituciones, min(horas_aportadas)
FROM voluntarios
GROUP BY ins.id_instituciones
HAVING min(horas_aportadas) > (select min(horas_aportadas)
                               FROM voluntario WHERE id_institucion = 40)


--Seleccionar el nombre y apellido de los voluntarios del estado (provincia) de Texas
SELECT nombre, apellido FROM voluntarios v, institucion i, direccion d
WHERE v.id_institucion = i.id_institucion
AND i.id_institucion = d.id_direccion
AND d.provincia = 'texas'

--Ejemplo: Listar los voluntarios que realizan las tareas
--ST_CLERK, SA_MAN, SA_REP o IT_PROG
SELECT voluntarios FROM voluntarios
WHERE id_tarea IN ('stclear', 'sman')

--Ejemplo:Liste el apellido y nombre de los empleados que trabajan en departamentos de Argentina.


SELECT e.nombre, e.apellido FROM empleados e
WHERE (SELECT e.id_empleado FROM departamento WHERE
SELECT pais FROM departamentos WHERE nombre_pais = 'ARGENTINA'
                                                  )

--el que esta bien hecho:
SELECT e.nombre, e.apellido
FROM empleado e
WHERE (e.id_departamento, e.id_distribuidor) IN (
SELECT d.id_departamento,d.id_distribuidor
FROM departamento d
WHERE d.id_ciudad IN (
SELECT c.id_ciudad
FROM ciudad c
WHERE c.id_pais IN (
SELECT p.id_pais
FROM pais p
WHERE nombre_pais = 'ARGENTINA'
)
)
);

--Listar todas las instituciones que no poseen voluntarios
SELECT id_instituciones, nombre_institucion
FROM instituciones
WHERE id_instituciones NOT IN (SELECT DISTINCT id_institucion FROM voluntarios);

