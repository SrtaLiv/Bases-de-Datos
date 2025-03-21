--PARTE UNO
/*1. Seleccione el identificador y nombre de todas las instituciones que son Fundaciones.(V)*/
select id_institucion, nombre_institucion
from unc_esq_voluntario.institucion
where nombre_institucion LIKE 'FUNDACION%';

/*2. Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos
los departamentos.(P)*/
select id_distribuidor, id_departamento, nombre
from unc_esq_peliculas.departamento;

/*3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231,
ordenados por apellido y nombre.(P)*/
select nombre, apellido, telefono
from unc_esq_peliculas.empleado
where id_tarea = '7231'
order by apellido, nombre;

/*4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de
comisión.(P)*/
select id_empleado, apellido
from unc_esq_peliculas.empleado
where porc_comision IS NULL;

/*5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen
coordinador.(V)*/
select apellido, id_tarea
from unc_esq_voluntario.voluntario
where id_coordinador IS NULL;

/*6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono.
(P)*/
select *
from unc_esq_peliculas.distribuidor
where tipo = 'I' AND telefono IS NULL;

/*7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo
sueldo sea superior a $ 1000. (P)*/
select apellido, nombre, e_mail
from unc_esq_peliculas.empleado
where e_mail LIKE '%@gmail%' AND sueldo > 1000;

/*8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)*/
select distinct id_tarea
from unc_esq_peliculas.empleado
order by id_tarea;

/*9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
+51. Coloque el encabezado de las columnas de los títulos &#39;Apellido y Nombre&#39; y &#39;Dirección
de mail&#39;. (V)*/
select apellido ||' '|| nombre AS "Apellido y nombre", e_mail AS "Direccion de mail"
from unc_esq_voluntario.voluntario
where telefono like '+51%';

/*10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
el apellido (concatenados y separados por una coma) y su fecha de cumpleaños (solo el
día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)*/
select nombre ||' '|| apellido AS "nombre y apellido",
    extract(month from fecha_nacimiento) || '-' ||
    extract(day from fecha_nacimiento) AS "Fecha de cumpleaños"
from unc_esq_peliculas.empleado
order by extract(month from fecha_nacimiento),
    extract(day from fecha_nacimiento);

/*11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios
nacidos desde 1990. (V)*/
select MAX(horas_aportadas) AS "Hora maxima",
       MIN(horas_aportadas) AS "Hora minima",
       AVG(horas_aportadas)
from unc_esq_voluntario.voluntario
where extract(year from fecha_nacimiento) >= '1990';

/*12. Listar la cantidad de películas que hay por cada idioma. (P)*/
select distinct idioma, count(*) AS "cantidad de peliculas"
from unc_esq_peliculas.pelicula
group by idioma;

/*13. Calcular la cantidad de empleados por departamento. (P)*/
select distinct id_departamento, count(*) AS "cantidad de empleados"
from unc_esq_peliculas.empleado
group by id_departamento;

/*14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas,
NO cantidad de películas entregadas).*/
select distinct codigo_pelicula
from unc_esq_peliculas.renglon_entrega
where nro_entrega between 3 AND 5;

/*15. ¿Cuántos cumpleaños de voluntarios hay cada mes?*/
select extract(month from fecha_nacimiento) AS mes, count(*) AS "cantidad de cumpleaños"
from unc_esq_voluntario.voluntario
group by mes
order by mes;

/*16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?*/
select id_institucion, count(*)
from unc_esq_voluntario.institucion
group by id_institucion
order by count(*) desc
limit 2;

/*17. ¿Cuáles son los id de ciudades que tienen más de un departamento?*/
select id_ciudad, count(id_ciudad) AS cant_departamentos
from unc_esq_peliculas.departamento
group by id_ciudad
having count(id_ciudad) > 1;
/*having es teniendo*/






--PARTE 2
/*1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante
el año 2006.*/
SELECT titulo, idioma
FROM unc_esq_peliculas.pelicula p
WHERE p.idioma = 'Inglés' AND p.codigo_pelicula IN (
    SELECT codigo_pelicula
    FROM unc_esq_peliculas.renglon_entrega r
    WHERE r.nro_entrega IN (
        SELECT nro_entrega
        FROM unc_esq_peliculas.entrega e
        WHERE extract(year from fecha_entrega) = '2006'
    )
);

/*1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
nacional. Trate de resolverlo utilizando ensambles.*/
select count(*)
from unc_esq_peliculas.pelicula p
where codigo_pelicula IN(
    select codigo_pelicula
    from unc_esq_peliculas.renglon_entrega r
    where r.nro_entrega IN (
        select nro_entrega
        from unc_esq_peliculas.entrega e
        where extract(year from fecha_entrega) = '2006' AND e.id_distribuidor IN(
            select id_distribuidor
            from unc_esq_peliculas.distribuidor d
            where d.tipo = 'N'
            )
        )
    )

