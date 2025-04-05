-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-04-12 18:44:35.173

-- tables
-- Table: TP03_EJ04_DISCIPLINA
CREATE TABLE TP03_EJ04_DISCIPLINA (
    id_disciplina int  NOT NULL,
    nombre_disciplina varchar(20)  NOT NULL,
    descripcion_disciplina varchar(120)  NOT NULL
);

-- Table: TP03_EJ04_INVESTIGADOR
CREATE TABLE TP03_EJ04_INVESTIGADOR (
    id_investigador int  NOT NULL,
    tipo_doc char(3)  NOT NULL,
    nro_doc int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    direccion varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    telefono varchar(15)  NOT NULL
);

-- Table: TP03_EJ04_PROYECTO
CREATE TABLE TP03_EJ04_PROYECTO (
    cod_proyecto int  NOT NULL,
    nombre_proyecto varchar(40)  NOT NULL,
    monto decimal(10,2)  NOT NULL,
    estadio char(3)  NOT NULL,
    tipo_proy char(1)  NOT NULL,
    CONSTRAINT TP03_EJ04_PROYECTO_pk PRIMARY KEY (cod_proyecto)
);

-- Table: TP03_EJ04_PROY_INIC_FINAL
CREATE TABLE TP03_EJ04_PROY_INIC_FINAL (
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: TP03_EJ04_TAREA
CREATE TABLE TP03_EJ04_TAREA (
    id_tarea int  NOT NULL,
    nombre_tarea varchar(15)  NOT NULL,
    cant_horas decimal(6,2)  NOT NULL,
    CONSTRAINT TP03_EJ04_TAREA_pk PRIMARY KEY (id_tarea)
);

-- End of file.

