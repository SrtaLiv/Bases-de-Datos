--CONSULTAS: en el 6 como accedo al distribuidor internacional?
-- si est abien dudas en el 14

--2. Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos los departamentos.(P) --
-- Preguntar si esta bien --
SELECT id_distribuidor, id_departamento, id_departamento, id_distribuidor, nombre, calle, numero, id_ciudad, jefe_departamento FROM unc_esq_peliculas.departamento;

--3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231, ordenados por apellido y nombre.(P)--
SELECT nombre, apellido, telefono
FROM  unc_esq_peliculas.empleado
WHERE id_tarea = '7231'
ORDER BY apellido, nombre;

--4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de comisión.(P)--
SELECT apellido FROM empleado WHERE porc_comision is null;

-- 6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono. (P)
SELECT * FROM distribuidor WHERE telefono IS NULL;

--7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo sueldo sea superior a $ 1000. (P)
SELECT apellido, nombre, e_mail FROM empleado WHERE e_mail LIKE '%gmail%' AND sueldo > 1000;

--8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)
SELECT DISTINCT id_tarea FROM empleado;
SELECT id_tarea FROM empleado;

--10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
--el apellido (concatenados y separados por una coma)
-- y su fecha de cumpleaños (solo el día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)
SELECT empleado.nombre, empleado.apellido, empleado.fecha_nacimiento FROM empleado;

SELECT CONCAT(empleado.nombre, ', ', empleado.apellido) nombre,
       TO_CHAR(empleado.fecha_nacimiento, 'DD-MM-YY') AS cumpleanos
FROM empleado
--WHERE EXTRACT(YEAR FROM empleado.fecha_nacimiento) >= 1989
ORDER BY EXTRACT(MONTH FROM empleado.fecha_nacimiento), EXTRACT(DAY FROM empleado.fecha_nacimiento);




--12. Listar la cantidad de películas que hay por cada idioma. (P)
    SELECT idioma, count(idioma) AS cantidad_peliculas FROM pelicula GROUP BY idioma;

--13. Calcular la cantidad de empleados por departamento. (P)
    SELECT id_departamento, count(nombre) AS cantidad_empleados FROM empleado GROUP BY id_departamento;

--extra yo:_ calcular la cantidad de generos que hay por cada peliculas
    SELECT genero, count(genero) AS cant_generos_por_peli FROM pelicula GROUP BY genero;
    --La función COUNT(nombre) cuenta cuántos valores no nulos hay en el campo nombre de la tabla empleado
    -- para cada valor único de id_departamento. Es decir, cuenta cuántos empleados hay en cada departamento
    -- y muestra ese conteo junto con el ID del departament

--14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas, NO cantidad de películas entregadas).
    SELECT cantidad, codigo_pelicula
    FROM renglon_entrega
    WHERE cantidad
    BETWEEN 3 AND 5;


