set search_path to final_04_12_2025;

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-03-11 18:07:02.523

-- tables
-- Table: AREA
CREATE TABLE AREA (
    id_area int  NOT NULL,
    denominacion varchar(40)  NOT NULL,
    cant_habit_disponibles int  NOT NULL,
    matr_medico_resp int  NOT NULL,
    tipo_matr_medico_resp char(1)  NOT NULL,
    CONSTRAINT AREA_pk PRIMARY KEY (id_area)
);

-- Table: HABITACION
CREATE TABLE HABITACION (
    id_area int  NOT NULL,
    nro_habitacion int  NOT NULL,
    descripcion_accesorios varchar(40)  NOT NULL,
    acompaniante boolean  NOT NULL,
    situacion char(1)  NOT NULL,
    CONSTRAINT HABITACION_pk PRIMARY KEY (id_area,nro_habitacion)
);

-- Table: INTERNACION
CREATE TABLE INTERNACION (
    id_paciente int  NOT NULL,
    id_area int  NOT NULL,
    nro_habitacion int  NOT NULL,
    fecha_ingreso date  NOT NULL,
    fecha_salida date  NULL,
    diagnostico_ppal varchar(255)  NOT NULL,
    matr_med_asignado int  NOT NULL,
    tipo_matr_med_asig char(1)  NOT NULL,
    CONSTRAINT INTERNACION_pk PRIMARY KEY (id_paciente,id_area,nro_habitacion,fecha_ingreso)
);

-- Table: MEDICO
CREATE TABLE MEDICO (
    nro_matricula int  NOT NULL,
    tipo_matricula char(1)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    especialidad varchar(40)  NOT NULL,
    e_mail varchar(40)  NOT NULL,
    telefono varchar(15)  NOT NULL,
    CONSTRAINT MEDICO_pk PRIMARY KEY (nro_matricula,tipo_matricula)
);

-- Table: PACIENTE
CREATE TABLE PACIENTE (
    id_paciente int  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    obra_social char(10)  NULL,
    matr_med_cabecera int  NULL,
    tipo_mat_med_cabecera char(1)  NULL,
    CONSTRAINT PACIENTE_pk PRIMARY KEY (id_paciente)
);

-- foreign keys
-- Reference: FK_AREA_MEDICO (table: AREA)
ALTER TABLE AREA ADD CONSTRAINT FK_AREA_MEDICO
    FOREIGN KEY (matr_medico_resp, tipo_matr_medico_resp)
    REFERENCES MEDICO (nro_matricula, tipo_matricula)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_HABITACION_AREA (table: HABITACION)
ALTER TABLE HABITACION ADD CONSTRAINT FK_HABITACION_AREA
    FOREIGN KEY (id_area)
    REFERENCES AREA (id_area)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_INTERNACION_HABITACION (table: INTERNACION)
ALTER TABLE INTERNACION ADD CONSTRAINT FK_INTERNACION_HABITACION
    FOREIGN KEY (id_area, nro_habitacion)
    REFERENCES HABITACION (id_area, nro_habitacion)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_INTERNACION_MEDICO (table: INTERNACION)
ALTER TABLE INTERNACION ADD CONSTRAINT FK_INTERNACION_MEDICO
    FOREIGN KEY (matr_med_asignado, tipo_matr_med_asig)
    REFERENCES MEDICO (nro_matricula, tipo_matricula)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_INTERNACION_PACIENTE (table: INTERNACION)
ALTER TABLE INTERNACION ADD CONSTRAINT FK_INTERNACION_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PACIENTE_MEDICO (table: PACIENTE)
ALTER TABLE PACIENTE ADD CONSTRAINT FK_PACIENTE_MEDICO
    FOREIGN KEY (matr_med_cabecera, tipo_mat_med_cabecera)
    REFERENCES MEDICO (nro_matricula, tipo_matricula)
    ON DELETE  SET NULL
    ON UPDATE  SET NULL
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;





insert into medico VALUES (1,'P','Nick','Riviera', 'Otorrino', 'NickRiv@gmail.com', '2281254035'),
                          (2,'N','Rene','Favaloro', 'Cardiologia', 'Rfava@gmail.com', '0116362194');

