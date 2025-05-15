CREATE TABLE tabla AS
SELECT * FROM unc_esq_voluntario.;

CREATE TABLE HIS_TAREA (
    nro_registro varchar,
    fecha date,
    operacion varchar(20),
    usuario varchar(15));

ALTER TABLE unc_46203524.his_tarea
ALTER COLUMN nro_registro TYPE varchar;
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
    DECLARE
    operacion varchar;
registro varchar;
BEGIN
   IF tg_op = 'INSERT' THEN
       operacion := 'INSERT';
       registro := NEW.id_tarea;
    ELSIF tg_op = 'UPDATE' THEN
        operacion := 'UPDATE';
        registro := NEW.id_tarea;
   ELSIF TG_OP = 'DELETE' THEN
       operacion := 'DELETE';
       registro := OLD.id_tarea;
   end if;

   INSERT INTO unc_46203524.his_tarea(nro_registro, fecha, operacion, usuario)
   VALUES (registro, CURRENT_DATE, operacion, SESSION_USER);

   RETURN NULL;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_tarea
AFTER INSERT OR UPDATE OR DELETE
ON unc_46203524.tarea_personal FOR EACH ROW
EXECUTE PROCEDURE fn_actualizar_tarea();

-- FOR EACH ROW es ideal para auditorias como esta, ya que permite un seguimiento detallado de los cambios
-- FOR EACH STATEMENT es mas liviano pero menos detallado

-- Ejercicio 2
-- A partir del esquema unc_peliculas, realice procedimientos para:
-- c) Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas
-- más entregadas en los últimos seis meses desde la ejecución del procedimiento. Esta tabla
-- por lo menos debe tener las columnas código_pelicula, nombre, cantidad_de_entregas (en
-- caso de coincidir en cantidad de entrega ordenar por código de película).

CREATE TABLE renglon_entrega AS
SELECT * FROM unc_esq_peliculas.renglon_entrega;

CREATE TABLE entrega AS
SELECT * FROM unc_esq_peliculas.entrega;

CREATE TABLE MAS_ENTREGADAS (
    cantidad_de_entregas INT,
    codigo_pelicula INT,
    nombre VARCHAR(90)
);

CREATE OR REPLACE FUNCTION fn_mas_entregadas_por_meses()
RETURNS TRIGGER AS $$
BEGIN
    SELECT re.codigo_pelicula
    FROM unc_46203524.entrega e
    JOIN unc_46203524.renglon_entrega re USING (nro_entrega)
    WHERE e.fecha_entrega BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '6 months')
    group by re.codigo_pelicula
    ORDER BY count(re.nro_entrega)
    LIMIT 20;

    INSERT INTO
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_top_entregas
BEFORE INSERT OR UPDATE OR DELETE ON unc_46203524.pelicula
FOR EACH ROW EXECUTE PROCEDURE fn_mas_entregadas_por_meses();


SELECT re.codigo_pelicula
FROM unc_46203524.entrega e
JOIN unc_46203524.renglon_entrega re USING (nro_entrega)
WHERE e.fecha_entrega BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '6 months')
group by re.codigo_pelicula
ORDER BY count(re.nro_entrega)
LIMIT 20;
;  -- entre fecha de hoy y 6 meses mas

-- d) Generar los datos para una tabla denominada SUELDOS, con los datos de los empleados
-- cuyas comisiones superen a la media del departamento en el que trabajan. Esta tabla debe
-- tener las columnas id_empleado, apellido, nombre, sueldo, porc_comision.

CREATE TABLE SUELDOS (
    id_empleado varchar,
    porc_comision integer,
    sueldo integer,
    apellido varchar(15),
    nombre varchar(15)
);

-- e) Cambiar el distribuidor de las entregas sucedidas a partir de una fecha dada, siendo que el
-- par de valores de distribuidor viejo y distribuidor nuevo es variable.


-----------------------------------------------------------------------------------------------------------------------

-- Ejercicio 3
-- Para el esquema unc_voluntarios se desea conocer la cantidad de voluntarios que hay en cada
-- tarea al inicio de cada mes y guardarla a lo largo de los meses. Para esto es necesario hacer un
-- procedimiento que calcule la cantidad y la almacene en una tabla denominada

-- CANT_VOLUNTARIOSXTAREA con la siguiente estructura:
-- CANT_VOLUNTARIOSXTAREA (anio, mes, id_tarea, nombre_tarea, cant_voluntarios)