-- RIR - RESTRICCIONES DE INTEGRIDAD REFERENCIAL ----
-- KAHOOT                                        ----
--
-- BORRADO DE TABLAS
DROP TABLE IF EXISTS CONTIENE;
DROP TABLE IF EXISTS ARTICULO;
DROP TABLE IF EXISTS PALABRA;

--CREACIÓN DE TABLAS
CREATE TABLE ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(50),
    CONSTRAINT PK_ARTICULO PRIMARY KEY (id_articulo)
);

CREATE TABLE PALABRA (
    idioma CHAR(3)  NOT NULL,
    cod_palabra int NOT NULL ,
    CONSTRAINT PK_PALABRA PRIMARY KEY (idioma, cod_palabra)
);

CREATE TABLE CONTIENE (
    id_articulo int  NOT NULL,
    idioma CHAR(3)  NOT NULL ,
    cod_palabra int NOT NULL ,
    CONSTRAINT PK_CONTIENE PRIMARY KEY (id_articulo, idioma, cod_palabra)
);

ALTER TABLE CONTIENE ADD CONSTRAINT FK_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES ARTICULO (id_articulo)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
;

ALTER TABLE CONTIENE ADD CONSTRAINT FK_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES PALABRA (idioma, cod_palabra)
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

-- CARGA DE DATOS
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (1, 'A');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (2, 'B');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (3, 'C');
INSERT INTO ARTICULO (id_articulo, titulo) VALUES (4, 'D');

INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ESP', 1);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ENG', 3);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ESP', 2);
INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ENG', 1);

INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 1);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 2);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ENG', 3);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 1);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 2);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (3, 'ENG', 3);

--pruebas
-- OPERACIONES DEL KAHOOT

-- 1.1 no procede, hay delete restrict en contiene
DELETE FROM ARTICULO
 WHERE id_articulo = 1;


-- 1.2 Procede porque no hay referencias en CONTIENE
DELETE FROM ARTICULO
 WHERE id_articulo = 4;

--INSERT INTO ARTICULO (id_articulo, titulo) VALUES (4, 'D');

-- 1.3 Procede, hay referencias en CONTIENE pero hay delete CASCADE
DELETE FROM PALABRA
 WHERE idioma  = 'ESP'
   AND cod_palabra = 1;

select * from palabra;
select * from contiene;

--INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ESP', 1);
--INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 1);
--INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 1);


-- 1.4 Procede ya que los delete son cascade
DELETE FROM PALABRA
 WHERE idioma  = 'ENG'
   AND cod_palabra = 1;

--INSERT INTO PALABRA (idioma, cod_palabra) VALUES ('ENG', 1);

-- 1.5 Procede, hay referencias en palabra pero esta en CASCADE. Se elimina solo en CONTIENE.
DELETE FROM CONTIENE
 WHERE cod_palabra = 2 AND idioma = 'ESP';

INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (1, 'ESP', 1);
INSERT INTO CONTIENE (id_articulo, idioma, cod_palabra) VALUES (2, 'ESP', 1);


-- 1.6 NO PROCEDE, hay referencias en CONTIENE y es RESTRICT
UPDATE ARTICULO
   SET id_articulo = 5
 WHERE id_articulo = 1;


-- 1.7 PROCEDE, PORQUE NO HAY REFERENCIAS.
UPDATE ARTICULO
   SET id_articulo = 7
 WHERE id_articulo = 4;

-- UPDATE ARTICULO
--   SET id_articulo = 4
-- WHERE id_articulo = 7;

-- 1.8 procede porque los update son CASCADE
UPDATE PALABRA
   SET idioma      = 'POR'
 WHERE idioma      = 'ESP'
   AND cod_palabra = 1;

--UPDATE PALABRA
--   SET idioma      = 'ESP'
-- WHERE idioma      = 'POR'
--   AND cod_palabra = 1;

-- 1.9 PROCEDE
UPDATE PALABRA
   SET idioma      = 'POR'
 WHERE idioma      = 'ENG'
   AND cod_palabra = 1;

UPDATE PALABRA
 SET idioma      = 'ENG'
 WHERE idioma      = 'POR'
   AND cod_palabra = 1;

-- 1.10
UPDATE  CONTIENE
   SET id_articulo = 4
 WHERE id_articulo = 3
   AND idioma      = 'ENG'
   AND cod_palabra = 3;

select * from contiene;
select * from palabra;
select * from articulo;


--UPDATE  CONTIENE
--   SET id_articulo = 3
-- WHERE id_articulo = 4
--   AND idioma      = 'ENG'
--   AND cod_palabra = 3;

-- 1.11 no procede porque no existe articulo 8 en la pk
UPDATE  CONTIENE
   SET id_articulo = 8
 WHERE id_articulo = 2;

---pruena propia
DELETE FROM contiene
 WHERE id_articulo  = '1';

INSERT INTO contiene (id_articulo, idioma, cod_palabra) VALUES (2, 'ENG', 1);/**/
INSERT INTO articulo (id_articulo, titulo) VALUES (2, 'ENG');

DELETE FROM articulo
 WHERE id_articulo = 2;

select * from articulo;
select * from contiene