--Considere el esquema de BD de un sistema de gestión de instituciones en las cuales trabajan profesionales de
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
-- Sobre el esquema dado se necesita incorporar las restricciones enunciadas a continuación. En cada caso
-- provea una solución mediante el recurso declarativo más restrictivo en SQL estándar, utilizando sólo las
-- tablas/atributos necesarios. Justifique el tipo de restricción usada.

-- 1.a) Un profesional no puede trabajar más de 10 horas semanales si el periodo de trabajo es menor a un año de
-- duración

-- 1.b) Sólo puede haber una fecha_fin no establecida (nula) por cada Profesional e Institución
-- 1.c) Cada Profesional en una misma Institución no puede registrar más de un trabajo en un mismo momento; es
-- decir que por cada Institución y Profesional, los intervalos de tiempo (fecha_inicio, fecha_fin) no se pueden
-- superponer ni total ni parcialmente, salvo en los extremos (fecha_inicio o fecha_fin, pero no ambos).

--1, a) id_profesional, horas_semanales,fecha inicio, fecha_fin. Unica tabla: TRABAJA_EN
ALTER TABLE trabaja_en ADD CONSTRAINT ck_ejercicio_1 CHECK (
    NOT (fecha_fin - fecha_inicio < INTERVAL '1 year')
        OR horas_semanales <= 10
)

-- SI (duración < 1 año) → NO (horas > 10)
-- A → B  ≡  NOT(A) OR B

-- ejemplo: Pepe, trabaja hace 2 años y 20 horas semanales. Condicion 1: menor a 1 año? FALSO -> con NOT a VERDADERO (PASA).
-- no llega al segundo or porque ya con el primero pasó.

-- ejemplo 2: Pepa, trabaja hace 10 meses, 12 horas semanales. C1. menor a 1 año? VERDADERO -> pasa a FALSO. Esta condicion
-- no cumple, verificamos C2: horas semanales < 10? FALSO. Falso y Falso queda en FALSO, no pasa

------------------------------------------------------------------------------------------------
-- EJERCICIO FALSO PARA PRACTICAr:
--Un profesional no puede trabajar en una institución con más de 40 horas semanales si el
-- trabajo tiene fecha_fin nula (es decir, sigue activo).

-- cod_institucion, id_profesional, horas_semanales, fecha_fin es nulo

ALTER TABLE trabaja_en ADD CONSTRAINT ck_falso CHECK (
    NOT (fecha_fin IS NULL AND horas_semanales > 40)
    )


--truco 1
-- ¿Qué NO debería pasar nunca?
--  NOT (caso_prohibido)
-- NOT (fecha_fin IS NULL AND horas > 40)

-- truco 2
--“Si pasa A → entonces B”
--“Si dura menos de 1 año → horas ≤ 10”
--NOT (A) OR B

-- ej 1: institucion con 55 horas, fecha fin nul. C1: FALSO C2: FALSO -> NO PASA
-- ej 2: institucion con 35 horas, fecha fin nulL. C1: VERDADERO C2: VERDADERO -> PASA

-- ejercicio falso 2:
--Un profesional no puede registrar un trabajo con horas_semanales mayores a 30 si la fecha_inicio es anterior al año 2020.
-- opcion 1:
ALTER TABLE trabaja_en ADD CONSTRAINT ck_falso CHECK (
    NOT (horas_semanales > 30 AND fecha_inicio  < DATE '2020-01-01')
)

-- PRIMER OPCION
-- ej 1: profesional con 32 horas y fecha inicio 2022 -> VERDADERO Y FALSO -> NOT(FALSO) VERDADERO. PASA
-- ej 2: profesional con 25 horas y fecha inicio 2022 -> FALSO Y FALSO. SE CONTRARIAN VERDADERO Y VERDADERO. VERDADERO. PASA
-- ej 3: profesional con 25 horas y fecha inicio 2019 -> FALSO Y VERDADERO. SE CONTRARIAN ASI QUE DA VERDADERO. PASA
-- ej 4: profesional con 32 horas y fecha inicio 2019 -> VERDADERO Y VERDADERO -> verdadero. NOT(TRUE) -> FALSO. NO PASA

