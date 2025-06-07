-- Sobre el esquema dado (
--  link
--  ), incorpore los siguientes controles en SQL estándar mediante el recurso declarativo
--  más restrictivo y utilizando sólo las tablas y atributos necesarios. Justifique el tipo de restricción definida en cada
--  caso.
--  a) Los clientes con menos de 3 años de antigüedad pueden tener hasta 3 servicios instalados de cada tipo.

-- fecha_alta, nroC, zona, | Instalacikn idServ, -servicio tipoServ

--  b) La fecha de instalación de cada servicio no puede ser anterior ni posterior a los años de comienzo y de fin,
--  respectivamente, asociadas a dicho servicio.
--  c) El año de comienzo de los servicios que son de vigilancia debe ser posterior a 2020


UPDATE servicio s
SET cant_clientes = sub.cant
    FROM (
    SELECT id_servicio, COUNT(*) AS cant
    FROM instalacion
    GROUP BY id_servicio
) AS sub
WHERE s.id_servicio = sub.id_servicio;

select count(*)
from unc_esq_peliculas.renglon_entrega
where codigo_pelicula = 5;

SELECT p.nombre_pais
FROM unc_esq_voluntario.pais p
         JOIN unc_esq_voluntario.direccion d ON p.id_pais = d.id_pais
         JOIN unc_esq_voluntario.institucion i ON i.id_direccion = d.id_direccion
         JOIN unc_esq_voluntario.voluntario v ON v.id_institucion = i.id_institucion
         JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
WHERE t.id_tarea LIKE '%REP'
GROUP BY p.nombre_pais
ORDER BY COUNT(*) DESC
LIMIT 1;

CREATE OR REPLACE FUNCTION fn_control_docente()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(
        SELECT 1 FROM se_inscribe s
        LEFT JOIN docente d ON (d.id_materia = s.id_materia
        and (d.id_carrera = s.id_carrera)
        WHERE d.id_materia = new.id_materia
        AND d.id_carrera = new.id_carrera
        AND d.id_profesor IS NULL
    ) THEN
        RAISE EXCEPTION 'la % de la carrera %, no tiene docente a cargo',
        new.id_materia, new.id_carrera;
    END IF;
    RETURN NEW;
end;
    $$
    LANGUAGE plpgsql;

CREATE TRIGGER
BEFORE INSERT OR UPDATE id_materia, id_carrera FOR EACH ROW
on se_inscribe
    EXECUTE PROCEDURE fn_control_docente;


SELECT count(*), v.id_tarea
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
WHERE t.id_tarea LIKE '%MAN'
  AND v.fecha_nacimiento BETWEEN '1998-01-01' AND '1999-12-31'
    group by v.id_tarea
;

SELECT count(*)
FROM unc_esq_peliculas.pelicula p
JOIN unc_esq_peliculas.empresa_productora e
ON p.codigo_productora = e.codigo_productora
WHERE p.codigo_productora > '200000';
