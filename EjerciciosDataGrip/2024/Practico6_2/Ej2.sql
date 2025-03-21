/*
 Ejercicio 2
A partir del esquema unc_peliculas, realice procedimientos para:

c) Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas
más entregadas en los últimos seis meses desde la ejecución del procedimiento. Esta tabla
por lo menos debe tener las columnas código_pelicula, nombre, cantidad_de_entregas
 (en caso de coincidir en cantidad de entrega ordenar por código de película).
*/
 --tenes que crear la tabla mas entrgadas con los datos de las 20 películas más entregadas en los últimos seis meses desde la ejecución del procedimiento
CREATE TABLE MAS_ENTREGADAS
    (codigo_pelicula INTEGER,
     nombre varchar(30),
     cantidad_de_entregas integer);

SELECT * FROM unc_esq_peliculas.pelicula;
SELECT * FROM unc_esq_peliculas.renglon_entrega;
SELECT * FROM MAS_ENTREGADAS;


--crear cursor de las 20 peliculas
CREATE OR REPLACE FUNCTION pelis_mas_entregadas()
RETURNS VOID AS $$
DECLARE
    cr CURSOR FOR
        SELECT p.codigo_pelicula, p.titulo, COUNT(*) AS cant_entregas
        FROM pelicula p
        JOIN unc_esq_peliculas.renglon_entrega re ON re.codigo_pelicula = p.codigo_pelicula
        JOIN unc_esq_peliculas.entrega ent ON ent.nro_entrega = re.nro_entrega
        WHERE ent.fecha_entrega >= NOW() - INTERVAL '6 months'
        GROUP BY p.codigo_pelicula, p.titulo
        ORDER BY COUNT(*) DESC, p.codigo_pelicula
        LIMIT 20;
    pelicula RECORD;
BEGIN
    TRUNCATE TABLE MAS_ENTREGADAS; -- Limpiar la tabla antes de llenarla

    OPEN cr; -- Abrir el cursor
    LOOP
        FETCH cr INTO pelicula; -- Obtener la siguiente fila del cursor
        EXIT WHEN pelicula IS NULL; -- Salir del bucle si no hay más filas

        INSERT INTO MAS_ENTREGADAS (codigo_pelicula, nombre, cantidad_de_entregas)
        VALUES (pelicula.codigo_pelicula, pelicula.titulo, pelicula.cant_entregas);
    END LOOP;

    CLOSE cr; -- Cerrar el cursor
END;
$$ LANGUAGE plpgsql;

SELECT pelis_mas_entregadas();
SELECT * FROM MAS_ENTREGADAS;
