/* PRACTICO 6
   PARTE 1
   EJERCICIO 1
 */
--Resolucion declarativa
--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT c_contiene
CHECK ( NOT EXISTS(
    SELECT 1
    FROM p5p1e1_contiene
    GROUP BY cod_palabra, idioma
    HAVING count(id_articulo) > 5
));

/*
    Resolucion procedural
    tabla: contiene
    para insert y update (idioma, cod_palabra)
 */
CREATE OR REPLACE FUNCTION fn_con_max_pl_claves()
RETURNS trigger AS $$
DECLARE
    cant Integer;
BEGIN
    SELECT count(id_articulo) INTO cant
    FROM p5p1e1_contiene
    WHERE idioma= NEW.idioma AND cod_palabra= NEW.cod_palabra;
    IF (cant > 4)THEN
        RAISE EXCEPTION 'Esta palabra ya aparece en 5 articulos';
    END IF;
    RETURN NEW;
END;$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_con_max_pl_claves
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
ON p5p1e1_contiene
FOR EACH ROW
EXECUTE PROCEDURE fn_con_max_pl_claves();

--Resolucion declarativa
/*D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
artículos que contengan hasta 10 palabras claves.
  CREATE ASSERTION d_contiene_articulo
CHECK ( NOT EXISTS (
        SELECT 1
        FROM p5p1e1_articulo a
        WHERE (a.nacionalidad LIKE 'AR' AND
        id_articulo IN (
                SELECT c.id_articulo
                FROM p5p1e1_contiene c
                GROUP BY id_articulo
                HAVING (count(*) > 15) ) OR
        nacionalidad NOT LIKE 'AR' AND
        id_articulo IN (
                SELECT id_articulo
                FROM p5p1e1_contiene c
                GROUP BY id_articulo
                HAVING COUNT(*) > 10)));*/


/*
    Resolucion procedural
    tabla: articulo para update (nacionalidad)
    tabla: contiene para insert, update (id_articulo)
 */

CREATE OR REPLACE FUNCTION fn_con_max_pl_claves()
RETURNS trigger AS $$
DECLARE
    cant Integer;
    fnacionalidad p5p1e1_articulo.nacionalidad%type;
BEGIN
    SELECT nacionalidad INTO fnacionalidad
    FROM p5p1e1_articulo
    WHERE id_articulo= new.id_articulo;
    SELECT count(*) INTO cant
    FROM p5p1e1_contiene
    WHERE id_articulo= new.id_articulo;
    IF (fnacionalidad= 'ARG' AND cant > 14) OR (fnacionalidad <> 'ARG' AND cant >9)THEN
        RAISE EXCEPTION 'Este articulo ya contiene mas de las palabras claves permitidas';
    END IF;
    RETURN NEW;
END; $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_con_max_pl_claves2
BEFORE INSERT OR UPDATE OF id_articulo
ON p5p1e1_contiene
FOR EACH ROW
EXECUTE PROCEDURE fn_con_max_pl_claves();

CREATE OR REPLACE FUNCTION fn_art_nacionalidad()
RETURNS trigger AS $$
DECLARE
    cant Integer;
BEGIN
    SELECT count(*) INTO cant
    FROM p5p1e1_articulo
    WHERE id_articulo = new.id_articulo;
    IF(new.nacionalidad = 'ARG' AND cant>15) OR (new.nacionalidad <> 'ARG' AND cant>10)THEN
        RAISE EXCEPTION 'El articulo ya contiene 15 palabras claves';
    END IF;
    RETURN NEW;
END;$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_art_nacionalidad
BEFORE UPDATE of nacionalidad
ON p5p1e1_articulo
FOR EACH ROW
EXECUTE PROCEDURE fn_art_nacionalidad();



-- EJERCICIO 2

