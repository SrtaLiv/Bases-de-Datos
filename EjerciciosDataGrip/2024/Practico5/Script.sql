-- BORRADO DE TABLAS
DROP TABLE IF EXISTS EMPLEADO CASCADE;
DROP TABLE IF EXISTS AREA;

--CREACIÓN DE TABLAS
CREATE TABLE EMPLEADO (
    id_empleado int  NOT NULL,
    nombre varchar(50) NOT NULL,
	apellido varchar(50)  NOT NULL,
	fecha_nac date  NOT NULL,
	tipo_area char(2) DEFAULT 'Z',
	id_area int DEFAULT 99,
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado)
);

CREATE TABLE AREA (
	tipo_area char(2) NOT NULL,
	id_area int NOT NULL,
	descripcion varchar(20),
	CONSTRAINT PK_AREA PRIMARY KEY (tipo_area, id_area)
);

ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_AREA
    FOREIGN KEY (tipo_area, id_area)
    REFERENCES AREA (tipo_area, id_area)
	MATCH FULL
    ON DELETE SET DEFAULT
    ON UPDATE SET DEFAULT
;

INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('A', 1, 'Area A1');
INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('A', 2, 'Area A1');
INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('B', 1, 'Area A1');
INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('B', 2, 'Area A1');
INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('Z', 99, 'Valos por defecto');

INSERT INTO EMPLEADO (id_empleado, nombre, apellido, fecha_nac, tipo_area, id_area) VALUES (2, 'José', 'Mares', to_date('06-03-1990', 'dd-MM-yyyy'), 'A',1);
INSERT INTO EMPLEADO (id_empleado, nombre, apellido, fecha_nac, tipo_area, id_area) VALUES (3, 'Ana', 'Castro', to_date('01-08-1980', 'dd-MM-yyyy'), 'B',1);
INSERT INTO EMPLEADO (id_empleado, nombre, apellido, fecha_nac, tipo_area, id_area) VALUES (4, 'Ximena', 'Lopez', to_date('07-08-1985', 'dd-MM-yyyy'), 'A',2);
INSERT INTO EMPLEADO (id_empleado, nombre, apellido, fecha_nac, tipo_area, id_area) VALUES (6, 'Iris', 'Dominic', to_date('07-05-1978', 'dd-MM-yyyy'), 'B',1);

--PRUEBAS:
--Primer prueba: intentar borra de la tabla AREA el registro que contiene
--el valor por defecto. Qué pasará?
DELETE FROM AREA WHERE tipo_area='Z' AND  id_area=99;
Lo eliminó

--Segunda prueba: intentar borrar de la tabla AREA el que tiene clave <A, 1>
-- ya no tengo el registro en area para poner el valor por defecto. Qué pasará?
DELETE FROM AREA WHERE tipo_area='A' AND  id_area=1;

ERROR:  insert or update on table "empleado" violates foreign key constraint "fk_empleado_area"
DETAIL:  Key (tipo_area, id_area)=(Z , 99) is not present in table "area".

-- Vuelvo a cargar el valor por defecto y vuelvo a intentar borrar e la tabla AREA el que tiene clave <A, 1>. Qué pasará?
INSERT INTO AREA (tipo_area, id_area, descripcion) VALUES ('Z', 99, 'Valos por defecto');
DELETE FROM AREA WHERE tipo_area='A' AND  id_area=1;

--Ahora vuelvo a intentar borra de la tabla AREA el registro que contiene
--el valor por defecto. Qué pasará?
DELETE FROM AREA WHERE tipo_area='Z' AND  id_area=99;

ERROR:  update or delete on table "area" violates foreign key constraint "fk_empleado_area" on table "empleado"
DETAIL:  Key (tipo_area, id_area)=(Z , 99) is still referenced from table "empleado".






