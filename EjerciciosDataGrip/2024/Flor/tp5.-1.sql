
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;

/*a)Ejercicio 1- Cómo debería implementar las Restricciones de Integridad Referencial (RIR) si se desea que
cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
que la referencian en la tabla CONTIENE.*/
ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT ck_palabra_contiene
FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
ON DELETE CASCADE;

INSERT INTO P5P1E1_CONTIENE (id_articulo, idioma, cod_palabra)
VALUES (5, 'ES', 1),
       (15, 'BR', 2),
       (23, 'AR', 3);


SELECT *
FROM P5P1E1_PALABRA;

INSERT INTO P5P1E1_ARTICULO (id_articulo, titulo, autor )
VALUES (5, 'HOLA', 'LORENZO'),
       (15, 'CHAU', 'DELFINA'),
       (23, 'VENI', 'FLORENCIA');

SELECT *
FROM P5P1E1_ARTICULO;

SELECT *
FROM P5P1E1_CONTIENE;

DELETE FROM P5P1E1_PALABRA WHERE cod_palabra=1 ;


/*Ejercicio 1. a.b Restrict*/
ALTER TABLE P5P1E1_CONTIENE
DROP CONSTRAINT ck_palabra_contiene,
ADD CONSTRAINT fk_palabra_contiene
FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
ON DELETE RESTRICT ;

DELETE FROM P5P1E1_PALABRA WHERE cod_palabra=2;

/*SET NULL no se puede*/
ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT ck_palabra_contiene
FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
ON UPDATE SET NULL;

ALTER TABLE P5P1E1_CONTIENE
DROP CONSTRAINT ck_palabra_contiene;

ALTER TABLE p5p1e1_palabra
ALTER COLUMN descripcion DROP NOT NULL;

UPDATE P5P1E1_PALABRA SET descripcion='holasdasdas' WHERE cod_palabra=3;

/*SET DEFAULT*/
ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT fk_palabra_contiene_default
FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
ON UPDATE SET DEFAULT ;

UPDATE P5P1E1_CONTIENE SET idioma='PJ' WHERE idioma='AR';

/*VUELVO A HACER NOT NULL DESCRIPCION*/
ALTER TABLE p5p1e1_palabra
ALTER COLUMN descripcion SET NOT NULL;

ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT fk_articulo_contiene
FOREIGN KEY (id_articulo)
REFERENCES P5P1E1_ARTICULO (id_articulo)
ON DELETE CASCADE;

/*EJERCICIO 2*/
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-24 19:20:52.273

-- tables
-- Table: TP5_P1_EJ2_AUSPICIO
CREATE TABLE TP5_P1_EJ2_AUSPICIO (
    id_proyecto int  NOT NULL,
    nombre_auspiciante varchar(20)  NOT NULL,
    tipo_empleado char(2)  NULL,
    nro_empleado int  NULL,
    CONSTRAINT TP5_P1_EJ2_AUSPICIO_pk PRIMARY KEY (id_proyecto,nombre_auspiciante)
);

-- Table: TP5_P1_EJ2_EMPLEADO
CREATE TABLE TP5_P1_EJ2_EMPLEADO (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    cargo varchar(15)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_EMPLEADO_pk PRIMARY KEY (tipo_empleado,nro_empleado)
);

-- Table: TP5_P1_EJ2_PROYECTO
CREATE TABLE TP5_P1_EJ2_PROYECTO (
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(40)  NOT NULL,
    anio_inicio int  NOT NULL,
    anio_fin int  NULL,
    CONSTRAINT TP5_P1_EJ2_PROYECTO_pk PRIMARY KEY (id_proyecto)
);

-- Table: TP5_P1_EJ2_TRABAJA_EN
CREATE TABLE TP5_P1_EJ2_TRABAJA_EN (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    id_proyecto int  NOT NULL,
    cant_horas int  NOT NULL,
    tarea varchar(20)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_TRABAJA_EN_pk PRIMARY KEY (tipo_empleado,nro_empleado,id_proyecto)
);


-- End of file.

/* MATCH FULL ESPECIFICA QUE TODOS LOS VALORES DE LAS COLUMNAS REFERENCIADAS
   DE "EMPLEADO" (TIPO_EMPLEADO, NRO_EMPLEADO) DEBEN COINCIDIR CON LOS VALORES DE LAS COLUMNAS
   REFERENCIADAS DE "AUSPICIO".
   SI QUIERO BORRAR UN REGISTRO DE LA TABLA "EMPLEADO" QUE ESTÁ SIENDO REFERENCIADO EN LA
   TABLA "AUSPICIO" ME LO VA A BORRAR Y LE VA A PONER COMO VALOR "NULL"
   SI QUIERO ACTUALIZAR UN REGISTRO DE LA TABLA "EMPLEADO" NO ME VA A DEJAR YA QUE
   ES ON UPDATE RESTRICT, PARA PODER REALIZARLO TENGO QUE IR A LA TABLA "AUSPICIO"
   Y DESDE ALLÍ PRIMERO MODIFICARLO.*/
-- foreign keys
-- Reference: FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO
    ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
	MATCH FULL
    ON DELETE  SET NULL
    ON UPDATE  RESTRICT;


