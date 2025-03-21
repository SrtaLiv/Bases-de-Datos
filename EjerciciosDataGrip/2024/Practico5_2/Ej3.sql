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
ALTER TABLE P5P1E1_ARTICULO ADD COLUMN nacionalidad varchar(50);


--A. Controlar que las nacionalidades sean 'Argentina' 'Español'; 'Inglés'; ';Alemán'; o 'Chilena'
--B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales
--al 2010.
--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
--claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
--artículos que contengan hasta 10 palabras claves.

--A. Controlar que las nacionalidades sean 'Argentina' 'Español'; 'Inglés'; ';Alemán'; o 'Chilena'
ALTER TABLE P5P1E1_ARTICULO
ADD CONSTRAINT nacion
CHECK (
    nacionalidad IN ('Argentina', 'Español', 'Inglés', 'Alemán', 'Chilena')
);

--B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales
--al 2010.
ALTER TABLE p5p1e1_articulo
ADD CONSTRAINT fecha_2010
CHECK ( extract(year from fecha_publicacion) >= 2010 );

--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
--no existan articulos con menos de 5 palabras
ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT palabra_clave_en_5_articulos
check (not exists( SELECT 1
    FROM p5p1e1_contiene
    GROUP BY id_articulo, cod_palabra --cod_palabra e idioma, articulo no, pero por que?!
    HAVING count(*) > 5)
    );

--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
-- claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
-- artículos que contengan hasta 10 palabras claves.

-- autor, cod_palabra, id_articulo. ASSERTION, necesito mas de 2 tablas.
--Quiero que los autores argentinos publicen articulos con > 10 y < 15 palabras
--si no es argentino articulos con <10 palabras
CREATE ASSERTION palabra_clave_en_5_articulos
CHECK (NOT EXIST(SELECT 1
        FROM ARTICULO
        WHERE NACIONALIDAD LIKE ('ARGENTINA')
        AND ID_ARTICULO IN (
        SELECT ID_ARTICULO FROM CONTIENE
        GROUP BY ID_ARTICULO HAVING COUNT(*) > 15 OR
        NACIONALIDAD NOT LIKE 'ARGENTINA' AND ID_ARTICULO
        IN (SELECT ID_ARTICULO FROM CONTIENE GROUP BY ID_ARTICULO
          COUNT(*) > 10)
        )
    )
)


))
