set search_path to final_17_02_2022;
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

INSERT INTO contenido(idcontenido, titulo, tipo) VALUES (1, 'Cars', 'P');

INSERT INTO contenido(idcontenido, titulo, tipo) VALUES (2, 'HarryPotter', 'S');
INSERT INTO pelicula(idcontenido, descripcion, fecha_estreno) VALUES(1,'gran pelicula','2025-10-20'::DATE);
INSERT INTO serie(idcontenido, resumen) VALUES(2, 'boludo con magia');
INSERT INTO temporada(nro_temporada, idcontenido) VALUES (1, 2);
insert into capitulo(nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,2,1, 'primer capitulo','2025-10-20'::DATE);
Insert into capitulo(nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,2,2, 'segundo capitulo','2026-10-20'::DATE);


INSERT INTO actor (id_actor, pais_origen, nombre_real, nombre_fantasia, fecha_nacim, ciudad_residencia, pais_residencia)
                    VALUES (1,'Inglaterra', 'Jack Grealish', 'Jaco', '1990-10-25'::date,'Londres','Inglaterra'),
                           (2,'Argentina', 'Sergio Aguero', 'Kuni', '1987-06-20'::date,'Miami','Estados Unidos'),
                           (3,'Argentina', 'Marcelo Tossini', 'Bondage', '1960-03-17'::date,'Tandil','Argentina'),
                           (4,'Argentina', 'Lucas Leiva', 'Leivo', '1972-01-29'::date,'Tandil','Argentina'),
                           (5,'Australia', 'Oscar Piastri', 'Pechon', '2003-07-16'::date,'Madrid','España');

INSERT INTO personaje (id_personaje, nombre_apellido, descripcion) VALUES (1,'Mike Wheeler', 'Un narigon que juega D&D'),
                                                                          (2,'Will Byers','Un boludo que lo rapta el demogorgon'),
                                                                          (3,'Nancy Wheeler','Hermana del boludo raptado');

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (2,2,'Argentina', 8000, 2),
           (1,2,'Argentina', 12000, 1);

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (3,3,'Argentina', 12000, 2),
           (2,3,'Argentina', 9000, 1);
INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (2,4,'Argentina', 9000, 2),
           (1,4,'Argentina', 15000, 1);

insert into actor (id_actor, pais_origen, nombre_real, nombre_fantasia, fecha_nacim, ciudad_residencia, pais_residencia)
            VALUES (6,'Peru','Jenifer Aliston', 'La Jeny', '2015-08-12'::date, NULL,NULL);
insert into contenido (idcontenido, titulo, tipo)
    VALUES (3,'Stranger Things','S');
insert into serie (idcontenido, resumen)
    VALUES (3,'Unos guachines que juegan D&D');
insert into temporada (nro_temporada, idcontenido)
    VALUES (1,3);
insert into capitulo (nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,3,1,'Al guachin que lo rapta el bicho', '2025-06-19'::date);

INSERT INTO capitulo VALUES (1,2,3,'tercer capitulo','2026-10-21'::date),
                           (1,2,4,'cuarto capitulo','2026-10-24'::date),
                           (1,2,5,'quinto capitulo','2026-10-26'::date),
                           (1,2,6,'sexto capitulo','2026-11-03'::date),
                           (1,2,7,'septimo capitulo','2026-11-12'::date);

INSERT INTO actor VALUES (8,'Francia','Killian Mbappe','Traviño','2002-10-13'::date,'Madrid');
INSERT INTO temporada VALUES (2,2);
INSERT INTO capitulo VALUES(2,2,1,'primer capitulo','2026-10-21'::date),
                           (2,2,2,'segundo capitulo','2026-10-21'::date),
                           (2,2,3,'tercer capitulo','2026-10-21'::date),
                           (2,2,4,'cuarto capitulo','2026-10-24'::date),
                           (2,2,5,'quinto capitulo','2026-10-26'::date),
                           (2,2,6,'sexto capitulo','2026-11-03'::date),
                           (2,2,7,'septimo capitulo','2026-11-12'::date);


