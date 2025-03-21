--preguntas
--1b, como hago con 3 tablas para hacer la restriccion

--ELIMINAR TABLAS
DROP TABLE unc_188.P5P1E1_ARTICULO;
DROP TABLE unc_188.P5P1E1_CONTIENE;
DROP TABLE unc_188.P5P1E1_PALABRA;

--SELECCIONAR TABLAS
SELECT * FROM unc_188.p5p1e1_palabra;
SELECT * FROM unc_188.p5p1e1_contiene;
SELECT * FROM unc_188.p5p1e1_articulo;


--CONSIGNAS
--EJERCICIO 1 A
-- a) Cómo debería implementar las Restricciones de Integridad Referencial (RIR) si se desea que
-- cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
-- que la referencian en la tabla CONTIENE.

ALTER TABLE P5P1E1_CONTIENE
DROP CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA;

ALTER TABLE unc_188.p5p1e1_articulo
ADD CONSTRAINT FK_ARTICULO_CONTIENE_PALABRA
FOREIGN KEY (id_articulo)
REFERENCES unc_188.p5p1e1_contiene (id_articulo)
ON DELETE RESTRICT;

ALTER TABLE unc_188.p5p1e1_contiene
DROP CONSTRAINT fk_palabra_contiene,
ADD CONSTRAINT fk_palabra_contiene
FOREIGN KEY (idioma, cod_palabra)
REFERENCES unc_188.p5p1e1_palabra (idioma, cod_palabra)
ON DELETE RESTRICT;

INSERT INTO unc_188.p5p1e1_articulo (id_articulo, titulo, autor )
VALUES (5, 'HOLA', 'LORENZO'),
       (15, 'CHAU', 'DELFINA'),
       (23, 'VENI', 'FLORENCIA');

INSERT INTO unc_188.p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (5, 'E', 1),
       (15, 'E', 2),
       (23, 'E', 2);

INSERT INTO unc_188.p5p1e1_palabra (idioma, cod_palabra, descripcion)
VALUES ('E', 1, 'Hola mundo'),
       ('E', 2, 'Chau mundo');

DELETE FROM unc_188.p5p1e1_palabra WHERE cod_palabra = 2 ;

--EJERCICIO 1 B
--b) Verifique qué sucede con las palabras contenidas en cada artículo, al eliminar una palabra, si
--definen la Acción Referencial para las bajas (ON DELETE) de la RIR correspondiente como:
--ii) Restrict
--iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON DELETE y ON UPDATE?

ALTER TABLE unc_188.p5p1e1_articulo
ADD CONSTRAINT FK_ARTICULO_CONTIENE_PALABRA
FOREIGN KEY (id_articulo)
REFERENCES unc_188.p5p1e1_contiene (id_articulo)
ON DELETE RESTRICT ;

ALTER TABLE unc_188.p5p1e1_contiene
DROP CONSTRAINT ck_palabra_contiene,
ADD CONSTRAINT fk_palabra_contiene
FOREIGN KEY (idioma, cod_palabra)
REFERENCES unc_188.p5p1e1_palabra (idioma, cod_palabra)
ON DELETE RESTRICT ;

DELETE FROM P5P1E1_PALABRA WHERE cod_palabra=2;




/************ TABLAS ************/
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
ALTER TABLE unc_188.p5p1e1_contiene ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE unc_188.P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.
