set search_path to final_13_08_2020;
-- =========================
-- TABLA: ASIGNATURA
-- =========================
CREATE TABLE ASIGNATURA (
    cod_carrera     INT NOT NULL,
    cod_asignatura  INT NOT NULL,
    nombre_asig     VARCHAR(40) NOT NULL,
    cuatrimestre    INT NOT NULL,
    cant_hs_t       INT NOT NULL,
    cant_hs_p       INT NOT NULL,
    CONSTRAINT PK_ASIGNATURA
        PRIMARY KEY (cod_carrera, cod_asignatura)
);

-- =========================
-- TABLA: PROFESOR
-- =========================
CREATE TABLE PROFESOR (
    legajo          INT NOT NULL,
    apellido        VARCHAR(50) NOT NULL,
    nombre          VARCHAR(40) NOT NULL,
    titulo          VARCHAR(30),
    departamento    VARCHAR(20),
    tipo_prof       CHAR(1) NOT NULL,
    cod_carrera     INT,
    cod_asignatura  INT,
    CONSTRAINT PK_PROFESOR
        PRIMARY KEY (legajo),
    CONSTRAINT FK_PROFESOR_ASIGNATURA
        FOREIGN KEY (cod_carrera, cod_asignatura)
        REFERENCES ASIGNATURA (cod_carrera, cod_asignatura)
);

-- =========================
-- TABLA: ASIGNATURA_PROFESOR
-- =========================
CREATE TABLE ASIGNATURA_PROFESOR (
    cod_carrera     INT NOT NULL,
    cod_asignatura  INT NOT NULL,
    legajo          INT NOT NULL,
    cantidad_horas  INT NOT NULL,
    CONSTRAINT PK_ASIG_PROF
        PRIMARY KEY (cod_carrera, cod_asignatura, legajo),
    CONSTRAINT FK_AP_ASIGNATURA
        FOREIGN KEY (cod_carrera, cod_asignatura)
        REFERENCES ASIGNATURA (cod_carrera, cod_asignatura),
    CONSTRAINT FK_AP_PROFESOR
        FOREIGN KEY (legajo)
        REFERENCES PROFESOR (legajo)
);

-- =========================
-- TABLA: PROF_SIMPLE
-- =========================
CREATE TABLE PROF_SIMPLE (
    legajo  INT NOT NULL,
    perfil  VARCHAR(120) NOT NULL,
    CONSTRAINT PK_PROF_SIMPLE
        PRIMARY KEY (legajo),
    CONSTRAINT FK_PS_PROFESOR
        FOREIGN KEY (legajo)
        REFERENCES PROFESOR (legajo)
);

-- =========================
-- TABLA: PROF_EXCLUSIVO
-- =========================
CREATE TABLE PROF_EXCLUSIVO (
    legajo          INT NOT NULL,
    proy_investig   VARCHAR(20) NOT NULL,
    CONSTRAINT PK_PROF_EXCLUSIVO
        PRIMARY KEY (legajo),
    CONSTRAINT FK_PE_PROFESOR
        FOREIGN KEY (legajo)
        REFERENCES PROFESOR (legajo)
);





--Provea una expresión PostgreSQL que permita obtener identificador y nombre de
--las asignaturas de más de 30 horas de práctica en las que NO participan
--profesores del Departamento de Computación.
INSERT INTO ASIGNATURA VALUES(1,1,'BD',1,20,31);
INSERT INTO ASIGNATURA VALUES(1,2,'BD',1,20,31);

INSERT INTO PROFESOR  VALUES(1,'Cobo', 'Hernan', 'Ing de sistemas', 'Computación', 'E', NULL,NULL);
INSERT INTO PROFESOR  VALUES(2,'Berdún', 'Luis', 'Ing de sistemas', 'Computación', 'E', NULL,NULL);
INSERT INTO ASIGNATURA_PROFESOR VALUES(1,1,1,10);
INSERT INTO ASIGNATURA_PROFESOR VALUES(1,2,1,10);


