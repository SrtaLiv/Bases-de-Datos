/**
  Ejercicio 1
Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y
cuándo realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la
siguiente estructura:
HIS_TAREA(nro_registro, fecha, operación, usuario)

a) Provea el/los trigger/s necesario/s para mantener en forma automática la tabla HIS_TAREA
cuando se realizan actualizaciones (insert, update o delete) en la tabla TAREA.
 */

-- Ejercicio 1 - (A)
-- HIS_TAREA(nro_registro, fecha, operacion, usuario)
CREATE TABLE HIS_TAREA (
    nro_registro INTEGER,
    fecha TIMESTAMP,
    operacion VARCHAR(10),
    usuario VARCHAR(30)
);

CREATE OR REPLACE FUNCTION mantener_registro_tarea()
RETURNS TRIGGER AS $body$
BEGIN
    IF (tg_op = 'INSERT') OR (tg_op = 'UPDATE' ) THEN
        INSERT INTO his_tarea
        VALUES (new.nro_registro,
                new.fecha,
                new.operacion,
                new.usuario);
        RETURN new;
    END IF;

    IF  (tg_op = 'DELETE') THEN
        INSERT INTO his_tarea
        VALUES (old.nro_registro,
                old.fecha,
                old.operacion,
                old.usuario);
        RETURN old;
    END IF;
END; $body$
LANGUAGE 'plpgsql';

SELECT * FROM unc_esq_voluntario.voluntario;

--agregar trigger a tarea
CREATE TRIGGER mantener_registro_tarea_trigger
    BEFORE INSERT OR UPDATE OR DELETE
    ON unc_esq_voluntario.tarea
    FOR EACH ROW
    EXECUTE PROCEDURE mantener_registro_tarea();