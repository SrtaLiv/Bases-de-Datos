/*
--
-- EJERCICIO A > Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.
--
CREATE OR REPLACE FUNCTION fn_venta_desc_maxmin() RETURNS TRIGGER AS $$

DECLARE
    v_descuento = P5P2E5_VENTA.descuento%type;

BEGIN
    
    SELECT descuento INTO v_descuento FROM P5P2E5_VENTA v WHERE v.descuento = NEW.descuento;

    IF(v_descuento BETWEEN 0 AND 100) THEN
        RETURN NEW
    ELSE
        RAISE EXCEPTION 'Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.', v_descuento;
    END IF;

END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_venta_desc_maxmin
    BEFORE INSERT OR UPDATE OF descuento
    ON P5P2E5_VENTA
    FOR EACH ROW
    EXECUTE PROCEDURE fn_venta_desc_maxmin()

--
-- EJERCICIO B > Los descuentos realizados en fechas de liquidación deben superar el 30%.
--
CREATE OR REPLACE FUNCTION fn_fecha_liquidacion_supera_30() RETURNS TRIGGER AS $$

DECLARE
    dia_liq int;
    mes_liq int;

BEGIN

    dia_liq = EXTRACT(DAY FROM NEW.fecha);
    mes_liq = EXTRACT(MONTH FROM NEW.fecha);

    IF EXISTS(
        SELECT 1 FROM P5P2E5_FECHA_LIQ fl
        WHERE fl.dia_liq = dia_liq 
            AND fl.mes_liq = mes_liq
    ) THEN

        IF NEW.descuento <= 30 THEN
            RAISE EXCEPTION 'Los descuentos realizados en fechas de liquidación deben superar el 30%.';
        END IF;
    END IF;

    RETURN NEW;
    
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_fecha_liquidacion_supera_30
    BEFORE INSERT OR UPDATE ON P5P2E5_VENTA
    FOR EACH ROW
    EXECUTE fn_fecha_liquidacion_supera_30();

--
-- EJERCICIO C > Las liquidaciones de Julio (7) y Diciembre (12) no deben superar los 5 días.
--
CREATE OR REPLACE FUNCTION fn_liq_jul_dic_supera_5_dias() RETURNS TRIGGER AS $$
BEGIN

    IF(NEW.mes_liq = 7 OR NEW.mes_liq = 12) THEN
        IF(NEW.cant_dias > 5) THEN
            RAISE EXCEPTION 'Las liquidaciones de Julio y Diciembre no deben superar los 5 días.'
        END IF;
    END IF;

    RETURN NEW;

END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_liq_jul_dic_supera_5_dias
    BEFORE INSERT OR UPDATE ON P5P1E5_FECHA_LIQ
    FOR EACH ROW
    EXECUTE fn_liq_jul_dic_supera_5_dias();

--

 */
-- EJERCICIO D > Las prendas de categoría ‘oferta’ no tienen descuentos.
--
