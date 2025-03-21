/*
 Ejercicio 1
Considere las siguientes sentencias de creación de vistas en el esquema de Películas:

Nota: el planteo es sólo teórico porque no podrá insertar registros en unc_esq_peliculas por los
permisos */


CREATE VIEW Distribuidor_200 AS
SELECT id_distribuidor, nombre, tipo
FROM unc_esq_peliculas.distribuidor
WHERE id_distribuidor > 200;


CREATE VIEW Departamento_dist_200 AS
SELECT id_departamento, nombre, id_ciudad, jefe_departamento
FROM unc_esq_peliculas.departamento
WHERE id_distribuidor > 200;

 --Discuta si las vistas son actualizables o no y justifique.

--RTAS:
 --si es actualizable pero la segunda no porque le falta seleccionar
-- la clave primaria de id_distributiodr en la tbala departamento

 --C. Falla porque si bien la vista es actualizable viola una restricción de primary key.