--Un profesional no puede trabajar con menos de 5 horas semanales si el trabajo ya finalizó (es decir, tiene fecha_fin no nula).
ALTER TABLE trabaja_en ADD CONSTRAINT ck_falso_3 CHECK (
    NOT (horas_semanales < 5 AND fecha_fin IS NOT NULL)
    )

-- EJ 1: profesional con 4 horas y fecha fin = null -> VERDADERO Y FALSO -> NOT(FALSO) -> VERDADERO. PASA
-- EJ 1: profesional con 6 horas y fecha fin = null -> FALSO Y FALSO -> NOT(FALSO) -> VERDADERO. PASA
-- EJ 1: profesional con 4 horas y fecha fin = 2020 -> VERDAERO Y VERDADERO. NOT(VERDADERO) FALSO. NO PASA
-- EJ 1: profesional con 6 horas y fecha fin = 2010 .> FALSO Y VERDADERO. NOT(FALSO) VERDADERO. PASA

-- volvienod a hacer el 1 a)=
-- 1.a) Un profesional no puede trabajar más de 10 horas semanales si el periodo de trabajo es menor a un año de duración
ALTER TABLE trabaja_en ADD CONSTRAINT ck_otra_vez_xD CHECK (
    NOT (horas_semanales > 10 AND fecha_fin - fecha_inicio  < INTERVAL '1 year')
    )

--1.b) Sólo puede haber una fecha_fin no establecida (nula) por cada Profesional e Institución
-- fecha_fin, id_profesional, cod_institucion
CREATE ASSERTION ck_1b (
       CHECK NOT EXISTS(
        SELECT 1
        FROM trabaja_en
       WHERE fecha_fin IS NULL
       GROUP BY cod_institucion, tipo_especialidad, cod_especialidad, id_profesional
        HAVING count(*) >= 2
       )
)

--1.c) Cada Profesional en una misma Institución no puede registrar más de un trabajo en un mismo momento; es
       -- decir que por cada Institución y Profesional, los intervalos de tiempo (fecha_inicio, fecha_fin) no se pueden
-- superponer ni total ni parcialmente, salvo en los extremos (fecha_inicio o fecha_fin, pero no ambos).

-- id_profesional, cod_insitucion, where fecha_inicio and fecha_fin sean distintos siempre.. pero no se esto como hacerlo

CREATE ASSERTION ck_1c
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM trabaja_en t1
        JOIN trabaja_en t2
        ON t1.cod_institucion = t2.cod_institucion
        AND t1.tipo_especialidad = t2.tipo_especialidad
        AND t1.cod_especialidad = t2.cod_especialidad
        AND t1.id_profesional = t2.id_profesional

        -- evitar comparar la misma fila
        AND t1.fecha_inicio <> t2.fecha_inicio

        WHERE t1.fecha_inicio < COALESCE(t2.fecha_fin, DATE '9999-12-31')
          AND t2.fecha_inicio < COALESCE(t1.fecha_fin, DATE '9999-12-31')
    )
);

-- usamos coalesce porque fecha fin puede ser null, entonces primero prueba con el primero, si el primero es nulo,
-- prueba con el segundo

-- ejercicio extra para practicar
--1 d) Un profesional no puede trabajar con más de 20 horas semanales si el trabajo pertenece a una institución certificada.
CREATE ASSERTION ck_1d
CHECK (
    NOT EXISTS (

)
);

SELECT 1
FROM trabaja_en t1
JOIN institucion
USING (cod_institucion)
WHERE horas_semanales > 20 AND
    certificada IS TRUE
GROUP BY cod_institucion, id_profesional, tipo_especialidad, cod_especialidad

--Ejercicio 2)
-- Considere las siguientes reglas del negocio sobre el esquema dado y resuelva lo indicado:
-- 2.a) En toda institución certificada debe trabajar al menos un profesional de alguna especialidad relacionada
-- con la gestión ambiental durante 6 o más horas semanales.

-- Enuncie y justifique todos los eventos críticos que se requiere controlar para asegurar su cumplimiento en PostgreSQL
-- y escriba las declaraciones de los triggers correspondientes (sin las funciones).

--certificaba true,

