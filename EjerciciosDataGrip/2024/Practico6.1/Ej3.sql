--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
--D. Las prendas de categoría ‘oferta’ no tienen descuentos.

/*
Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
el ejercicio 5 del Práctico 5 Parte 2; cuyo script de creación del esquema se encuentra aquí.
Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron B, C, D, E
*/


--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
CREATE OR REPLACE FUNCTION fn_max_pl_claves()
RETURNS TRIGGER AS $$
    BEGIN
    IF NEW.fecha = 'julio' and
    (SELECT cant_dias
     from p5p2e5_fecha_liq
     WHERE mes_liq = 'julio') > 5
           --error

    or NEW.fecha = 'diciembre' and
        (SELECT cant_dias
            from p5p2e5_fecha_liq
            WHERE mes_liq = 'diciembre') > 5
      THEN raise exception 'no ';
        end if;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_palabras_max_articulos
BEFORE INSERT OR UPDATE OF id_venta, fecha
 ON p5p2e5_venta
 EXECUTE PROCEDURE fn_max_pl_claves();













-- Crear el desencadenador que llama a la función antes de insertar o actualizar el descuento
CREATE TRIGGER validar_descuento_en_fecha_liq
BEFORE INSERT OR UPDATE OF descuento
ON p5p2e5_venta
FOR EACH ROW EXECUTE FUNCTION descuentoEnFechaLiq();

CREATE FUNCTION descuentoEnFechaLiq()
    RETURNS TRIGGER AS $$
    DECLARE esFechaLiq BOOLEAN;
    BEGIN
        SELECT EXISTS (
            SELECT 1
            FROM p5p2e5_fecha_liq
            WHERE EXTRACT(DAY FROM NEW.fecha) = p5p2e5_fecha_liq.dia_liq
              AND EXTRACT(MONTH FROM NEW.fecha) = p5p2e5_fecha_liq.mes_liq
        ) INTO esFechaLiq;

          IF esFechaLiq THEN
                IF NEW.descuento <= 30 THEN
                    RAISE EXCEPTION 'El descuento debe superar el 30%% en fecha de liquidación. Descuento actual: %', NEW.descuento;
            END IF;
        END IF;

        RETURN NEW; -- Permitir la operación si no se excede el límite
    END;
$$ LANGUAGE plpgsql;


--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
--TABLAS: FECHA, VENTA.
--extraer el mes y si fecha_liq tiene > 5 dias retornar error
CREATE FUNCTION liquidacionesXDias()
RETURNS TRIGGER AS $$
DECLARE cantDias int;
    BEGIN
        SELECT cant_dias into cantDias
        FROM p5p2e5_fecha_liq
        WHERE mes_liq = 7
        OR mes_liq = 12;
        IF cantDias > 5 THEN
            RAISE EXCEPTION 'En Julio y Diciembre las liquidaciones no deben superar los 5 dias.';
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER liquidacionesXDiasTrigger
BEFORE INSERT OR UPDATE ON p5p2e5_fecha_liq
FOR EACH ROW
EXECUTE FUNCTION liquidacionesXDias();

--------------------------

CREATE OR REPLACE FUNCTION fn_liq_jul_dic_supera_5_dias()
    RETURNS TRIGGER AS $$
BEGIN
    IF(NEW.mes_liq = 7 OR NEW.mes_liq = 12) THEN
        IF(NEW.cant_dias > 5) THEN
            RAISE EXCEPTION 'Las liquidaciones de Julio y Diciembre no deben superar los 5 días.';
        END IF;
    END IF;
    RETURN NEW;
END; $$
LANGUAGE 'plpgsql';


CREATE TRIGGER tr_liq_jul_dic_supera_5_dias
    BEFORE INSERT OR UPDATE ON p5p2e5_fecha_liq
    FOR EACH ROW
    EXECUTE FUNCTION fn_liq_jul_dic_supera_5_dias();


--D. Las prendas de categoría ‘oferta’ no tienen descuentos.
-- EJERCICIO D > Las prendas de categoría ‘oferta’ no tienen descuentos.
--
CREATE OR REPLACE FUNCTION fn_prenda_cat_oferta_no_desc() RETURNS TRIGGER AS $$

DECLARE categoria_prenda P5P2E5_PRENDA.categoria%type;

BEGIN

    SELECT categoria INTO categoria_prenda FROM P5P2E5_PRENDA WHERE id_prenda = NEW.id_prenda;

    IF (categoria_prenda = upper('oferta')) THEN

        IF (NEW.descuento <> 0) THEN
            RAISE EXCEPTION 'Las prendas de categoría ‘oferta’ no tienen descuentos.';
        END IF;

    END IF;

    RETURN NEW;

END $$
LANGUAGE 'plpgsql';


CREATE TRIGGER tr_prenda_cat_oferta_no_desc
    BEFORE INSERT OR UPDATE of descuento ON P5P2E5_VENTA
    FOR EACH ROW
    EXECUTE FUNCTION fn_prenda_cat_oferta_no_desc();
