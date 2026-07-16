-- Considere el esquema de BD de un sistema de gestión de instituciones en las cuales trabajan profesionales de
-- distintas especialidades, con cierta cantidad de horas semanales durante un periodo determinado por las
-- fechas de inicio y de fin. Las instituciones pueden estar certificadas o no, y se registra información sobre la
-- localidad donde se ubican (script de creación).

          -- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-12-13 22:54:32.044

-- tables
-- Table: especialidad
CREATE TABLE especialidad (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: institucion
CREATE TABLE institucion (
                             cod_institucion int  NOT NULL,
                             nombre varchar(60)  NOT NULL,
                             calle varchar(60)  NOT NULL,
                             numero int  NOT NULL,
                             localidad int  NOT NULL,
                             certificada boolean  NOT NULL,
                             CONSTRAINT pk_centro_salud PRIMARY KEY (cod_institucion)
);

-- Table: profesional
CREATE TABLE profesional (
                             tipo_especialidad char(3)  NOT NULL,
                             cod_especialidad int  NOT NULL,
                             id_profesional int  NOT NULL,
                             nombre varchar(30)  NOT NULL,
                             apellido varchar(30)  NOT NULL,
                             nro_matricula int  NOT NULL,
                             inicio_profesional date  NOT NULL,
                             CONSTRAINT pk_medico PRIMARY KEY (tipo_especialidad,cod_especialidad,id_profesional)
);

-- Table: trabaja_en
CREATE TABLE trabaja_en (
                            cod_institucion int  NOT NULL,
                            tipo_especialidad char(3)  NOT NULL,
                            cod_especialidad int  NOT NULL,
                            id_profesional int  NOT NULL,
                            fecha_inicio date  NOT NULL,
                            fecha_fin date  NULL,
                            horas_semanales int  NOT NULL,
                            CONSTRAINT pk_atiende PRIMARY KEY (tipo_especialidad,cod_especialidad,id_profesional,fecha_inicio)
);

-- Table: ubicacion
CREATE TABLE ubicacion (
                           cod_localidad int  NOT NULL,
                           nombre varchar(30)  NOT NULL,
                           superficie int  NOT NULL,
                           poblacion int  NOT NULL,
                           CONSTRAINT ubicacion_pk PRIMARY KEY (cod_localidad)
);

-- foreign keys
-- Reference: fk_institucion_ubicacion (table: institucion)
ALTER TABLE institucion ADD CONSTRAINT fk_institucion_ubicacion
    FOREIGN KEY (localidad)
        REFERENCES ubicacion (cod_localidad)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_profesional_especialidad (table: profesional)
ALTER TABLE profesional ADD CONSTRAINT fk_profesional_especialidad
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
        REFERENCES especialidad (tipo_especialidad, cod_especialidad)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_trabaja_institucion (table: trabaja_en)
ALTER TABLE trabaja_en ADD CONSTRAINT fk_trabaja_institucion
    FOREIGN KEY (cod_institucion)
        REFERENCES institucion (cod_institucion)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_trabaja_profesional (table: trabaja_en)
ALTER TABLE trabaja_en ADD CONSTRAINT fk_trabaja_profesional
    FOREIGN KEY (tipo_especialidad, cod_especialidad, id_profesional)
        REFERENCES profesional (tipo_especialidad, cod_especialidad, id_profesional)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

--Ejercicio 1)
Sobre el esquema dado se necesita incorporar las restricciones enunciadas a continuación. En cada caso
provea una solución mediante el recurso declarativo más restrictivo en SQL estándar, utilizando sólo las
tablas/atributos necesarios. Justifique el tipo de restricción usada.

1.a) Un profesional no puede trabajar más de 10 horas semanales si el periodo de trabajo es menor a un año de
duración

horas_semanales, id_profesional, fecha_inicio, fecha_fin

SELECT ( DATE '2001-12-16' >=  DATE '2001-1-21' + INTERVAL '1' YEAR);

ALTER TABLE trabaja_en
    ADD CONSTRAINT ck_horas_periodo
        CHECK (
            fecha_fin >= fecha_inicio + INTERVAL '1' YEAR
                OR horas_semanales <= 10
            );

1.b) Sólo puede haber una fecha_fin no establecida (nula) por cada Profesional e Institución
-- fecha_fin, tipo_especialidad, cod_especialiadd, id_profesional, cod_institucion

ALTER TABLE trabaja_en
    ADD CONSTRAINT ck_fecha_estableicda
        CHECK (
            NOT EXISTS(
                SELECT 1
                FROM trabaja_en
                WHERE fecha_fin IS NULL
                GROUP BY tipo_especialidad, cod_especialidad, id_profesional, cod_institucion
                HAVING count(*) > 1
            )
            );


-- 1.c) Cada Profesional en una misma Institución no puede registrar más de un trabajo en un mismo momento; es
-- decir que por cada Institución y Profesional, los intervalos de tiempo (fecha_inicio, fecha_fin) no se pueden
-- superponer ni total ni parcialmente, salvo en los extremos (fecha_inicio o fecha_fin, pero no ambos).
-- id_prof, tipo_espe, cod_esp, fecha_inicio y fecha_fin no pueden suporponerse.






-- Ejercicio 2)
-- Considere las siguientes reglas del negocio sobre el esquema dado y resuelva lo indicado:
--
--2.a) En toda institución certificada debe trabajar al menos un profesional de alguna especialidad relacionada
-- con la gestión ambiental durante 6 o más horas semanales.

-- Enuncie y justifique todos los eventos críticos que se
-- requiere controlar para asegurar su cumplimiento en PostgreSQL y escriba las declaraciones de los triggers
-- correspondientes (sin las funciones).