INSERT INTO paciente VALUES(1, 'Murgades', 'Faustino', 'OSMATA', 1, 'P');
INSERT INTO paciente VALUES(2, 'Lanfranconi', 'Nach', 'OSDE', 2, 'N'),
                           (3, 'Monti', 'Benjamin', 'Benahacks', NULL, NULL);

AREA 1 2 3
insert into area VALUES (1,'Area de Cardiologia', 10,2,'N'),
                        (2,'Area de Traumatologia', 22,1,'P'),
                        (3,'Area de Terapia intensiva', 4,2,'N');

INSERT INTO habitacion VALUES('1', '1', 'Tiene aire acondicionado', True, 'O'),
                             ('1', '2', 'Tiene respirador de USA', False, 'O'),
                             ('1', '3', 'Al lado del baño', True, 'L'),
                             ('2', '1', 'Enfrente a urgencias', True, 'O'),
                             ('2', '2', 'Tiene cuatro ventanas', True, 'L'),
                             ('2', '3', 'Posee cortinas hechas de hilos de seda', False, 'O'),
                             ('3', '1', 'No posee ventilacion', False, 'L'),
                             ('3', '2', 'Tiene el nuevo electroencefalograma', True, 'O'),
                             ('3', '3', 'En remodelacion', False, 'L');
INSERT INTO habitacion values('1', 4, 'La cuarta habitacion', True, 'O');

INSERT INTO internacion VALUES (1,1,2,'2025-12-25'::date,'2025-12-29'::date,
                                'Paciente que tuvo un pre infarto al enterarse que su tio en realidad es su padre en la cena navideña',2,'N'),
                            (2,2,1,'2026-01-08'::date,null,
                                'Paciente que se quebro tibia y perone esquiando',1,'P'),
                            (3,3,1,'2025-10-20'::date,'2026-01-03'::date,
                                'Paciente con pronostico reservado, luchando por su vida',1,'P');

--Ejercicio 2
--Considere las siguientes restricciones sobre el esquema dado debidas a políticas de la institución:
--A- Al menos el 50% de las camas de cada área deben tener lugar para acompañante.





CREATE ASSERTION check_acompaniante_area
CHECK (
    NOT EXISTS (
        SELECT t.id_area
        FROM (
                SELECT id_area, COUNT(*) * 0.5 AS mitad
                FROM habitacion
                GROUP BY id_area
             ) t
        JOIN (
                SELECT id_area, COUNT(*) AS con_acompaniante
                FROM habitacion
                WHERE acompaniante
                GROUP BY id_area
             ) a
        ON t.id_area = a.id_area
        WHERE a.con_acompaniante < t.mitad
    )
);

-- insert en habitacion, update en habitacion de acompaniante y area si las rir te dejan.

CREATE TRIGGER tr_2a
BEFORE INSERT ON habitacion
FOR EACH ROW
WHEN(
    NEW.acompaniante IS FALSE
    )
EXECUTE FUNCTION fn_2a()

CREATE TRIGGER tr_2a
BEFORE DELETE ON habitacion
FOR EACH ROW
WHEN(
    OLD.acompaniante IS TRUE
    )
EXECUTE FUNCTION fn_2a()


CREATE TRIGGER tr_2a
BEFORE UPDATE OF acompaniante ON habitacion
FOR EACH ROW
    WHEN(

        )
EXECUTE FUNCTION fn_2a()

SELECT id_area
        FROM habitacion h
        GROUP BY id_area
        HAVING (SELECT count(nro_habitacion)
                 FROM habitacion h2
                 WHERE h2.id_area = h.id_area AND NOT h2.acompaniante
                 GROUP BY id_area) >= COUNT(nro_habitacion) * 0.5;



--B- Los pacientes de la obra social PAMI deben tener un médico de cabecera.
--NO debe existir un paciente con obra social PAMI que NO tenga un medico de cabecera
ALTER TABLE paciente
ADD CONSTRAINT chkb
CHECK ( NOT EXISTS(
SELECT 1
FROM paciente p
WHERE p.obra_social ilike 'pami' AND (matr_med_cabecera IS NULL AND tipo_mat_med_cabecera IS NULL)));