INSERT INTO CONTENIDO (idcontenido, titulo, tipo) VALUES (5,'El señor de los anillos', 'P');
INSERT INTO pelicula (idcontenido, descripcion, fecha_estreno) VALUES (5,'El chaval que le entrega el anillo a Sauron', '2025-12-22'::date);
INSERT INTO personaje (id_personaje, nombre_apellido, descripcion)
    VALUES (5,'Gandalf el blanco','El mago lechero'),
           (6,'Aragorn Rey de Gondor','El rey de los numenoir');
INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (5,2,'Argentina',60000,5),
           (6,4,'Argentina',25000,5);
--b) VistaB, con los datos de las películas estrenadas durante el mes pasado, en las cuales el monto promedio facturado por actuaciones de actores de origen español supere 30.000.

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (5,5,'Australia',1,5);

INSERT INTO CONTENIDO (idcontenido, titulo, tipo) VALUES (10,'messi la peli', 'P');
INSERT INTO pelicula (idcontenido, descripcion, fecha_estreno) VALUES (10,'la mejor peli del mundo', '2027-12-22'::date);
INSERT INTO temporada VALUES (3,2);
INSERT INTO capitulo VALUES(3,2,1,'primer capitulo','2027-10-21'::date);

--a) No puede haber temporadas de series con más de 12 capítulos.

ALTER TABLE temporada ADD CONSTRAINT chk2a
CHECK NOT EXISTS(SELECT 1 FROM capitulo c GROUP BY c.nro_temporada HAVING COUNT(*) > 12)

--b) Los actores no pueden facturar más de 500000 en actuaciones de películas si han participado en series.
que exista un actor que facture mas de 500000 en actuaciones de peliculas y existe una actuacion suya en una serie

SELECT a.*
FROM actua a
JOIN pelicula p USING(idcontenido)
WHERE a.monto_facturado > 500000 AND EXISTS (SELECT 1 from actua a2 JOIN serie s USING(idContenido) WHERE a.id_actor = a2.id_actor AND a.pais_origen = a2.pais_origen);





--c) La fecha de estreno de una película no puede ser postergada por más de 12 meses.

CREATE OR REPLACE FUNCTION fn()
RETURNS TRIGGER AS $$
BEGIN
        RAISE EXCEPTION 'no se puede realizar debido a que la fecha de estreno de una película no puede ser postergada por más de 12 meses';
end;
$$ language 'plpgsql';

CREATE or replace TRIGGER  tr_fn
BEFORE UPDATE ON pelicula
FOR EACH ROW  WHEN ( AGE(new.fecha_estreno, OLD.fecha_estreno) > INTERVAL '12 MONTHS') execute FUNCTION fn();

begin;
update pelicula set fecha_estreno = '2026-11-20'::date WHERE idContenido = 1;

update pelicula set fecha_estreno = '2026-10-19'::date WHERE idContenido = 1;
rollback ;

SELECT AGE('2026-10-19'::date, '2025-10-20'::date);



--b) Los actores no pueden facturar más de 500000 en actuaciones de películas si han participado en series.
que exista un actor que facture mas de 500000 en actuaciones de peliculas y existe una actuacion suya en una serie

SELECT a.*
FROM actua a
JOIN pelicula p USING(idcontenido)
WHERE a.monto_facturado > 500000 AND EXISTS (SELECT 1 from actua a2 JOIN serie s USING(idContenido) WHERE a.id_actor = a2.id_actor AND a.pais_origen = a2.pais_origen);




CREATE OR REPLACE FUNCTION fn_2b()
RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS(
    SELECT 1
    FROM actua a
    JOIN pelicula p USING(idcontenido)
    WHERE a.idcontenido = NEW.id_contenido AND a.id_actor = NEW.id_actor AND a.id_personaje = NEW.id_personaje AND NEW.monto_facturado > 500000 AND
          EXISTS (SELECT 1 from actua a2 JOIN serie s USING(idContenido) WHERE NEW.id_actor = a2.id_actor AND NEW.pais_origen = a2.pais_origen)
        ) THEN
        RAISE EXCEPTION 'No se puede realizar el insert';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';





/*

CREATE OR REPLACE FUNCTION fn_2b()
RETURNS TRIGGER AS
$$
BEGIN
    IF new.monto_facturado > 500000 AND EXISTS(
    SELECT 1
    FROM actua a
    JOIN pelicula p USING(idcontenido)
    WHERE a.idcontenido = NEW.id_contenido AND a.id_actor = NEW.id_actor AND a.id_personaje = NEW.id_personaje  AND
          EXISTS (SELECT 1 from actua a2 JOIN serie s USING(idContenido) WHERE a.id_actor = a2.id_actor AND a.pais_origen = a2.pais_origen)
        ) THEN
    raise exception 'no se puede realizar el update de monto facturado'
    end if;

    RETURN NEW;
end;
$$ language 'plpgsql';
*/


