ALTER TABLE unc_188_categoria
ADD cant_prod INT DEFAULT 0,
ADD cant_suc INT DEFAULT 0;

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_CANT_PROD()
RETURNS Trigger AS $$
    BEGIN
        UPDATE unc_188_categoria
        SET cant_prod = (
        SELECT COUNT(*)
        FROM unc_188_producto
        WHERE cod_categoria = NEW.cod_categoria AND tipo_categoria = NEW.tipo_categoria
    ) WHERE cod_categoria = NEW.cod_categoria AND tipo_categoria = NEW.tipo_categoria;

    RETURN NEW;
    end;
$$ language 'plpgsql';


CREATE TRIGGER TR_ACTUALIZAR_CANT_PROD
BEFORE UPDATE OF nro_producto ON unc_188_producto
FOR EACH ROW EXECUTE PROCEDURE FN_ACTUALIZAR_CANT_PROD();

-----------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_CANT_SUCURSAL()
RETURNS Trigger AS $$
    BEGIN
 BEGIN
        UPDATE unc_188_categoria
        SET cant_suc = (
        SELECT COUNT(*)
        FROM unc_188_sucursal s
        JOIN unc_188_productos_x_sucursal ps ON s.cod_sucursal = ps.cod_sucursal
        WHERE ps.cod_categoria = NEW.cod_categoria AND ps.tipo_categoria = NEW.tipo_categoria
    ) WHERE cod_categoria = NEW.cod_categoria AND tipo_categoria = NEW.tipo_categoria;
    RETURN NEW;
    end;
$$  language 'plpgsql';

CREATE TRIGGER TR_ACTUALIZAR_CANT_PROD
BEFORE UPDATE OF cod_sucursal ON unc_188_sucursal
FOR EACH ROW EXECUTE PROCEDURE FN_ACTUALIZAR_CANT_SUCURSAL();