--C- El médico asignado a una internación debe tener la misma especialidad que el médico responsable del
--área correspondiente.
--se busca que un medico asignado a una internacion tenga una especialida distinta que el medico responsable del area correspondiente
CREATE ASSERTION chk_c
CHECK(
    NOT EXISTS
    (
    SELECT i.matr_med_asignado, i.tipo_matr_med_asig
    FROM internacion i
    JOIN medico m_i ON (m_i.nro_matricula = i.matr_med_asignado) AND (m_i.tipo_matricula = i.tipo_matr_med_asig)
    WHERE (i.matr_med_asignado,i.tipo_matr_med_asig) IN
          (SELECT a.matr_medico_resp, a.tipo_matr_medico_resp
           FROM area a
           JOIN medico m_a ON (m_a.nro_matricula = a.matr_medico_resp) AND (m_a.tipo_matricula = a.tipo_matr_medico_resp)
           WHERE a.id_area = i.id_area AND m_a.especialidad != m_i.especialidad )
    )
) --MAL

CREATE ASSERTION chk_c
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM internacion i
        JOIN medico m_i ON m_i.nro_matricula = i.matr_med_asignado AND m_i.tipo_matricula = i.tipo_matr_med_asig
        JOIN area a ON a.id_area = i.id_area
        JOIN medico m_a ON m_a.nro_matricula = a.matr_medico_resp AND m_a.tipo_matricula = a.tipo_matr_medico_resp
        WHERE m_i.especialidad <> m_a.especialidad
    )
); --BIEN

--2.b)
--para aquellas restricciones que no puedan incorporarse en PostgreSQL
--según lo implementado en 2.a),indique y justifique cada uno de los eventos críticos que deben ser chequeados
-- y provea las declaraciones delos triggers correspondientes.

--El médico asignado a una internación debe tener la misma especialidad que el médico responsable del
--área correspondiente.

Hay que chequear cuando:
    INSERT en internacion
    UPDATE de especialidad un medico
    UPDATE de matr_med_asignado y tipo_matr_med_asig en internacion ya que apuntaria a otro medico logico
    UPDATE matr_medico_responsable y tipo_matr_medico_resp en area

ante un insert en internacion tengo que verificar dos cosas: la primera es el medico de area y la segunda es el medico asignado

CREATE OR REPLACE TRIGGER tr_internacion
BEFORE INSERT OR UPDATE OF id_area, matr_med_asignado, tipo_matr_med_asig ON internacion
FOR EACH ROW EXECUTE FUNCTION fn_2b_internacion();
CREATE OR REPLACE FUNCTION fn_2b_internacion()
RETURNS TRIGGER AS $$
DECLARE
    especialidad_internacion VARCHAR(40);
    especialidad_area VARCHAR(40);
BEGIN
    SELECT m.especialidad
    INTO especialidad_internacion
    FROM medico m
    WHERE m.nro_matricula = NEW.matr_med_asignado
    AND m.tipo_matricula = NEW.tipo_matr_med_asig;

    SELECT m_a.especialidad INTO especialidad_area
    FROM area a JOIN medico m_a ON m_a.nro_matricula = a.matr_medico_resp AND m_a.tipo_matricula = a.tipo_matr_medico_resp
    WHERE id_area = NEW.id_area;

    IF TG_OP = 'INSERT' THEN
        IF especialidad_internacion IS DISTINCT FROM especialidad_area THEN
            RAISE EXCEPTION 'No puedes agregar esta internacion dado que los medicos asignados en esa area y esta internacion tienen diferentes especialidades';
        end if;
    end if;
    IF TG_OP = 'UPDATE' THEN
        IF especialidad_internacion IS DISTINCT FROM especialidad_area THEN
            RAISE EXCEPTION 'No puedes realizar ese UPDATE dado que los medicos asignados en esa area y esta internacion tienen diferentes especialidades';
        end if;
    end if;
    RETURN new;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION fn_2b_area()
RETURNS TRIGGER AS $$
DECLARE
    especialidad_area VARCHAR(40);
