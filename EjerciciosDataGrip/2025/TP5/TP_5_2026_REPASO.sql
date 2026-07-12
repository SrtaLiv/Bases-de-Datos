-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
                                 id_articulo int  NOT NULL,
                                 titulo varchar(120)  NOT NULL,
                                 autor varchar(30)  NOT NULL,
                                 CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
                                 id_articulo int  NOT NULL,
                                 idioma char(2)  NOT NULL,
                                 cod_palabra int  NOT NULL,
                                 CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
                                idioma char(2)  NOT NULL,
                                cod_palabra int  NOT NULL,
                                descripcion varchar(25)  NOT NULL,
                                CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
        REFERENCES P5P1E1_ARTICULO (id_articulo)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
        REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

--a) Cómo debería implementar las Restricciones de Integridad Referencial (RIR) si se desea que
--cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
--que la referencian en la tabla CONTIENE.
--

ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT fk_contiene_palabra FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
on DELETE CASCADE

--     b) Verifique qué sucede con las palabras contenidas en cada artículo, al eliminar una palabra,
--     si definen la Acción Referencial para las bajas (ON DELETE) de la RIR correspondiente
--     como:
--     ii) Restrict
--     iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON

--B Si es restrict, y eliminamos PALABRA, si en palabra hay restrict, y hay referenca de alguna fila en contiene,
-- no se podra eliminar.
-- No se puede colocar set null o default dado que son primary keys y no pueden ir null.
-- SET DEFAULT solo sería posible si idioma y cod_palabra tuvieran valores DEFAULT definidos y
--     esos valores existieran en PALABRA. En este esquema no corresponde.


    Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-24 19:20:52.273

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
            MATCH FULL
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
        ON UPDATE  RESTRICT
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto)
        REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
        ON DELETE  RESTRICT
        ON UPDATE  CASCADE
;

-- End of file.

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

d) Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas, según se considere
para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO
match: i)
simple, ii)
parcial, o iii) full:
a. insert into Auspicio values (1, Dell , B, null); -- acepta el siple, y el partial
b. insert into Auspicio values (2, Oracle, null, null);
c. insert into Auspicio values (3, Google, A, 3);
d. insert into Auspicio values (1, HP, null, 3);

-- el a acepta simple pq una de las columnas en null,
-- luego el full no pq deberian ser todos nulls,y el partial si podria pasar.
--b, pasa simple pq hay null, pasa full pq es todo null, en partial rtambien pasa
--c, simple no pasa pq NO existen las referencias, partial tamb porque no existen referencias, y full
-- tampoco pasa pq no existen ref
--d. simple pasa pq hay null, luego partial no pasa pq el nro empleado 3 no existe, y full tampoco pasa.

--caso falso con gpt
-- 1
INSERT INTO auspicio VALUES (1, 'Sony', 'A ', 1);
-- SIMPLE Si pasa, existe tipo empleado A y el  nro empelado 1
-- PARTIAL: Si pasa pq existen las referencias
-- FULL: Si pasa pq existen las ref y estan todas (no hay 1 null y 1 ref)
-- 2
INSERT INTO auspicio VALUES (1, 'Nike', 'A ', 9);
-- SIMPLE: no pasa, no existen las ref y no hay algun null pa q safe
-- PARTIAL: no pasa, no existe las ref
-- FULL: no pasa, no existen las ref

-- 3
INSERT INTO auspicio VALUES (1, 'Apple', 'A ', NULL);
-- SIMPLE: pasa, pq hay 1 null
-- PARTIAL: pasa, pq hay 1 referencia bien
-- FULL NO PASA PORQUE solo acepta:
-- - todas las columnas con valor y que exista la referencia completa
-- - o todas las columnas NULL

No acepta mezcla: una columna con valor y otra NULL.
-- 4
INSERT INTO auspicio VALUES (1, 'Intel', NULL, 1);
-- SIMPLE : pasa
-- PARTIAL: pasa pq existe la referencia
-- FULL: no pasa, o son todos nulls o todas referencias

-- 5
INSERT INTO auspicio VALUES (1, 'Meta', NULL, NULL);
-- SIMPLE pasa
-- PARTIAL: pasa
-- FULL: pasa

-- 6
INSERT INTO auspicio VALUES (1, 'IBM', 'C ', NULL);
-- SIMPLE: pasa
-- PARTIAL: no pasa, ref inexistente
-- FULL: no pasa, ref inexistente

-- 7
INSERT INTO auspicio VALUES (1, 'Tesla', NULL, 9);
-- SIMPLE: pasa
-- PARTIAL: no pasa, ref inexistente
-- FULL: no pasa, ref inexistente

-- 8
INSERT INTO auspicio VALUES (1, 'Dell', 'B ', 1);
-- SIMPLE: pasa
-- PARTIAL: pasa
-- FULL: pasa


-- Ejercicio 3.
-- Sea el siguiente DERExt cuyo link de Vertabelo es el siguiente:
-- https://my.vertabelo.com/public-model-
-- view/d67hBldigh2s4OBTzotdRGl4yHyYUge3cYBZxdxVS5f1Vx03tYysV2BFSluJgBpA?x=906
-- 7&amp;y=9425&amp;zoom=1.3305
-- a. Se podrá declarar como acción referencial de la (RIR) FK_RUTA_CIUDAD_DESDE
-- DELETE CASCADE y para la RIR FK_Ruta_ciudad_hasta DELETE RESTRICT ?
--     b. Es posible colocar DELETE SET NULL o UPDATE SET NULL como acción
--     referencial de la RIR FK_RUTA_CARRETERA