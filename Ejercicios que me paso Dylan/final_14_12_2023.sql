set search_path to final_14_12_2023;
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-12-13 22:54:32.044

-- tables
-- Table: especialidad
CREATE TABLE especialidad (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: institucion
CREATE TABLE institucion (
    cod_institucion int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    localidad int  NOT NULL,
    certificada boolean  NOT NULL,
    CONSTRAINT pk_centro_salud PRIMARY KEY (cod_institucion)
);

-- Table: profesional
CREATE TABLE profesional (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    id_profesional int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    nro_matricula int  NOT NULL,
    inicio_profesional date  NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (tipo_especialidad,cod_especialidad,id_profesional)
);

-- Table: trabaja_en
CREATE TABLE trabaja_en (
    cod_institucion int  NOT NULL,
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    id_profesional int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL,
    horas_semanales int  NOT NULL,
    CONSTRAINT pk_atiende PRIMARY KEY (tipo_especialidad,cod_especialidad,id_profesional,fecha_inicio)
);

-- Table: ubicacion
CREATE TABLE ubicacion (
    cod_localidad int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    superficie int  NOT NULL,
    poblacion int  NOT NULL,
    CONSTRAINT ubicacion_pk PRIMARY KEY (cod_localidad)
);

-- foreign keys
-- Reference: fk_institucion_ubicacion (table: institucion)
ALTER TABLE institucion ADD CONSTRAINT fk_institucion_ubicacion
    FOREIGN KEY (localidad)
    REFERENCES ubicacion (cod_localidad)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: fk_profesional_especialidad (table: profesional)
ALTER TABLE profesional ADD CONSTRAINT fk_profesional_especialidad
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES especialidad (tipo_especialidad, cod_especialidad)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: fk_trabaja_institucion (table: trabaja_en)
ALTER TABLE trabaja_en ADD CONSTRAINT fk_trabaja_institucion
    FOREIGN KEY (cod_institucion)
    REFERENCES institucion (cod_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: fk_trabaja_profesional (table: trabaja_en)
ALTER TABLE trabaja_en ADD CONSTRAINT fk_trabaja_profesional
    FOREIGN KEY (tipo_especialidad, cod_especialidad, id_profesional)
    REFERENCES profesional (tipo_especialidad, cod_especialidad, id_profesional)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.


INSERT INTO especialidad VALUES('PED', 1, 'Pediatria', 'Trabaja con niños'),
                               ('BIO', 2, 'Bioingenieria', 'ingenieria pero con biologia'),
                               ('CAR',3,'Cardiologia','Corazones');

INSERT INTO profesional VALUES('PED', 1, 1, 'Alberto', 'Peralta',72030, '2020-12-20'::date),
                              ('BIO',2,2,'Roberto', 'Bolanios', 82030, '2023-11-15'::date),
                              ('CAR',3,3, 'Armando Esteban', 'Quito', 42030, CURRENT_DATE),
                              ('PED', 1, 4, 'Victor', 'Menta', 52030,'2026-01-06'::date ),
                              ('BIO',2,5,'Debora', 'Dora', 12030, '2021-11-15'::date),
                              ('PED', 1, 6, 'Cesar', 'Noso',02030, '2024-06-20'::date);


INSERT INTO ubicacion VALUES (1,'Tandil',40,160000),
                            (2,'Mar Del Plata',80,1300000),
                            (3,'Olavarria',30,120000),
                            (4,'Balcarce',20,80000);

INSERT INTO institucion VALUES (1,'Laboratorio Scaloneta','9 de julio',920,1,TRUE),
                               (2,'Hospital Santamarina','Alem',1250,1,TRUE),
                               (3,'Clinica Modelo','España',902,1,FALSE),
                               (4,'Laboratorio Alfonsina','Colon',2430,2,TRUE),
                               (5,'Hospital Lobo Marino','Luro',1330,2,TRUE),
                               (6,'Clinica Chingoto','Belgrano',610,3,FALSE),
                               (7,'Hospital Emiliozzi','Panama',330,3,TRUE),
                               (8,'Salita Fangio','Paz',128,4,FALSE);


INSERT INTO trabaja_en VALUES (1,'BIO',2,2,'2025-02-01'::date,null,40),
                              (1,'BIO',2,5,'2024-01-10'::date,'2025-10-20'::date,50),
                              (2,'CAR',3,3,'2025-06-09'::date,null,25),
                              (3,'CAR',3,3,'2024-12-01'::date,'2026-01-06'::date,20),
                              (4,'PED',1,1,'2025-10-01'::date,null,48),
                              (4,'BIO',2,5,'2025-03-01'::date,null,40),
                              (5,'PED',1,4,'2023-12-01'::date,'2025-10-20'::date,42),
                              (6,'PED',1,4,'2022-02-01'::date,null,40),
                              (7,'PED',1,6,'2020-01-01'::date,'2025-12-31'::date,30),
                              (8,'PED',1,6,'2021-02-01'::date,null,25);


--1.a) Un profesional no puede trabajar más de 10 horas semanales si el periodo de trabajo es menor a un año de
--duración



--1.b) Sólo puede haber una fecha_fin no establecida (nula) por cada Profesional e Institución
ALTER TABLE trabaja_en ADD CONSTRAINT a2
CHECK NOT EXISTS(
    SELECT *
    FROM trabaja_en te
    WHERE te.fecha_fin is null
      AND EXISTS(SELECT 1
                 FROM trabaja_en te2
                 WHERE te2.cod_institucion = te.cod_institucion
                   AND te2.tipo_especialidad = te.tipo_especialidad
                   AND te2.cod_especialidad = te.cod_especialidad
                   AND te2.id_profesional = te.id_profesional
                   AND te2.fecha_inicio <> te.fecha_inicio
                   AND te2.fecha_fin is null);
);

