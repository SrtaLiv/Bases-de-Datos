SET search_path = unc_188;


-- Ejercicio 1
--C Cada palabra clave puede aparecer como máximo en 5 artículos.
CREATE OR REPLACE FUNCTION fn_max_pl_claves()
RETURNS TRIGGER AS $$
        DECLARE cant INTEGER; --Declaracion de Variables
BEGIN --Logica

    SELECT COUNT(id_articulo) INTO cant
    FROM p5p1e1_contiene
    WHERE idioma = NEW.idioma AND cod_palabra = NEW.cod_palabra;  --El NEW almacena una nueva fila para las operaciones INSERT/UPDATE

    IF cant >= 5 THEN
        RAISE EXCEPTION 'Esta palabra clave (%s) ya está contenida en más de 5 artículos', NEW.cod_palabra;
    END IF;
    RETURN NEW; --Si la condicion anterior no se cumple, es decir que la cantidad es menor a 5 la operacion de insertar continua.
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_palabras_max_articulos
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
 ON p5p1e1_contiene
 EXECUTE PROCEDURE fn_max_pl_claves();


--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras claves, pero con un tope de 15 palabras,
-- El resto de los autores sólo pueden publicar
--artículos que contengan hasta 10 palabras claves.
CREATE OR REPLACE FUNCTION fn_max_pl_claves_arg()
RETURNS TRIGGER AS $$
            DECLARE cant INTEGER; --Declaracion de Variables
BEGIN

    SELECT count(cod_palabra) INTO cant
    FROM p5p1e1_articulo a
    JOIN unc_188.p5p1e1_contiene p5p1e1c on a.id_articulo = p5p1e1c.id_articulo;

    IF NEW.NACIONALIDAD = 'Argentina' THEN
        IF cant > 10 THEN
        RAISE EXCEPTION 'EL AUTOR NO PUEDE PUBLICAR MAS DE 10 PALABRAS', NEW.cod_palabra;
    end if;
    else
    IF cant > 15 THEN
                RAISE EXCEPTION 'EL AUTOR NO PUEDE PUBLICAR MAS DE 15 PALABNRAS', NEW.cod_palabra;
END IF;
    END IF;
    return new;
    end;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_palabras_max_articulos_arg
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
 ON p5p1e1_contiene
 EXECUTE PROCEDURE fn_max_pl_claves();


