/*
  Ejercicio 4
a) Copie en su esquema la estructura de la tabla PELICULA del esquema unc_peliculas

CREATE TABLE Pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;
b) Cree la tabla ESTADISTICA con la siguiente sentencia:

CREATE TABLE estadistica AS
SELECT genero, COUNT(*) total_peliculas, count (distinct idioma) cantidad_idiomas
FROM Pelicula GROUP BY genero;

c) Cree un trigger que cada vez que se realice una modificación en la tabla película (la creada
en su esquema) tiene que actualizar la tabla estadística.No se olvide de identificar:
i) la granularidad del trigger.
ii) Eventos ante los cuales se debe disparar.
iii) Analice si conviene modificar por cada operación de actualización o reconstruirla de
cero.
 */

CREATE TABLE Pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;

CREATE TABLE estadistica AS
SELECT genero, COUNT(*) total_peliculas, count (distinct idioma) cantidad_idiomas
FROM Pelicula GROUP BY genero;

CREATE TRIGGER tr_actualizar_estadistica
    AFTER INSERT OR UPDATE OR DELETE ON pelicula
    FOR EACH ROW
    EXECUTE FUNCTION actualizarEstadisticas();

CREATE OR REPLACE FUNCTION actualizarEstadisticas() RETURNS TRIGGER AS $$
    DECLARE
        cantIdioma int;
        cantTotal int;
    BEGIN
        SELECT genero, COUNT(*) total_peliculas , count (distinct idioma) cantidad_idiomas FROM Pelicula WHERE genero = new.genero GROUP BY genero;

        IF exists( --si ya existe el genero..
                SELECT 1
                FROM estadistica
                WHERE genero = new.genero --donde nuevo genero sea igual a alguno de estadistica..
                )
        THEN --entonces lo actualizo en mi tabla de estadisticas
             UPDATE estadistica SET
            total_peliculas = cantTotal,
            cantidad_idiomas = cantIdioma
            WHERE genero = new.genero;
        ELSE
            INSERT INTO estadistica (genero, total_peliculas, cantidad_idiomas) VALUES (new.genero, cantTotal, cantIdioma);
    END IF;
RETURN new;
    end;
    $$
LANGUAGE plpgsql;





--
CREATE OR REPLACE FUNCTION fn_estadisticas_peliculas() RETURNS TRIGGER AS $$
DECLARE
    p_genero                    estadistica.genero%type;
    p_total_peliculas           estadistica.total_peliculas%type;
    p_cantidad_idiomas          estadistica.cantidad_idiomas%type;

BEGIN

    SELECT genero, COUNT(*) total_peliculas, count(DISTINCT idioma) cantidad_idiomas
    INTO p_genero, p_total_peliculas, p_cantidad_idiomas
    FROM pelicula
    WHERE genero = NEW.genero
    GROUP BY genero;

    IF EXISTS (SELECT 1 FROM estadistica WHERE genero = p_genero) THEN

        UPDATE estadistica SET
            total_peliculas = p_total_peliculas,
            cantidad_idiomas = p_cantidad_idiomas
        WHERE genero = p_genero;

    ELSE
        INSERT INTO estadistica (genero, total_peliculas, cantidad_idiomas) VALUES (p_genero, p_total_peliculas, p_cantidad_idiomas);

    END IF;

    RETURN NEW;

END; $$
LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER tr_estadisticas_peliculas
    AFTER INSERT OR UPDATE OR DELETE ON pelicula
    FOR EACH ROW
    EXECUTE PROCEDURE fn_estadisticas_peliculas();

drop trigger if exists tr_actualizar_estadistica on pelicula;
select * from pelicula where codigo_pelicula = 120000;

------------
select  count(v.nro_voluntario),t.id_tarea
from unc_esq_voluntario.voluntario v
join unc_esq_voluntario.institucion i on v.id_institucion = i.id_institucion
join unc_esq_voluntario.tarea t on t.id_tarea = v.id_tarea
where t.id_tarea  like '%MAN'
and i.nombre_institucion like 'FUNDACION HOGAR DE CRISTO'
and v.horas_aportadas between 5000 and 7000
group by t.id_tarea