1.c) Cada Profesional en una misma Institución no puede registrar más de un trabajo en un mismo momento;

es decir que por cada Institución y Profesional, los intervalos de tiempo (fecha_inicio, fecha_fin) no se pueden
superponer ni total ni parcialmente, salvo en los extremos (fecha_inicio o fecha_fin, pero no ambos).

ALTER TABLE trabaja_en ADD CONSTRAINT a2
CHECK NOT EXISTS(
    SELECT 1
    FROM trabaja_en te
    WHERE EXISTS
    (                   SELECT 1
                        FROM trabaja_en te2
                        WHERE te2.cod_institucion = te.cod_institucion
                        AND te2.tipo_especialidad = te.tipo_especialidad
                        AND te2.cod_especialidad = te.cod_especialidad
                        AND te2.id_profesional = te.id_profesional
                        AND te2.fecha_inicio <> te.fecha_inicio
                        AND te.fecha_inicio < COALESCE(te2.fecha_fin, '9999-12-31'::date)
                        AND te2.fecha_inicio < COALESCE(te.fecha_fin,  '9999-12-31'::date)
    )
)


--2.a) En toda institución certificada debe trabajar al menos un profesional de alguna especialidad relacionada
--con la gestión ambiental durante 6 o más horas semanales.

lo que esta mal: que exista una institucion certificada donde no exista un profesional relacionado con la gestion ambiental durante 6 horas o mas semanales que se encuentre trabajando ahí

lo que esta bien: que NO EXISTA lo que esta mal
NOT EXISTS(
    SELECT *
    FROM institucion i
    WHERE certificada = true AND NOT EXISTS
(SELECT 1 FROM trabaja_en te WHERE i.cod_institucion = te.cod_institucion AND tipo_especialidad = 'GA' AND cod_especialidad = '777'
                                                                         AND horas_semanales >= 6)
);
-- Enuncie y justifique todos los eventos críticos que se
--requiere controlar para asegurar su cumplimiento en PostgreSQL y escriba las declaraciones de los triggers
--correspondientes (sin las funciones).