/* B)
    Referencia declarativa
    Cada imagen no debe tener más de 5 procesamientos.
*/
ALTER TABLE P5P2E4_PROCESAMIENTO
ADD CONSTRAINT b_procedimiento
CHECK ( NOT EXISTS(
    SELECT 1
    FROM P5P2E4_PROCESAMIENTO
    GROUP BY id_imagen, id_paciente
    HAVING count(*) > 5
) );

/*Referencia procedural
    tabla: procesamiento insert, update
*/
CREATE OR REPLACE FUNCTION fn_max_proc()
RETURNS trigger AS $$
    DECLARE
        cant Integer;
    BEGIN
        SELECT count(*) INTO cant
        FROM p5p2e4_procesamiento
        WHERE id_imagen= new.id_imagen AND id_paciente = new.id_paciente;
        IF (cant > 4)THEN
            RAISE EXCEPTION 'la imagen ya tiene 5 procesamiento';
        END IF;
        RETURN NEW;
END; $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_proc
BEFORE INSERT OR UPDATE OF id_imagen, id_paciente
ON p5p2e4_procesamiento
FOR EACH ROW
EXECUTE PROCEDURE fn_max_proc();

/* C)
    Restriccion declarativa
    Controle que la fecha del procesamiento no sea menor que la de la imagen.
   CREATE ASSERTION c_img_procedimiento
CHECK ( NOT EXISTS (
    SELECT 1
    FROM p5p2e4_imagen_medica i
    INNER JOIN P5P2E4_PROCESAMIENTO p
    ON i.id_imagen = p.id_imagen AND i.id_paciente = p.id_paciente
    WHERE p.fecha_procesamiento < i.fecha_imagen
));
*/

/*
    Restrinccion procedural
    Tabla: procesamiento. insert y update fecha_procesamiento,id_imagen,id_paciente
    Tabla: imagen medica. update fecha_imagen
 */

CREATE OR REPLACE FUNCTION fn_control_fecha_imagen()
RETURNS TRIGGER AS $$
BEGIN
    IF(SELECT 1
    FROM p5p2e4_procesamiento p
    WHERE (p.id_imagen= new.id_imagen AND p.id_paciente= new.id_paciente)
    AND fecha_procesamiento>new.fecha_imagen)THEN
         RAISE EXCEPTION 'La fecha de la imagen no puede ser menor que la de procesamiento'
    END IF;
RETURN NEW;
END;$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_control_fecha_imagen()
BEFORE UPDATE OF fecha_imagen
ON p5p2e4_imagen_medica
FOR EACH ROW
EXECUTE PROCEDURE fn_control_fecha_imagen();

CREATE OR REPLACE FUNCTION fn_control_fecha_procesamiento()
RETURNS trigger AS $$
BEGIN
    IF(SELECT 1
    FROM p5p2e4_imagen_medica i
    WHERE (i.id_imagen= new.id_imagen AND i.id_paciente= new.id_paciente)
    AND fecha_imagen<new.fecha_procesamiento)THEN
        RAISE EXCEPTION 'La fecha de la imagen no puede ser menor que la de procesamiento';
    END IF;
    RETURN NEW;
END; $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_control_fecha_procesamiento
BEFORE INSERT OR UPDATE OF fecha_procesamiento, id_imagen, id_paciente
ON p5p2e4_procesamiento
FOR EACH ROW
EXECUTE PROCEDURE fn_control_fecha_procesamiento();


/* D)
    Restrinccion declarativa
    Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
 */

ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD CONSTRAINT d_imagen_medica
CHECK ( NOT EXISTS(
        SELECT 1
        FROM P5P2E4_IMAGEN_MEDICA i
        WHERE i.modalidad = 'FLUOROSCOPIA'
        GROUP BY i.id_paciente, extract(year from i.fecha_imagen)
        HAVING (COUNT(*) > 2)
));

/* Restriccion procedural
    Tabla: imagen medica. insert y update (modalidad, id_paciente,fecha_imagen)
 */