/*1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
(P) (Probar con 10% para que retorne valores)*/
Select nombre
from unc_esq_peliculas.departamento d
where not exists(
    select sueldo
    from unc_esq_peliculas.empleado e
        inner join unc_esq_peliculas.tarea t on t.id_tarea = e.id_tarea
        where (t.sueldo_maximo - t.sueldo_minimo) < (e.sueldo*0.1)
);

/*1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.*/
select titulo
from unc_esq_peliculas.pelicula p
where codigo_pelicula NOT IN (
    select codigo_pelicula
    from unc_esq_peliculas.renglon_entrega e
    where e.nro_entrega IN (
        select nro_entrega
        from unc_esq_peliculas.entrega
        where id_distribuidor IN(
        select id_distribuidor
        from unc_esq_peliculas.distribuidor d
        where d.tipo='N'
        )
    )
)
/*1.4a. Liste las películas que han sido entregadas
por un distribuidor nacional.*/
select titulo
from unc_esq_peliculas.pelicula p
where codigo_pelicula IN (
    select codigo_pelicula
    from unc_esq_peliculas.renglon_entrega e
    where e.nro_entrega NOT IN (
        select nro_entrega
        from unc_esq_peliculas.entrega
        where id_distribuidor IN(
        select id_distribuidor
        from unc_esq_peliculas.distribuidor d
        where d.tipo='N'
        )
    )
)
/*1.5. Determinar los jefes que poseen personal a cargo
y cuyos departamentos (los del jefe) se encuentren en la Argentina.*/
select *
from unc_esq_peliculas.empleado e
where e.id_empleado IN (
    select d.jefe_departamento
    FROM unc_esq_peliculas.departamento d
    where d.id_ciudad IN(
        select c.id_ciudad
        from unc_esq_peliculas.ciudad c
        where c.id_pais IN(
            select p.id_pais
            from unc_esq_peliculas.pais p
            where p.id_pais LIKE 'AR'
        )
    )
)

/*1.6. Liste el apellido y nombre de los empleados que pertenecen
a aquellos departamentos de Argentina y donde el jefe de departamento
posee una comisión de más del 10% de la que posee su empleado a cargo.*/

SELECT e.nombre, e.apellido, e.id_departamento, e.id_distribuidor, d.jefe_departamento
FROM unc_esq_peliculas.empleado e JOIN unc_esq_peliculas.departamento d
    ON (e.id_departamento = d.id_departamento AND e.id_distribuidor = d.id_distribuidor)
JOIN unc_esq_peliculas.empleado e2 ON (d.jefe_departamento = e2.id_empleado)
WHERE d.id_ciudad IN (SELECT c.id_ciudad
                      FROM unc_esq_peliculas.ciudad c
                      WHERE c.id_pais = 'AR')
AND
e2.porc_comision > (e.porc_comision * 0.1);


/*1.7. Indicar la cantidad de películas entregadas
a partir del 2010, por género.*/
SELECT COUNT(cantidad), genero
FROM unc_esq_peliculas.renglon_entrega re
    INNER JOIN unc_esq_peliculas.pelicula p
        ON re.codigo_pelicula = p.codigo_pelicula
        WHERE nro_entrega IN(
            SELECT nro_entrega
            FROM unc_esq_peliculas.entrega e
            WHERE extract(years from fecha_entrega) >='2010'
            )
            GROUP BY genero;

/*1.8. Realizar un resumen de entregas por día, indicando el video
club al cual se le realizó la entrega y la cantidad entregada.
Ordenar el resultado por fecha.*/
SELECT extract(day from e.fecha_entrega) AS dia, e.id_video AS videoClub, SUM(re.cantidad) AS cantidad
FROM unc_esq_peliculas.entrega e
         INNER JOIN unc_esq_peliculas.renglon_entrega re
                ON e.nro_entrega = re.nro_entrega
GROUP BY e.fecha_entrega, e.id_video
ORDER BY fecha_entrega

/*1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad
de empleados mayores de edad que desempeñan tareas en departamentos
de la misma y que posean al menos 30 empleados.*/

SELECT c.nombre_ciudad, COUNT(e.id_empleado>=30)
FROM unc_esq_peliculas.ciudad c
    INNER JOIN unc_esq_peliculas.departamento d
    ON c.id_ciudad = d.id_ciudad
    INNER JOIN unc_esq_peliculas.empleado e
    ON d.id_distribuidor = e.id_distribuidor and d.id_departamento = e.id_departamento
WHERE extract(YEAR FROM AGE(fecha_nacimiento)) >= 18
    AND e.id_tarea IS NOT NULL
GROUP BY c.nombre_ciudad
HAVING count(e.id_empleado) >= 30

/*Ejercicio 2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan
aportes. Ordene el resultado por nombre de institución.*/

SELECT count(i.id_institucion) AS cantidadVoluntarios, i.nombre_institucion
FROM unc_esq_voluntario.institucion i INNER JOIN unc_esq_voluntario.voluntario v
    ON i.id_institucion = v.id_institucion
WHERE v.horas_aportadas IS NOT NULL
GROUP BY i.nombre_institucion
ORDER BY nombre_institucion;