INSERT EN INSTITUCION ->  se agrega una institucion se debe asegurar al menos un profesional que trabaje ahi

UPDATE EN Institucion -> fila certificada

UPDATE EN trabaja_en -> cod_institucion
UPDATE EN trabaja_En -> cambiar tipo_especialidad y cambiar cod_especialidad
UPDATE EN trabaja_en -> cambiar horas_semanales

update en profesional -> cambiar tipo_especialidad y cambiar cod_especialidad

UPDATE especialidad -> en nombre

DELETE en trabaja_en
DELETE en profesional. -> Se controla por las RIR


CREATE TRIGGER tr1
BEFORE INSERT or UPDATE OF certificada ON institucion
FOR EACH ROW EXECUTE FUNCTION fn_tr1();

CREATE TRIGGER tr2
BEFORE DELETE or UPDATE OF cod_institucion, tipo_especialidad, cod_especialidad, horas_semanales ON trabaja_en
FOR EACH ROW EXECUTE FUNCTION fn_tr2();

CREATE TRIGGER tr3
BEFORE UPDATE OF nombre ON especialidad
FOR EACH ROW EXECUTE FUNCTION fn_tr3();

CREATE TRIGGER tr4
BEFORE UPDATE OF tipo_especialidad, cod_especialidad ON profesional
FOR EACH ROW EXECUTE FUNCTION fn_tr4();



-- 2.b) En localidades (ubicaciones) de menos de 100.000 habitantes puede haber 5 instituciones como
-- máximo.

exista una localidad con menos de 100000 habitantes donde hay mas de 5 habitaciones
-- Escriba una implementación completa (encabezado/s y función/es) mediante trigger/s en PostgreSQL
-- que garantice que la restricción se verifique siempre ante cualquier operación de inserción.


SELECT 1
FROM ubicacion u
WHERE poblacion < 100000 AND (SELECT COUNT(*) FROM institucion i WHERE i.localidad = u.cod_localidad) > 5;


CREATE OR REPLACE FUNCTION fn_2b()
RETURNS TRIGGER AS $$
DECLARE
    cant_inst INTEGER;
    hab INTEGER;
BEGIN
    SELECT poblacion
    INTO hab
    FROM ubicacion
    WHERE cod_localidad = NEW.localidad;

    IF hab < 100000 THEN

        SELECT COUNT(*)
        INTO cant_inst
        FROM institucion
        WHERE localidad = NEW.localidad;

        IF cant_inst >= 5 THEN
            RAISE EXCEPTION
            'error';
        END IF;
    END IF;

RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_2b
BEFORE INSERT ON institucion
FOR EACH ROW EXECUTE FUNCTION fn_2b();

--3.a) Listar los datos de las instituciones en las que trabaja al menos un profesional de cada tipo de especialidad

SELECT * FROM
institucion
WHERE cod_institucion IN (SELECT cod_institucion
                          FROM trabaja_en
                          GROUP BY cod_institucion
                          HAVING COUNT(DISTINCT tipo_especialidad) = (SELECT COUNT(*) FROM especialidad));

SELECT * FROM trabaja_en WHERE cod_institucion = 4;
BEGIN;
INSERT INTO trabaja_en VALUES(4,'CAR',3,3,CURRENT_DATE,null,60);
ROLLBACK;

SELECT * FROM institucion i
WHERE NOT EXISTS
( SELECT e.tipo_especialidad FROM especialidad e
EXCEPT SELECT tipo_especialidad
FROM trabaja_en t  WHERE I.cod_institucion = T.cod_institucion);


--3.b) Obtener identificador y nombre de los profesionales que no registran trabajos de más de 30 horas
--semanales en instituciones localizadas en Tandil.
lo que esta mal: que exista un profesional que registre trabajos de mas de 30 horas

