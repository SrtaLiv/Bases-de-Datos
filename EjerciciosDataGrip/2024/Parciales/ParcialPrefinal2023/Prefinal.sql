--a) Se necesita Controlar que sólo puede existir una fecha_hasta en nulo para cada Area e Investigador
ALTER TABLE trabaja_en
CREATE ASSERTION
CHECK NOT EXIST(
       SELECT 1
       FROM trabaja_en
       WHERE fecha_hasta IS NULL
)

CREATE OR REPLACE FUNCTION fn_controlar_fecha_hasta_nula()
RETURNS TRIGGER AS $$
BEGIN
    IF new.fecha_desde > NEW.fecha_hasta
        THEN RAISE EXCEPTION 'fecha desde debe ser menor o igual que la fecha hasta';
    END IF;

        -- Verificar inserción o actualización
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        select 1 FROM trabaja_en
            WHERE id_area = NEW.id_area
              AND id_investigador = NEW.id_investigador
              AND fecha_desde <= NEW.fecha_desde

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_controlar_fecha_hasta_nula
BEFORE INSERT OR UPDATE --OF idioma, cod_palabra
 ON trabaja_en
 EXECUTE PROCEDURE fn_controlar_fecha_hasta_nula();