CREATE FUNCTION fn_tr1()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.certificada IS TRUE THEN
        IF NOT EXISTS (
            SELECT 1
            FROM trabaja_en t
                     JOIN especialidad e
                          ON t.tipo_especialidad = e.tipo_especialidad
                              AND t.cod_especialidad = e.cod_especialidad
            WHERE t.cod_institucion = NEW.cod_institucion
              AND e.nombre ILIKE '%gestion ambiental%'
              AND t.horas_semanales >= 6
        )
        THEN
            RAISE EXCEPTION 'No cumple condición';
        END IF;
    END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_fn_1
BEFORE INSERT OR UPDATE OF certificada ON institucion
FOR EACH ROW EXECUTE FUNCTION fn_tr1();

CREATE TRIGGER tr_fn_1
BEFORE INSERT OR UPDATE OF horas_semanales, id_profesional, cod_institucion ON trabaja_en
FOR EACH ROW EXECUTE FUNCTION fn_tr1();

CREATE TRIGGER tr_fn_1
    BEFORE INSERT OR UPDATE OF nombre ON especialidad
    FOR EACH ROW EXECUTE FUNCTION fn_tr1();

--Eventos criticos  para 2.a:
-- INSERT en institucion con certificada = true
-- UPDATE de certificada en institucion de false a true
-- INSERT en trabaja_en para institución certificada
-- UPDATE de horas_semanales en trabaja_en para institución certificada (puede bajar de 6)
-- UPDATE de cod_institucion en trabaja_en (cambio de institución)
-- UPDATE de fecha_fin (finalización de trabajo activo)
-- UPDATE de tipo_especialidad o cod_especialidad en trabaja_en (cambio de especialidad)
-- DELETE en trabaja_en  (eliminación del profesional que cumple la condición)
-- DELETE en profesional(eliminacion del profesional completo)
-- UPDATE en especialidad (si cambia el nombre de la especialidad ambiental)

--2.b) En localidades (ubicaciones) de menos de 100.000 habitantes puede haber 5 instituciones como
-- máximo. Escriba una implementación completa (encabezado/s y función/es) mediante trigger/s en PostgreSQL
-- que garantice que la restricción se verifique siempre ante cualquier operación de inserción.


CREATE FUNCTION fn_tr1()
RETURNS TRIGGER AS $$
    declare cant int;
BEGIN
    SELECT count(distinct cod_institucion) into cant, i.localidad
    FROM ubicacion u
             JOIN institucion i
                  ON i.localidad = u.cod_localidad
    WHERE poblacion < 100000
    AND cod_localidad = new.cod_localidad
    group by u.cod_localidad;

    IF cant > 5 THEN raise exception '' ;
    END IF;
end;
$$;

CREATE TRIGGER tr_fn_2b
BEFORE INSERT OR UPDATE OF cod_localidad, poblacion ON ubicacion
FOR EACH ROW EXECUTE FUNCTION fn_tr1();

CREATE TRIGGER tr_fn_2b
    BEFORE INSERT OR UPDATE OF localidad ON institucion
    FOR EACH ROW EXECUTE FUNCTION fn_tr1();

--- ALTERNATIVA ---
CREATE OR REPLACE FUNCTION fn_verificar_max_instituciones()
    RETURNS TRIGGER AS $$
DECLARE
    v_poblacion INTEGER;
    v_cantidad INTEGER;
    v_localidad INTEGER;
BEGIN
    IF TG_TABLE_NAME = 'institucion' THEN
        v_localidad := NEW.localidad;
    ELSE
        v_localidad := NEW.cod_localidad;
    END IF;

    SELECT poblacion INTO v_poblacion
    FROM ubicacion
    WHERE cod_localidad = v_localidad;

    IF v_poblacion < 100000 THEN
        SELECT COUNT(*) INTO v_cantidad
        FROM institucion
        WHERE localidad = v_localidad;

        IF v_cantidad > 5 THEN
            RAISE EXCEPTION 'Localidad con menos de 100.000 habitantes no puede tener más de 5 instituciones (tiene %)', v_cantidad;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_institucion_2b
    BEFORE INSERT OR UPDATE OF localidad ON institucion
    FOR EACH ROW
EXECUTE FUNCTION fn_verificar_max_instituciones();

CREATE TRIGGER tr_ubicacion_2b
    BEFORE UPDATE OF poblacion ON ubicacion
    FOR EACH ROW
EXECUTE FUNCTION fn_verificar_max_instituciones();

--Ejercicio 3)
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