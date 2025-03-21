--obtenga todos los datos de los directivos que no han terminado su proyecto

--necesito los datos de los directivos que no terminaron su proyecto
SELECT * FROM directivo d
JOIN proyecto p
ON p.id_proyecto = d.id_proyecto
         and p.cod_tipo_proy = d.cod_tipo_proy
where fecha_fin IS null;

select * from directivo;

SELECT d.* FROM directivo d
JOIN proyecto p
ON p.id_proyecto = d.id_proyecto
         and p.cod_tipo_proy = d.cod_tipo_proy
where d.fecha_fin IS null;

/*
 1) De la sentencia declarativa más restrictiva que controle que una
 materia que comience con el nombre de
 ‘INTRODUCCION’ puede tener solo un docente con fecha de ingreso mayor al año 2020.
 */

CREATE ASSERTION solo_un_docente_mayor_al_2020
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM materia m
        JOIN docente d ON m.id_materia = d.id_materia
        WHERE m.nombre_materia LIKE 'INTRODUCCION%'
       AND d.fecha_ingreso <= '2020-12-31'
    )
);
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:52:31.178

-- tables

-- End of file.

       ALTER TABLE DOCENTE
ADD CONSTRAINT chk_docente_intro
CHECK (NOT EXISTS (
    SELECT 1 FROM DOCENTE d
    JOIN MATERIA m ON d.id_materia = m.id_materia
    WHERE d.fecha_ingreso > '2020-01-01'
      AND m.nombre_materia LIKE 'INTRODUCCION%'
      AND d.id_profesor <> id_profesor
));

/*
CREATE OR REPLACE FUNCTION fn_check_materia_docentes2()
RETURNS TRIGGER AS $$
BEGIN
    if (tg_table_name = 'DOCENTE') THEN
        IF EXISTS (
            SELECT 1
            FROM DOCENTE d
            JOIN MATERIA m ON d.id_materia = m.id_materia
            WHERE d.fecha_ingreso > '2020-01-01'
              AND m.nombre_materia LIKE 'INTRODUCCION%'
              AND d.id_materia = NEW.id_materia
              AND d.id_profesor <> NEW.id_profesor
        ) THEN
        RAISE EXCEPTION 'Solo puede haber un DOCENTE con fecha_ingreso mayor 2020 para materias que empiecen en "INTRODUCCION"';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

*/
CREATE TRIGGER tr_check_docentes
BEFORE INSERT OR UPDATE ON DOCENTE
FOR EACH ROW
EXECUTE FUNCTION fn_check_materia_docentes2();



--SOLUCION:

    CREATE OR REPLACE FUNCTION fn_check_materia_docentes2020()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        IF EXISTS (
            SELECT 1
            FROM DOCENTE d
            JOIN MATERIA m ON d.id_materia = m.id_materia
            WHERE d.fecha_ingreso > '2020-01-01'
              AND m.nombre_materia LIKE 'INTRODUCCION%'
              AND d.id_materia = NEW.id_materia
              AND d.id_profesor <> NEW.id_profesor
        ) THEN
            RAISE EXCEPTION 'Solo puede haber un DOCENTE con fecha_ingreso mayor a 2020 para materias que empiecen en "INTRODUCCION"';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_check_docentes
BEFORE INSERT OR UPDATE ON DOCENTE
FOR EACH ROW
EXECUTE FUNCTION fn_check_materia_docentes2020();


INSERT INTO MATERIA (id_carrera, id_materia, nombre_materia)
VALUES
    (1, 1, 'INTRODUCCION A LA PROGRAMACION'),
    (1, 2, 'PROGRAMACION AVANZADA'),
    (2, 3, 'INTRODUCCION A LAS BASES DE DATOS'),
    (2, 4, 'BASES DE DATOS AVANZADAS'),
    (3, 5, 'INTRODUCCION AL DISEÑO GRAFICO'),
    (3, 6, 'DISEÑO AVANZADO DE INTERFACES');

INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES(11111111, 1, '2021-02-15', 1, 1);
INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES(11111111, 2, '2023-02-15', 1, 1);
INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES(11111111, 1, '2018-02-15', 1, 1);
INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES(11111111, 9, '2021-02-15', 1, 1);

INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES(11111111, 9, '2020-02-15', 1, 1);


--SOLO PUEDE HABER 1 DOCENTE CON FECHA DE INGRESO MAYOR A 2020 EN MATERIAS QUE EMPIECEN CON NOMBRE INTRODUCCION.


SELECT * FROM docente;
SELECT * FROM materia;

INSERT INTO MATERIA (id_carrera, id_materia, nombre_materia) VALUES
(1, 101, 'INTRODUCCION A LA PROGRAMACION'),
(1, 102, 'BASES DE DATOS'),
(2, 201, 'INTRODUCCION A LA INGENIERIA');

INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES
(12345678, 1, '2023-01-01', 101, 1);

INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES
(87654321, 2, '2024-01-01', 101, 1);

INSERT INTO DOCENTE (DNI, id_profesor, fecha_ingreso, id_materia, id_carrera) VALUES
(87654321, 10, '2018-01-01', 101, 1);


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:52:31.178

-- tables
-- Table: ALUMNO
CREATE TABLE ALUMNO (
    DNI int  NOT NULL,
    LU int  NOT NULL
);

-- Table: CARRERA
CREATE TABLE CARRERA (
    id_carrera int  NOT NULL,
    nombre_titulo_otorgado text  NOT NULL,
    nombre_carrera text  NOT NULL
);

-- Table: DOCENTE
CREATE TABLE DOCENTE (
    DNI int  NOT NULL,
    id_profesor int  NOT NULL,
    fecha_ingreso date  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL
);

-- Table: MATERIA
CREATE TABLE MATERIA (
    id_carrera int  NOT NULL,
    id_materia int  NOT NULL,
    nombre_materia varchar(150)  NOT NULL
);

-- Table: PERSONA
CREATE TABLE PERSONA (
    DNI int  NOT NULL,
    email varchar(120)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    nombre varchar(30)  NOT NULL,
    fecha_nac date  NOT NULL
);

-- Table: SE_INSCRIBE
CREATE TABLE SE_INSCRIBE (
    DNI int  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL
);

-- End of file.


/*
 Plantee una vista V_INSCRIPTOS_BD transformando la vista
 P4_T1 para que sea automáticamente actualizable.
 Además asegúrese que las operaciones de insert, update y
 delete sobre la vista V_INSCRIPTOS_BD no hagan que los registros migren de la misma.
 */

/*
 Solo es actualizable si
Conserva las columnas de la clave primaria
Para que una vista sea actualizable, en el front debe haber una única tabla.
No puede contener funciones de agregación (group by, count, sum, min, max) o derivados,
Sin cláusula DISTINCT
No incluye SELECT con subconsulta

 */
create VIEW  P4_T1 AS
    SELECT s.*
    FROM se_inscribe s JOIN materia m USING (id_carrera, id_materia)
    WHERE nombre_materia like 'BASES DE DATO%';

 create VIEW  V_INSCRIPTOS_BD AS
    SELECT s.*
    FROM P4_T1 s
 WITH LOCAL CHECK OPTION;;



-- el check option

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-04 12:38:51.138

-- tables
-- Table: DIRECTIVO
CREATE TABLE DIRECTIVO (
    DNI int  NOT NULL,
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: EMPLEADO
CREATE TABLE EMPLEADO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(120)  NOT NULL
);

-- Table: TECNICO
CREATE TABLE TECNICO (
    DNI int  NOT NULL
);

-- Table: TIPO_PROYECTO
CREATE TABLE TIPO_PROYECTO (
    cod_tipo_proy int  NOT NULL,
    nombre_tipo_proy varchar(40)  NOT NULL,
    descripcion_tipo_proy text  NOT NULL
);

-- Table: TRABAJA_EN
CREATE TABLE TRABAJA_EN (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    DNI int  NOT NULL
);

-- End of file.


-- primary keys
ALTER TABLE TIPO_PROYECTO ADD  CONSTRAINT PK_TIPO_PROYECTO PRIMARY KEY (cod_tipo_proy);
ALTER TABLE DIRECTIVO ADD CONSTRAINT PK_DIRECTIVO PRIMARY KEY (DNI);
ALTER TABLE TECNICO ADD CONSTRAINT PK_TECNICO PRIMARY KEY (DNI);

-- foreign keys
ALTER TABLE TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_TECNICO
    FOREIGN KEY (DNI)
    REFERENCES TECNICO (DNI);


--PRIMARY KEYS:
ALTER TABLE EMPLEADO ADD  CONSTRAINT PK_EMPLEADO PRIMARY KEY (dni);
ALTER TABLE trabaja_en ADD  CONSTRAINT PK_trabaja_en PRIMARY KEY (dni, id_proyecto, cod_tipo_proy);
ALTER TABLE proyecto ADD  CONSTRAINT PK_proyecto PRIMARY KEY (id_proyecto, cod_tipo_proy);


--El nombre del tipo de proyecto debe ser único.
ALTER TABLE TIPO_PROYECTO ADD CONSTRAINT ak_NOMBRE UNIQUE (nombre_tipo_proy);

--FOREIGN KEY
ALTER TABLE DIRECTIVO ADD CONSTRAINT fk_directivo_empleado
FOREIGN KEY (dni) REFERENCES EMPLEADO(dni)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TECNICO ADD CONSTRAINT fk_tecnico_empleado
FOREIGN KEY (dni) REFERENCES EMPLEADO(dni)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TRABAJA_EN ADD CONSTRAINT fk_proyecto_trabaja_en
FOREIGN KEY (cod_tipo_proy, id_proyecto) REFERENCES
    PROYECTO(cod_tipo_proy, id_proyecto);


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-04 12:38:51.138


