/*TP6 PARTE 2
    EJERCICIO 1
    Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y
    cuándo realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la
    siguiente estructura:
    HIS_TAREA(nro_registro, fecha, operación, usuario)
 */

CREATE TABLE HIS_TAREA (
    nro_registro int,
    fecha date,
    operacion varchar(20),
    usuario varchar(15));

CREATE TABLE TAREA_PERSONAL as
select * FROM unc_esq_voluntario.tarea;

/*
    Triggers de actualizacion
    TABLA HIS_TAREA. cuando se hace en TAREA un INSERT un UPDATE de
    (id_tarea, nombre_tarea, min_horas, max_horas) COMO SE TRATA DE TODAS LAS COLUMNAS NO SE DETALLA EN EL TRIGGER
    un DELETE
   operacion: TG_OP
    usuario: current_user
    fecha actual: curren_date
    autoincremento de numero de registro: nextval(tabla_columna_seq)---> nextval(his_tarea_nro_registro_seq)
 */

--CREAR INTERVALO (NEXTVAL) para que incremente cada vez que se invoca
CREATE SEQUENCE his_tarea_nro_registro_seq AS INTEGER;
ALTER SEQUENCE his_tarea_nro_registro_seq owner to unc_252058;
ALTER SEQUENCE his_tarea_nro_registro_seq owned by his_tarea.nro_registro;



CREATE FUNCTION fn_actualizacion_his_tarea_row()
RETURNS trigger AS $$
BEGIN
    INSERT INTO HIS_TAREA (nro_registro, fecha, operacion, usuario) VALUES (nextval('his_tarea_nro_registro_seq'), current_date, tg_op, current_user);
IF(TG_OP='DELETE')THEN
    RETURN OLD;
ELSE
RETURN NEW;
END IF;
end;$$language 'plpgsql';



CREATE TRIGGER tr_actualizacion_his_tarea_row
AFTER INSERT OR UPDATE OR DELETE
ON TAREA_PERSONAL
FOR EACH ROW
EXECUTE PROCEDURE fn_actualizacion_his_tarea_row();


CREATE TRIGGER tr_actualizacion_his_tarea_statemenT
AFTER INSERT OR UPDATE OR DELETE
ON TAREA_PERSONAL
FOR EACH STATEMENT
EXECUTE PROCEDURE fn_actualizacion_his_tarea_row();

DELETE FROM tarea_personal
WHERE id_tarea like 'AD%';

INSERT INTO tarea_personal (nombre_tarea, min_horas, id_tarea, max_horas) VALUES ('PROMOCION', 3000, 'AD_VP',5000);

select *
from HIS_TAREA;

/*
 EJERCICIO 2
 C) Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas
más entregadas en los últimos seis meses desde la ejecución del procedimiento. Esta tabla
por lo menos debe tener las columnas código_pelicula, nombre, cantidad_de_entregas (en
caso de coincidir en cantidad de entrega ordenar por código de película).
 */

CREATE TABLE MAS_ENTREGADAS(
    codigo_pelicula numeric(5) NOT NULL,
    nombre varchar(60) NOT NULL,
    cantidad_de_entregas numeric(5) NOT NULL,
    CONSTRAINT pk_codigo_pelicula PRIMARY KEY (codigo_pelicula));


SELECT p.codigo_pelicula, titulo, re.cantidad
FROM esq_peliculas_pelicula p
INNER JOIN esq_peliculas_renglon_entrega re
ON p.codigo_pelicula = re.codigo_pelicula
INNER JOIN esq_peliculas_entrega e
ON re.nro_entrega = e.nro_entrega
WHERE fecha_entrega > NOW() - INTERVAL '200 month' --DEVUELVE SOLO LOS QUE SEAN DE LOS ULTIMOS 6 MESES DESDE LA FECHA ACTUAL
ORDER BY re.cantidad DESC, fecha_entrega DESC
LIMIT 20;

--LA ULTIMA FECHA ES 2011. POR ESO NO DEVUELVE NADA

SELECT *
FROM MAS_ENTREGADAS;

CREATE OR REPLACE FUNCTION fn_actualizacion_mas_entregadas()
RETURNS VOID AS $$ --ES RETURNS VOID PORQUE NO HACE NADA
    BEGIN
DELETE FROM MAS_ENTREGADAS;
        INSERT INTO MAS_ENTREGADAS (codigo_pelicula, nombre, cantidad_de_entregas)
            (SELECT re.codigo_pelicula, titulo, re.cantidad
            FROM pelicula p
            INNER JOIN  REGLON_ENTREGA re
            ON p.codigo_pelicula = re.codigo_pelicula
            INNER JOIN ENTREGA e
            ON re.nro_entrega = e.nro_entrega
            WHERE fecha_entrega >= NOW() - INTERVAL '6 month'
            --DEVUELVE SOLO LOS QUE SEAN DE LOS ULTIMOS 6 MESES DESDE LA FECHA ACTUAL
            ORDER BY re.cantidad DESC, fecha_entrega DESC
            LIMIT 20);
RETURN;
end$$ LANGUAGE 'plpgsql';

SELECT fn_actualizacion_mas_entregadas();




/*D)
 Generar los datos para una tabla denominada SUELDOS, con los datos de los empleados
cuyas comisiones superen a la media del departamento en el que trabajan. Esta tabla debe
tener las columnas id_empleado, apellido, nombre, sueldo, porc_comision.
 */

CREATE TABLE SUELDO (
    id_empleado NUMERIC(6) NOT NULL,
    apellido VARCHAR(30),
    nombre VARCHAR(30),
    sueldo NUMERIC(8,2),
    por_comision NUMERIC(6,2));

CREATE OR REPLACE FUNCTION obtener_tabla_sueldos()
RETURNS VOID AS $$
BEGIN
    DELETE FROM SUELDO;
    INSERT INTO SUELDO (id_empleado, apellido, nombre, sueldo, por_comision)
    (SELECT e.id_empleado, e.apellido, e.nombre, e.sueldo, e.porc_comision
    FROM unc_esq_peliculas.empleado e INNER JOIN unc_esq_peliculas.departamento de
    ON (e.id_departamento= de.id_departamento AND e.id_distribuidor= de.id_distribuidor)
    WHERE e.porc_comision > (
        SELECT AVG(porc_comision)
        FROM unc_esq_peliculas.empleado
        WHERE e.id_departamento= de.id_departamento AND e.id_distribuidor= de.id_distribuidor));
RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT obtener_tabla_sueldos();


/*
 E) Cambiar el distribuidor de las entregas sucedidas a partir de una fecha dada, siendo que el
par de valores de distribuidor viejo y distribuidor nuevo es variable.
 */

CREATE OR REPLACE FUNCTION fn_actualizar_distribuidor(distribuidor numeric, fecha date)
RETURNS VOID AS $$
BEGIN
    UPDATE ENTREGA SET id_distribuidor= distribuidor WHERE fecha_entrega=fecha;

END; $$ LANGUAGE 'plpgsql';

SELECT fn_actualizar_distribuidor(15, '2006-09-06');

SELECT *
FROM ENTREGA e
WHERE e.fecha_entrega= '2006-09-06';

 /*
  EJERCICIO 3
Para el esquema unc_voluntarios se desea conocer la cantidad de voluntarios que hay en cada
tarea al inicio de cada mes y guardarla a lo largo de los meses. Para esto es necesario hacer un
procedimiento que calcule la cantidad y la almacene en una tabla denominada
CANT_VOLUNTARIOSXTAREA con la siguiente estructura:

CANT_VOLUNTARIOSXTAREA (anio, mes, id_tarea, nombre_tarea, cant_voluntarios)

  Procedimiento (returns void) que modifique la cantidad de voluntarios en la tabla CANT_VOLUNTARIOSXTAREA
  Funcion que pase como parametro una determinada tarea.
  */
CREATE TABLE VOLUNTARIOSXTAREA(
    anio numeric(4) NOT NULL,
    mes numeric (2) NOT NULL,
    id_tarea varchar(10) NOT NULL,
    nombre_tarea varchar(100) NOT NULL,
    cant_voluntarios numeric (1000) NOT NULL
);

SELECT *
FROM VOLUNTARIOSXTAREA;

SELECT pr_conocer_cantidad_voluntarios('SA_MAN');

CREATE OR REPLACE FUNCTION pr_conocer_cantidad_voluntarios(tarea varchar)
RETURNS VOID AS $$
    DECLARE
        cantMes integer;
        nuevoIdTarea varchar(30);
    BEGIN
    SELECT count(*) INTO cantMes
    FROM voluntario
    group by id_tarea;

    INSERT INTO VOLUNTARIOSXTAREA (anio, mes, id_tarea, nombre_tarea, cant_voluntarios) (
        SELECT extract(year from current_date), extract(month from current_date),tarea , t.nombre_tarea, cantMes
        FROM unc_esq_voluntario.voluntario v INNER JOIN unc_esq_voluntario.tarea t ON v.id_tarea= t.id_tarea
        GROUP BY tarea , nombre_tarea);
RETURN;
END;$$LANGUAGE 'plpgsql';
