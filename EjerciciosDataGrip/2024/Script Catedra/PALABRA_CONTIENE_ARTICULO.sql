-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

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
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

--VALORES FALSOS
INSERT INTO P5P1E1_ARTICULO (id_articulo, titulo, autor) VALUES
(1, 'Introduction to SQL', 'John Doe'),
(2, 'Advanced SQL Techniques', 'Jane Smith'),
(3, 'Database Design Principles', 'Alice Johnson');

INSERT INTO P5P1E1_PALABRA (idioma, cod_palabra, descripcion) VALUES
('EN', 1, 'Database'),
('EN', 2, 'SQL'),
('EN', 3, 'Design'),
('EN', 4, 'Advanced'),
('ES', 1, 'Base de datos'),
('ES', 2, 'SQL'),
('ES', 3, 'Diseño'),
('ES', 4, 'Avanzado');

INSERT INTO P5P1E1_CONTIENE (id_articulo, idioma, cod_palabra) VALUES
(1, 'EN', 1),
(1, 'EN', 2),
(1, 'EN', 3),
(2, 'EN', 2),
(2, 'EN', 4),
(3, 'EN', 1),
(3, 'EN', 3),
(3, 'ES', 1),
(3, 'ES', 3);

INSERT INTO P5P1E1_CONTIENE (id_articulo, idioma, cod_palabra) values (2, 'EN', 1);

SELECT * FROM P5P1E1_CONTIENE
