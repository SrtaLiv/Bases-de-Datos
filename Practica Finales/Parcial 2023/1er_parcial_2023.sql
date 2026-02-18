-- Para el esquema de la figura cuyo script de creación se encuentra aquí, plantee el recurso declarativo más
-- adecuado que controle que “en cada area de investigación aplicada y para cada proyecto, pueden haber
-- como máximo 5 investigadores

-- en cada area de investigacion aplicada y para cada proyecto no pueden haber > de 5 investigadores
-- tables
-- Table: AREA_INVESTIGACION

CREATE ASSERTION ck_proyecto
CHECK(
       NOT EXISTS(
       SELECT 1
       FROM trabaja_en t1
       JOIN area_investigacion a
       on using(cod_area)
       WHERE investigacion_aplicada = true
        GROUP BY t.cod_area, t.tipo_proyecto, t.cod_proyecto
       HAVING COUNT(nro_investigador) > 5
       )
)

