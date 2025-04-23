Set SEARCH_PATH = unc_esq_voluntario;
Set SEARCH_PATH = unc_esq_peliculas;
-- Ejercicio 1
-- Consultas con anidamiento (usando IN, NOT IN, EXISTS, NOT EXISTS):

-- 1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante
-- el año 2006. (P)
SELECT p.codigo_pelicula
FROM pelicula p
WHERE p.idioma = 'Inglés'
  AND EXISTS (
    SELECT 1
    FROM renglon_entrega r
    JOIN entrega e ON r.nro_entrega = e.nro_entrega
    WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006
      AND r.codigo_pelicula = p.codigo_pelicula
  );

-- distinct sin repetidos
SELECT DISTINCT  p.codigo_pelicula
FROM pelicula p
JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
JOIN entrega e ON re.nro_entrega = e.nro_entrega
WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006
AND p.idioma = 'Inglés';


-- 1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
-- nacional. Trate de resolverlo utilizando ensambles.(P)
-- fecha entrega 2006: esq_pel_entrega -> fecha_entrega
-- distribuidor nacional: esq_pel_distribuidor -> tipo NACIONAL
SELECT count(r.codigo_pelicula)
FROM unc_esq_peliculas.renglon_entrega r
JOIN unc_esq_peliculas.entrega e ON r.nro_entrega = e.nro_entrega
JOIN unc_esq_peliculas.distribuidor d ON d.id_distribuidor = e.id_distribuidor
WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006
AND d.tipo = 'N';

-- 1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
-- máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
-- (P) (Probar con 10% para que retorne valores)
select id_departamento, nombre
from "Tudai25".unc_esq_peliculas.departamento
where id_departamento IN (
        select id_departamento
        from "Tudai25".unc_esq_peliculas.empleado e
        join "Tudai25".unc_esq_peliculas.tarea t on e.id_tarea = t.id_tarea
        where (t.sueldo_maximo - t.sueldo_minimo) < t.sueldo_maximo * 0.40);

-- 1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)
SELECT * FROM "Tudai25".unc_esq_peliculas.entrega
JOIN unc_esq_peliculas.distribuidor d on entrega.id_distribuidor = d.id_distribuidor
WHERE NOT d.tipo = 'N';

SELECT p.codigo_pelicula, p.titulo
FROM "Tudai25".unc_esq_peliculas.pelicula p
WHERE NOT EXISTS (
    SELECT 1
    FROM "Tudai25".unc_esq_peliculas.entrega e
    JOIN "Tudai25".unc_esq_peliculas.distribuidor d
        ON e.id_distribuidor = d.id_distribuidor
    WHERE e.codigo_pelicula = p.codigo_pelicula
      AND d.tipo = 'N'
);


-- 1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
-- jefe) se encuentren en la Argentina.


-- 1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos
-- departamentos de Argentina y donde el jefe de departamento posee una comisión de más
-- del 10% de la que posee su empleado a cargo.
-- empleado, departametos
SELECT e.nombre, e.apellido
FROM empleado e
JOIN unc_esq_peliculas.departamento d USING (id_departamento)
JOIN unc_esq_peliculas.ciudad c USING (id_ciudad)
JOIN unc_esq_peliculas.pais p USING (id_pais)
WHERE p.nombre_pais = 'Argentina';



-- 1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad de empleados
-- mayores de edad que desempeñan tareas en departamentos de la misma y que posean al
-- menos 30 empleados.
SELECT c.nombre_ciudad, count(id_empleado)
FROM unc_esq_peliculas.ciudad c
JOIN unc_esq_peliculas.departamento d on c.id_ciudad = d.id_ciudad
JOIN unc_esq_peliculas.empleado e USING (id_departamento, id_distribuidor)
WHERE ( extract(year from now()) - extract(year from e.fecha_nacimiento)) > 18
AND (d.id_distribuidor, d.id_departamento) IN (
    -- : ¿este departamento con este distribuidor tiene al menos 30 empleados?
    SELECT e2.id_departamento, e2.id_distribuidor
    FROM empleado e2
    GROUP BY e2.id_departamento, e2.id_distribuidor
    HAVING count(*) >= 30
    )
GROUP BY c.nombre_ciudad;

-- Ejercicio 2
-- 2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan
-- aportes. Ordene el resultado por nombre de institución.
SELECT i.nombre_institucion, count(nro_voluntario)
FROM unc_esq_voluntario.institucion i
JOIN "Tudai25".unc_esq_voluntario.voluntario v
USING (id_institucion)
WHERE v.horas_aportadas IS NOT NULL and v.horas_aportadas > 0
GROUP BY i.nombre_institucion
ORDER BY i.nombre_institucion;

