-- Utilizando el esquema unc_esq_voluntarios. Mostrar los tres voluntarios (su PK) que más horas aportadas
-- tienen y posean coordinador.

SELECT voluntario.nro_voluntario
FROM unc_esq_voluntario.voluntario
WHERE voluntario.id_coordinador IS NOT NULL
GROUP BY voluntario.nro_voluntario
ORDER BY horas_aportadas DESC
LIMIT 3;

-- INCORRECTO


-- - Un Servicio no puede ser contratado en las dos modalidades de Servicio

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


-- - Un Servicio no puede ser contratado en las dos modalidades de Servicio
CREATE OR REPLACE FUNCTION fn_servicio_hasta_2_modalidades()
RETURNS TRIGGER AS $$
DECLARE
    cant_contrata INT := 0;
    cant_uniserv INT := 0;
BEGIN
    SELECT COUNT(*) INTO cant_contrata
    FROM CONTRATA
    WHERE id_servicio = NEW.id_servicio
    AND CONTRATA.cod_tipo_serv = new.cod_tipo_serv
    ;

    SELECT COUNT(*) INTO cant_uniserv
    FROM UNI_SERV
    WHERE id_servicio = NEW.id_servicio
    AND UNI_SERV.cod_tipo_serv = new.cod_tipo_serv;

    IF (cant_contrata + cant_uniserv) >= 2 THEN
        RAISE EXCEPTION 'Un servicio no puede ser contratado en más de dos modalidades de servicio';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TR_SERVICIO_HASTA_2_MODALIDADES
BEFORE INSERT OR UPDATE ON CONTRATA
FOR EACH ROW
EXECUTE PROCEDURE fn_servicio_hasta_2_modalidades();

CREATE TRIGGER TR_SERVICIO_HASTA_2_MODALIDADES
BEFORE INSERT OR UPDATE ON UNI_SERV
FOR EACH ROW
EXECUTE PROCEDURE fn_servicio_hasta_2_modalidades();

-- resolucion de la catedra
CREATE FUNCTION VERIFICAR() RETURNS TRIGGER AS $$
BEGIN
IF (tg_table_name = 'UNI_SERV' ) THEN
    IF EXISTS(
    SELECT 1
    FROM CONTRATA
    WHERE id_servicio = NEW.id_servicio
    AND CONTRATA.cod_tipo_serv = new.cod_tipo_serv
    ) THEN
        RAISE EXCEPTION 'EL SERVICIO % DEL TIPO % YA ESTA CONTRATAD0', new.id_servicio, new.cod_tipo_serv;
    end if;
ELSIF (tg_table_name = 'contata') THEN
    IF EXISTS(
        SELECT 1
        FROM UNI_SERV
        WHERE id_servicio = NEW.id_servicio
        AND UNI_SERV.cod_tipo_serv = new.cod_tipo_serv
    ) THEN
        RAISE EXCEPTION 'El servicio % de tipo %  ya está contratado en modalidad única', NEW.id_servicio , NEW.cod_tipo_serv;

              END IF;
        END IF;
        RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE ASSERTION ck_servicio_hasta_2_modalidades
CHECK (
       NOT EXISTS(
       SELECT 1
       FROM CONTRATA C
       JOIN UNI_SERV U
       USING (COD_TIPO_SERV, ID_SERVICIO);
       )
)

-- UN SERVICIO PUEDE SER CONTRATADO EN LAS 2 MODALIDADES DE SERVICIO


---------------------------------------------------------------------------------------------------------------------


       -- tables
