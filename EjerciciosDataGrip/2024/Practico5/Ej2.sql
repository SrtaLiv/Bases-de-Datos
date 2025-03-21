SET search_path = unc_188;
SELECT * FROM tp5_p1_ej2_empleado;
SELECT * FROM tp5_p1_ej2_proyecto;
SELECT * FROM tp5_p1_ej2_trabaja_en;
SELECT * FROM tp5_p1_ej2_auspicio;

-- CONSIGNA 2

/************************************ EJERCICIO A ************************************/
--a) Indique el resultado de las siguientes operaciones, teniendo en cuenta las acciones
-- referenciales e instancias dadas. En caso de que la operación no se pueda realizar, indicar qué
-- regla/s entra/n en conflicto y cuál es la causa. En caso de que sea aceptada, comente el
-- resultado que produciría (NOTA: en cada caso considere el efecto sobre la instancia original de
-- la BD, los resultados no son acumulativos).

-- b.1)
DELETE FROM tp5_p1_ej2_proyecto WHERE id_proyecto = 3;
--SE ELIMINA PORQUE NO REFERENCIA A NADA.

--b.2)
UPDATE tp5_p1_ej2_proyecto SET id_proyecto = 7 WHERE id_proyecto = 3;
--PUEDE MODIFICARLO PORQUE EL ID_PROYECTO 3 NO REFERENCIA A NADIE

--b.3)
DELETE FROM tp5_p1_ej2_proyecto WHERE id_proyecto = 1;
--NO SE PUEDE ELIMINAR PQ ON DELETE ES RESTRICT Y EL ID PROYECTO TIENE REFERENCIAS

--b.4)
DELETE FROM tp5_p1_ej2_empleado WHERE tipo_empleado = 'A' and nro_empleado = 2;
--SE ELIMINO PORQUE EMPLEADO NO TIENE RESTRICCIONES

--b.5)
UPDATE tp5_p1_ej2_trabaja_en SET id_proyecto = 3 WHERE id_proyecto = 1;
--DELETE FROM tp5_p1_ej2_trabaja_en WHERE id_proyecto = 3;
--si se puede cambiar el id 1 por el 3. pero no entenid por que

--b.6)
UPDATE tp5_p1_ej2_proyecto SET id_proyecto = 5 WHERE id_proyecto = 2;
--NO SE PUEDE PQ TIENE REFERENCIA EN AUSPICIO Y EL UPDATE ACCION REF DE AUSPICIO ES
--    ON DELETE  RESTRICT
--    ON UPDATE  RESTRICT
    --POR LO TANTO TAMPOCO SE PODRIA ELIMINAR EJ:
DELETE FROM tp5_p1_ej2_proyecto WHERE id_proyecto = 2;


/************************************ EJERCICIO B ************************************/
/*
 b) Indique el resultado de la siguiente operaciones justificando su elección:*/

UPDATE tp5_p1_ej2_auspicio SET id_proyecto = 66, nro_empleado = 10
WHERE id_proyecto = 22
AND tipo_empleado = 'A'
AND nro_empleado = 5;
--(suponga que existe la tupla asociada)

--i. realiza la modificación si existe el proyecto 22 y el empleado TipoE ='A', NroE = 5
--ii. realiza la modificación si existe el proyecto 22 sin importar si existe el empleado TipoE = 'A', NroE = 5
-- iii. Se modifican los valores, dando de alta el proyecto 66 en caso de que no exista (si no se violan restricciones
-- de nulidad), sin importar si existe el empleado
--iv. se modifican los valores, y se da de alta el proyecto 66 y el empleado correspondiente (si
-- no se violan restricciones de nulidad)
-- v. no permite en ningún caso la actualización debido a la modalidad de la restricción entre la
-- tabla empleado y auspicio.
-- vi. ninguna de las anteriores, cuál?

--RTA: D?