SELECT p.id_profesional, p.nombre
FROM profesional p
WHERE NOT EXISTS(SELECT 1
                 FROM trabaja_en t
                 JOIN institucion i USING(cod_institucion)
                 JOIN ubicacion u  ON i.localidad = u.cod_localidad
                 WHERE p.id_profesional = t.id_profesional AND p.tipo_especialidad = t.tipo_especialidad AND p.cod_especialidad = t.cod_especialidad
                 AND t.horas_semanales > 30
                 AND u.nombre ilike 'tandil'
                 );

SELECT p.id_profesional, p.nombre
FROM profesional p
JOIN trabaja_en t USING (id_profesional)
JOIN institucion i USING (cod_institucion)
WHERE t.horas_semanales < 30
AND i.localidad NOT IN
(SELECT cod_localidad
FROM UBICACION
WHERE nombre ilike 'tandil');



SELECT p.*, t.horas_semanales
FROM profesional p
JOIN trabaja_en t USING (id_profesional, tipo_especialidad, cod_especialidad)
JOIN institucion i USING (cod_institucion)
WHERE t.horas_semanales < 30

--3.c) Listar los diferentes códigos y nombres de instituciones en las que trabajan actualmente más de 10
--profesionales de especialidades relacionadas con bioingeniería.
SELECT i.cod_institucion, i.nombre
FROM institucion i
WHERE EXISTS (SELECT 1
                            FROM trabaja_en t
                            WHERE t.cod_institucion = i.cod_institucion AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE) AND tipo_especialidad ilike 'bio'
                            GROUP BY t.cod_institucion
                            HAVING COUNT(id_profesional) >1);

update trabaja_en SET fecha_fin = '2026-04-08'::date WHERE tipo_especialidad = 'BIO' AND cod_especialidad = 2 AND id_profesional = 5 AND fecha_inicio = '2024-01-10'::date;

SELECT * FROM trabaja_en JOIN especialidad USING(tipo_especialidad,cod_especialidad) WHERE n;







SELECT i.cod_institucion, i.nombre
FROM institucion i
WHERE i.cod_institucion IN
    ( SELECT t.cod_institucion FROM trabaja_en t
    WHERE t.fecha_fin > current_date
    AND t.fecha_fin = null
    AND EXISTS (SELECT 1 FROM especialidad
    WHERE nombre LIKE '%bioingenieria%')
GROUP BY i.cod_institucion
HAVING COUNT(*) >= 10;


--a) vista_1 : que contenga los identificadores y nombres de los distribuidores que poseen más del 0,5 % del total
--de empleados registrados.

CREATE VIEW vista_1 AS
SELECT d.id_distribuidor, d.nombre
FROM distribuidor d
WHERE d.id_distribuidor IN (select e.id_distribuidor
                            from empleado e
                            group by e.id_distribuidor
                            having count(*) >= (select count(*) from empleado) * 0.05)
set search_path to final_14_12_2023;
--b) vista_2 : con el identificador y nombre de el/los departamento/s que registre/n la menor cantidad de
--empleados, incluyendo también el apellido y nombre del jefe de departamento.
CREATE VIEW VISTA_2 AS
WITH t AS (
SELECT d.id_departamento, d.id_distribuidor, d.nombre, COUNT(id_empleado) as cant_Emp
FROM departamento d
JOIN empleado e USING(id_departamento, id_distribuidor)
GROUP BY d.id_departamento, d.id_distribuidor, d.nombre
)

