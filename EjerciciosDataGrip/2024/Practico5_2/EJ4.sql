/*
Ejercicio 4
A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA
CONVENCIONAL, FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON
FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,

B. Cada imagen no debe tener más de 5 procesamientos.

C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
que la segunda no sea menor que la primera.

D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.

E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de
FLUOROSCOPIA
*/

--A
ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD CONSTRAINT modalidad_check
CHECK ( modalidad IN ('FLOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFRUA'));

--B
ALTER TABLE p5p2e4_procesamiento
   ADD CONSTRAINT CK_CANTIDAD_PROCESAMIENTOS
   CHECK ( NOT EXISTS (
            SELECT 1
            FROM p5p2e4_procesamiento
            GROUP BY id_paciente, id_imagen
            HAVING COUNT(*) > 5
       ))
;

--C  Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
-- indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
-- que la segunda no sea menor que la primera.

ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD COLUMN
fecha_img DATE;

ALTER TABLE P5P2E4_PROCESAMIENTO ADD COLUMN
fecha_proc DATE;

CREATE ASSERTION
   CHECK ( NOT EXISTS (
            select 1
            FROM p5p2e4_imagen_medica i JOIN p5p2e4_procesamiento p
            ON (i.id_paciente = p.id_paciente and i.id_imagen = p.id_imagen) --TODAS LAS FK!
            WHERE fecha_proc < fecha_img )
   )

--D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
ALTER TABLE p5p2e4_paciente
ADD CONSTRAINT fl_modalidad
CHECK ( NOT EXISTS(
    SELECT 1
    FROM P5P2E4_IMAGEN_MEDICA
    WHERE modalidad = ('FLOROSCOPIA')
    GROUP BY id_paciente, extract(year from fecha_img)
    HAVING count(*) > 2
)
);

--E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de
--FLUOROSCOPIA

CREATE ASSERTION
CHECK NOT EXIST(
SELECT 1 FROM p5p2e4_imagen_medica med
JOIN P5P2E4_PROCESAMIENTO pr ON med.id_imagen = pr.id_imagen
    AND pr.id_paciente = med.id_paciente
    WHERE modalidad = 'FLUOROSCOPIA' AND
    costo_computacional = 'O(n)'
);




-- A. Controlar que las nacionalidades sean 'Argentina' 'Español' 'Inglés' 'Alemán' o 'Chilena'.
-- TIPO - check atributo = dominio
ALTER TABLE p5p2e3_articulo
   ADD CONSTRAINT ck_articulo_nacionalidad
   CHECK ( nacionalidad in ('Argentina','Español','Ingles','Aleman','Chilena'))
;


-- B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
-- TIPO TIPO - check atributo = dominio
ALTER TABLE p5p2e3_articulo
   ADD CONSTRAINT ck_articulo_fecha_publicacion
   CHECK ( extract(year from fecha_publicacion) >= 2010 )
;

--C. Cada palabra puede aparecer como máximo en 5 artículos.
-- buscar las palabras que aparecen en más de 5 articulos
-- TIPO - TABLA
/*
ALTER TABLE p5p2e3_contiene
   ADD CONSTRAINT ck_cantpalabra_articulo
   CHECK ( NOT EXISTS (
             SELECT 1
             FROM p5p2e3_contiene
             GROUP BY idioma, cod_palabra
             HAVING COUNT(*) > 5));
*/

--D. Sólo los autores argentinos pueden publicar artículos que contengan más de
-- 10 palabras claves, pero con un tope de 15 palabras, el resto de los autores
-- sólo pueden publicar artículos que contengan hasta 10 palabras claves.
-- TIPO - general
/*
CREATE ASSERTION CK_CANTIDAD_PALABRAS
   CHECK (NOT EXISTS (
            SELECT 1
            FROM p5p2e3_articulo
            WHERE (nacionalidad LIKE 'Argentina' AND
                  id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 15) ) OR
                  (nacionalidad NOT LIKE 'Argentina' AND
                  id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 10) )))
;
*/

ALTER TABLE
ADD CONSTRAINT
CHECK (
    NOT EXIST(
    SELECT 1 FROM
    WHERE MODALIDAD ILIKE 'FLUROSCOPIA'
    GROUP BY id_paciente EX
    )
    )