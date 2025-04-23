-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-03-27 21:48:08.863

-- tables
-- Table: Asiste
CREATE TABLE Asiste (
    id_paciente int  NOT NULL,
    cod_centro int  NOT NULL,
    nro_matricula int  NOT NULL,
    cod_especialidad int  NOT NULL,
    tipo_especialidad varchar(30)  NOT NULL,
    CONSTRAINT pk_asiste PRIMARY KEY (id_paciente,cod_centro,nro_matricula,cod_especialidad,tipo_especialidad)
);

-- Table: Atiende
CREATE TABLE Atiende (
    cod_centro int  NOT NULL,
    nro_matricula int  NOT NULL,
    tipo_especialidad varchar(30)  NOT NULL,
    cod_especialidad int  NOT NULL,
    CONSTRAINT pk_atiened PRIMARY KEY (cod_centro,nro_matricula,cod_especialidad,tipo_especialidad)
);

-- Table: Centro_Salud
CREATE TABLE Centro_Salud (
    cod_centro int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    calle int  NOT NULL,
    numero int  NOT NULL,
    sala_atencion varchar(30)  NOT NULL,
    CONSTRAINT pk_centro PRIMARY KEY (cod_centro)
);

-- Table: Especialidad
CREATE TABLE Especialidad (
    tipo_especialidad varchar(30)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: Medico
CREATE TABLE Medico (
    nro_matricula int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    apellido varchar(60)  NOT NULL,
    fecha_nac date  NOT NULL,
    email varchar(60)  NOT NULL,
    tipo_especialidad varchar(30)  NOT NULL,
    cod_especialidad int  NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad)
);

-- Table: Paciente
CREATE TABLE Paciente (
    id_paciente serial  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apelido varchar(60)  NOT NULL,
    celular int  NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente)
);

-- foreign keys
-- Reference: fk_asiste_atiende (table: Asiste)
ALTER TABLE Asiste ADD CONSTRAINT fk_asiste_atiende
    FOREIGN KEY (cod_centro, nro_matricula, cod_especialidad, tipo_especialidad)
    REFERENCES Atiende (cod_centro, nro_matricula, cod_especialidad, tipo_especialidad)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_asiste_paciente (table: Asiste)
ALTER TABLE Asiste ADD CONSTRAINT fk_asiste_paciente
    FOREIGN KEY (id_paciente)
    REFERENCES Paciente (id_paciente)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_atiende_centro_salud (table: Atiende)
ALTER TABLE Atiende ADD CONSTRAINT fk_atiende_centro_salud
    FOREIGN KEY (cod_centro)
    REFERENCES Centro_Salud (cod_centro)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_atiende_medico (table: Atiende)
ALTER TABLE Atiende ADD CONSTRAINT fk_atiende_medico
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
    REFERENCES Medico (nro_matricula, tipo_especialidad, cod_especialidad)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_medico_especialidad (table: Medico)
ALTER TABLE Medico ADD CONSTRAINT fk_medico_especialidad
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES Especialidad (tipo_especialidad, cod_especialidad)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

CREATE TABLE Paciente (
    id_paciente serial  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apelido varchar(60)  NOT NULL,
    celular int  NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente)
);

INSERT INTO Paciente (nombre, apelido, celular) VALUES ('olivia', 'todesco', '32342');

SELECT * FROM Paciente;