CREATE OR REPLACE FUNCTION fn_2b()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.monto_facturado > 500000
       AND EXISTS (
            SELECT 1
            FROM pelicula p
            WHERE p.idContenido = NEW.id_contenido
       )
       AND EXISTS (
            SELECT 1
            FROM actua a2
            JOIN serie s USING(idContenido)
            WHERE a2.id_actor = NEW.id_actor
              AND a2.pais_origen = NEW.pais_origen
       )
    THEN
        RAISE EXCEPTION
        'no se pudo realizar';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_2b
BEFORE update of monto_facturado, id_actor, pais_origen ON actua
FOR EACH ROW EXECUTE FUNCTION fn_2b();

CREATE TRIGGER tr_2b_insert
BEFORE INSERT ON actua
FOR EACH ROW EXECUTE FUNCTION fn_2b();






CREATE OR REPLACE FUNCTION fn_2b()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM actua a
        JOIN pelicula p USING(idContenido)
        WHERE a.id_actor = NEW.id_actor
          AND a.pais_origen = NEW.pais_origen
          AND a.monto_facturado > 500000
    )
    AND EXISTS (
        SELECT 1
        FROM actua a2
        JOIN serie s USING(idContenido)
        WHERE a2.id_actor = NEW.id_actor
          AND a2.pais_origen = NEW.pais_origen
    )
    THEN
        RAISE EXCEPTION
        'error';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Vista1, con los datos completos de los actores que actúan en películas estrenadas el año actual.
SELECT ac. *
FROM ACTOR ac
WHERE EXISTS(SELECT 1 FROM ACTUA a JOIN pelicula p USING (idContenido) WHERE ac.id_actor = a.id_actor AND ac.pais_origen = a.pais_origen AND EXTRACT (YEAR FROM fecha_estreno) = EXTRACT(YEAR FROM CURRENT_DATE));

insert into actua (id_personaje, id_actor, pais_origen, monto_facturado, idContenido)
    VALUES (1,8,'Francia',400000,10);

update pelicula set fecha_estreno = '2026-12-22'::date WHERE idContenido = 10;
-- Vista2, con los datos completos de las series de más de 3 temporadas en las que participan actores de origen español.
SELECT s.*
FROM serie s
WHERE EXISTS(SELECT ac.idContenido
            FROM actua ac
            JOIN temporada t USING (idContenido)
                WHERE ac.pais_origen ilike 'españa' AND t.idContenido = s.idContenido
            GROUP BY ac.idContenido
                HAVING COUNT(*) >= 3);

SELECT c.*,s.resumen
    FROM contenido c
    JOIN serie s USING(idContenido)
    WHERE EXISTS(
        SELECT 1
        FROM temporada t
        WHERE t.idContenido = c.idContenido
        HAVING COUNT(Nro_temporada) >= 3
    ) AND EXISTS(
        SELECT 1
        FROM actua a
        WHERE a.idContenido = c.idContenido AND a.pais_origen ilike 'españa'
    );

select * from actor;

INSERT INTO actor VALUES(7, 'España', 'Antonio Banderas', 'Botitas', '1987-12-20'::date, 'Barcelona', 'España');
INSERT INTO actor VALUES(9, 'España', 'David Villa ', 'David Villero', '1996-12-20'::date, 'Barcelona', 'España');

INSERT INTO actua VALUES(2,7,'España', 2000.10, 2);
idcontenido 2


SELECT * FROM TEMPORADA T

select * from contenido join serie USING(idContenido) JOIN temporada USING (idContenido);

--b) Explique la diferencia de utilizar WITH CHECK OPTION y no usarla, a partir de una sentencia SQL de actualización
-- concreta sobre alguna de estas vistas.

-- c) Explique cómo se puede forzar una actualización sobre una vista que resulta no actualizable. Ejemplifique a
-- partir de alguna de las vistas anteriores, incluyendo una implementación completa adecuada para inserciones.