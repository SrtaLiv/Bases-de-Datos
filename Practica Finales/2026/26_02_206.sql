CREATE TABLE TEATRO(
id_teatro integer not null PRIMARY KEY   ,
nombre_teatro varchar not null ,
direccion varchar not null,
CONSTRAINT pk_teatro PRIMARY KEY (id_teatro)
);

CREATE TABLE tarifa (
                        id_teatro integer NOT NULL,
                        dia date NOT NULL,
                        precio integer,
                        CONSTRAINT pk_tarifa PRIMARY KEY (id_teatro, dia),
                        CONSTRAINT fk_tarifa_teatro FOREIGN KEY (id_teatro)
                        REFERENCES teatro(id_teatro)
);

CREATE TABLE OBRA(
    id_obra integer not null ,
    titulo varchar,
    director varchar,
    genero varchar,
    CONSTRAINT pk_obra PRIMARY KEY (id_obra)
)

-- o sea primero los agrego como primary key en conjunto, y despues como foreign key
CREATE TABLE en_cartelera (
                              id_teatro integer NOT NULL,
                              id_obra integer NOT NULL,
                              CONSTRAINT pk_en_cartelera PRIMARY KEY (id_teatro, id_obra),
                              CONSTRAINT fk_cartelera_teatro FOREIGN KEY (id_teatro)
                                  REFERENCES teatro(id_teatro),
                              CONSTRAINT fk_cartelera_obra FOREIGN KEY (id_obra)
                                  REFERENCES obra(id_obra)
);


create table actor(
    id_actor integer not null ,
    nombre_artistico varchar,
    apellido varchar,
    nombre varchar,
    nacionalidad varchar,
    constraint pk_id_actor PRIMARY KEY (id_actor)
);

create table participa
(
    id_obra integer NOT NULL ,
    id_actor integer NOT NULL ,
    CONSTRAINT pk_participa PRIMARY KEY (id_obra, id_actor),
    CONSTRAINT fk_id_obra FOREIGN KEY (id_obra) REFERENCES OBRA(ID_OBRA),
    CONSTRAINT fk_id_actor FOREIGN KEY (id_actor) REFERENCES actor(ID_ACTOR)
)

create table pago(
    id_pago int NOT NULL ,
    tipo_pago int  ,
    nro_pago int  ,
    monto int,
    fecha date,
    id_actor int not null ,
    id_obra int not null ,
    CONSTRAINT pk_pago PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_actor FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
    CONSTRAINT fk_pago_obra FOREIGN KEY (id_obra) REFERENCES obra(id_obra)
)

ALTER TABLE OBRA
ADD CONSTRAINT FK_OBRA_PARTICIPA FOREIGN KEY (id_obra) REFERENCES OBRA(id_obra) ON DELETE restrict

ALTER TABLE participa
    ADD CONSTRAINT fk_participa_obra
        FOREIGN KEY (id_obra)
            REFERENCES obra(id_obra)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT;

ALTER TABLE participa
    ADD CONSTRAINT fk_participa_actor
        FOREIGN KEY (id_actor)
            REFERENCES actor(id_actor)
            ON DELETE CASCADE
            ON UPDATE RESTRICT;

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_participa
        FOREIGN KEY (id_obra, id_actor)
            REFERENCES participa(id_obra, id_actor)
            ON DELETE CASCADE
            ON UPDATE RESTRICT;

---------------------------------------------------------------------------------------------------------------------

CREATE TABLE persona (
                         tipo_doc char(4) NOT NULL,
                         nro_doc int NOT NULL,
                         apellido varchar(60) NOT NULL,
                         nombre varchar(60) NOT NULL,
                         direccion varchar(120),
                         e_mail varchar(60),
                         tipo char(1) NOT NULL,
                         CONSTRAINT pk_persona PRIMARY KEY (tipo_doc, nro_doc)
);

CREATE TABLE obra (
                      id_obra int NOT NULL,
                      superficie decimal(6,2),
                      direccion varchar(60),
                      fecha_inicio date,
                      fecha_fin date,
                      municipio varchar(50),
                      CONSTRAINT pk_obra PRIMARY KEY (id_obra)
);

CREATE TABLE constructor (
                             tipo_doc char(4) NOT NULL,
                             nro_doc int NOT NULL,
                             matricula int NOT NULL,
                             CONSTRAINT pk_constructor PRIMARY KEY (tipo_doc, nro_doc),
                             CONSTRAINT fk_constructor_persona
                                 FOREIGN KEY (tipo_doc, nro_doc)
                                     REFERENCES persona(tipo_doc, nro_doc)
);

CREATE TABLE operario (
                          tipo_doc char(4) NOT NULL,
                          nro_doc int NOT NULL,
                          categoria varchar(20),
                          CONSTRAINT pk_operario PRIMARY KEY (tipo_doc, nro_doc),
                          CONSTRAINT fk_operario_persona
                              FOREIGN KEY (tipo_doc, nro_doc)
                                  REFERENCES persona(tipo_doc, nro_doc)
);

CREATE TABLE ejecuta (
                         tipo_doc char(4) NOT NULL,
                         nro_doc int NOT NULL,
                         id_obra int NOT NULL,
                         rol varchar(30),
                         CONSTRAINT pk_ejecuta PRIMARY KEY (tipo_doc, nro_doc, id_obra),
                         CONSTRAINT fk_ejecuta_constructor
                             FOREIGN KEY (tipo_doc, nro_doc)
                                 REFERENCES constructor(tipo_doc, nro_doc),
                         CONSTRAINT fk_ejecuta_obra
                             FOREIGN KEY (id_obra)
                                 REFERENCES obra(id_obra)
);

CREATE TABLE participa (
                           tipo_doc char(4) NOT NULL,
                           nro_doc int NOT NULL,
                           id_obra int NOT NULL,
                           fecha_desde date,
                           fecha_hasta date,
                           CONSTRAINT pk_participa PRIMARY KEY (tipo_doc, nro_doc, id_obra),
                           CONSTRAINT fk_participa_operario
                               FOREIGN KEY (tipo_doc, nro_doc)
                                   REFERENCES operario(tipo_doc, nro_doc),
                           CONSTRAINT fk_participa_obra
                               FOREIGN KEY (id_obra)
                                   REFERENCES obra(id_obra)
);

ALTER TABLE ejecuta
ADD COLUMN rol varchar(30) NOT NULL ;

-- UN MISMO OPERARIO NO PUEDE PARTICIPAR EN MAS DE 5 OBRAS POR AÑO (CONSIDERE SU FECHA_DESDE)
-- tipo_doc, nro_doc, fecha_desde

ALTER TABLE participa ADD CONSTRAINT ck_participaorba CHECK NOT EXISTS (
    SELECT 1
    FROM participa
    GROUP BY extract(YEAR FROM fecha_desde), tipo_doc, nro_doc
    HAVING count(*) >= 5
)

-- 1, 13123, 0, 2019
-- 1, 13123, 1, 2020
-- 1, 13123, 2, 2020
-- 1, 13123, 3, 2020
-- 1, 13123, 4, 2020
-- 1, 13123, 5, 2020
-- 1, 13123, 6, 2020  ERROR, NO DEJAR

-- 1, 13123, 2020

-- toda obra debe ser ejecutada por al meno sun constructor con rol "resposabbel" y no puede tener mas de 2
-- constructores con el rol 'asociado'