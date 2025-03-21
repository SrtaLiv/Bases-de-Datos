SET search_path = unc_188;
/*Ejercicio 1
Considere las siguientes restricciones que debe definir sobre el esquema de la BD de Voluntarios:
No puede haber voluntarios de más de 70 años. Aquí como la edad es un dato que depende de la fecha actual lo deberíamos controlar de otra manera.
A.Bis - Controlar que los voluntarios deben ser mayores a 18 años.
b. Ningún voluntario puede aportar más horas que las de su coordinador.
c. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y mínimos consignados en la tarea.
d. Todos los voluntarios deben realizar la misma tarea que su coordinador.
e. Los voluntarios no pueden cambiar de institución más de tres veces al año.
f. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.*/

INSERT INTO voluntario (telefono, fecha_nacimiento, apellido, id_tarea, salario, nro_coordinador, horas_aportadas, edad)
VALUES
    ('+41 643 165 6647', '1998-08-26', 'ST_CLERK', 134, 2900.00, NULL, 50, 122),
    ('+55 357 58 9144', '1999-12-12', 'ST_CLERK', 135, 2400.00, NULL, 50, 122);


--A.
ALTER TABLE voluntario
ADD CONSTRAINT edad
CHECK (age(fecha_nacimiento) < 70);

ALTER TABLE voluntario
ADD CONSTRAINT ck_voluntario_chequeo_edad
CHECK (NOT EXISTS(
   SELECT fecha_nacimiento, age(fecha_nacimiento), extract(YEAR FROM age(fecha_nacimiento)) AS "Edad"
   FROM voluntario WHERE extract(YEAR FROM age(fecha_nacimiento)) > 70));

--B. SE SOLUCIONARIA CON UN ASSERTION
ALTER TABLE voluntario
ADD CONSTRAINT check_horas_coordinador
CHECK (not exists(SELECT horas_aportadas <= (
        SELECT v_coordinador.horas_aportadas
        FROM voluntario v_coordinador
        WHERE v_coordinador.nro_voluntario = voluntario.id_coordinador)
    )
);


CREATE OR REPLACE FUNCTION check_horas_coordinador() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.horas_aportadas > (
        SELECT v_coordinador.horas_aportadas
        FROM voluntario v_coordinador
        WHERE v_coordinador.nro_voluntario = NEW.id_coordinador
    ) THEN
        RAISE EXCEPTION 'No se puede aportar más horas que el coordinador';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_horas_coordinador_trigger
BEFORE INSERT OR UPDATE ON voluntario
FOR EACH ROW
EXECUTE FUNCTION check_horas_coordinador();


--C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y mínimos consignados en la tarea.

--MAL!! EL CHECK NOOOOOOOOOOOOOOOO SOPORTA SUBQUERYS
ALTER TABLE voluntario
ADD CONSTRAINT voluntarios_valores
CHECK (horas_aportadas BETWEEN (
        SELECT tarea.min_horas
        FROM tarea
        ) AND (SELECT tarea.max_horas FROM tarea)
);


--d Todos los voluntarios deben realizar la misma tarea que su coordinador.
--RESTRICCION DE 1 TABLA, CON EL ID_TAREA Y ID_COORDINADOR. CREO QUE SERIA RESTRICCION DE TUPLA
ALTER TABLE voluntario
ADD CONSTRAINT voluntario_tarea_del_coordinador
CHECK ( NOT EXISTS(id_tarea = (SELECT id_tarea FROM voluntario coor WHERE coor.id_coordinador = voluntario.nro_voluntario))
    );




