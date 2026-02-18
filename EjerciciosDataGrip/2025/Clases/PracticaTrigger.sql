-- Para el esquema de la figura cuyo script de creación se encuentra aquí, y datos aquí, se debe controlar
-- que  “por cada sala de atención y  por cada especialidad sólo pueden atender 2 médicos” y cuya restricción
-- declarativa es:

--¿Cuáles son las tablas, los eventos y para qué columnas se deben despertar los triggers?
-- Atiende: cod_centro, cod_especialidad, tipo_especialidad, nro_matricula
-- Centro_salud: sala_atencion = true

-- POR CADA SALA DE ATENCION Y POR CADA ESPECIALIDAD NO PUEDEN ATENDER MAS DE 2 MEDICOS

CREATE ASSERTION CK_MEDICO(
CHECK(
       NOT EXISTS(
       SELECT 1
       FROM ATIENDE A
       JOIN CENTRO_SALUD
       USING (COD_CENTRO)
       WHERE SALA_ATENCION = TRUE
       GROUP BY (TIPO_ESPECIALIDAD, COD_ESPECIALIDAD, COD_CENTRO)
       HAVING COUNT(*) > 2
       )
)
)


-- trigger:
-- ATIENDE: tipo_especialidad, cod_especialidad, COD_CENTRO
CREATE FUNCTION fn_control_cant_medicos() RETURNS TRIGGER AS $$
    DECLARE cant int;
    BEGIN
    IF ((
        SELECT c.cod_centro, sala_atencion
        FROM centro_salud c WHERE c.cod_centro = new.cod_centro
        ) = true)

    THEN (
        SELECT count(*) INTO cant
        FROM unc_46203524.atiende a
        WHERE a.tipo_especialidad = new.tipo_especialidad
        AND a.cod_especialidad = new.cod_especialidad
        AND a.cod_centro = new.cod_centro
         );
    end if;

    IF cant > 1 THEN
        RAISE EXCEPTION 'NO PUEDEN HABER MAS DE 2 MEDICOS..';
    end if;

    RETURN new;
end;
    $$
LANGUAGE plpgsql;


CREATE TRIGGER tr_contorl_cant_medicos
    BEFORE INSERT OR UPDATE OF tipo_especialidad, cod_Especialidad, cod_centro
    ON atiende
    FOR EACH ROW EXECUTE PROCEDURE fn_control_cant_medicos();

CREATE OR REPLACE FUNCTION fn_control_cant_medicos_update()
    RETURNS TRIGGER AS
$$
BEGIN
    if(exists(
        SELECT 1
        where cod_centro = new.cod_centro
        GROUP BY tipo_especialidad, cod_especialidad
        having count(*) > 1
    )) THEN
        RAISE EXCEPTION 'HAY MUCHOS MEDICOS POR ESPECIALIDAD EN EL % %', NEW.COD_CENTRO, NEW.NOMBRE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create trigger tr_sala_atencion
    before update of sala_atencion
    on centro_salud
    FOR EACH ROW
    when ( new.sala_atencion = true)
EXECUTE PROCEDURE fn_control_cant_medicos_update();
