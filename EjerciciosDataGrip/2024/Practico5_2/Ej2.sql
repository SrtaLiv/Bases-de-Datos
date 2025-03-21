SET search_path = unc_188;

--Ejercicio 2
--Considere las siguientes restricciones que debe definir sobre el esquema de la BD de Películas:
--A. Para cada tarea el sueldo máximo debe ser mayor que el sueldo mínimo.
--B. No puede haber más de 70 empleados en cada departamento.
--C. Los empleados deben tener jefes que pertenezcan al mismo departamento.
--D. Todas las entregas, tienen que ser de películas de un mismo idioma.
--E. No pueden haber más de 10 empresas productoras por ciudad.
--F. Para cada película, si el formato es 8mm, el idioma tiene que ser francés.
--G. El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su
--distribuidor mayorista.

--A resticcion de TUPLA, sueldo_max, sueldo_min
ALTER TABLE tarea
ADD CONSTRAINT tareas_mayor_que_el_min
    CHECK (
    NOT EXISTS(
        SELECT id_tarea FROM unc_188.tarea WHERE sueldo_maximo < sueldo_minimo
    )
);

--B. No puede haber más de 70 empleados en cada departamento.
ALTER TABLE empleado
ADD CONSTRAINT emp_dep
CHECK (
    (SELECT COUNT(*) FROM empleado WHERE id_departamento = empleado.id_departamento) <= 70
);

CREATE ASSERTION check_emp_dep
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM empleado e
        GROUP BY e.id_departamento
        HAVING COUNT(*) > 70
    )
)

--C. Los empleados deben tener jefes que pertenezcan al mismo departamento. atributo id jefe, id_departamento, id_empleado
ALTER TABLE empleado
ADD CONSTRAINT emp_jefes_igual_dep
CHECK ( NOT EXISTS(
    SELECT 1
    FROM empleado e1
    INNER JOIN empleado e2
    ON e1.id_empleado = e2.id_jefe
     WHERE e1.id_departamento <> e2.id_departamento
     AND e1.id_jefe IS NOT NULL
) );

--D. Todas las entregas, tienen que ser de películas de un mismo idioma. necesito tabla entrega, pelicla
CREATE ASSERTION peli_mismo_idioma
CHECK (NOT EXIST(
       SELECT 1
       FROM peliculas p
       INNER JOIN rengon_entrega re ON
       p.codigo_pelicula = re.codigo_pelicula
       GROUP BY re.nro_entrega
       HAVING COUNT(DISTINCT p.idioma > 1)
));

--E. No pueden haber más de 10 empresas productoras por ciudad. Tabla Empresa_productora y Ciudad
CREATE ASSERTION emp_check_ciudad
CHECK (NOT EXIST(
       SELECT 1
       FROM empresa_productora
       GROUP BY id_ciudad
       HAVING COUNT(codigo_productora) > 10
));


--F. Para cada película, si el formato es 8mm, el idioma tiene que ser francés.
ALTER TABLE pelicula
ADD CONSTRAINT peli_f_i
CHECK (NOT EXISTS(SELECT 1
    FROM pelicula
    WHERE formato = '8mm'
    AND idioma <> 'frances') -- DIFERENTE
);

--G. El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su
--distribuidor mayorista.
--
-- necesito: telefono, id_distribuidor de nacional = id_distribuidor,
--nacional: id_distrib_mayorista, id_distribuidor

CREATE ASSERTION g_pelicula
CHECK( NOT EXISTS(
    SELECT 1
    FROM  nacional n
    INNER JOIN distribuidor d1
    ON (d1.id_distribuidor= n.id_distribuidor)
    INNER JOIN distribuidor d2
    ON (d2.id_distribuidor=n.id_distrib_mayorista)
    WHERE SUBSTRING(d1.telefono, 1,3) <> SUBSTRING (d2.telefono, 1,3)
    --OTRA FORMA DE HACERLO---> left(d.telefono,3) = left(m.telefono,3)
))