BEGIN
    SELECT m_a.especialidad INTO especialidad_area
    FROM medico m_a
    WHERE m_a.nro_matricula = NEW.matr_medico_resp
    AND m_a.tipo_matricula = NEW.tipo_matr_medico_resp;

    IF EXISTS(SELECT 1
              FROM internacion i JOIN medico m_i ON m_i.nro_matricula = i.matr_med_asignado AND m_i.tipo_matricula = i.tipo_matr_med_asig
              WHERE id_area = NEW.id_area AND especialidad_area IS DISTINCT FROM m_i.especialidad) THEN
        RAISE EXCEPTION 'No puedes realizar ese UPDATE dado que si cambias el medico jefe en ese area, existe ya un medico en esa internacion/area con una especialidad distinta';
    end if;

    RETURN new;
end;
$$ LANGUAGE 'plpgsql';
CREATE OR REPLACE TRIGGER tg_2b_area
BEFORE UPDATE OF matr_medico_resp ON area
FOR EACH ROW
WHEN
(
    OLD.matr_medico_resp IS DISTINCT FROM NEW.matr_medico_resp
    OR
    OLD.tipo_matr_medico_resp IS DISTINCT FROM  NEW.tipo_matr_medico_resp
)
EXECUTE FUNCTION fn_2b_area();



CREATE OR REPLACE FUNCTION fn_2b_medico()
RETURNS TRIGGER AS $$
BEGIN

    IF EXISTS(SELECT 1
              FROM internacion i
              WHERE NEW.nro_matricula = matr_med_asignado
              AND NEW.tipo_matricula = tipo_matr_med_asig
              AND (SELECT especialidad FROM area a JOIN medico m2 ON (a.matr_medico_resp = m2.nro_matricula AND a.tipo_matr_medico_resp = m2.tipo_matricula) WHERE a.id_area = i.id_area)
                  IS DISTINCT FROM NEW.especialidad) THEN
        RAISE EXCEPTION 'No puedes realizar ese UPDATE dado que si cambias el medico jefe en ese area, existe ya un medico en esa internacion/area con una especialidad distinta';
    end if;

    IF EXISTS(SELECT 1
              FROM area a
              WHERE NEW.nro_matricula = a.matr_medico_resp
                AND NEW.tipo_matricula = a.tipo_matr_medico_resp AND EXISTS(SELECT 1
                                                                            FROM internacion i
                                                                            JOIN medico m_i ON m_i.nro_matricula = i.matr_med_asignado AND m_i.tipo_matricula = i.tipo_matr_med_asig
                                                                            WHERE id_area = a.id_area
                                                                            AND m_i.especialidad IS DISTINCT FROM NEW.especialidad)) THEN
        RAISE EXCEPTION 'No puedes realizar eso';

    end if;

    RETURN new;
end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_2b_medico
BEFORE UPDATE OF especialidad
ON MEDICO
FOR EACH ROW EXECUTE FUNCTION fn_2b_medico();


CREATE OR REPLACE FUNCTION fn_2b_medico()
RETURNS TRIGGER AS $$
BEGIN
    -- CASO A: soy médico ASIGNADO en una internación
    IF EXISTS (
        SELECT 1
        FROM internacion i
        JOIN area a ON a.id_area = i.id_area
        JOIN medico m_resp
             ON m_resp.nro_matricula = a.matr_medico_resp
            AND m_resp.tipo_matricula = a.tipo_matr_medico_resp
        WHERE i.matr_med_asignado = NEW.nro_matricula
          AND i.tipo_matr_med_asig = NEW.tipo_matricula
          AND m_resp.especialidad IS DISTINCT FROM NEW.especialidad
    ) THEN
        RAISE EXCEPTION
        'No puedes cambiar la especialidad: rompe la coherencia con el área de una internación asignada';
    END IF;

    -- CASO B: soy médico RESPONSABLE de un área
    IF EXISTS (
        SELECT 1
        FROM area a
        JOIN internacion i ON i.id_area = a.id_area
        JOIN medico m_i
             ON m_i.nro_matricula = i.matr_med_asignado
            AND m_i.tipo_matricula = i.tipo_matr_med_asig
        WHERE a.matr_medico_resp = NEW.nro_matricula
          AND a.tipo_matr_medico_resp = NEW.tipo_matricula
          AND m_i.especialidad IS DISTINCT FROM NEW.especialidad
    ) THEN
        RAISE EXCEPTION
        'No puedes cambiar la especialidad: rompe internaciones del área que diriges';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


