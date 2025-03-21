--EJ 1
/* CREATE ASSERTION SERVICIO_UNICO
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM UNI_SERV u
        WHERE EXISTS (
            SELECT 1
            FROM MULTI_SERV m
            WHERE u.DNI = m.DNI
            AND u.id_servicio = m.DNI
            AND u.cod_tipo_serv = m.DNI
        )
    )
);
*/
-- EJERCICIO 2
CREATE OR REPLACE FUNCTION fn_verifica_servicio()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM MULTI_SERV m
        WHERE NEW.DNI = m.DNI
        AND NEW.id_servicio = m.DNI
        AND NEW.cod_tipo_serv = m.DNI
    ) THEN
        RAISE EXCEPTION ' Un Servicio no puede ser contratado en las dos modalidades de Servicio';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_verificar_servicio
BEFORE INSERT ON UNI_SERV
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_servicio();
