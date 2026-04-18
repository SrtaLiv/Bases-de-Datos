
-- tables
-- Table: ACTOR
CREATE TABLE ACTOR (
    id_actor int  NOT NULL,
    pais_origen varchar(30)  NOT NULL,
    nombre_real varchar(50)  NOT NULL,
    nombre_fantasia varchar(50)  NOT NULL,
    fecha_nacim date  NOT NULL,
    ciudad_residencia varchar(50)  NULL,
    pais_residencia varchar(30)  NULL,
    CONSTRAINT ACTOR_pk PRIMARY KEY (id_actor,pais_origen)
);

-- Table: ACTUA
CREATE TABLE ACTUA (
    id_personaje int  NOT NULL,
    id_actor int  NOT NULL,
    pais_origen varchar(30)  NOT NULL,
    monto_facturado decimal(10,2)  NOT NULL,
    idContenido int  NOT NULL,
    CONSTRAINT ACTUA_pk PRIMARY KEY (id_personaje,id_actor,pais_origen)
);

-- Table: CAPITULO
CREATE TABLE CAPITULO (
    Nro_temporada int  NOT NULL,
    idContenido int  NOT NULL,
    NroCapitulo int  NOT NULL,
    titulo varchar(80)  NOT NULL,
    fecha_aparicion date  NOT NULL,
    CONSTRAINT CAPITULO_pk PRIMARY KEY (Nro_temporada,idContenido,NroCapitulo)
);

-- Table: CONTENIDO
CREATE TABLE CONTENIDO (
    idContenido int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    tipo char(1)  NOT NULL,
    CONSTRAINT CONTENIDO_pk PRIMARY KEY (idContenido)
);

-- Table: PELICULA
CREATE TABLE PELICULA (
    idContenido int  NOT NULL,
    descripcion varchar(250)  NOT NULL,
    fecha_estreno date  NOT NULL,
    CONSTRAINT PELICULA_pk PRIMARY KEY (idContenido)
);

-- Table: PERSONAJE
CREATE TABLE PERSONAJE (
    id_personaje int  NOT NULL,
    nombre_apellido varchar(50)  NOT NULL,
    descripcion varchar(200)  NOT NULL,
    CONSTRAINT PERSONAJE_pk PRIMARY KEY (id_personaje)
);

-- Table: SERIE
CREATE TABLE SERIE (
    idContenido int  NOT NULL,
    resumen varchar(200)  NOT NULL,
    CONSTRAINT SERIE_pk PRIMARY KEY (idContenido)
);

-- Table: TEMPORADA
CREATE TABLE TEMPORADA (
    Nro_temporada int  NOT NULL,
    idContenido int  NOT NULL,
    CONSTRAINT TEMPORADA_pk PRIMARY KEY (Nro_temporada,idContenido)
);

-- foreign keys
-- Reference: FK_ACTUA_ACTOR (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_ACTOR
    FOREIGN KEY (id_actor, pais_origen)
    REFERENCES ACTOR (id_actor, pais_origen)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ACTUA_CONTENIDO (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ACTUA_PERSONAJE (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_PERSONAJE
    FOREIGN KEY (id_personaje)
    REFERENCES PERSONAJE (id_personaje)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_CAPITULO_TEMPORADA (table: CAPITULO)
ALTER TABLE CAPITULO ADD CONSTRAINT FK_CAPITULO_TEMPORADA
    FOREIGN KEY (Nro_temporada, idContenido)
    REFERENCES TEMPORADA (Nro_temporada, idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PELICULA_CONTENIDO (table: PELICULA)
ALTER TABLE PELICULA ADD CONSTRAINT FK_PELICULA_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_SERIE_CONTENIDO (table: SERIE)
ALTER TABLE SERIE ADD CONSTRAINT FK_SERIE_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TEMPORADA_SERIE (table: TEMPORADA)
ALTER TABLE TEMPORADA ADD CONSTRAINT FK_TEMPORADA_SERIE
    FOREIGN KEY (idContenido)
    REFERENCES SERIE (idContenido)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 1
-- Según las acciones referenciales especificadas en el script de creación, analice los posibles efectos de cada una
-- de las siguientes operaciones sobre la BD, justificando a partir de los aspectos conceptuales involucrados (Nota:
-- considere que en cada caso existen tupla/s afectada/s según los valores dados y que los resultados no son
-- acumulativos):

--A)
UPDATE contenido SET idContenido = 234 WHERE idContenido = 123;
-- se puede actualizar correctamente siempre y cuando no haya PELICULAS con ese ID, ya que
-- por default tiene restrict. Pero si en contrenido, no hay ninguna FK en pelicula
--podria proceder correctamente, Mismo escenario con Actua. Si tuviera CASCADE para
--pelicula y actua, procederia.
-- Se propaga correctamnte en pelicula, serie, temporada por cascade pero en ACTUA
-- impediria hacerlo, asi que se rechaza toa la transaccion

-- b)
delete from serie where idContenido = 345;

-- si hay referencias en TEMPORADA de SERIE, no se podra eliminar proque por defcto tiene
-- delete RESTRICT. solo se podra hacer la operacixon si no hay referencia

delete from actor where pais_origen= 'Brasil';
-- rechazada, porque entre entre actor y actua hay cascade, ahi si pasaria
-- pero si vamos a actua y personaje tambien pasaria por el cascade,
--el problema esta entre actua y CONTENIDO ahi el delete es restrict.
-- por lo tanto si se elimina un actor que actua y tiene contenido SE RECHAZARIA
-- PERO SI NO HAY REFERENCIAS SI SE PODRIA ELIMINAR

--Ejercicio 2
-- Considere las siguientes restricciones de integridad (En cada caso indique y justifique el recurso declarativo más
-- restrictivo necesario para definirla e incluya su implementación completa según el estándar SQL. Si en algún
-- caso no es posible, explique por qué y cómo se podría implementar)

-- a) No puede haber temporadas de series con más de 12 capítulos.
--EN MIS PALABRAS: una temporada de una serie no puede tener mas de 12 capitulos, deben ser menos.
--Nro_temporada, NroCapitulo < 12 caps
--NO SE SI NECESITO LAS 3 TABLAS O CON USAR CAPITULO Y SERIE ESTOY!
CREATE ASSERTION ej_2_a CHECK (
       NOT EXISTS(
            SELECT 1 FROM CAPITULO
            GROUP BY Nro_temporada, idcontenido
            HAVING count(*) > 12
       )
)
