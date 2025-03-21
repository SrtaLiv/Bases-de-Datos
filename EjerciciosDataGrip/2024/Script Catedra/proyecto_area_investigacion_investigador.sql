-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 02:04:10.532

-- tables
-- Table: AREA_INVESTIGACION
CREATE TABLE AREA_INVESTIGACION (
    cod_area int  NOT NULL,
    descripcion varchar(60)  NOT NULL,
    investigacion_aplicada boolean  NOT NULL,
    CONSTRAINT PK_AREA_INVESTIGACION PRIMARY KEY (cod_area)
);

-- Table: INVESTIGADOR
CREATE TABLE INVESTIGADOR (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    nro_investigador int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    CONSTRAINT PK_INVESTIGADOR PRIMARY KEY (nro_investigador,tipo_proyecto,cod_proyecto)
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_PROYECTO PRIMARY KEY (tipo_proyecto,cod_proyecto)
);

-- Table: TRABAJA_EN
CREATE TABLE TRABAJA_EN (
    tipo_proyecto char(3)  NOT NULL,
    cod_proyecto int  NOT NULL,
    nro_investigador int  NOT NULL,
    cod_area int  NOT NULL,
    CONSTRAINT PK_TRABAJA_EN PRIMARY KEY (nro_investigador,tipo_proyecto,cod_proyecto,cod_area)
);

-- foreign keys
-- Reference: FK_INVESTIGADOR_PROYECTO (table: INVESTIGADOR)
ALTER TABLE INVESTIGADOR ADD CONSTRAINT FK_INVESTIGADOR_PROYECTO
    FOREIGN KEY (tipo_proyecto, cod_proyecto)
    REFERENCES PROYECTO (tipo_proyecto, cod_proyecto)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TRABAJA_EN_AREA_INVESTIGACION (table: TRABAJA_EN)
ALTER TABLE TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_AREA_INVESTIGACION
    FOREIGN KEY (cod_area)
    REFERENCES AREA_INVESTIGACION (cod_area)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TRABAJA_EN_INVESTIGADOR (table: TRABAJA_EN)
ALTER TABLE TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_INVESTIGADOR
    FOREIGN KEY (nro_investigador, tipo_proyecto, cod_proyecto)
    REFERENCES INVESTIGADOR (nro_investigador, tipo_proyecto, cod_proyecto)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.


INSERT INTO AREA_INVESTIGACION (cod_area, descripcion, investigacion_aplicada)
VALUES
    (1, 'Inteligencia Artificial', true),
    (2, 'Biotecnología', true),
    (3, 'Ciencias del Espacio', false),
    (4, 'Robótica', true),
    (5, 'Nanotecnología', false);

INSERT INTO PROYECTO (tipo_proyecto, cod_proyecto, descripcion)
VALUES
    ('PRO', 101, 'Proyecto IA Avanzada'),
    ('PRO', 102, 'Desarrollo de Vacunas'),
    ('PRO', 103, 'Exploración de Marte'),
    ('PRO', 104, 'Robots Asistentes'),
    ('PRO', 105, 'Materiales Nanoestructurados');

INSERT INTO INVESTIGADOR (tipo_proyecto, cod_proyecto, nro_investigador, nombre, apellido)
VALUES
    ('PRO', 101, 1, 'Alice', 'Smith'),
    ('PRO', 101, 2, 'Bob', 'Johnson'),
    ('PRO', 102, 3, 'Carol', 'Williams'),
    ('PRO', 102, 4, 'David', 'Jones'),
    ('PRO', 103, 5, 'Eve', 'Brown'),
    ('PRO', 103, 6, 'Frank', 'Davis'),
    ('PRO', 104, 7, 'Grace', 'Miller'),
    ('PRO', 104, 8, 'Heidi', 'Wilson'),
    ('PRO', 105, 9, 'Ivan', 'Moore'),
    ('PRO', 105, 10, 'Judy', 'Taylor');

INSERT INTO TRABAJA_EN (tipo_proyecto, cod_proyecto, nro_investigador, cod_area)
VALUES
    ('PRO', 101, 1, 1),
    ('PRO', 101, 2, 1),
    ('PRO', 102, 3, 2),
    ('PRO', 102, 4, 2),
    ('PRO', 103, 5, 3),
    ('PRO', 103, 6, 3),
    ('PRO', 104, 7, 4),
    ('PRO', 104, 8, 4),
    ('PRO', 105, 9, 5),
    ('PRO', 105, 10, 5);
