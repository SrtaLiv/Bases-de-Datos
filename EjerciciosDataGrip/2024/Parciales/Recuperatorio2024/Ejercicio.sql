CREATE TABLE TIPO_SUMINISTRO (
    cod_tipo_sum INTEGER PRIMARY KEY
);
DELETE FROM TIPO_SUMINISTRO WHERE cod_tipo_sum = 'D';


-- Un Servicio no puede ser contratado en las dos modalidades de Servicio


--usamos assertion pq afecta a 2 tablas
CREATE ASSERTION ck_servicio_no_contratado_en_ambas_modalidades
CHECK (NOT EXISTS (
    SELECT 1
    FROM contrata c
    JOIN uni_serv u ON c.id_servicio = u.id_servicio AND c.cod_tipo_serv = u.cod_tipo_serv
));

CREATE ASSERTION ck_servicio_no_contratado_en_ambas_modalidades
CHECK (NOT EXISTS (
    SELECT 1
    FROM contrata c
    JOIN uni_serv u ON c.id_servicio = u.id_servicio AND c.cod_tipo_serv = u.cod_tipo_serv
));

       CREATE OR REPLACE FUNCTION verificar_contratacion() RETURNS trigger AS $$
   BEGIN
	IF (TG_TABLE_NAME = 'uni_serv' ) THEN
		IF EXISTS (SELECT 1 FROM contrata
                           WHERE id_servicio = NEW.id_servicio
                           AND cod_tipo_serv = NEW.cod_tipo_serv
                           ) THEN
                          RAISE EXCEPTION 'El servicio % de tipo % ya está contratado en modalidad múltiple', NEW.id_servicio, NEW.cod_tipo_serv;
		END IF;
	ELSIF (TG_TABLE_NAME = 'contrata') THEN
              IF EXISTS (SELECT 1 FROM uni_serv
                         WHERE id_servicio = NEW.id_servicio
                         AND cod_tipo_serv = NEW.cod_tipo_serv
                         ) THEN
                         RAISE EXCEPTION 'El servicio % de tipo %  ya está contratado en modalidad única', NEW.id_servicio , NEW.cod_tipo_serv;
               END IF;
        END IF;
        RETURN NEW;
    END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER TRG_B_INS_UPD_uni_serv
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON uni_serv
FOR EACH ROW
EXECUTE FUNCTION verificar_contratacion();

CREATE TRIGGER TRG_B_INS_UPD__contrata
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON contrata
FOR EACH ROW
EXECUTE FUNCTION verificar_contratacion();