/*
 TP7- VISTAS

 EJERCICIO 1:
 a) Distribuidor_200 es actualizable porque la vista contiene la PK de DISTRIBUIDOR
 En cambio Departamento_dist_200 no es actualizable porque la tabla departamento tiene dos PK (id_departamento y id_distribuidor)
 y en la vista solo ponen id_departamento.
 b)FALLA PORQUE SI BIEN LA VISTA ES ACTUALIZABLE VIOLA UN RESTRINCCION DE PK
 Ya que el id_distribuidor 1050 existe.
 */

 --EJERCICIO 2
/*
1. Cree una vista EMPLEADO_DIST que liste el nombre, apellido, sueldo, y fecha_nacimiento de
 los empleados que pertenecen al distribuidor cuyo identificador es 20.
*/
CREATE VIEW EMPLEADO_DIST AS
    SELECT nombre, apellido, sueldo, fecha_nacimiento
    FROM esq_peliculas_empleado
    WHERE id_distribuidor= 20;

SELECT *
FROM EMPLEADO_DIST;

--No es una vista actualizable ni para el estandar ni para postgresql ya que no tiene la pk de empleado (VISTA KEY PRESERVED)
-- Es de Proyeccion-Seleccion

/*
 2. Sobre la vista anterior defina otra vista EMPLEADO_DIST_2000 con el nombre, apellido y sueldo
de los empleados que cobran más de 2000.
 */

CREATE VIEW EMPLEADO_DIST_2000 AS
    SELECT nombre,apellido, sueldo
    FROM EMPLEADO_DIST
    WHERE sueldo > 2000;

SELECT *
FROM EMPLEADO_DIST_2000;

-- No es actualizable por la misma razon anterior. No respeta la VISTA KEY PRESERVED
-- Es de Proyeccion-Seleccion

/*
 3. Sobre la vista EMPLEADO_DIST cree la vista EMPLEADO_DIST_20_70 con aquellos
empleados que han nacido en la década del 70 (entre los años 1970 y 1979).
 */
CREATE VIEW EMPLEADO_DIST_20_70 AS
    SELECT nombre
    FROM EMPLEADO_DIST
    WHERE extract(year from fecha_nacimiento) BETWEEN 1970 AND 1979;

SELECT *
FROM EMPLEADO_DIST_20_70;

--No es actualizable por la misma razon
-- Es de Proyeccion-Seleccion

/*
 4. Cree una vista PELICULAS_ENTREGADA que contenga el código de la película y la cantidad de
unidades entregadas.
 */

CREATE VIEW PELICULAS_ENTREGADAS AS
    SELECT codigo_pelicula, cantidad
    FROM esq_peliculas_renglon_entrega;

SELECT *
FROM PELICULAS_ENTREGADAS;

--No es actualizable porque solo contiene una PK (codigo_pelicula) y la tabla renglon_entrega tiene dos PK (codigo_pelicula y nro_entrega)
-- Es de Proyeccion_Seleccion

/*
 5. Cree una vista ACCION_2000 con el código, el titulo el idioma y el formato de las películas del
género ‘Acción’ entregadas en el año 2006.
 */

CREATE VIEW ACCION_2000 AS
    SELECT p.codigo_pelicula, p.titulo, p.idioma, p.formato
    FROM esq_peliculas_pelicula p
    WHERE p.codigo_pelicula IN (
            SELECT re.codigo_pelicula
            FROM esq_peliculas_renglon_entrega re
            WHERE re.nro_entrega IN (
                SELECT e.nro_entrega
                FROM esq_peliculas_entrega e
                WHERE extract (year from e.fecha_entrega) = 2006))
    AND p.genero = 'Acción';

SELECT *
FROM ACCION_2000;

--Es actualizable para postgresql
--Es de Proyeccion-Seleccion
/*
 6. Cree una vista DISTRIBUIDORAS_ARGENTINA con los datos completos de las distribuidoras
nacionales y sus respectivos departamentos.
 */

CREATE VIEW DISTRIBUIDORAS_ARGENTINAS AS
    SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono, n.nro_inscripcion, n.encargado, n.id_distrib_mayorista, de.id_departamento
    FROM esq_peliculas_distribuidor d
    NATURAL JOIN esq_peliculas_nacional n
    INNER JOIN esq_peliculas_departamento de
    ON (d.id_distribuidor= de.id_distribuidor);

select *
from DISTRIBUIDORAS_ARGENTINAS;

--Para el estandar si es actualizable. Para postgresql no estructuralmente, ya que en el from hay join
--Es de Proyeccion-Seleccion-Esamble
/*
 7. De la vista anterior cree la vista Distribuidoras_mas_2_emp con los datos completos de las
distribuidoras cuyos departamentos tengan más de 2 empleados.
 */
CREATE VIEW DISTRIBUIDORAS_MAS_2_EMPLEADOS AS
    SELECT *
    FROM DISTRIBUIDORAS_ARGENTINAS da
    WHERE (
        SELECT count(id_empleado)
        FROM DISTRIBUIDORAS_ARGENTINAS da
        INNER JOIN esq_peliculas_empleado e
        ON da.id_departamento= e.id_departamento AND da.id_distribuidor= e.id_distribuidor) >2;

SELECT *
FROM DISTRIBUIDORAS_MAS_2_EMPLEADOS;

--No es actualizable porque la vista anterior no es
--Es de Proyeccion-Seleccion

/*
 8. Cree la vista PELI_ARGENTINA con los datos completos de las productoras y las películas que
fueron producidas por empresas productoras de nuestro país.
 */