SELECT cod_carrera, cod_asignatura
FROM ASIGNATURA
WHERE cant_hs_p > 30 AND NOT EXISTS (SELECT 1 FROM asignatura_profesor JOIN profesor p USING(legajo) WHERE p.departamento ilike 'computación');


--Provea una expresión SQL-99 que permita verificar que los profesores exclusivos
--con título registrado participen en menos del 20% del total de las asignaturas.

CREATE ASSERTION A1
CHECK (NOT EXISTS(
SELECT p.legajo, COUNT((ap.cod_carrera, ap.cod_asignatura))
FROM PROFESOR p
JOIN asignatura_profesor ap USING(legajo)
WHERE tipo_prof = 'E' AND titulo is not null
GROUP BY p.legajo
HAVING COUNT((ap.cod_carrera, ap.cod_asignatura)) > 0.2 * (SELECT COUNT((cod_carrera, cod_asignatura)) FROM asignatura_profesor)));

select *
FROM PROFESOR p
LEFT JOIN asignatura_profesor ap USING(legajo)
WHERE tipo_prof = 'E' AND titulo is not null;

SELECT p.legajo, COUNT((ap.cod_carrera, ap.cod_asignatura))
FROM PROFESOR p
LEFT JOIN asignatura_profesor ap USING(legajo)
WHERE tipo_prof = 'E' AND titulo is not null
GROUP BY p.legajo
HAVING COUNT((ap.cod_carrera, ap.cod_asignatura)) >= 0.2 * (SELECT COUNT(*) FROM asignatura);


SELECT p.legajo, COUNT(ap.cod_carrera)
        FROM PROFESOR p
        LEFT JOIN asignatura_profesor ap
               ON ap.legajo = p.legajo
        WHERE p.tipo_prof = 'E'
          AND p.titulo IS NOT NULL
        GROUP BY p.legajo
        HAVING COUNT(ap.cod_carrera)
               >= 0.2 * (SELECT COUNT(*) FROM ASIGNATURA);

--PARA HABLAR CON NICO!!!
--Provea una expresión SQL-99 que permita verificar que los profesores exclusivos
--con título registrado participen en menos del 20% del total de las asignaturas.


UPDATE EN PROFESOR: update de titulo
INSERT EN asignatura_profesor
UPDATE EN asignatura_profesor cod_carrera, cod_asignatura, legajo

CREATE OR REPLACE FUNCTION fn_insupd_asignatura_profesor()
RETURNS TRIGGER AS $$
DECLARE
    cantidad int;
BEGIN
    IF (EXISTS(SELECT 1 FROM profesor p where p.legajo = NEW.legajo AND p.tipo_prof = 'E' AND p.titulo IS NOT NULL)) THEN
        SELECT COUNT(*) INTO cantidad
                                     FROM (
                                         SELECT cod_carrera, cod_asignatura
                                         FROM ASIGNATURA_PROFESOR
                                         WHERE legajo = new.legajo
                                         AND NOT (tg_op= 'update' and legajo = old.legajo and cod_carrera = old.cod_carrera and cod_asignatura = old.cod_asignatura)
                                         UNION
                                         SELECT new.cod_carrera, NEW.cod_asignatura
                                          ) t;
        IF (cantidad >= 0.2 * (SELECT COUNT(*) FROM asignatura)) THEN
            RAISE EXCEPTION 'no se puede';
        end if;
    end if;

    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_insupd_asignatura_profesor
BEFORE INSERT OR UPDATE ON asignatura_profesor
FOR EACH ROW EXECUTE FUNCTION fn_insupd_asignatura_profesor();

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_after_asignatura_profesor()
RETURNS TRIGGER AS $$
DECLARE
    cantidad INT;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM profesor p
        WHERE p.legajo = NEW.legajo
          AND p.tipo_prof = 'E'
          AND p.titulo IS NOT NULL
    ) THEN

        SELECT COUNT(DISTINCT cod_carrera, cod_asignatura)
        INTO cantidad
        FROM asignatura_profesor
        WHERE legajo = NEW.legajo;

        IF cantidad >= 0.2 * (SELECT COUNT(*) FROM asignatura) THEN
            RAISE EXCEPTION 'no se puede';
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