/************************************ EJERCICIO D ************************************/
--d) Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas, según se considere
--para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO match: i) simple, ii)
--parcial, o iii) full:
--a. insert into Auspicio values (1, Dell , B, null);
--b. insert into Auspicio values (2, Oracle, null, null);
--c. insert into Auspicio values (3, Google, A, 3);
--d. insert into Auspicio values (1, HP, null,

--MATCH SIMPLE:
--MATCH PARCIAL:
--MATCH FULL:

--A
--MATCH SIMPLE: SI, PQ HACE AL MENOS MATCH CON 'B' EN EMPLEADO Y ID_PROY 1
--MATCH PARCIAL:
--MATCH FULL: NO, PQ TIENE UN NULL Y NO HACE MATCH EN LA TABLA DE NRO EMPLEADO
insert into tp5_p1_ej2_auspicio values (1, 'Dell' , 'C', null);

--B
--MATCH SIMPLE: SI
--MATCH PARCIAL:
--MATCH FULL: NO
insert into tp5_p1_ej2_auspicio values (2, 'Oracle', null, null);

--C
--MATCH SIMPLE: NO
--MATCH PARCIAL:
--MATCH FULL: NO, no hay nro de empleado 3
insert into tp5_p1_ej2_auspicio values (3, 'Google', 'A', 3);

--D
--MATCH SIMPLE: SI
--MATCH PARCIAL
--MATCH FULL:
insert into TP5_P1_EJ2_AUSPICIO values (1, 'HP', null, 3);

/************************************ SCRIPT CENTRO DE DESARROLLO ************************************/
--REESTABLECER VALORES
    -- Eliminar datos de la tabla TP5_P1_EJ2_TRABAJA_EN
DELETE FROM tp5_p1_ej2_trabaja_en;

-- Eliminar datos de la tabla TP5_P1_EJ2_AUSPICIO
DELETE FROM tp5_p1_ej2_auspicio;

-- Eliminar datos de la tabla TP5_P1_EJ2_EMPLEADO
DELETE FROM tp5_p1_ej2_empleado;

-- Eliminar datos de la tabla TP5_P1_EJ2_PROYECTO
DELETE FROM tp5_p1_ej2_proyecto;


-- EMPLEADO

INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 1, 'Juan', 'Garcia', 'Jefe');
INSERT INTO tp5_p1_ej2_empleado VALUES ('B', 1, 'Luis', 'Lopez', 'Adm');
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 2, 'María', 'Casio', 'CIO');

-- PROYECTO
INSERT INTO tp5_p1_ej2_proyecto VALUES (1, 'Proy 1', 2019, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (2, 'Proy 2', 2018, 2019);
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);

-- TRABAJA_EN
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 1, 1, 35, 'T1');
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 2, 2, 25, 'T3');

-- AUSPICIO
INSERT INTO tp5_p1_ej2_auspicio VALUES (2, 'McDonald', 'A ', 2);

-- tables
-- Table: TP5_P1_EJ2_AUSPICIO
CREATE TABLE TP5_P1_EJ2_AUSPICIO (
    id_proyecto int  NOT NULL,
    nombre_auspiciante varchar(20)  NOT NULL,
    tipo_empleado char(2)  NULL,
    nro_empleado int  NULL,
    CONSTRAINT TP5_P1_EJ2_AUSPICIO_pk PRIMARY KEY (id_proyecto,nombre_auspiciante)
);

-- Table: TP5_P1_EJ2_EMPLEADO
CREATE TABLE TP5_P1_EJ2_EMPLEADO (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    cargo varchar(15)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_EMPLEADO_pk PRIMARY KEY (tipo_empleado,nro_empleado)
);

-- Table: TP5_P1_EJ2_PROYECTO
CREATE TABLE TP5_P1_EJ2_PROYECTO (
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(40)  NOT NULL,
    anio_inicio int  NOT NULL,
    anio_fin int  NULL,
    CONSTRAINT TP5_P1_EJ2_PROYECTO_pk PRIMARY KEY (id_proyecto)
);

-- Table: TP5_P1_EJ2_TRABAJA_EN
CREATE TABLE TP5_P1_EJ2_TRABAJA_EN (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    id_proyecto int  NOT NULL,
    cant_horas int  NOT NULL,
    tarea varchar(20)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_TRABAJA_EN_pk PRIMARY KEY (tipo_empleado,nro_empleado,id_proyecto)
);

-- foreign keys
-- Reference: FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
	MATCH SIMPLE
    ON DELETE  SET NULL
    ON UPDATE  RESTRICT
;


-- Reference: FK_TP5_P1_EJ2_AUSPICIO_PROYECTO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
    ON DELETE  CASCADE
    ON UPDATE  RESTRICT;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  CASCADE
;

-- End of file.
