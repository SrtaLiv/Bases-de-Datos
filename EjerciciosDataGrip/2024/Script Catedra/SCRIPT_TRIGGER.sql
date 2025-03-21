CREATE OR REPLACE FUNCTION fn_max_pl_claves()
RETURNS TRIGGER AS $$
BEGIN

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_palabras_max_articulos
BEFORE INSERT OR UPDATE OF idioma, cod_palabra
 ON p5p1e1_contiene
 EXECUTE PROCEDURE fn_max_pl_claves();