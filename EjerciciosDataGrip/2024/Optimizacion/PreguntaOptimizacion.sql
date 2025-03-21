/*
 Dado el siguiente esquema y las consultas A y B que podrían o
no responder el siguiente requerimiento “Seleccionar el
identificador de asignatura de aquellas asignaturas con
nombre Base de Datos y que pertenezcana profesores
simples con titulo de alguna ingeniería ordenados por código
de asignatura”  marque cuál de las siguientes afirmaciones
son correctas.
Notas las opciones incorrectas restan puntos
 */

--a
 SELECT DISTINCT a.cod_asig
FROM asignatura a JOIN asignatura_profesor ap ON
(a.cod_asig = ap.cod_asig)
      JOIN profesor p ON (ap.nro_documento =
p.nro_documento AND ap.tipo_documento =
p.tipo_documento)
      JOIN prof_simple ps ON (ps.nro_documento =
p.nro_documento AND ps.tipo_documento =
p.tipo_documento)
WHERE a.nombre_asig = 'Base de Datos'
AND p.tipo_prof = ‘S’
AND p.titulo LIKE ‘Ing%’
ORDER BY 1;

--b
SELECT a.cod_asig
FROM asignatura a
WHERE a.cod_asig IN (SELECT ap.cod_asig
                     FROM asignatura_profesor ap
                              JOIN (SELECT p.nro_documento,
                                           p.tipo_documento
                                    FROM profesor p
                                    WHERE p.titulo LIKE ‘Ing % ’
                                      AND p.tipo_prof = ‘S’) as t
                                   ON (ap.nro_documento = t.nro_documento
                                       AND ap.tipo_documento = t.tipo_documento))
  AND a.nombre_asig = 'Base de Datos'
ORDER BY 1;