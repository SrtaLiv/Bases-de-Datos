CREATE TABLE tabla AS
SELECT * FROM unc_esq_voluntario.;

create table HIS_TAREA(nro_registro, fecha, operación, usuario);

-- Ejercicio 1
-- Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y
-- cuándo realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la
-- siguiente estructura:
-- HIS_TAREA(nro_registro, fecha, operación, usuario)
-- a) Provea el/los trigger/s necesario/s para mantener en forma automática la tabla HIS_TAREA
-- cuando se realizan actualizaciones (insert, update o delete) en la tabla TAREA.
-- b) Muestre los resultados de las tablas si se ejecuta la operación:
--
-- DELETE FROM TAREA
-- WHERE id_tarea like ‘AD%’;
-- Según el o los triggers definidos sean FOR EACH ROW o FOR EACH STATEMENT.
-- Evalúe la diferencia entre ambos tipos de granularidad.

CREATE OR REPLACE FUNCTION fn_actualizar_tarea()
RETURNS TRIGGER AS $$
BEGIN
   IF tg_op = 'INSERT' THEN
       -- INSERT INTO HIS_TAREA VALUES (1, now(), 'INSERT', 'user');
       operacion := 'INSERT';
       registro := NEW.id_tarea;
    ELSIF tg_op = 'UPDATE' THEN
        operacion := 'UPDATE';
        registro := NEW.id_tarea;
   ELSIF TG_OP = 'DELETE' THEN
       operacion := 'DELETE';
       registro := OLD.id_tarea;
   end if;

   INSERT INTO HIS_TAREA(nro_registro, fecha, operacion, usuario)
   VALUES (registro, CURRENT_DATE, operacion, SESSION_USER);

   RETURN NULL;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_tarea
AFTER INSERT OR UPDATE OR DELETE
ON tarea FOR EACH ROW
EXECUTE PROCEDURE fn_actualizar_tarea();
