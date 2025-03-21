--B. Cada imagen no debe tener más de 5 procesamientos.
CREATE OR REPLACE FUNCTION fn_max_pl_claves()
RETURNS TRIGGER AS $$
declare cant int;
    BEGIN
    select count(*) into cant
    FROM p5p2e4_procesamiento p
    WHERE id_paciente = new.id_paciente AND id_imagen = new.id_imagen;

    IF cant > 4 THEN
        raise exception 'no pueden haber mas de 5 procesamientos';
    RETURN new;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_palabras_max_articulos
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
 ON p5p1e1_contiene
 EXECUTE PROCEDURE fn_max_pl_claves();


--c
/*
 C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle:

que la segunda no sea menor que la primera.
 o sea que la segunda sea > que la primera
 */

CREATE OR REPLACE FUNCTION fn_controlar_fecha()
RETURNS TRIGGER AS $$
    BEGIN
        IF new.fecha_pr > (
            SELECT fecha_img
            FROM p5p2e4_imagen_medica
            WHERE p5p2e4_imagen_medica.id_paciente = new.id_paciente
            AND p5p2e4_imagen_medica.id_imagen = new.id_imagen )
         THEN
	    RAISE EXCEPTION 'Fecha de la imagen % del paciente % es mayor que la de procesamiento %', NEW.id_imagen, NEW.id_paciente, NEW.fecha_pr;
        end if;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_controlar_fecha
BEFORE INSERT OR UPDATE OF fecha_pr, id_paciente, id_imagen
 ON p5p2e4_procesamiento
FOR EACH ROW
 EXECUTE PROCEDURE fn_controlar_fecha();

--------------------------------------------------------------------
-- D. Sólo se pueden realizar dos FLUOROSCOPIA anuales por paciente
CREATE OR REPLACE FUNCTION fn_controlar_fluoroscopias_por_paciente()
RETURNS TRIGGER AS $$
    BEGIN
        if new.modalidad = 'FLUOROSCOPIA '  AND
        (
            SELECT 1
            FROM p5p2e4_imagen_medica
            WHERE id_paciente = new.id_paciente
            AND modalidad = new.modalidad
            AND EXTRACT(YEAR FROM fecha_img) = EXTRACT(YEAR FROM NEW.fecha_img)
        ) > 2
            THEN
            RAISE EXCEPTION 'NO PUEDE HACER MAS DE 2 MODALIDADES POR AÑO'
        end if;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_controlar_fluoroscopias_por_paciente
BEFORE INSERT OR UPDATE OF id_paciente, modalidad
 ON p5p2e4_imagen_medica
FOR EACH ROW
 EXECUTE PROCEDURE fn_controlar_fluoroscopias_por_paciente();