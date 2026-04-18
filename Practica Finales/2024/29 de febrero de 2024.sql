-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-02-27 16:44:42.412

-- tables
-- Table: ASIGNACION
CREATE TABLE ASIGNACION (
                            cod_plan int  NOT NULL,
                            idArea char(2)  NOT NULL,
                            nroUsuario int  NOT NULL,
                            fecha_desde date  NOT NULL,
                            fecha_hasta date  NULL,
                            num_dispositivos int  NOT NULL,
                            CONSTRAINT ASIGNACION_pk PRIMARY KEY (cod_plan,idArea,nroUsuario)
);

-- Table: GESTION
CREATE TABLE GESTION (
                         usuario int  NOT NULL,
                         nro_gestion int  NOT NULL,
                         motivo char(80)  NOT NULL,
                         idArea char(2)  NULL,
                         cod_plan int  NULL,
                         fecha date  NOT NULL,
                         CONSTRAINT GESTION_pk PRIMARY KEY (usuario,nro_gestion)
);

-- Table: PLAN
CREATE TABLE PLAN (
                      idArea char(2)  NOT NULL,
                      cod_plan int  NOT NULL,
                      nombre varchar(50)  NOT NULL,
                      anio_inicio int  NOT NULL,
                      tipo_plan char(1)  NOT NULL,
                      CONSTRAINT PLAN_pk PRIMARY KEY (idArea,cod_plan)
);

-- Table: PLAN_PROMO
CREATE TABLE PLAN_PROMO (
                            idArea char(2)  NOT NULL,
                            cod_plan int  NOT NULL,
                            condicion varchar(80)  NOT NULL,
                            descuento decimal(5,2)  NOT NULL,
                            CONSTRAINT PLAN_PROMO_pk PRIMARY KEY (idArea,cod_plan)
);

-- Table: PLAN_TRAD
CREATE TABLE PLAN_TRAD (
                           idArea char(2)  NOT NULL,
                           cod_plan int  NOT NULL,
                           caracteristica varchar(80)  NOT NULL,
                           CONSTRAINT PLAN_TRAD_pk PRIMARY KEY (idArea,cod_plan)
);

-- Table: USUARIO
CREATE TABLE USUARIO (
                         nroUsuario int  NOT NULL,
                         apell_nombre varchar(50)  NOT NULL,
                         ciudad varchar(20)  NOT NULL,
                         fecha_alta date  NOT NULL,
                         CONSTRAINT USUARIO_pk PRIMARY KEY (nroUsuario)
);

-- foreign keys
-- Reference: FK_ASIGNACION_PLAN (table: ASIGNACION)
ALTER TABLE ASIGNACION ADD CONSTRAINT FK_ASIGNACION_PLAN
    FOREIGN KEY (idArea, cod_plan)
        REFERENCES PLAN (idArea, cod_plan)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_ASIGNACION_USUARIO (table: ASIGNACION)
ALTER TABLE ASIGNACION ADD CONSTRAINT FK_ASIGNACION_USUARIO
    FOREIGN KEY (nroUsuario)
        REFERENCES USUARIO (nroUsuario)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_GESTION_PLAN (table: GESTION)
ALTER TABLE GESTION ADD CONSTRAINT FK_GESTION_PLAN
    FOREIGN KEY (idArea, cod_plan)
        REFERENCES PLAN (idArea, cod_plan)
        ON DELETE  SET NULL
        ON UPDATE  SET NULL
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_GESTION_USUARIO (table: GESTION)
ALTER TABLE GESTION ADD CONSTRAINT FK_GESTION_USUARIO
    FOREIGN KEY (usuario)
        REFERENCES USUARIO (nroUsuario)
        ON DELETE  CASCADE
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_PLANPROMO_PLAN (table: PLAN_PROMO)
ALTER TABLE PLAN_PROMO ADD CONSTRAINT FK_PLANPROMO_PLAN
    FOREIGN KEY (idArea, cod_plan)
        REFERENCES PLAN (idArea, cod_plan)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_PLANTRAD_PLAN (table: PLAN_TRAD)
ALTER TABLE PLAN_TRAD ADD CONSTRAINT FK_PLANTRAD_PLAN
    FOREIGN KEY (idArea, cod_plan)
        REFERENCES PLAN (idArea, cod_plan)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 1
-- a) Complete apropiadamente las siguientes definiciones de
-- vistas sobre el esquema dado, teniendo en cuenta que deben
-- resultar -siempre que sea posible- automáticamente
-- actualizables en PostgreSQL, justificándolo en cada caso:

-- V1 con los datos de los usuarios de Tandil o Mar del Plata que no
-- registran gestiones sobre planes promocionales durante el
-- corriente año.

CREATE VIEW V1 (nroUsuario, apell_nombre, ciudad,
anio_alta) AS
    SELECT *
    FROM USUARIO
    WHERE nroUsuario NOT IN = (
        SELECT
        usuario
        FROM
        GESTION
        WHERE id_area, cod_area
        NOT IN = (
            SELECT idArea, cod_plan
            FROM PLAN
            WHERE tipo_plan ILIKE = 'P' --PLAN PROMO
            AND -- no se si tener en cuenta para el corriente año, el inicio y que este activo por la condicion de plan_promo,
        --o tener ne cuenta lo de asignacion la fecha desde y hasta.. ire por la 2da opcion
            -- y el not in, lo ocntinuo aca, o lo continuo fuera de este where? elijo 1era opcion
            id_area, cod_plan NOT IN = (
                SELECT idArea, cod_plan
                FROM ASIGNACION
                WHERE NOT (EXTRACT(YEAR FROM FECHA_DESDE) = EXTRACT(YEAR FROM CURRENT_DATE))
            )
            AND (EXTRACT(YEAR FROM anio_inicio) = EXTRACT(YEAR FROM CURRENT_DATE)) -- O QUIZA ERA que tenga plan, anio_inicio = a este?!
        )
        WHERE ciudad ILIKE 'TANDIL'
        OR ciudad ILIKE 'MAR DEL PLATA'
    )

-- CORRECCIONES: la fecha que tenian en cuenta era la de gestion, y no hacia falta ir a PLAN, sino con ir a PLAN_PROMO bastaba

CREATE VIEW V1 (nroUsuario, apell_nombre, ciudad,
                anio_alta) AS
SELECT *
FROM USUARIO
WHERE nroUsuario NOT IN = (
        SELECT usuario
        FROM GESTION
        WHERE id_area, cod_area
        NOT IN = (
            SELECT idArea, cod_plan
            FROM PLAN_PROMO
        )
        AND EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
    )
WHERE ciudad ILIKE 'TANDIL'
OR ciudad ILIKE 'MAR DEL PLATA'

-- ERRORES:
-- 1. NOT IN =  NO EXISTE
-- 2. NO PUEDE SER SELECT * PORQUE ESTARIA OBTENIENDO FECHA_ALTA, Y EN EL CREATE VIEW DE LA CONSIGNA ES ANIO_ALTA
-- 3. EL WHERE DEBE IR ( ), NO WHERE id_area, cod_area
-- 4. HAY DOBLE WHERE EN UNA MISMA CONSULTA A PARTIR DE USUARIO.

CREATE VIEW V1 (nroUsuario, apell_nombre, ciudad,
                anio_alta) AS
SELECT nroUsuario, apell_nombre, ciudad, EXTRACT(YEAR FROM fecha_alta) AS anio_alta -- ACA SE VE EL PUNTO 2.
FROM USUARIO u
WHERE  (ciudad ILIKE 'TANDIL'
OR ciudad ILIKE 'MAR DEL PLATA'
) AND NOT EXISTS (
        SELECT 1
        FROM GESTION g
        WHERE u.nroUsuario = g.usuario
        AND EXTRACT(YEAR FROM g.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND (g.idArea, g.cod_plan) IN ( -- aca no podia ser NOT IN, pq DEBE estar en plan promo para agarrar los que NO EXISTEN
            SELECT idArea, cod_plan
            FROM PLAN_PROMO
        )
    )

-- ULTIMO ERROR:
-- NOT IN NO ES SEGURO CUANDO PUEDE HABER NULLS, EN CAMBIO EL NOT EXISTS MANEJA CORRECTAMENTE EL NUL.
--EXISTS (o NOT EXISTS) no se aplica sobre una columna (nroUsuario)

-- ES ACTUALIZABLE? NO, PORQUE PARA SER ACTUALIZABLE DEBERIA TENER LAS COLUMNAS DE LA TABLA BASE, Y EN ESTA PIDE
-- CREAR UNA VISTA SELECCIONANDO ANIO_ALTA, QUE SE CALCULA A TRAVES DEL EXTRACT YEAR.
-- EN LAS REGLAS DICE: NO TIENE COLUMNAS CALCULADAS COMPLEJAS.

--tiempo: 40 minutos
------------------------------------------------------------------------------------------------------------------------------

-- V2 con los datos completos de todos los planes ofrecidos,
-- incluyendo también los atributos: caract_cond (con su
-- característica o condición, según sea plan tradicional o
-- promocional) y descuento (con el valor de descuento ofrecido si
-- es promocional, o 0 si es tradicional).

CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio,
tipo_plan, caract_cond, descuento) AS