insert into medico VALUES (3,'N','Milagro','Martin','Porctologo','Milagro@gmail.com','223228045');
insert into paciente VALUES (4,'Fabre','Liliana','OSPUNCPBA','2','N');
begin;
insert into internacion VALUES (3,1,3,'2026-01-07'::date,null, 'Aorta comprometida por accidente automovilistico',3,'N');
rollback ;


--dada una cierta fecha, brindada por un usuario, se debe verificar si se ha superado el 75% de ocupación
-- de habitaciones en el centro de salud y registrar en una tabla auxiliar (ya creada) si esto sucede,
-- indicando tal fecha y el porcentaje de capacidad alcanzada.
insert into internacion
    VALUES (1,2,2,'2025-12-25'::date,null,'Diagnostico reservado',1,'P'),
           (4,2,3,'2025-12-25'::date,null,'Diagnostico reservado',1,'P'),
           (2,1,1,'2025-12-25'::date,null,'Diagnostico reservado',2,'N'),
           (3,1,3,'2025-12-25'::date,null,'Diagnostico reservado',2,'N'),
           (4,1,4,'2025-12-25'::date,null,'Diagnostico reservado',2,'N');


Me dan una fecha ->
tengo que ver fecha_salida para "predecir"
como estará ese dia

me dan una fecha -> tengo que ver fecha_ingreso y egreso
que la fecha que me dan sea mayor igual a la fecha_ingreso y menor igual a la fecha egreso

CREATE TABLE ocupacion (
    fecha_ocupacion DATE,
    porcentaje_ocupado DOUBLE PRECISION
);

CREATE OR REPLACE PROCEDURE pr_3a(fecha_dada DATE) AS $$
    DECLARE
        cant_habitaciones BIGINT;
        cant_habitaciones_ocupadas BIGINT;
BEGIN
        SELECT COUNT(*) INTO cant_habitaciones_ocupadas
    FROM (SELECT i.fecha_ingreso, i.fecha_salida
      FROM internacion i
      WHERE (fecha_salida IS NOT NULL AND fecha_salida >= fecha_dada
        AND fecha_ingreso <= fecha_dada) OR (fecha_ingreso <= fecha_dada AND fecha_salida IS NULL)
      ) t;

    SELECT COUNT(*) into cant_habitaciones
    FROM habitacion h;
    INSERT INTO ocupacion(fecha_ocupacion, porcentaje_ocupado) VALUES(
    fecha_dada, (cant_habitaciones_ocupadas*100)/cant_habitaciones);

END;
$$ LANGUAGE 'plpgsql';

CALL pr_3a('2025-12-25'::date);
SELECT * from ocupacion;


--se debe mantener automáticamente actualizada la cantidad de habitaciones disponibles en cada área a medida
-- que se ocupan o desocupan camas de pacientes internados
-- (considere que los valores actuales de dicho atributo son consistentes con los datos existentes en la base)
CONTROLAR:
INSERT en internacion
UPDATE en internacion -> fecha_salida, id_area y nro_habitacion

UPDATE en HABITACION -> situacion

CREATE OR REPLACE FUNCTION fn_3b_habitacion()
RETURNS TRIGGER AS $$
BEGIN
    IF (old.situacion ilike 'l') AND (new.situacion ilike 'o') THEN
        UPDATE area
        SET cant_habit_disponibles = cant_habit_disponibles-1
        WHERE id_area = NEW.id_area;
    end if;

    IF (old.situacion ilike 'o') AND (new.situacion ilike 'l') THEN
        UPDATE area
        SET cant_habit_disponibles = cant_habit_disponibles+1
        WHERE id_area = NEW.id_area;
    end if;
    RETURN NEW;
end;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION fn_3b_internacion()
RETURNS TRIGGER AS $$
BEGIN
    IF tg_op = 'INSERT' THEN
        if ( (SELECT cant_habit_disponibles FROM area WHERE id_area = new.id_area) > 0) then
            update habitacion set situacion = 'O' WHERE id_area = new.id_area AND nro_habitacion = new.nro_habitacion;
        else
            raise exception 'No hay camas disponibles en esa area';
        end if;
    end if;
    IF tg_op = 'UPDATE' THEN
        IF (new.fecha_salida = CURRENT_DATE) THEN
            UPDATE habitacion
            SET situacion = 'L'
            WHERE id_area = NEW.id_area AND nro_habitacion = NEW.nro_habitacion;
        ELSE
            UPDATE habitacion
            SET situacion = 'L'
            WHERE id_area = OLD.id_area AND nro_habitacion = OLD.nro_habitacion;

            UPDATE habitacion
            SET situacion = 'O'
            WHERE id_area = NEW.id_area AND nro_habitacion = NEW.nro_habitacion;
        end if;
    end if;
    RETURN NEW;
end;
$$ LANGUAGE 'plpgsql';
--Implemente las siguientes vistas sobre
-- el esquema dado
-- de manera que resulten

--1, con identificador y denominación de la/s área/s con la mayor cantidad de internaciones en el año actual.

CREATE VIEW V1 AS
SELECT id_area, denominacion
FROM area a1
WHERE EXISTS (SELECT 1
              FROM area a2 JOIN internacion i USING(id_area)
              WHERE a2.id_area = a1.id_area AND EXTRACT (YEAR FROM i.fecha_ingreso) = EXTRACT (YEAR FROM CURRENT_DATE)
              GROUP BY a2.id_area
              HAVING COUNT(*) = (   SELECT count(*)
                                    FROM area a
                                    JOIN internacion i USING(id_area)
                                    WHERE EXTRACT (YEAR FROM i.fecha_ingreso) = EXTRACT (YEAR FROM CURRENT_DATE)
                                    GROUP BY a.id_area
                                    ORDER BY (COUNT(*)) DESC
                                    LIMIT 1
                                )
              );

SELECT a.id_area, count(*)
FROM area a
JOIN internacion i USING(id_area)
GROUP BY a.id_area
HAVING COUNT(*) = ( SELECT count(*)
                    FROM area a
                    JOIN internacion i USING(id_area)
                    GROUP BY a.id_area
                    ORDER BY (COUNT(*)) DESC
                    LIMIT 1
                  );

SELECT a.*, i.*
FROM area a
JOIN internacion i USING(id_area);


--b)
--V2, con datos de todos los pacientes con obra social,
-- junto con el número total de internaciones que han tenido en los últimos 5 años
-- y el promedio de duración de las mismas (si no registra internaciones, estos valores deben ser 0).
SELECT m.*
FROM medico m;
INSERT INTO paciente VALUES(11, 'Verstappen', 'Max', 'F1', '1', 'P');


CREATE VIEW V2 AS
SELECT
    p.id_paciente,
    p.nombre,
    p.apellido,
    p.matr_med_cabecera,
    p.tipo_mat_med_cabecera,
    p.obra_social,
    COALESCE(t.cant_internaciones, 0) AS cant_internaciones,
    COALESCE(t.promedio_duracion_en_dias, 0) AS promedio_duracion_en_dias
FROM paciente p
LEFT JOIN (
    SELECT
        p.id_paciente,
        SUM(COALESCE(i.fecha_salida - i.fecha_ingreso, 0))
            / COUNT(i.fecha_ingreso) AS promedio_duracion_en_dias,
        COUNT(i.fecha_ingreso) AS cant_internaciones
    FROM paciente p
    JOIN internacion i
        ON (i.id_paciente = p.id_paciente)
       AND (EXTRACT(YEAR FROM AGE(i.fecha_ingreso, CURRENT_DATE)) <= 5)
    WHERE p.obra_social IS NOT NULL
    GROUP BY p.id_paciente
) t
ON p.id_paciente = t.id_paciente
WHERE p.obra_social IS NOT NULL;


SELECT p.*, i.*
FROM paciente p LEFT JOIN internacion i USING (id_paciente);

--4.c)V3, con apellido y nombre de los médicos de especialidad cardiología asignados únicamente a internaciones realizadas en el área de cardiología.

CREATE VIEW V3 AS
SELECT m.apellido, m.nombre, m.especialidad
FROM medico m
WHERE m.especialidad ilike 'cardiologia' AND NOT EXISTS (SELECT 1 FROM medico m2 JOIN internacion i ON m2.nro_matricula = i.matr_med_asignado AND m2.tipo_matricula = i.tipo_matr_med_asig
                                                         WHERE m2.nro_matricula = m.nro_matricula AND m2.tipo_matricula= m.tipo_matricula AND m2.especialidad NOT ilike 'cardiologia');

