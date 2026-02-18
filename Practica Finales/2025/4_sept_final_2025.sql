-- Dado el siguiente esquema que será utilizado en éste exámen: (

-- Last modification date: 2025-09-01 18:03:02.421

-- tables
-- Table: CONTACTO_ESTACION
CREATE TABLE CONTACTO_ESTACION (
                                   id_contacto serial  NOT NULL,
                                   id_satelite int  NOT NULL,
                                   id_estacion int  NOT NULL,
                                   fecha_contacto timestamp  NOT NULL,
                                   duracion_minutos int  NULL,
                                   tipo_contacto varchar(50)  NULL,
                                   CONSTRAINT CONTACTO_ESTACION_pk PRIMARY KEY (id_contacto)
);

-- Table: ESTACION_TERRENA
CREATE TABLE ESTACION_TERRENA (
                                  id_estacion serial  NOT NULL,
                                  nombre varchar(100)  NOT NULL,
                                  pais varchar(100)  NOT NULL,
                                  ubicacion_lat decimal(9,6)  NOT NULL,
                                  ubicacion_lon decimal(9,6)  NOT NULL,
                                  responsable varchar(100)  NULL,
                                  CONSTRAINT ESTACION_TERRENA_pk PRIMARY KEY (id_estacion)
);

-- Table: IMAGENES_CAPTURADAS
CREATE TABLE IMAGENES_CAPTURADAS (
                                     id_imagen serial  NOT NULL,
                                     id_sensor int  NOT NULL,
                                     fecha_captura timestamp  NOT NULL,
                                     ubicacion_centro_lat decimal(9,6)  NOT NULL,
                                     ubicacion_centro_lon decimal(9,6)  NOT NULL,
                                     resolucion decimal(6,2)  NOT NULL,
                                     formato varchar(20)  NOT NULL,
                                     ruta_archivo varchar(255)  NULL,
                                     CONSTRAINT IMAGENES_CAPTURADAS_pk PRIMARY KEY (id_imagen)
);

-- Table: MISION
CREATE TABLE MISION (
                        id_mision serial  NOT NULL,
                        nombre_mision varchar(100)  NOT NULL,
                        objetivo text  NULL,
                        fecha_inicio date  NOT NULL,
                        fecha_fin date  NULL,
                        CONSTRAINT MISION_pk PRIMARY KEY (id_mision)
);

-- Table: ORBITA
CREATE TABLE ORBITA (
                        id_orbita serial  NOT NULL,
                        tipo_orbita varchar(50)  NOT NULL,
                        altitud_km decimal(8,2)  NULL,
                        inclinacion_grados decimal(5,2)  NULL,
                        periodo_minutos decimal(6,2)  NULL,
                        CONSTRAINT ORBITA_pk PRIMARY KEY (id_orbita)
);

-- Table: SATELITE
CREATE TABLE SATELITE (
                          id_satelite serial  NOT NULL,
                          nombre varchar(100)  NOT NULL,
                          pais_origen varchar(100)  NOT NULL,
                          agencia varchar(100)  NOT NULL,
                          fecha_lanzamiento date  NOT NULL,
                          vida_util_estimada int  NOT NULL,
                          estado varchar(5)  NOT NULL,
                          id_tipo int  NOT NULL,
                          id_orbita int  NOT NULL,
                          CONSTRAINT SATELITE_pk PRIMARY KEY (id_satelite)
);

-- Table: SATELITE_MISION
CREATE TABLE SATELITE_MISION (
                                 id_satelite int  NOT NULL,
                                 id_mision int  NOT NULL,
                                 CONSTRAINT SATELITE_MISION_pk PRIMARY KEY (id_satelite,id_mision)
);

-- Table: SENSOR
CREATE TABLE SENSOR (
                        id_sensor serial  NOT NULL,
                        id_satelite int  NOT NULL,
                        nombre_sensor varchar(100)  NOT NULL,
                        tipo_sensor varchar(50)  NOT NULL,
                        resolucion decimal(6,2)  NOT NULL,
                        ancho_banda decimal(6,2)  NULL,
                        CONSTRAINT SENSOR_pk PRIMARY KEY (id_sensor)
);

-- Table: TIPO_SATELITE
CREATE TABLE TIPO_SATELITE (
                               id_tipo serial  NOT NULL,
                               descripcion varchar(100)  NOT NULL,
                               CONSTRAINT TIPO_SATELITE_pk PRIMARY KEY (id_tipo)
);

-- foreign keys
-- Reference: FK_0 (table: SENSOR)
ALTER TABLE SENSOR ADD CONSTRAINT FK_0
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_1
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_2
    FOREIGN KEY (id_estacion)
        REFERENCES ESTACION_TERRENA (id_estacion)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_3
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_4
    FOREIGN KEY (id_mision)
        REFERENCES MISION (id_mision)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: IMAGENES_CAPTURADAS)
ALTER TABLE IMAGENES_CAPTURADAS ADD CONSTRAINT FK_5
    FOREIGN KEY (id_sensor)
        REFERENCES SENSOR (id_sensor)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_orbita (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_orbita
    FOREIGN KEY (id_orbita)
        REFERENCES ORBITA (id_orbita)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_tipo (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_tipo
    FOREIGN KEY (id_tipo)
        REFERENCES TIPO_SATELITE (id_tipo)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

--a) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
-- declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
-- tablas/atributos necesarios.

-- - Verificar que cada satélite tenga al menos una misión

-- Seleccione la/las opción/es que considera correcta/s, d
-- e acuerdo a lo solicitado y justifique claramente porqué
-- la/s considera correcta/s

-- TABLAS: SATELITE Y MISION, pq si solo agarro satelite mision tengo tofdos los datelites con mision
CREATE ASSERTION CHECK(
       CHECK NOT EXIST(
       SELECT 1
        FROM SATELITE
        LEFT JOIN SATELITE_MISION USING (id_satelite)
        group by id_satelite
        having count(id_mision) < 1
       )
)

--b) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
--declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando solo las
--tablas/atributos necesarios.
--Las fechas de contacto de cada estación deben ser posteriores a la fecha de lanzamiento de cada satélite.
       -- Resuelva según lo solicitado y justifique el tipo de chequeo utilizado.

CREATE ASSERTION CHECK(
       CHECK NOT EXIST(
            SELECT 1
            FROM CONTACTO_ESTACION
            JOIN SATELITE
            USING (id_satelite)
            WHERE CONTACTO_ESTACION.fecha_contacto < SATELITE.fecha_lanzamiento
       )
)

