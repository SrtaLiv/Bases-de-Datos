/*CREATE OR REPLACE VIEW v_usuario_mayor
AS
SELECT DNI, e_mail, apellido, nombre, fecha_nac
FROM usuario
WHERE DNI > 12345678;

CREATE OR REPLACE VIEW v_mayor_gmail
AS
SELECT *
FROM v_usuario_mayor
WHERE e_mail like '%gmail%'
WITH LOCAL CHECK OPTION;

CREATE OR REPLACE VIEW v_mayor_parcial
AS
SELECT *
FROM v_usuario_mayor
WHERE apellido like 'Alva%'
WITH CASCADED CHECK OPTION;

INSERT INTO v_mayor_parcial  (DNI, e_mail, apellido, nombre, fecha_nac)
VALUES (11234567, 'cc@gmail.com', 'Alvarado', 'J', to_date('20170103','YYYYMMDD'))

Falla, porque viola el check option de la vista v_usuario_mayor

INSERT INTO v_mayor_gmail (DNI, e_mail, apellido, nombre, fecha_nac)
VALUES (11234567, 'cc@gmail.com', 'Alvarado', 'J', to_date('20170103','YYYYMMDD'))



INSERT INTO v_mayor_parcial (DNI, e_mail, apellido, nombre, fecha_nac)
VALUES (13234567, 'cc@gmail.com', 'Alvarado', 'J', to_date('20170103','YYYYMMDD'))



CREATE ASSERTION ck_servicio_sin_ambas_modalidades
       CHECK ( NOT EXISTS( SELECT 1
                   FROM contrata
                   WHERE (id_servicio, cod_tipo_serv)
                       IN (SELECT id_servicio, cod_tipo_serv
                               FROM uni_serv)));

CREATE ASSERTION ck_servicio_sin_ambas_modalidades
       CHECK ( NOT EXISTS( SELECT 1
                   FROM contrata c
                   JOIN uni_serv u USING (id_servicio, cod_tipo_serv)));

       -----------------------------------------------------------

       -- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:00:07.082

-- tables
-- Table: CONTRATA
CREATE TABLE CONTRATA (
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    DNI int  NOT NULL
);

-- Table: MULTI_SERV
CREATE TABLE MULTI_SERV (
    DNI int  NOT NULL
);

-- Table: SERVICIO
CREATE TABLE SERVICIO (
    cod_tipo_serv int  NOT NULL,
    id_servicio int  NOT NULL,
    nombre_servicio varchar(120)  NOT NULL
);

-- Table: TIPO_SERVICIO
CREATE TABLE TIPO_SERVICIO (
    cod_tipo_serv int  NOT NULL,
    nombre_tipo_serv varchar(40)  NOT NULL,
    descripcion_tipo_serv text  NOT NULL,
    CONSTRAINT AK_TIPO_SERVICIO UNIQUE (nombre_tipo_serv) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: UNI_SERV
CREATE TABLE UNI_SERV (
    DNI int  NOT NULL,
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_USUARIO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);
*/
-- End of file.
CREATE OR REPLACE FUNCTION fn_verificar_modalidad_servicio() RETURNS trigger AS $$
   BEGIN
	IF (TG_TABLE_NAME = 'UNI_SERV' ) THEN
		IF EXISTS (SELECT 1 FROM contrata
                           WHERE id_servicio = NEW.id_servicio
                           AND cod_tipo_serv = NEW.cod_tipo_serv
                           ) THEN
                          RAISE EXCEPTION 'El servicio % ya ha sido contratado en la modalidad %.', NEW.id_servicio, NEW.cod_tipo_serv;
		END IF;
	ELSIF (TG_TABLE_NAME = 'CONTRATA') THEN
              IF EXISTS (SELECT 1 FROM uni_serv
                         WHERE id_servicio = NEW.id_servicio
                         AND cod_tipo_serv = NEW.cod_tipo_serv
                         ) THEN
                         RAISE EXCEPTION 'El servicio % ya ha sido contratado en la modalidad %', NEW.id_servicio , NEW.cod_tipo_serv;
               END IF;
        END IF;
        RETURN NEW;
    END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_modalidad_servicio_unica
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON uni_serv FOR EACH ROW EXECUTE FUNCTION fn_verificar_modalidad_servicio();

CREATE TRIGGER tr_modalidad_servicio_multiple
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON contrata FOR EACH ROW EXECUTE FUNCTION fn_verificar_modalidad_servicio();

INSERT INTO UNI_SERV (DNI, id_servicio, cod_tipo_serv, fecha_inicio) VALUES (12345678, 1, 101, '2024-06-01');

-- Insertar un registro en CONTRATA
INSERT INTO CONTRATA (id_servicio, cod_tipo_serv, DNI) VALUES (2, 102, 87654321);
INSERT INTO UNI_SERV (DNI, id_servicio, cod_tipo_serv, fecha_inicio) VALUES (87654321, 2, 102, '2024-06-02');


SELECT min(horas_aportadas) as min FROM unc_esq_voluntario.voluntario



SELECT DISTINCT t1.id_tarea, t1.nombre_tarea
FROM unc_esq_peliculas.tarea t1
JOIN unc_esq_peliculas.empleado e USING (id_tarea)
JOIN unc_esq_peliculas.departamento d USING (id_departamento)
WHERE d.calle ILIKE 'Bhapoo'
AND NOT EXISTS(
    SELECT 1
    FROM unc_esq_peliculas.tarea t
    WHERE t.sueldo_maximo > 13000
    AND t.id_tarea = t1.id_tarea
);

sELECT MIN(horas_aportadas)
FROM unc_esq_voluntario.voluntario

SELECT count(*)
FROM unc_esq_voluntario.voluntario
WHERE horas_aportadas = (
    SELECT MIN(horas_aportadas)
    FROM unc_esq_voluntario.voluntario
);


SELECT DISTINCT t1.id_tarea, t1.nombre_tarea
FROM unc_esq_peliculas.tarea t1
JOIN unc_esq_peliculas.empleado e USING (id_tarea)
JOIN unc_esq_peliculas.departamento d USING (id_departamento)
WHERE d.calle ILIKE 'Bhapoo'
AND NOT EXISTS(
    SELECT 1
    FROM unc_esq_peliculas.tarea t
    WHERE t.sueldo_maximo > 13000
    AND t.id_tarea = t1.id_tarea
);