CREATE OR REPLACE FUNCTION fn_control_modalidad_imagen()
RETURNS trigger AS $$
    DECLARE
        cant Integer;
BEGIN
    SELECT count(*) INTO cant
    FROM p5p2e4_imagen_medica
    WHERE id_paciente= new.id_paciente AND extract(year from fecha_imagen) = extract(year from new.fecha_imagen);
    IF (cant > 1)THEN
        RAISE EXCEPTION 'El paciente ya se hizo dos fluoroscopia en el año';
    END IF;
    RETURN NEW;
END; $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_control_modalidad_imagen
BEFORE INSERT OR UPDATE OF modalidad, id_paciente, fecha_imagen
ON p5p2e4_imagen_medica
FOR EACH ROW
WHEN( new.modalidad= 'FLOUROSCOPIA')
EXECUTE PROCEDURE fn_control_modalidad_imagen();


--EJERCICIO 4

--a) Copie en su esquema la estructura de la tabla PELICULA del esquema unc_peliculas
CREATE TABLE Pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;

--b) Cree la tabla ESTADISTICA con la siguiente sentencia:
CREATE TABLE estadistica AS
SELECT genero, COUNT(*) total_peliculas, count (distinct idioma) cantidad_idiomas
FROM Pelicula GROUP BY genero;

/*
    c) Cree un trigger que cada vez que se realice una modificación en la tabla película (la creada
    en su esquema) tiene que actualizar la tabla estadística.No se olvide de identificar:
    i) la granularidad del trigger.
    ii) Eventos ante los cuales se debe disparar. EN ESTADISTICA INSERT PELICULA, UPDATE PELICULA (genero e idioma), DELETE PELICULA
    iii) Analice si conviene modificar por cada operación de actualización o reconstruirla de
    cero.

    TABLA ESTADISTICA
        genero
        total_peliculas
        cantidad_idiomas
*/

CREATE TRIGGER tr_estadistica_peliculas
AFTER INSERT OR UPDATE OF codigo_pelicula, genero OR DELETE
ON pelicula
FOR EACH ROW
EXECUTE PROCEDURE fn_actualizar_estadistica();

CREATE OR REPLACE FUNCTION fn_actualizar_estadistica()
RETURNS trigger AS $$
DECLARE
    generoo pelicula.genero%type;
    idio pelicula.idioma%type;
BEGIN
    SELECT genero INTO generoo
    FROM pelicula
    WHERE codigo_pelicula= new.codigo_pelicula;
    SELECT idioma INTO idio
    FROM pelicula
    WHERE codigo_pelicula= new.codigo_pelicula;

    IF(TG_OP= 'INSERT')THEN
        UPDATE estadistica set total_peliculas= total_peliculas+1 WHERE generoo= new.genero;
        UPDATE estadistica set cantidad_idiomas= cantidad_idiomas+1 WHERE idio= new.idioma;
    RETURN NEW;
    END IF;

    IF (TG_OP= 'UPDATE') THEN
    --cuando cambian genero del pelicula
        UPDATE estadistica set total_peliculas= total_peliculas -1 WHERE generoo=old.genero;
        UPDATE estadistica set total_peliculas= total_peliculas +1 WHERE generoo= new.genero;
    --cuando cambian idioma de la pelicula
        UPDATE estadistica set cantidad_idiomas= cantidad_idiomas -1 WHERE idio= old.idioma;
        UPDATE estadistica set cantidad_idiomas= cantidad_idiomas +1 WHERE idio= new.idioma;
    RETURN NEW;
    END IF;

    IF (TG_OP= 'DELETE')THEN
        UPDATE estadistica set total_peliculas= total_peliculas -1 WHERE generoo = old.genero;
        UPDATE estadistica set cantidad_idiomas= cantidad_idiomas -1 WHERE idio= old.idioma;
    RETURN OLD;
    END IF;

END; $$
LANGUAGE 'plpgsql';