CREATE VIEW PELI_ARGENTINA AS
    SELECT *
    FROM esq_peliculas_pelicula p
    NATURAL JOIN esq_peliculas_empresa_productora e
    WHERE e.id_ciudad IN (
        SELECT c.id_ciudad
        FROM esq_peliculas_ciudad c
        WHERE c.id_pais = 'AR');

SELECT *
FROM PELI_ARGENTINA;

--Para el estandar si es actualizable. Para postgresql no estructuralmente, ya que en el from hay join
--Es de Proyeccion-Seleccion-Esamble

/*
 9. De la vista anterior cree la vista ARGENTINAS_NO_ENTREGADA para las películas producidas
por empresas argentinas pero que no han sido entregadas
 */
CREATE VIEW ARGENTINAS_NO_ENTREGADA AS
    SELECT *
    FROM PELI_ARGENTINA p
    WHERE NOT EXISTS (
        SELECT e.codigo_pelicula
        FROM esq_peliculas_renglon_entrega e
        WHERE p.codigo_pelicula= e.codigo_pelicula
    );

SELECT *
FROM ARGENTINAS_NO_ENTREGADA;

/*
 10. Cree una vista PRODUCTORA_MARKETINERA con las empresas productoras que hayan
entregado películas a TODOS los distribuidores.
 */

/*
 Ejercicio 3
Analice cuáles serían los controles y el comportamiento ante actualizaciones sobre las vistas
EMPLEADO_DIST, EMPLEADO_DIST_2000 y EMPLEADO_DIST_20_70 creadas en el ej. 2, si las
mismas están definidas con WITH CHECK OPTION LOCAL o CASCADE en cada una de ellas.
Evalúe todas las alternativas.
 */

CREATE VIEW EMPLEADO_DIST AS
    SELECT nombre, apellido, sueldo, fecha_nacimiento
    FROM esq_peliculas_empleado
    WHERE id_distribuidor= 20;
/*
 Con WITH LOCAL CHECK OPTION O WITH CASCADE CHECK OPTION.
 INSERT: con id_distribuidor 20
 UPDATE: no tiene que ser 20 el id_distribuidor que cambiemos
 DELETE: no se puede eliminar el id_distribuidor 20
 */

CREATE VIEW EMPLEADO_DIST_2000 AS
    SELECT nombre,apellido, sueldo
    FROM EMPLEADO_DIST
    WHERE sueldo > 2000;

/*
 Con WITH LOCAL CHECK OPTION
 INSERT: empleados con sueldo mayor a 2000
 UPDATE: idem
 DELETE: no pueden eliminarse empleados con sueldo mayor a 2000

 O WITH CASCADE CHECK OPTION.
INSERT: empleados con sueldo mayor a 2000 y con id_distribuidor 20
 UPDATE: idem
 DELETE: idem, no se pueden eliminar esos
 */

CREATE VIEW EMPLEADO_DIST_20_70 AS
    SELECT nombre
    FROM EMPLEADO_DIST
    WHERE extract(year from fecha_nacimiento) BETWEEN 1970 AND 1979;

/*
 Con WITH LOCAL CHECK OPTION
 INSERT: empleados nacidos entre 1970 y 1979
 UPDATE: idem
 DELETE: no pueden eliminarse empleados nacidos en esa fecha

 O WITH CASCADE CHECK OPTION.
INSERT: empleados con sueldo mayor a 2000, con id_distribuidor 20, y nacidos en esa fecha
 UPDATE: idem
 DELETE: idem, no se pueden eliminar esos
 */



/*
 Usar trigger en este ejemplo para que sea actualizable en postgresql
  6. Cree una vista DISTRIBUIDORAS_ARGENTINA con los datos completos de las distribuidoras
nacionales y sus respectivos departamentos.
 */
CREATE TABLE DISTRIBUIDOR AS
    SELECT *
    FROM esq_peliculas_distribuidor;

CREATE TABLE NACIONAL AS
    SELECT *
    FROM esq_peliculas_nacional;

CREATE TABLE DEPARTAMENTO AS
    SELECT *
    FROM esq_peliculas_departamento;

CREATE VIEW DISTRIBUIDORAS_ARGENTINAS_ACTUALIZABLE AS
    SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono, n.nro_inscripcion, n.encargado, n.id_distrib_mayorista, de.id_departamento
    FROM distribuidor d
    NATURAL JOIN nacional n
    INNER JOIN departamento de
    ON (d.id_distribuidor= de.id_distribuidor);

select *
from DISTRIBUIDORAS_ARGENTINAS_ACTUALIZABLE;

CREATE OR REPLACE FUNCTION fn_actualizar_vista_distribuidoras()
RETURNS TRIGGER AS $$
    BEGIN
IF (TG_OP='INSERT')THEN
    UPDATE DISTRIBUIDOR SET id_departamento= new.id_distribuidor, nombre= new.nombre,
    direccion= new.direccion, telefono= new.telefono
    WHERE id_distribuidor= new.id_distribuidor;
    UPDATE NACIONAL SET nro_inscripcion= new.nro_inscripcion, encargado= new.encargado,
    id_distrib_mayorista= new.id_distrib_mayorista
    WHERE id_distribuidor= new.id_distribuidor;
end if;
RETURN NULL;
end;$$ LANGUAGE 'plpgsql';



INSERT INTO NACIONAL (id_distribuidor, nro_inscripcion, encargado, id_distrib_mayorista) VALUES
(2000, 12, 'yo', 33333);

CREATE TRIGGER tr_actualizar_vista_distribuidoras_argentinas
INSTEAD OF INSERT OR UPDATE OR DELETE
ON DISTRIBUIDORAS_ARGENTINAS_ACTUALIZABLE
FOR EACH ROW
EXECUTE PROCEDURE fn_actualizar_vista_distribuidoras();