-- MI INTENTO
    CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio,
tipo_plan, caract_cond, descuento) AS
SELECT
    cod_plan, idarea, nombre, anio_inicio,
tipo_plan,
caract_cond
    , descuento
FROM PLAN p
WHERE EXISTS(
    SELECT 1
    FROM PLAN_PROMO pp
    WHERE p.idArea = pp.idArea
    AND p.cod_plan = pp.cod_plan
    and caract_cond = condicion -- le asingo condicion  a plan promo
)
OR EXISTS(
    SELECT 1
    FROM PLAN_TRAD pt
    WHERE p.idArea = pt.idArea
    AND p.cod_plan = pt.cod_plan
    AND pt.descuento = 0
    AND caract_cond = caracteristica -- le asingo caracteristica  aplan trad
)

--ERRORES:
-- filtrar en where el caract_cond que no es una columna de plan
-- FALTA USAR EL COALASCE, esta es una funcion que te trae el primer valor
-- no null que encuentra
-- por ejemplo encontramos 2 planes,
-- id 1 plan trad con caract = 1,
-- id 2 plan promo con descuento = 100
--resultado: id 1, plan_trad, caract =1, CONDICION = NULL
--resultado: id 1, plan_promo, caract =0, condicion = 2
-- EL COALASCE ME LO TRAERIA ASI:
--resultado: id 1, plan_trad, caract_COND =1,
--resultado: id 1, plan_promo, CARACT_cond = 2
-- entonces donde tenemos caracteristica y condiciin, le ponemos
-- caract_cond as COALASCE(caracteristica, condicion) :D

--2do intento
 CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio,
tipo_plan, caract_cond, descuento) AS
SELECT
    cod_plan, idarea, nombre, anio_inicio,
tipo_plan,
COALESCE(pp.condicion, pt.caracteristica) AS caract_cond,
COALESCE(pp.descuento, 0) AS descuento
FROM PLAN p
LEFT JOIN plan_promo pp USING(idarea, cod_plan)
LEFT JOIN plan_trad pt USING(idArea, cod_plan);

-- por que usamos left join y no join comun?
-- porque si hay algo nulo entre plan promo y plan trad
-- me ignorara la fila,pq los join debe coindicir
-- las filas para que me lo traiga

-- MINUTOS: 25 APROX

-- b)Respecto de las vistas V1 y V2 anteriores que no resulten
-- actualizables por parte del SGBD, provea una implementación
-- completa en PostgreSQL para posibilitar la propagación
-- adecuada de inserciones. Explique su solución y ejemplifique a
-- partir de una sentencia SQL concreta.

CREATE OR REPLACE FUNCTION fn_actualizar_1b()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO plan VALUES(new.idarea, new.cod_plan, new.nombre, new.anio_inicio, new.tipo_plan);
    IF (new.tipo_plan = 'P') THEN
        INSERT INTO PLAN_PROMO VALUES(new.idarea, new.cod_plan, new.caract_cond, new.descuento);
    end if;
    IF (new.tipo_plan = 'T') THEN
        INSERT INTO PLAN_TRAD VALUES(new.idarea, new.cod_plan, new.caract_cond);
    end if;
    return null;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_actualizar_1b
INSTEAD OF insert on V2
FOR EACH ROW EXECUTE FUNCTION fn_actualizar_1b();

insert into v2 VALUES (1,'D','Plan Jubilado',2026,'T','Ser mayor de 60 años',0);

SELECT * FROM V2;

--c) Dada la siguiente definición de vista sobre el esquema dado:
CREATE VIEW V3 AS select * from plan NATURAL JOIN gestion;

--crea una vista que selecciona todas las filas en comun de plan con gestion.
--el natural join lo que hace es hacer join con las columnas con mismo nombre
-- para las FK y PK de cada tabla

--V3 muestra todos los planes que tienen al menos una gestión asociada,
-- combinando los datos del plan con los datos de la gestión, uniendo
-- automáticamente por el área y código de plan."



--corectas: I. y V eso pense xD
--correctas reales: II y III porque la 2 incluye filas que aparece en gestion,
--eso es correcto.
-- 3 porque si se pude en algunos casos en SQL ESTANDAR!! pero en postgresql nO.