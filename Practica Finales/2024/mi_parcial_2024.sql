-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:00:07.082

-- tables
-- Table: CONTRATA
CREATE TABLE CONTRATA (
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    DNI int  NOT NULL
);

-- Table: MULTI_SERV
CREATE TABLE MULTI_SERV (
    DNI int  NOT NULL
);

-- Table: SERVICIO
CREATE TABLE SERVICIO (
    cod_tipo_serv int  NOT NULL,
    id_servicio int  NOT NULL,
    nombre_servicio varchar(120)  NOT NULL
);

-- Table: TIPO_SERVICIO
CREATE TABLE TIPO_SERVICIO (
    cod_tipo_serv int  NOT NULL,
    nombre_tipo_serv varchar(40)  NOT NULL,
    descripcion_tipo_serv text  NOT NULL,
    CONSTRAINT AK_TIPO_SERVICIO UNIQUE (nombre_tipo_serv) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: UNI_SERV
CREATE TABLE UNI_SERV (
    DNI int  NOT NULL,
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_USUARIO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- End of file.


-- Considere las siguientes sentencias SQL de declaración de claves primarias
-- (PK) y claves extranjeras (FK) sobre el esquema dado:

-- Primary keys
ALTER TABLE MULTI_SERV ADD CONSTRAINT PK_MULTI_SERV PRIMARY KEY (DNI);
ALTER TABLE TIPO_SERVICIO ADD CONSTRAINT PK_TIPO_SERVICIO PRIMARY KEY (cod_tipo_serv);
ALTER TABLE UNI_SERV ADD CONSTRAINT PK_UNI_SERV PRIMARY KEY (DNI);
ALTER TABLE USUARIO ADD CONSTRAINT PK_USUARIO PRIMARY KEY (DNI);

-- foreign keys
ALTER TABLE CONTRATA ADD CONSTRAINT FK_CONTRATA_MULTI_SERV
    FOREIGN KEY (DNI)
        REFERENCES MULTI_SERV (DNI);

ALTER TABLE CONTRATA ADD CONSTRAINT FK_CONTRATA_SERVICIO
    FOREIGN KEY (id_servicio, cod_tipo_serv)
        REFERENCES SERVICIO (id_servicio, cod_tipo_serv);

ALTER TABLE SERVICIO ADD CONSTRAINT FK_SERVICIO_TIPO_SERVICIO
    FOREIGN KEY (cod_tipo_serv)
        REFERENCES TIPO_SERVICIO (cod_tipo_serv);

--Escriba las sentencias sentencias SQL de declaración de claves primarias (PK),
-- claves alterativas (AK) y claves extranjeras (FK) que faltan teniendo en cuenta los siguiente:
--a) Deben definirse las acciones referenciales para que cada vez que se elimine o modifique (PK) de usuario debe hacerse también de las tablas subtipo en la jerarquía.
--b) El e_mail de los usuarios debe ser único.


------------------------------

-- 1) De la sentencia Declarativa mas restrictuva que controle lo siguiente:

-- Un Servicio no puede ser contratado en las dos modalidades de Servicio

--2) En caso de que no pueda ser implementado en PostgreSQL declarativamente, de
-- la solución procedural mas eficiente.

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:00:07.082

-- tables
INSERT INTO SERVICIO(COD_TIPO_SERV, ID_SERVICIO, NOMBRE_SERVICIO) VALUES (1, 1, 'A');
INSERT INTO SERVICIO(COD_TIPO_SERV, ID_SERVICIO, NOMBRE_SERVICIO) VALUES (2, 1, 'B');
INSERT INTO CONTRATA(ID_SERVICIO, COD_TIPO_SERV, DNI) VALUES (1,1,1312 );
INSERT INTO CONTRATA(ID_SERVICIO, COD_TIPO_SERV, DNI) VALUES (1,2,1312 );

select id_servicio
from SERVICIO
JOIN CONTRATA
USING (id_servicio, cod_tipo_serv)
where cod_tipo_serv IN (1, 2)
GROUP BY id_servicio;

CREATE ASSERTION ck_ej CHECK (
       NOT EXISTS(
        SELECT 1
                   FROM contrata c
                   JOIN uni_serv u USING (id_servicio, cod_tipo_serv)));

)

-- pregunta 5
--P
DELETE FROM PROVEE WHERE CUIT = ’1-26356-0’;

Respuesta 1
UPDATE PROVEE SET id_suministro = 1 WHERE CUIT = ’1-40592-3’;
-- PROCEDE!

Respuesta 2
-- F
DELETE FROM TIPO_SUMINISTRO WHERE cod_tipo_sum =’D’;

Respuesta 3
-- P
DELETE FROM SUMINISTRO WHERE id_suministro = 3;

Respuesta 4
F
UPDATE SUMINISTRO SET id_suministro =’2’ WHERE cod_tipo_sum =’B’;

Respuesta 5
F
UPDATE TIPO_SUMINISTRO SET cod_tipo_sum =’F’ WHERE cod_tipo_sum =’B’;

Respuesta 6
F
DELETE FROM TIPO_SUMINISTRO WHERE cod_tipo_sum =’B’;

Respuesta 7