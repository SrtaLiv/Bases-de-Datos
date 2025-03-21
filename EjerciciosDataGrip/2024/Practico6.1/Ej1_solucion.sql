--p5p2e3c) Cada palabra clave puede aparecer como máximo en 5 artículos.
ALTER TABLE p5p2e3_contiene  ADD CONSTRAINT ck_max_palabra
CHECK (NOT EXISTS(SELECT count(id_articulo)
                FROM p5p2e3_contiene
                GROUP BY (idioma, cod_palabra)
                HAVING count(id_articulo) > 5   ));


create or replace function fn_maxArticulosxPalabra()
RETURNS Trigger AS
    $$ declare cant integer;
        begin
                SELECT count(id_articulo) INTO cant
                FROM p5p2e3_contiene
                WHERE idioma=NEW.idioma AND cod_palabra=NEW.cod_palabra;
                IF (cant > 4) THEN
                    RAISE EXCEPTION 'Esta palabra esta contenida en mas de 5 articulos: ';
                END IF;
            RETURN NEW;
        end
    $$
language 'plpgsql';

CREATE TRIGGER tr_max_pal_art
BEFORE INSERT OR UPDATE OF idioma, cod_palabra ON p5p2e3_contiene
    FOR EACH ROW EXECUTE PROCEDURE fn_maxArticulosxPalabra();

--p5p2e3d) Sólo los autores argentinos pueden publicar artículos que contengan más de 3 palabras claves, pero con un tope de 5 palabras,
-- el resto de los autores sólo pueden publicar artículos que contengan hasta 3 palabras claves.

CREATE ASSERTION CK_CANTIDAD_PALABRAS
   CHECK (NOT EXISTS (
            SELECT id_articulo
            FROM p5p2e3_articulo
            WHERE (nacionalidad LIKE 'ARG' AND
                  id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 5) ) OR
                  (nacionalidad NOT LIKE 'ARG' AND
                    id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 3) )))
;

SELECT * FROM p5p2e3_contiene ORDER BY id_articulo;

create or replace function fn_cantPalabras_contiene()
RETURNS Trigger AS
    $$ declare nac P5P2E3_ARTICULO.NACIONALIDAD%type;
                cant integer;
        begin
               SELECT nacionalidad INTO nac
               FROM p5p2e3_articulo
               WHERE id_articulo=NEW.id_articulo;
               SELECT count(*) into cant
               FROM p5p2e3_contiene
               WHERE id_articulo=NEW.id_articulo;
                IF ((nac='ARG' AND cant>5) OR (nac!='ARG' AND cant>3))
                THEN
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
                END IF;
            RETURN NEW;
        end
    $$
language 'plpgsql';

CREATE TRIGGER tr_pal_cont_art_max
BEFORE INSERT OR UPDATE OF id_articulo ON p5p2e3_contiene
    FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_contiene();

create or replace function fn_cantPalabras_articulo()
RETURNS Trigger AS
    $$ declare cant integer;
        begin
               SELECT count(*) into cant
               FROM p5p2e3_contiene
               WHERE id_articulo=NEW.id_articulo;
                IF ((NEW.nacionalidad='ARG' AND cant>5) OR (NEW.nacionalidad!='ARG' AND cant>3))
                -- NEW.nacionalidad refiere a la nacionalidad de la tupla que se esta actualizando
                THEN
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
                END IF;
            RETURN NEW;
        end
    $$
language 'plpgsql';

CREATE TRIGGER tr_max_pal_art
BEFORE UPDATE OF nacionalidad ON p5p2e3_articulo
FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_articulo();