/* SI QUIERO BORRAR O ACTUALIZAR UN PROYECTO QUE ESTÁ SIENDO UTILIZADO
   EN LA TABLA "AUSPICIO" NO ME VA A DEJAR YA QUE SON DOS RESTRICT */
-- Reference: FK_TP5_P1_EJ2_AUSPICIO_PROYECTO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO
    ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT;


/* SI QUIERO BORRAR UN REGISTRO DE LA TABLA EMPLEADO QUE ESTÉ EN "TRABAJA EN"
   SE VA A BORRAR PERFECTAMENTE Y TAMBIÉN SE VA A ELIMINAR DE "TRABAJA EN"
   SI QUIERO ACTUALIZAR UN REGISTRO DE LA TABLA EMPLEADO QUE TAMBIÉN ESTÉ EN LA
   TABLA "TRABAJA EN" NO SE VA A PODER YA QUE ES ON UPDATE RESTRICT, PARA ESTE
   CASO, DEBERÍA IR A LA TABLA "TRABAJA EN" Y DESDE ALLÍ ACTUALIZAR PRIMERO EL
   REGISTRO Y LUEGO DESDE LA TABLA EMPLEADO. */
-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN
    ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
    ON DELETE  CASCADE
    ON UPDATE  RESTRICT;


/* SI QUIERO BORRAR ALGO DE PROYECTO QUE ESTÉ EN LA TABLA "TRABAJA EN" NO LO PUEDO HACER
   YA QUE ES ON DELETE RESTRICT. PARA PODER ELIMINARLO, PRIMERO DEBO ELIMINAR DE LA TABLA
   "TRABAJA EN" EL REGISTRO Y LUEGO DE LA TABLA "PROYECTO"
   SI QUIERO ACTUALIZAR UN REGISTRO DE LA TABLA PROYECTO QUE ESTÉ EN LA TABLA
   "TRABAJA EN" SE VA A PODER REALIZAR Y SE VA A CAMBIAR TAMBIÉN EN LA TLABA "TRABAJA EN" */

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  CASCADE;



-- EMPLEADO
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 1, 'Juan', 'Garcia', 'Jefe');
INSERT INTO tp5_p1_ej2_empleado VALUES ('B', 1, 'Luis', 'Lopez', 'Adm');
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 2, 'María', 'Casio', 'CIO');

-- PROYECTO
INSERT INTO tp5_p1_ej2_proyecto VALUES (1, 'Proy 1', 2019, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (2, 'Proy 2', 2018, 2019);
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);

-- TRABAJA_EN
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 1, 1, 35, 'T1');
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 2, 2, 25, 'T3');

-- AUSPICIO
INSERT INTO tp5_p1_ej2_auspicio VALUES (2, 'McDonald', 'A ', 2);

/*EJERCICIO 2. A*/
--b.1) Se puede borrar porque proyecto 3 no esta en ninguna relacion. Es RESTRICT pero no tiene referencias
delete from tp5_p1_ej2_proyecto where id_proyecto = 3;

--b.2) IDEM
update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;

--b.3) No te deja porque la relacion de proyecto con trabaja es restrict.
delete from tp5_p1_ej2_proyecto where id_proyecto = 1;

--b.4) Deja borrar porque la relacion entre empleado y trabaja es cascade,
--y no esta referenciada con ningun proyecto (restrict)
delete from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;

--b.5) No se puede porque el id_proyecto 3 ya existe, y es primary key
update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;

--b.6) No se puede porque la relacion entre proyecto y auspicio es restrict UPDATE
update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;

/*EJERCICIO 2. B*/
--Opcion 5, seria: realiza la modificacion si existe el proyecto 66 y el empleado 10

/*d)
  Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas, según se considere
para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO match: i) simple, ii)
parcial, o iii) full:
a. insert into Auspicio values (1, Dell , B, null);
  no admite nulos por ser primary key
b. insert into Auspicio values (2, Oracle, null, null);
  no admite nulos por ser primary key
c. insert into Auspicio values (3, Google, A, 3);
  No se puede porque no existe el empleado numero 3
d. insert into Auspicio values (1, HP, null, 3);
  no admite nulos por ser primary key
 */


/*EJERCICIO 3.
A- Si se puede colocar una accion referencial DELETE RESTRICT porque las fk son distintas e independientes.
Entonces puedo eliminar una ruta desde sin eliminar una ruta hasta
B- No se puede set null o set default porque en ambas tablas las fk son pk
*/

/*EJERCICIO 4
  A- No se puede porque no se puede declarar una foreign key a una columna que no es primary key
  B- No se puede porque contacto y conductor no son primary key
  C- No se puede porque la columna etapa no existe
  D- No se puede xq nro auto no es pk de etapa
  E- Se puede ya q id_equipo en equipo es pk x ende se puede hacer la fk a la tabla auto
  F- Se puede ya que las dos columnas referenciadas (id_equipo y nro_auto) son pk tanto
     en la tabla auto como en la tabla "desem-etapa" y si no existiesen en la tabla
     "desem_etapa" no se podrìa  hacer la relacion entre auto y etapa.
 */


