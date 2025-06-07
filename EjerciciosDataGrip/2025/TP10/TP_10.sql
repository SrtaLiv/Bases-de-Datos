-- Ejercicio 1
--
--
-- Se desea obtener un listado de todos los voluntarios incluyendo identificador de voluntario,
-- nombre, apellido, email,  identificador de institución, horas aportadas y
-- por cada voluntario el total de horas aportadas por todos los voluntarios de su
-- misma institución. Ordenado por el total de horas aportadas por institución en orden descendente.

SELECT
    v.nro_voluntario,
    v.nombre,
    v.apellido,
    v.e_mail,
    v.id_institucion,
    v.horas_aportadas,
    SUM(v.horas_aportadas) OVER(PARTITION BY v.id_institucion) AS total_horas_institucion
FROM
    unc_esq_voluntario.voluntario v
ORDER BY
    total_horas_institucion DESC;

-- Ejercicio 2
--
--
-- Se desea obtener un listado de todos los voluntarios incluyendo su
-- identificador, nombre, apellido, y la tarea que desempeñan.
-- Además, se requiere calcular un ranking por tarea, que indique
-- la posición de cada voluntario dentro de su tarea según la
-- cantidad de horas aportadas, ubicando en los primeros puestos
-- a quienes más horas han contribuido.

SELECT v.nro_voluntario, v.nombre, v.apellido, v.id_tarea,
rank() OVER (PARTITION BY v.id_tarea ORDER BY v.horas_aportadas DESC )
    AS posicion_voluntario_por_horas
FROM unc_esq_voluntario.voluntario v;

-- Ejercicio 3
-- Utilizando la consulta anterior, cómo se modificaría para
-- obtener sólo aquellos voluntarios que aportan más horas por tarea.


-- todo proyecto debe tener un directivo,
--  si tiene personal trabajando en el


-- NO TIENE SENTIDO HACER UN
-- JOIN ENTRE TRABAJA EN Y DIRECTIVO
-- BUSCAR LO CONTRARIO
-- TODO PROYECTO NO DEBE TENER UN DIRECITVO SI TIENE PERSONAL
-- TRABAJANDO EN EL
CREATE ASSERION
CHECK NOT EXISTS(
       SELECT 1
       FROM TRABAJA_EN T
        WHERE NOT EXISTS(
       SELECT 1 FROM DIRECTIVO D
       WHERE D.COD_TIPO_PROY = T.COD_TIPO_PROY
       AND D.ID_PROYECTO = T.ID_PROYECTO
    )
)

CREATE FUNCTION FN_DIRECTIVO() RETURNS TRIGGER AS $$
BEGIN
    IF (NOT EXISTS(
              SELECT 1 FROM DIRECTIVO D
            WHERE (D.COD_TIPO_PROY, D.ID_PROYECTO) = (NEW.COD_TIPO_PROY,
            NEW.ID_PROYECTO)
    )
    RAISE EXCEPTION 'ERROR'
    END IF;
    RETURN NEW;
END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER TR_TRBAJA_EN
    BEFORE INSERT OR UPATE OF COD_TIPO)PROY, ID_PROYECTO ON TRABAJA_EN
    FOR EACH ROW
    EXECUTE FUNCTION FN_DIRECTIVO();