SELECT d.id_departamento, d.id_distribuidor, d.nombre
FROM departamento d
JOIN t USING (id_departamento, id_distribuidor)
JOIN empleado e USING(id_departamento, id_distribuidor)
WHERE e.id_empleado = d.jefe_departamento
GROUP BY d.id_departamento, d.id_distribuidor, d.nombre, t.cant_emp
HAVING t.cant_emp = (SELECT MIN(t.cant_emp)FROM t);
/*
Ejercicio 5)
Se dispone de una tabla ARCHIVO_BASE con atributos: fecha_insercion, nro_archivo, fecha_creacion,
descripción, tipo_archivo
La cual se encuentra cargada con datos.

Se sabe que esta tabla puede tener registros
repetidos (por repetido se entiende que los 4 últimos atributos son coincidentes entre distintos registros, pero la
fecha_insercion es única).

Además se tiene una tabla ARCHIVO y una tabla TIPO_ARCHIVO, la primera tiene todos los atributos de
ARCHIVO_BASE junto con una nueva columna llamada cant_filas y sin el atributo fecha_insercion.
Se necesitacopiar las filas únicas desde ARCHIVO_BASE a ARCHIVO e indicar en la columna cant_filas la cantidad de filas
repetidas que había de dicha fila.

Además se quiere definir una FOREIGN KEY sobre el atributo tipo_archivo de la tabla ARCHIVO a la tabla
TIPO_ARCHIVO, la cual ya contiene algunos tipo_archivo que figuran en ARCHIVO_BASE, pero no hay seguridad
de que estén todos.
Por eso, se requiere agregar a TIPO_ARCHIVO los valores faltantes.
Provea una solución procedural en PostgreSQL que permita completar lo requerido en las tablas indicadas; es
decir, copiar de ARCHIVO_BASE a ARCHIVO y completar los posibles tipos de archivos faltantes en TIPO_ARCHIVO.
Nota: considere que las tablas a completar ya están creadas.
*/

--Desde archivo_base debo contar la cantidad de filas repetidas (exceptuando fecha_insercion) y ponerlo en la tabla archivo.
--Luego debo copiar desde archivo_base los TIPO_ARCHIVO existentes que no esten en la tipo_archivo.
CREATE TABLE archivo_base (
    fecha_insercion DATE PRIMARY KEY,
    nro_archivo INTEGER,
    fecha_creacion DATE,
    descripcion VARCHAR(40),
    tipo_archivo CHAR(3)
);
INSERT INTO archivo_base VALUES('2025-12-12'::date, 100, '2025-12-10'::date, 'Es un archivo pesado', 'MP3'),
                               (CURRENT_DATE, 200, CURRENT_DATE, 'Archivo para la facu', 'PDF'),
                               ('2026-01-10'::date,300,'2026-01-01'::date, 'Video para YT', 'MP4');
INSERT INTO archivo_base VALUES('2025-12-10'::date, 100, '2025-12-10'::date, 'Es un archivo pesado', 'MP3');

CREATE TABLE archivo (
    nro_archivo INTEGER,
    fecha_creacion DATE,
    descripcion VARCHAR(40),
    tipo_archivo CHAR(3), --FK a tipo_archivo
    cant_filas INTEGER,
    CONSTRAINT archivo_TO_tipo_archivo FOREIGN KEY (tipo_archivo) REFERENCES tipo_archivo(tipo_archivo)--cant_filas hace referencia a la cantidad de filas repetidas
);


CREATE TABLE tipo_archivo (
    tipo_archivo CHAR(3) primary key
);

INSERT INTO tipo_archivo values('MP3');

CREATE OR REPLACE PROCEDURE llenar_tablas()
AS $$
BEGIN
    TRUNCATE TABLE archivo;

    INSERT INTO tipo_archivo(tipo_archivo)
    SELECT DISTINCT(tipo_archivo)
    FROM archivo_base
    EXCEPT
    SELECT tipo_archivo
    FROM tipo_archivo;

    INSERT INTO archivo
    SELECT nro_archivo, fecha_creacion, descripcion, tipo_archivo, COUNT(*)
    FROM archivo_base
    GROUP BY nro_archivo, fecha_creacion, descripcion, tipo_archivo;

end;
$$ language 'plpgsql';

begin;

CALL llenar_tablas();
SELECT * FROM archivo;
SELECT * FROM tipo_archivo;
rollback;