CREATE OR REPLACE VIEW v3 AS (
    SELECT m.apellido,m.nombre
    FROM medico m
    WHERE EXISTS(
                SELECT 1
                FROM internacion i
                JOIN area a USING(id_area)
                WHERE i.matr_med_asignado = m.nro_matricula AND i.tipo_matr_med_asig = m.tipo_matricula AND lower(m.especialidad) = 'cardiologia' AND lower(a.denominacion) = 'area de cardiologia'
                )
    AND
            NOT EXISTS(
                    SELECT 1
                    FROM internacion i
                    JOIN area a USING(id_area)
                    WHERE i.matr_med_asignado = m.nro_matricula AND i.tipo_matr_med_asig = m.tipo_matricula AND m.especialidad ilike 'cardiologia' AND a.denominacion not ilike 'area de cardiologia'
                )
);

select * from v3;

-- indice por where para que sea mas optimo -> preguntar pq
SELECT * FROM V3




CREATE OR REPLACE FUNCTION fn_ta()
RETURNS TABLE (
        nombre varchar(40),
        apellido varchar(40)
)
AS
$$
begin
    return query (
      select p.nombre, p.apellido
        FROM paciente p
    )
    ;

end;
$$ language 'plpgsql';

select * from fn_ta();

DROP FUNCTION fn_ej6();
CREATE OR REPLACE FUNCTION fn_ej6(p_anio int)
RETURNS TABLE(
        nombre_area varchar,
        apellido_medico varchar,
        nombre_medico varchar,
        cantidad_individual bigint,
        ranking bigint,
        total_int_area numeric,
        porcentaje_carga numeric(3,2)
             )
AS $$
BEGIN
    RETURN QUERY(
        SELECT
            a.denominacion,
            m.apellido,
            m.nombre,
            COUNT(*) as cantidad_individual,
            rank() OVER (PARTITION BY a.id_area ORDER BY COUNT(*) DESC) as ranking,
            SUM(COUNT(*)) OVER (PARTITION BY a.id_area) as total_int_area,
            COUNT(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY a.id_area) as porcentaje_carga
        FROM internacion i
        JOIN medico m ON m.nro_matricula = i.matr_med_asignado AND m.tipo_matricula = i.tipo_matr_med_asig
        JOIN area a on a.id_area = i.id_area
        WHERE EXTRACT(YEAR FROM i.fecha_ingreso) = p_anio
            GROUP BY (a.denominacion, a.id_area,
            m.apellido,
            m.nombre)

    );
end;
$$ language 'plpgsql';

select * FROM fn_ej6();





SELECT
            a.denominacion,
            m.apellido,
            m.nombre,
            COUNT(*) as cantidad_individual,
            rank() OVER (PARTITION BY a.id_area ORDER BY COUNT(*) DESC) as ranking,
            SUM(COUNT(*)) OVER (PARTITION BY a.id_area) as total_int_area,
            COUNT(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY a.id_area) as porcentaje_carga
        FROM internacion i
        JOIN medico m ON m.nro_matricula = i.matr_med_asignado AND m.tipo_matricula = i.tipo_matr_med_asig
        JOIN area a on a.id_area = i.id_area
        GROUP BY (a.denominacion, a.id_area,
            m.apellido,|
            m.nombre);


update medico set especialidad = 'Cardiologia' WHERE nro_matricula = 3 AND tipo_matricula = 'N';

INSERT INTO INTERNACION VALUES(2,3,3, CURRENT_DATE, NULL, 'Alergico a las minas', 3, 'N')
SELECT *
FROM area a
    JOIN medico m ON a.matr_medico_resp = m.nro_matricula AND a.tipo_matr_medico_resp = M.tipo_matricula

    select *
FROM internacion i
        JOIN medico m ON m.nro_matricula = i.matr_med_asignado AND m.tipo_matricula = i.tipo_matr_med_asig
    ORDER BY i.id_area
    martin con 2 nick con 1 en el area 3 denominacion area de terapia intensiva
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------FRO