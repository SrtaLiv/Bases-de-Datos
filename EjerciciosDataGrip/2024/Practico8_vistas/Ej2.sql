--1. Cree una vista EMPLEADO_DIST que liste el nombre, apellido, sueldo, y fecha_nacimiento de
--los empleados que pertenecen al distribuidor cuyo identificador es 20.

--NO ES ACTUALIZABLE
CREATE VIEW EMPLEADO_DIST AS
SELECT nombre, apellido, sueldo, fecha_nacimiento
FROM unc_esq_peliculas.empleado WHERE id_distribuidor = 20;

--2. Sobre la vista anterior defina otra vista EMPLEADO_DIST_2000 con el nombre, apellido y sueldo
-- de los empleados que cobran más de 2000.

--NO ES ACTUALIZABLE!
CREATE VIEW EMPLEADO_DIST_2000  AS
SELECT nombre, apellido, sueldo
FROM EMPLEADO_DIST WHERE sueldo > 2000;

--3. Sobre la vista EMPLEADO_DIST cree la vista EMPLEADO_DIST_20_70 con aquellos
-- empleados que han nacido en la década del 70 (entre los años 1970 y 1979).
CREATE VIEW EMPLEADO_DIST_20_70 AS
SELECT *
FROM EMPLEADO_DIST
WHERE extract(YEAR FROM fecha_nacimiento) BETWEEN 1970 AND 1979;

--4. Cree una vista PELICULAS_ENTREGADA que contenga el código de la película y la cantidad de
--unidades entregadas.
CREATE VIEW PELICULAS_ENTREGADA AS
SELECT p.codigo_pelicula,r.cantidad
FROM unc_esq_peliculas.pelicula p
    JOIN unc_esq_peliculas.renglon_entrega r ON r.codigo_pelicula = p.codigo_pelicula

