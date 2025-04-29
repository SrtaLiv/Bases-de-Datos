-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 00:43:08.428

-- tables
-- Table: ATIENDE
CREATE TABLE ATIENDE (
                         tipo_especialidad char(3)  NOT NULL,
                         cod_especialidad int  NOT NULL,
                         nro_matricula int  NOT NULL,
                         cod_centro int  NOT NULL,
                         CONSTRAINT PK_ATIENDE PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad,cod_centro)
);

-- Table: CENTRO_SALUD
CREATE TABLE CENTRO_SALUD (
                              cod_centro int  NOT NULL,
                              nombre varchar(60)  NOT NULL,
                              calle varchar(60)  NOT NULL,
                              numero int  NOT NULL,
                              sala_atencion boolean  NOT NULL,
                              CONSTRAINT PK_CENTRO_SALUD PRIMARY KEY (cod_centro)
);

-- Table: ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
                              tipo_especialidad char(3)  NOT NULL,
                              cod_especialidad int  NOT NULL,
                              descripcion varchar(40)  NOT NULL,
                              CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: MEDICO
CREATE TABLE MEDICO (
                        tipo_especialidad char(3)  NOT NULL,
                        cod_especialidad int  NOT NULL,
                        nro_matricula int  NOT NULL,
                        nombre varchar(30)  NOT NULL,
                        apellido varchar(30)  NOT NULL,
                        email varchar(30)  NOT NULL,
                        CONSTRAINT PK_MEDICO PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad)
);

-- foreign keys
-- Reference: FK_ATIENDE_CENTRO_SALUD (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_CENTRO_SALUD
    FOREIGN KEY (cod_centro)
        REFERENCES CENTRO_SALUD (cod_centro)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_ATIENDE_MEDICO (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_MEDICO
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
        REFERENCES MEDICO (nro_matricula, tipo_especialidad, cod_especialidad)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_MEDICO_ESPECIALIDAD (table: MEDICO)
ALTER TABLE MEDICO ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
        REFERENCES ESPECIALIDAD (tipo_especialidad, cod_especialidad)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

-- ESPECIALIDADES
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('PED', 1, 'Cirugía Pediatrica');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('PED', 2, 'Neumonólogo Infantil');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('NEO', 1, 'Infectología Neo');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('NEO', 2, 'Cardiología Neo');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('GEN', 1, 'Cardiología');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('GEN', 2, 'Traumatología');
INSERT INTO especialidad (tipo_especialidad, cod_especialidad, descripcion) VALUES ('GEN', 3, 'Neumonología');

-- MEDICOS
INSERT INTO medico (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email) VALUES ('GEN', 1, 334456, 'Juan', 'Lopez', 'jlopes@gmil.com');
INSERT INTO medico (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email) VALUES ('GEN', 1, 453367, 'Laura', 'Díaz', 'ldiaz@gmail.com');
INSERT INTO medico (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email) VALUES ('GEN', 2, 564388, 'María', 'Ferrer', 'mferrer@gmail.com');
INSERT INTO medico (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email) VALUES ('PED', 1, 564322, 'Silvia', 'Valca', 'svalca@gmail.com');
INSERT INTO medico (tipo_especialidad, cod_especialidad, nro_matricula, nombre, apellido, email) VALUES ('PED', 1, 432887, 'Esteban', 'Braggan', 'ebragan@gmail.com');

-- CENTROS DE SALUD
INSERT INTO centro_salud (cod_centro, nombre, calle, numero, sala_atencion) VALUES (1, 'HOSPITAL MUNICIPAL', 'Alem', 1450, false);
INSERT INTO centro_salud (cod_centro, nombre, calle, numero, sala_atencion) VALUES (2, 'CLINICA MODELO', 'Av.España', 490, false);
INSERT INTO centro_salud (cod_centro, nombre, calle, numero, sala_atencion) VALUES (3, 'SALA ATENCION La Movediza', 'Azucena', 890, true);

-- ATENCIONES
INSERT INTO atiende (tipo_especialidad, cod_especialidad, nro_matricula, cod_centro) VALUES ('GEN', 1, 334456, 3);
INSERT INTO atiende (tipo_especialidad, cod_especialidad, nro_matricula, cod_centro) VALUES ('GEN', 1, 453367, 3);
INSERT INTO atiende (tipo_especialidad, cod_especialidad, nro_matricula, cod_centro) VALUES ('PED', 1, 564322, 3);
INSERT INTO atiende (tipo_especialidad, cod_especialidad, nro_matricula, cod_centro) VALUES ('PED', 1, 432887, 3);

-- EJERCICIO 1
-- Para el esquema de la figura cuyo script de creación se encuentra aquí, y datos aquí,
-- se debe controlar que  “por cada sala de atención y  por cada especialidad sólo pueden
-- atender 2 médicos” y cuya restricción declarativa es:

-- por cada slaa de atencion y cada especialidad no pueden atender 2 medicos
-- tipo GENERAL, ASSERTION
CREATE ASSERTION ck_atienden_medicos(
    CHECK(
       NOT EXISTS(
         select 1 from
        atiende a
        JOIN CENTRO_SALUD c on a.cod_centro = c.cod_centro
        WHERE sala_atencion = true
        GROUP BY tipo_especialidad, cod_especialidad, a.cod_centro
        HAVING COUNT(*) > 2;
       )
    )
)

select 1 from
atiende a
JOIN CENTRO_SALUD c on a.cod_centro = c.cod_centro
WHERE sala_atencion = true
GROUP BY tipo_especialidad, cod_especialidad, a.cod_centro
HAVING COUNT(*) > 2;


-- TRIGGER
CREATE OR REPLACE FUNCTION fn_control_cant_medicos()
    RETURNS TRIGGER AS
$$
    declare
    cantidad int;
BEGIN
        IF ((SELECT centro_salud, sala_atencion from centro_salud
            where cod_centro = new.cod_centro) = true)

        THEN
            SELECT COUNT(*) INTO cantidad FROM atiende
            WHERE tipo_especialidad = NEW.tipo_especialidad
             AND cod_especialidad = new.cod_especialidad
            and cod_centro = new.cod_centro;

    IF (cantidad > 1) THEN
        RAISE EXCEPTION 'YA HAY 2 MEDICOS';
        END IF;
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- INSERT: devolves NEW
-- UPDATE: devolves NEW
-- BORRADO: devolves el registro "viejo"

CREATE TRIGGER tr_contorl_cant_medicos
    BEFORE INSERT OR UPDATE OF tipo_especialidad, cod_Especialidad, cod_centro
    ON atiende
    FOR EACH ROW EXECUTE PROCEDURE fn_control_cant_medicos();

-- IF CANTIDAD > 1, como es BEFORE inserta cuando hay 0 o 1 registros


-- UPDATEEEEEEEEEEEEEEEEEEEEEEEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION fn_control_cant_medicos_update()
    RETURNS TRIGGER AS
$$
BEGIN
    if(exists(
        SELECT 1
        where cod_centro = new.cod_centro
        GROUP BY tipo_especialidad, cod_especialidad
        having count(*) > 1
    )) THEN
        RAISE EXCEPTION 'HAY MUCHOS MEDICOS POR ESPECIALIDAD EN EL % %', NEW.COD_CENTRO, NEW.NOMBRE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create trigger tr_sala_atencion
    before update of sala_atencion
    on centro_salud
    FOR EACH ROW
    when ( new.sala_atencion = true)
EXECUTE PROCEDURE fn_control_cant_medicos_update();