-- Table: ALUMNO
CREATE TABLE ALUMNO (
    DNI int  NOT NULL,
    LU int  NOT NULL,
    CONSTRAINT AK_ALUMNO UNIQUE (LU) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: CARRERA
CREATE TABLE CARRERA (
    id_carrera int  NOT NULL,
    nombre_titulo_otorgado text  NOT NULL,
    nombre_carrera text  NOT NULL,
    CONSTRAINT AK_CARRERA_1 UNIQUE (nombre_titulo_otorgado) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT AK_CARRERA_2 UNIQUE (nombre_carrera) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: DOCENTE
CREATE TABLE DOCENTE (
    DNI int  NOT NULL,
    id_profesor int  NOT NULL,
    fecha_ingreso date  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL,
    CONSTRAINT AK_DOCENTE UNIQUE (id_profesor) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: MATERIA
CREATE TABLE MATERIA (
    id_carrera int  NOT NULL,
    id_materia int  NOT NULL,
    nombre_materia varchar(150)  NOT NULL,
    CONSTRAINT AK_MATERIA UNIQUE (nombre_materia) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: PERSONA
CREATE TABLE PERSONA (
    DNI int  NOT NULL,
    email varchar(120)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    nombre varchar(30)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_PERSONA UNIQUE (email) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: SE_INSCRIBE
CREATE TABLE SE_INSCRIBE (
    DNI int  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL
);

-- End of file.

-- Considere las siguientes sentencias SQL de declaración de claves primarias (PK) y
-- claves extranjeras (FK) sobre el esquema dado:

-- Primary Key
ALTER TABLE ALUMNO ADD CONSTRAINT PK_ALUMNO PRIMARY KEY (DNI);
ALTER TABLE CARRERA ADD CONSTRAINT PK_CARRERA PRIMARY KEY (id_carrera);
ALTER TABLE DOCENTE ADD CONSTRAINT PK_DOCENTE PRIMARY KEY (DNI);
ALTER TABLE PERSONA ADD CONSTRAINT PK_PERSONA PRIMARY KEY (DNI);

-- foreign keys
ALTER TABLE DOCENTE ADD CONSTRAINT FK_DOCENTE_MATERIA
    FOREIGN KEY (id_materia, id_carrera)
    REFERENCES MATERIA (id_materia, id_carrera);

ALTER TABLE MATERIA ADD CONSTRAINT FK_MATERIA_CARRERA
    FOREIGN KEY (id_carrera)
    REFERENCES CARRERA (id_carrera);

ALTER TABLE SE_INSCRIBE ADD CONSTRAINT FK_SE_INSCRIBE_ALUMNO
    FOREIGN KEY (DNI)
    REFERENCES ALUMNO (DNI);

ALTER TABLE SE_INSCRIBE ADD CONSTRAINT FK_SE_INSCRIBE_MATERIA
    FOREIGN KEY (id_materia, id_carrera)
    REFERENCES MATERIA (id_materia, id_carrera);



-- AGREGO YO:
-- Primary Key
ALTER TABLE SE_INSCRIBE ADD CONSTRAINT SE_INSCRIBE PRIMARY KEY (DNI, id_materia, id_carrera);
ALTER TABLE MATERIA ADD CONSTRAINT PK_MATERIA PRIMARY KEY (id_carrera, id_materia);

-- foreign key
ALTER TABLE DOCENTE ADD CONSTRAINT PERSONA_DOCENTE FOREIGN KEY (DNI)
REFERENCES PERSONA (DNI)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ALUMNO ADD CONSTRAINT PERSONA_ALUMNO FOREIGN KEY (DNI)
REFERENCES PERSONA (DNI)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- EMAIL UNICO
ALTER TABLE PERSONA ADD CONSTRAINT EMAIL_UNICO UNIQUE (email);

-----------------------------------------------------------------------------------------------------------------------
-- VISTAS

CREATE OR REPLACE VIEW v_emp_mail
AS
SELECT DNI, e_mail, apellido, nombre, fecha_nac
FROM empleado
WHERE e_mail not like '%hotmail%';

CREATE OR REPLACE VIEW v_mail_menor
AS
SELECT *
FROM v_emp_mail
WHERE DNI < 23456789
WITH LOCAL CHECK OPTION;

CREATE OR REPLACE VIEW v_menor_parcial
AS
SELECT *
FROM v_mail_menor
WHERE apellido like '%ado'
WITH LOCAL CHECK OPTION;

-- Para las siguientes sentencias ejecutadas de manera independiente señalar las opciones que son VERDADERAS. Nota:
-- Las respuestas incorrectas restan del puntaje total. Tenga cuidado al cortar y pegar las sentencias con las comillas simples ' '.
--
-- a.
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- Procede, inserta los datos en la tabla empleado y se muestran en la vista v_emp_mail y en la vista v_mail_menor

-- RTA: No se muestra en v_mail_mayor, porque el crea una vista en base a una vista que no muestra los que terminan en hotmail.

-- b
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- Procede, inserta los datos en la tabla empleado y se muestran en todas las vistas
-- FALSO. Si procede, pero no se muestra en todas las vistas por el @hotmail

-- c.
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- Procede, inserta los datos en la tabla empleado pero no se muestran en la vista v_mail_menor
-- Es verdadera, procede.

-- d.
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- Procede, inserta los datos en la tabla empleado pero no se muestran en la vista v_emp_mail
-- Es verdadera, procede peor por su email no se ve en v_emp_mail

-- e.
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- NO Procede, da error.
-- Falso, si procede pq respeta el apellido que termina con ado

-- f.
-- INSERT INTO v_mail_menor (DNI, e_mail, apellido, nombre, fecha_nac)
-- VALUES (22345678, ‘cc@hotmail.com’, ‘Alvarado’, ‘J’, to_date('20170103','YYYYMMDD'))
-- NO Procede, porque no cumple con la condición de la vista v_emp_mail
-- Local check option, solo se fija su condicion, no mirara la de v_emp_mail. Falso


-----------------------------------------------------------------------------------------------------------------------
--Utilizando el esquema unc_esq_voluntario. Cuáles son los 2 coordinadores(nombre) que han tenido a cargo la menor
-- cantidad de voluntarios que hayan realizado cualquier tarea terminada en CLERK.
SELECT v.id_coordinador, v.nombre, count(*) as cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v -- coordinador
JOIN unc_esq_voluntario.voluntario v2 -- voluntario
ON v2.nro_voluntario = v.id_coordinador
JOIN unc_esq_voluntario.tarea t
ON t.id_tarea = v2.id_tarea -- tareas de voluntario
WHERE t.nombre_tarea iLIKE '%CLERK'
GROUP BY v.id_coordinador, v.nombre
ORDER BY cantidad_voluntarios ASC
LIMIT 2;

SELECT v2.id_coordinador, v2.nombre, count(v1.nro_voluntario)
FROM unc_esq_voluntario.voluntario v1
JOIN unc_esq_voluntario.voluntario v2
USING (id_coordinador)
WHERE v1.id_tarea
LIKE '%CLERK'
GROUP BY v2.nombre, v2.apellido
;

SELECT
  c.nombre AS nombre_coordinador,
  c.apellido AS apellido_coordinador,
  COUNT( v.nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.tarea t
  ON v.id_tarea = t.id_tarea
JOIN unc_esq_voluntario.voluntario c
  ON v.id_coordinador = c.nro_voluntario
WHERE t.nombre_tarea ILIKE '%CLERK'
GROUP BY c.nombre, c.apellido
ORDER BY cantidad_voluntarios ASC
LIMIT 2;

-- respuesta catedra
select coor.nro_voluntario, coor.nombre  as "Coordinador", count(*)
from  voluntario V
join voluntario coor on V.id_coordinador=coor.nro_voluntario
join tarea t on V.id_tarea = t.id_tarea
where t.id_tarea  like '%CLERK'
group by coor.nro_voluntario, coor.nombre
order by 3 asc