/*
 Utilizando el esquema de la figura cuyas tablas se
 encuentran en el siguiente link dar la sentencia SQL optimizada
 que obtenga todos los DNI, nombre y apellido de los empleados mayores de 30 años,
 y los identificadores de los  proyectos en los que trabajan si los tuvieran
 */

SELECT e.DNI, e.nombre, e.apellido, t.cod_tipo_proy, t.id_proyecto
FROM EMPLEADO e
JOIN TRABAJA_EN t USING (DNI)
WHERE EXTRACT(YEAR FROM age(e.fecha_nac)) > 30;

select * from empleado;
select * from trabaja_en;

INSERT INTO TRABAJA_EN (cod_tipo_proy, id_proyecto, DNI)
VALUES
    (1, 101, 1),
    (2, 201, 2),
    (1, 102, 3),
    (1, 102, 1);  -- Juan Pérez trabaja en dos proyectos de tipo 1


INSERT INTO EMPLEADO (DNI, e_mail, apellido, nombre, fecha_nac)
VALUES
    (1, 'juan.perez@email.com', 'Pérez', 'Juan', '1980-05-15'),
    (2, 'maria.gomez@email.com', 'Gómez', 'María', '1987-08-20'),
    (3, 'carlos.lopez@email.com', 'López', 'Carlos', '1995-03-10'),

    (4, 'carlos.lopez@email.com', 'López', 'oLIVIA', '2000-03-10');;

INSERT INTO PROYECTO (cod_tipo_proy, id_proyecto, nombre_proyecto)
VALUES
    (1, 101, 'Desarrollo de Software'),
    (2, 201, 'Construcción de Infraestructura'),
    (1, 102, 'Mantenimiento de Sistemas');


-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-04 12:38:51.138

-- tables
-- Table: DIRECTIVO
CREATE TABLE DIRECTIVO (
    DNI int  NOT NULL,
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: EMPLEADO
CREATE TABLE EMPLEADO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(120)  NOT NULL
);

-- Table: TECNICO
CREATE TABLE TECNICO (
    DNI int  NOT NULL
);

-- Table: TIPO_PROYECTO
CREATE TABLE TIPO_PROYECTO (
    cod_tipo_proy int  primary key ,
    nombre_tipo_proy varchar(40)  NOT NULL,
    descripcion_tipo_proy text  NOT NULL
);

-- Table: TRABAJA_EN
CREATE TABLE TRABAJA_EN (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    DNI int  NOT NULL
);

ALTER TABLE PROYECTO
ADD CONSTRAINT FK_PROYECTO_TIPO_PROYECTO
FOREIGN KEY (cod_tipo_proy)
REFERENCES TIPO_PROYECTO(cod_tipo_proy)
ON UPDATE RESTRICT
ON DELETE CASCADE;

ALTER TABLE DIRECTIVO
ADD CONSTRAINT FK_DIRECTIVO_PROYECTO
FOREIGN KEY (cod_tipo_proy, id_proyecto)
REFERENCES PROYECTO(cod_tipo_proy, id_proyecto)
ON UPDATE CASCADE
ON DELETE RESTRICT;



-- End of file.

---
CREATE VIEW V_INSCRIPTOS_BD AS
    SELECT s.*
    FROM SE_INSCRIBE s
    JOIN MATERIA m USING (id_carrera, id_materia)
    WHERE m.nombre_materia LIKE 'BASES DE DATO%';

1)
ALTER TABLE DOCENTE
ADD CONSTRAINT chk_docente_intro
CHECK (NOT EXISTS (
    SELECT 1 FROM DOCENTE d
    JOIN MATERIA m ON d.id_materia = m.id_materia
    WHERE d.fecha_ingreso > '2020-01-01'
      AND m.nombre_materia LIKE 'INTRODUCCION%'
      AND d.id_profesor <> id_profesor
));
2)  CREATE OR REPLACE FUNCTION fn_check_materia_docentes2020()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        IF EXISTS (
            SELECT 1
            FROM DOCENTE d
            JOIN MATERIA m ON d.id_materia = m.id_materia
            WHERE d.fecha_ingreso > '2020-01-01'
              AND m.nombre_materia LIKE 'INTRODUCCION%'
              AND d.id_materia = NEW.id_materia
              AND d.id_profesor <> NEW.id_profesor
        ) THEN
            RAISE EXCEPTION 'Solo puede haber un DOCENTE con fecha_ingreso mayor a 2020 para materias que empiecen en "INTRODUCCION"';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_check_docentes
BEFORE INSERT OR UPDATE ON DOCENTE
FOR EACH ROW
EXECUTE FUNCTION fn_check_materia_docentes2020();