/*Ejercicio 2.2. Determine la cantidad de coordinadores
  en cada país, agrupados por nombre de
país y nombre de continente. Etiquete la primer
  columna como Número de coordinadores*/

SELECT count(p.id_pais) AS "Numero de coordinadores", nombre_pais, nombre_continente
FROM unc_esq_voluntario.voluntario v INNER JOIN unc_esq_voluntario.institucion i
ON (i.id_institucion= v.id_institucion)
INNER JOIN unc_esq_voluntario.direccion d ON i.id_direccion= d.id_direccion
INNER JOIN unc_esq_voluntario.pais p ON d.id_pais= p.id_pais
INNER JOIN unc_esq_voluntario.continente c ON p.id_continente= c.id_continente
WHERE v.id_coordinador IS NOT NULL
GROUP BY p.nombre_pais, c.nombre_continente;


/* 2.3. Escriba una consulta para mostrar el apellido, nombre y fecha de nacimiento de cualquier voluntario que trabaje en la misma institución que el Sr. de apellido Zlotkey. Excluya del resultado a Zlotkey.*/
SELECT v.apellido, v.nombre, v.fecha_nacimiento
FROM voluntario v
WHERE ((v.id_institucion = (
    SELECT v2.id_institucion
    FROM voluntario v2
    WHERE v2.apellido = 'Zlotkey'
    ))
    AND
    (v.apellido <> 'Zlotkey')
    );

/*2.4. Cree una consulta para mostrar los números de voluntarios
y los apellidos de todos los voluntarios cuya cantidad de horas
aportadas sea mayor que la media de las horas aportadas.
Ordene los resultados por horas aportadas en orden ascendente.*/

SELECT v.nro_voluntario, v.apellido
FROM unc_esq_voluntario.voluntario v
GROUP BY v.nro_voluntario, v.apellido
HAVING v.horas_aportadas >(
    SELECT AVG(v.horas_aportadas)
    FROM unc_esq_voluntario.voluntario v)
ORDER BY v.horas_aportadas

/*EJERCICIO 3*/

CREATE TABLE DistribuidorNac
(
id_distribuidor numeric(5,0) NOT NULL,
nombre character varying(80) NOT NULL,
direccion character varying(120) NOT NULL,
telefono character varying(20),
nro_inscripcion numeric(8,0) NOT NULL,
encargado character varying(60) NOT NULL,
id_distrib_mayorista numeric(5,0),
CONSTRAINT pk_distribuidorNac PRIMARY KEY (id_distribuidor)
);

/*3.1 Se solicita llenarla con la información correspondiente
a los datos completos de todos los distribuidores nacionales.*/
INSERT INTO DistribuidorNac(id_distribuidor, nombre, direccion,
    telefono, nro_inscripcion, encargado, id_distrib_mayorista)
VALUES(1, 'Marta', 'rivas 920', '2494556089', 1, 'cocina', null),
      (2, 'Juana', 'mexico 333', '2494223040', 2, 'limpieza', 6),
      (3, 'lorenzo', 'garibaldi 245', '24945165', 3, 'handball', null),
      (4, 'florencia', 'maritorena 223', '249567865', 4, 'pilates',1),
      (5, 'branco', 'maritorena 223', '2494324512', 5, 'comer',5),
      (6, 'rufi', 'maritorena 223', '2494324512', 6, 'romper pantalones', null);

SELECT *
FROM DistribuidorNac;

/*3.2 Agregar a la definición de la tabla DistribuidorNac,
el campo "codigo_pais"; que indica el código de país
del distribuidor mayorista que atiende a cada distribuidor
nacional.(codigo_pais character varying(5) NULL)*/

ALTER TABLE DistribuidorNac
ADD "codigo_pais" character varying(5);

/*3.3. Para todos los registros de la tabla DistribuidorNac,
llenar el nuevo campo" codigo_pais" con el valor correspondiente
existente en la tabla Internacional*/

UPDATE DistribuidorNac SET id_distribuidor=10 WHERE id_distribuidor=1;
UPDATE DistribuidorNac SET id_distribuidor=11 WHERE id_distribuidor=2;
UPDATE DistribuidorNac SET id_distribuidor=13 WHERE id_distribuidor=6;


UPDATE DistribuidorNac SET codigo_pais = 'BW' WHERE id_distribuidor= 10;
UPDATE DistribuidorNac SET codigo_pais = 'MZ' WHERE id_distribuidor= 11;
UPDATE DistribuidorNac SET codigo_pais = 'FO' WHERE id_distribuidor= 3;
UPDATE DistribuidorNac SET codigo_pais = 'SY' WHERE id_distribuidor= 4;
UPDATE DistribuidorNac SET codigo_pais = 'NE' WHERE id_distribuidor= 5;
UPDATE DistribuidorNac SET codigo_pais = 'TD' WHERE id_distribuidor= 13;

/*3.4. Eliminar de la tabla DistribuidorNac los registros que
no tienen asociado un distribuidor mayorista.*/

DELETE FROM DistribuidorNac where id_distrib_mayorista IS NULL;


SELECT *
FROM DistribuidorNac;