-- 2.2. Determine la cantidad de coordinadores en cada país, agrupados por nombre de
-- país y nombre de continente. Etiquete la primer columna como Número de coordinadores
SELECT count(DISTINCT v.id_coordinador) AS "Numero de coordinadores"
FROM unc_esq_voluntario.pais p
JOIN unc_esq_voluntario.continente c
ON c.id_continente = p.id_continente
JOIN "Tudai25".unc_esq_voluntario.direccion
USING (id_pais)
JOIN "Tudai25".unc_esq_voluntario.institucion i
USING (id_direccion)
JOIN "Tudai25".unc_esq_voluntario.voluntario v
USING (id_institucion)
WHERE v.id_coordinador IS NOT NULL
GROUP BY p.nombre_pais, c.nombre_continente;

-- 2.3. Escriba una consulta para mostrar el apellido, nombre y fecha de nacimiento de
-- cualquier voluntario que trabaje en la misma institución que el Sr. de apellido Zlotkey.
-- Excluya del resultado a Zlotkey.
SELECT nombre, apellido, fecha_nacimiento
FROM unc_esq_voluntario.voluntario v1
WHERE v1.id_institucion in
       (SELECT id_institucion
        FROM unc_esq_voluntario.voluntario v2
        WHERE v2.apellido = 'Zlotkey')
AND v1.apellido != 'Zlotkey';

-- 2.4. Cree una consulta para mostrar los números de voluntarios y los apellidos de todos
-- los voluntarios cuya cantidad de horas aportadas sea mayor que la media de las horas
-- aportadas. Ordene los resultados por horas aportadas en orden ascendente.
SELECT nro_voluntario, apellido
FROM unc_esq_voluntario.voluntario v
WHERE v.horas_aportadas > (
    SELECT avg(v2.horas_aportadas)
    from unc_esq_voluntario.voluntario v2
    -- si no pusiera group by, sacaria el promedio de TODOS los voluntarios
    WHERE v2.horas_aportadas IS NOT NULL
    )
ORDER BY v.horas_aportadas ASC

-- ejercicio 3 dada la sig tabla:
CREATE TABLE distribuidor_nac
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

select * from distribuidor_nac;

INSERT INTO distribuidor_nac (id_distribuidor, nombre, direccion, telefono, nro_inscripcion, encargado, id_distrib_mayorista, tipo, codigo_pais)
VALUES
(1, 'Distribuidor A', 'Calle Falsa 123', '123456789', 12345678, 'Juan Pérez', NULL, 'A', 'ARG'),
(2, 'Distribuidor B', 'Calle Real 456', '987654321', 23456789, 'Ana Gómez', 1, 'B', 'BRA'),
(3, 'Distribuidor C', 'Calle Ejemplo 789', '555123456', 34567890, 'Carlos Ruiz', NULL, 'C', 'CHL');

-- 3.1 Se solicita llenarla con la información correspondiente a los datos completos de
-- todos los distribuidores nacionales.

--ALTER TABLE tabla_nombre ADD COLUMN atributo_nombre tipo_de_dato [restricciones].
-- Por ejemplo, para agregar una columna llamada email de tipo TEXT a la tabla usuarios,
-- se usaría ALTER TABLE usuarios ADD COLUMN email TEXT;

-- falta TIPO
alter table distribuidor_nac ADD COLUMN tipo varchar(1);

-- 3.2 Agregar a la definición de la tabla distribuidor_nac, el campo codigo_pais que
-- indica el código de país del distribuidor mayorista que atiende a cada distribuidor
-- nacional.(codigo_pais varchar(5) NULL)
alter table distribuidor_nac ADD COLUMN codigo_pais varchar(5) NULL;

-- 3.3. Para todos los registros de la tabla distribuidor_nac, llenar el nuevo campo
-- codigo_pais con el valor correspondiente existente en la tabla internacional
UPDATE distribuidor_nac dn
SET codigo_pais = i.codigo_pais
FROM "Tudai25".unc_esq_peliculas.internacional i
WHERE dn.id_distrib_mayorista = i.id_distribuidor;

SELECT id_distribuidor, nombre, id_distrib_mayorista, codigo_pais
FROM distribuidor_nac;

-- 3.4. Eliminar de la tabla distribuidor_nac los registros que no tienen asociado un
-- distribuidor mayorista.
DELETE FROM distribuidor_nac
WHERE id_distrib_mayorista IS NULL;

select * from distribuidor_nac;