-- institucion: certificada = true,
-- trabaja_en: id_profesional, tipo_especialidad, cod_especialidad, horas_semanales > 6
-- especialidad: nombre '% Gestion ambiental %

-- Especialidad: nombre -> update
-- Trabaja_en: tipo_especialidad, cod_especialidad -> insert, update y delete, ya q  hay q controlar q exista al menos 1
--             horas_semanales -> insert or update
-- Institucion: certificada -> update

--
-- 2.b) En localidades (ubicaciones) de menos de 100.000 habitantes puede haber 5 instituciones como
-- máximo. Escriba una implementación completa (encabezado/s y función/es) mediante trigger/s en PostgreSQL
-- que garantice que la restricción se verifique siempre ante cualquier operación de inserción.

-- ubicacion: poblacion < 100000
-- institucion: cod_institucion

CREATE FUNCTION fn_exercuse() RETURNS TRIGGER AS $$
    declare cantMaxInstituciones int;
            v_poblacion     integer;
    begin
        SELECT u.poblacion
        INTO v_poblacion
        FROM ubicacion u
        WHERE u.cod_localidad = NEW.localidad;

        if v_poblacion < 100000 then
            SELECT COUNT(*)
            INTO cantMaxInstituciones
            FROM institucion i
            WHERE i.localidad = NEW.localidad;

            if cantMaxInstituciones >= 5 then raise exception
                'solo puede haber 5 instituciones al tener menos de 100.000 habitantes';
            end if;
        end if;
        RETURN NEW;

    end;
$$
language plpgsql;

create trigger tr_exercise before insert  on institucion
    for each row execute function fn_exercuse();

-- Ejercicio 3)
-- Para cada una de las siguientes consultas SQL requeridas sobre el esquema dado se propone una solución
-- adjunta. Indique en cada caso si considera que tal solución resuelve correctamente lo requerido o no. Justifique
-- claramente su respuesta, indicando el/los error/es en caso que posea, e incluya la/s corrección/es necesaria/s
-- (provea el código SQL).

-- 3.a) Listar los datos de las instituciones en las que trabaja al menos un profesional de cada tipo de especialidad

SELECT * FROM institucion i
 WHERE NOT EXISTS
           ( SELECT 1 FROM especialidad e
             EXCEPT SELECT tipo_especialidad
             FROM trabaja_en t );

-- Es incorrecot, no lo resuelve y no se si existe el ecept pero no compila esto y ademas no resuelve lo pedido
-- ya que deberia buscar las instituciones donde exista al menos 1 profesional

-- 3.b) Obtener identificador y nombre de los profesionales que no registran trabajos de más de 30 horas
-- semanales en instituciones localizadas en Tandil.
-- SELECT p.id_profesional, p.nombre
-- FROM profesional p
-- JOIN trabaja_en t USING (id_profesional)
-- JOIN institucion i USING (cod_institucion)
-- WHERE t.horas_semanales < 30
-- AND i.localidad NOT IN
-- (SELECT cod_localidad
-- FROM UBICACION
-- WHERE nombre = ‘Tandil’);

--  YO LO q noto de esta es q deberia ser de la localidad de tandil, y ahi esta espeicicando que NO sean de tandil
-- ademas q para identificar al profesional falta agregar tipo_especialidad, cod_especialidad para unir en trabaja en.
-- y el using esta mal pq entre profesinal y trabaja falta mas de la pk

SELECT p.id_profesional, p.nombre
FROM profesional p
JOIN trabaja_en t USING (id_profesional, tipo_especialidad, cod_especialidad)
JOIN institucion i USING (cod_institucion)
WHERE t.horas_semanales < 30
AND i.localidad IN
(SELECT cod_localidad
FROM UBICACION
WHERE nombre = 'Tandil');

-- 3.c) Listar los diferentes códigos y nombres de instituciones en las que trabajan actualmente más de 10
-- profesionales de especialidades relacionadas con bioingeniería.

SELECT i.cod_institucion, i.nombre
FROM institucion i
JOIN trabaja_en t USING (cod_institucion)
JOIN profesional USING (tipo_especialidad, cod_especialidad, id_profesional)
JOIN especialidad e USING (tipo_especialidad, cod_especialidad)
WHERE e.nombre LIKE '%bioingenieria%' AND fecha_fin IS NOT NULL
group by i.cod_institucion, i.nombre
having count(
       distinct (t.tipo_especialidad,
       t.id_profesional,
       t.cod_especialidad
      ) ) > 10

    t.fecha_inicio <= CURRENT_DATE
AND (
    t.fecha_fin IS NULL
    OR t.fecha_fin >= CURRENT_DATE
)

-- eso de fecha fin va asi poprque

-- fecha_inicio	fecha_fin	¿Trabaja actualmente?
-- 2024-01-01	NULL	Sí
-- 2024-01-01	2027-01-01	Sí
-- 2024-01-01	2025-01-01	No
-- 2027-01-01	NULL	No, todavía no empezó

-- Ejercicio 4)
-- Defina las siguientes vistas sobre el esquema de Películas (unc_esq_peliculas), de manera que resulten
-- automáticamente actualizables en PostgreSQL, siempre que esto sea posible (justifique este aspecto). Indique
-- las tuplas que componen cada vista.
-- a) vista_1 : que contenga los identificadores y nombres de los distribuidores que poseen más del 0,5 % del total
-- de empleados registrados.
-- b) vista_2 : con el identificador y nombre de el/los departamento/s que registre/n la menor cantidad de
-- empleados, incluyendo también el apellido y nombre del jefe de departamento.

SELECT DATE '20-02-2000' -DATE  '22-02-2000'

select nombre
from clientes
         join pedido using(id_cliente)
where extract(year from fecha_pedido) not exists(
extract(year from current_date())
)
