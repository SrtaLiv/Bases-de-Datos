--Todo proyecto debe tneer un directivo si tiene perosnal trabajando en el
--CHEQUEAR QUE NO EXISTAN PROYECTOS CON DIRECTIVOS SIN PERSONAL
ALTER TABLE controlarPersonalDirectivos
    ADD CONSTRAINT ASSERTION
    CHECK ( NOT EXISTS(
        SELECT 1
        FROM trabaja_en t
        WHERE NOT EXISTS(
            SELECT 1
            FROM DIRECTIVO D
            WHERE D.COD_TIPO_proyecto = t.cod_proyecto
            and d.id_proyecto = t.id_proyecto
        )
    ) )



CREATE ASSERTION ck_medico_sala
CHECK (
    NOT EXIST(
    SELECT 1
    FROM productos_x_sucursal p
    JOIN sucursal s on (p.cod_sucursal = s.cod_sucursal)
    WHERE c.sucural_rural = true
    GROUP BY tipo_categoria, cod_categoria, s.cod_sucursal
    HAVING COUNT(*) > 50
)

CREATE VIEW Envios500 AS
SELECT * FROM ENVIO
WHERE cantidad>=500;