
-- tables

-- Table: EQUIPO
CREATE TABLE TP03_EJ5_EQUIPO (
    id_equipo int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    tipo varchar(20)  NOT NULL,
    ANOMALIA_id_evento int  NOT NULL,
    CONSTRAINT EQUIPO_pk PRIMARY KEY (id_equipo)
);

-- Table: Instalado
CREATE TABLE TP03_EJ5_INSTALADO (
    id_equipo int NOT NULL ,
    id_satelite int NOT NULL,
    estado varchar(40) NOT NULL ,
    fecha_instalacion varchar(20) NOT NULL,
    CONSTRAINT INSTALADO_pk PRIMARY KEY (id_satelite, id_equipo)
);

-- Agrego FK de id_equipo
ALTER TABLE TP03_EJ5_INSTALADO ADD CONSTRAINT FK_EQUIPO_INSTALA_SATELITE
FOREIGN KEY (id_equipo)
REFERENCES TP03_EJ5_EQUIPO(id_equipo);

-- Agrego FK de id_satelite
ALTER TABLE TP03_EJ5_INSTALADO ADD CONSTRAINT FK_SATELITE_INSTALA_EQUIPO
FOREIGN KEY (id_satelite)
REFERENCES TP03_EJ5_SATELITE(id_satelite);

-- Table: SATELITE
CREATE TABLE TP03_EJ5_SATELITE (
    id_satelite int  NOT NULL,
    agencia_operadora varchar(40)  NOT NULL,
    estado varchar(20)  NOT NULL,
    nombre varchar(30) NOT NULL,
    tipo varchar(20) NOT NULL,
    fecha_lanzamiento date NOT NULL,
    CONSTRAINT SATELITE_pk PRIMARY KEY (id_satelite)
);

-- Table: MISION
CREATE TABLE TP03_EJ5_MISION (
    id_mision int NOT NULL,
    nombre_mision varchar(60)  NOT NULL,
    objetivos varchar(120)  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,

    -- hereda todos los id de la agregacion:
    id_satelite int NOT NULL,
    CONSTRAINT MISION_pk PRIMARY KEY (id_mision, id_satelite)
);

ALTER TABLE TP03_EJ5_MISION ADD CONSTRAINT FK_MISION_SATELITE
FOREIGN KEY (id_satelite)
REFERENCES TP03_EJ5_SATELITE(id_satelite);

CREATE TABLE TP03_EJ5_ANOMALIA (
    id_evento int NOT NULL,
    fecha_evento date NOT NULL,
    tipo_evento varchar(30) NOT NULL,
    resuelto boolean NOT NULL,
    descripcion varchar(240) NOT NULL,

      -- hereda todos los id de la agregacion:
    id_satelite int NOT NULL,
    id_equipo int NOT NULL,
    CONSTRAINT ID_EVENTO_pk PRIMARY KEY (id_evento, id_satelite, id_equipo)
);

ALTER TABLE TP03_EJ5_ANOMALIA ADD CONSTRAINT FK_ANOMALIA_SATELITE
FOREIGN KEY (id_satelite)
REFERENCES TP03_EJ5_SATELITE(id_satelite);

ALTER TABLE TP03_EJ5_ANOMALIA ADD CONSTRAINT FK_ANOMALIA_EQUIPO
FOREIGN KEY (id_equipo)
REFERENCES TP03_EJ5_EQUIPO(id_equipo);



-- End of file.

-- NUEVO:
