-- Dado el siguiente esquema que será utilizado en éste exámen: (

-- Last modification date: 2025-09-01 18:03:02.421

-- tables
-- Table: CONTACTO_ESTACION
CREATE TABLE CONTACTO_ESTACION (
                                   id_contacto serial  NOT NULL,
                                   id_satelite int  NOT NULL,
                                   id_estacion int  NOT NULL,
                                   fecha_contacto timestamp  NOT NULL,
                                   duracion_minutos int  NULL,
                                   tipo_contacto varchar(50)  NULL,
                                   CONSTRAINT CONTACTO_ESTACION_pk PRIMARY KEY (id_contacto)
);

-- Table: ESTACION_TERRENA
CREATE TABLE ESTACION_TERRENA (
                                  id_estacion serial  NOT NULL,
                                  nombre varchar(100)  NOT NULL,
                                  pais varchar(100)  NOT NULL,
                                  ubicacion_lat decimal(9,6)  NOT NULL,
                                  ubicacion_lon decimal(9,6)  NOT NULL,
                                  responsable varchar(100)  NULL,
                                  CONSTRAINT ESTACION_TERRENA_pk PRIMARY KEY (id_estacion)
);

-- Table: IMAGENES_CAPTURADAS
CREATE TABLE IMAGENES_CAPTURADAS (
                                     id_imagen serial  NOT NULL,
                                     id_sensor int  NOT NULL,
                                     fecha_captura timestamp  NOT NULL,
                                     ubicacion_centro_lat decimal(9,6)  NOT NULL,
                                     ubicacion_centro_lon decimal(9,6)  NOT NULL,
                                     resolucion decimal(6,2)  NOT NULL,
                                     formato varchar(20)  NOT NULL,
                                     ruta_archivo varchar(255)  NULL,
                                     CONSTRAINT IMAGENES_CAPTURADAS_pk PRIMARY KEY (id_imagen)
);

-- Table: MISION
CREATE TABLE MISION (
                        id_mision serial  NOT NULL,
                        nombre_mision varchar(100)  NOT NULL,
                        objetivo text  NULL,
                        fecha_inicio date  NOT NULL,
                        fecha_fin date  NULL,
                        CONSTRAINT MISION_pk PRIMARY KEY (id_mision)
);

-- Table: ORBITA
CREATE TABLE ORBITA (
                        id_orbita serial  NOT NULL,
                        tipo_orbita varchar(50)  NOT NULL,
                        altitud_km decimal(8,2)  NULL,
                        inclinacion_grados decimal(5,2)  NULL,
                        periodo_minutos decimal(6,2)  NULL,
                        CONSTRAINT ORBITA_pk PRIMARY KEY (id_orbita)
);

-- Table: SATELITE
CREATE TABLE SATELITE (
                          id_satelite serial  NOT NULL,
                          nombre varchar(100)  NOT NULL,
                          pais_origen varchar(100)  NOT NULL,
                          agencia varchar(100)  NOT NULL,
                          fecha_lanzamiento date  NOT NULL,
                          vida_util_estimada int  NOT NULL,
                          estado varchar(5)  NOT NULL,
                          id_tipo int  NOT NULL,
                          id_orbita int  NOT NULL,
                          CONSTRAINT SATELITE_pk PRIMARY KEY (id_satelite)
);

-- Table: SATELITE_MISION
CREATE TABLE SATELITE_MISION (
                                 id_satelite int  NOT NULL,
                                 id_mision int  NOT NULL,
                                 CONSTRAINT SATELITE_MISION_pk PRIMARY KEY (id_satelite,id_mision)
);

-- Table: SENSOR
CREATE TABLE SENSOR (
                        id_sensor serial  NOT NULL,
                        id_satelite int  NOT NULL,
                        nombre_sensor varchar(100)  NOT NULL,
                        tipo_sensor varchar(50)  NOT NULL,
                        resolucion decimal(6,2)  NOT NULL,
                        ancho_banda decimal(6,2)  NULL,
                        CONSTRAINT SENSOR_pk PRIMARY KEY (id_sensor)
);

-- Table: TIPO_SATELITE
CREATE TABLE TIPO_SATELITE (
                               id_tipo serial  NOT NULL,
                               descripcion varchar(100)  NOT NULL,
                               CONSTRAINT TIPO_SATELITE_pk PRIMARY KEY (id_tipo)
);

-- foreign keys
-- Reference: FK_0 (table: SENSOR)
ALTER TABLE SENSOR ADD CONSTRAINT FK_0
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_1
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_2
    FOREIGN KEY (id_estacion)
        REFERENCES ESTACION_TERRENA (id_estacion)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_3
    FOREIGN KEY (id_satelite)
        REFERENCES SATELITE (id_satelite)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_4
    FOREIGN KEY (id_mision)
        REFERENCES MISION (id_mision)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: IMAGENES_CAPTURADAS)
ALTER TABLE IMAGENES_CAPTURADAS ADD CONSTRAINT FK_5
    FOREIGN KEY (id_sensor)
        REFERENCES SENSOR (id_sensor)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_orbita (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_orbita
    FOREIGN KEY (id_orbita)
        REFERENCES ORBITA (id_orbita)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: fk_tipo (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_tipo
    FOREIGN KEY (id_tipo)
        REFERENCES TIPO_SATELITE (id_tipo)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

--a) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
-- declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
-- tablas/atributos necesarios.

-- - Verificar que cada satélite tenga al menos una misión

-- Seleccione la/las opción/es que considera correcta/s, d
-- e acuerdo a lo solicitado y justifique claramente porqué
-- la/s considera correcta/s

-- TABLAS: SATELITE Y MISION, pq si solo agarro satelite mision tengo tofdos los datelites con mision
CREATE ASSERTION CHECK(
       CHECK NOT EXIST(
       SELECT 1
        FROM SATELITE
        LEFT JOIN SATELITE_MISION USING (id_satelite)
        group by id_satelite
        having count(id_mision) < 1
       )
)

--b) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
--declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando solo las
--tablas/atributos necesarios.
--Las fechas de contacto de cada estación deben ser posteriores a la fecha de lanzamiento de cada satélite.
       -- Resuelva según lo solicitado y justifique el tipo de chequeo utilizado.

CREATE ASSERTION CHECK(
       CHECK NOT EXIST(
            SELECT 1
            FROM CONTACTO_ESTACION
            JOIN SATELITE
            USING (id_satelite)
            WHERE CONTACTO_ESTACION.fecha_contacto < SATELITE.fecha_lanzamiento
       )
)

-- 2a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
-- actualizable en PostgreSQL, siempre que sea posible:

       -- V1: que contenga todos los datos de los satélites que aún no
       -- han hecho contacto con ninguna estación terrena


CREATE V1 VIEW AS
SELECT * FROM SATELITE s
WHERE s.id_satelite NOT IN (
    SELECT 1
    FROM CONTACTO_ESTACION c
    WHERE s.id_satelite = c.id_satelite
    AND tipo_contacto = 'E'
    );

-- Esta mal, porque la tabla contacto_estacion ya es la intermedia entre estacion terrena y satelite
-- asi que solo con controlar que no haya nada de contacto estaicon satelite esta bien
-- para que sea actualizable solo debe tener 1 tabla, no deben haber joins
-- Si no existe → significa que no tuvo contacto con ninguna estación
-- No usar GROUP BY, DISTINCT, agregaciones, etc.

------------------------------------------------------------------------------------------------------------------------

--  2b) Considerando la siguiente definición para V1, seleccione la/s afirmación/es que considere correcta/s
-- respecto de esta vista y justifíquela/s claramente.

CREATE VIEW V1 AS
SELECT * FROM SATELITE s
WHERE NOT EXISTS (SELECT 1 FROM TIPO_SATELITE t WHERE s.id_tipo = t.id_tipo AND upper(descripcion) like
                                                                                '%RECONOCIMIENTO%')
-- a. Ninguna de las opciones es correcta
-- b. No es posible reformular la consulta para  seleccionar todos los satélites que son del tipo reconocimiento
-- (y sea automáticamente actualizable)
-- c. No resulta automáticamente actualizable en PostgreSQL
-- d. Contiene todos los datos de los satélites de reconocimiento
-- e. Es automáticamente actualizable en PostgreSQL -- CORRECTO
-- f. Para seleccionar todos los satélites que son del tipo reconocimiento hay que reformular la consulta cmbiendo el NOT EXISTS por EXISTS -- CORRECTO
-- g. No está correctamente correlacionada la consulta con la subconsulta
-- h. Está correctamente correlacionada la consulta con la subconsulta -- CORRECTO


-- 2c) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
-- actualizable en PostgreSQL, siempre que sea posible, y que se verifique que no haya migración de tuplas de la
-- vista. Resuelva según lo solicitado y justifique su solución.
--
-- - V2: Listar los satélites lanzados después del año 2024 que no poseen sensores.
CREATE VIEW V2 AS
    SELECT *
FROM SATELITE
WHERE extract(YEAR FROM fecha_lanzamiento) > 2024
AND SATELITE.id_satelite NOT IN (
    SELECT SENSOR.id_satelite
    FROM SENSOR
)WITH CHECK OPTION;


CREATE VIEW V2 AS
SELECT *
FROM SATELITE
WHERE extract(YEAR FROM fecha_lanzamiento) > 2024
  AND NOT EXISTS (
    SELECT 1
    FROM SENSOR
    WHERE SENSOR.id_satelite = SATELITE.id_satelite
)WITH CHECK OPTION;

-- EL WITH CHECK OPTION IMPIDE LA MIGRACION DE TUPLAS FUERA DE VISTA!

-- OK SIEMPRE Q SEA INSERT V2.. no me dejara, pero si es insert satelite si

------------------------------------------------------------------------------------------------------------------

--3) Para el esquema dado, es necesario consultar
-- los contactos de un satélite realizados después de una determinada fecha
-- , mostrando: estación, fecha del contacto y duración; el satélite y la fecha son datos que se
-- aportan. Resuelva con el recurso que considere más conveniente.

-- Para estos casos lo mejor son Stored procedure / función

CREATE OR REPLACE FUNCTION contactos_satelites_despues_de_x_fecha()
RETURNS CONTACTO_ESTACION
    AS $$
    DECLARE fecha_contacto_aportada timestamp;
        id_satelite_aportado integer;
BEGIN
    SELECT c.id_estacion, c.fecha_contacto, c.duracion_minutos
    FROM CONTACTO_ESTACION c
    WHERE extract(YEAR FROM c.fecha_contacto) > fecha_contacto_aportada
        AND c.id_satelite = id_satelite_aportado;
END;
    $$
LANGUAGE plpgsql;

-- mal escrito pero maso bien

CREATE OR REPLACE FUNCTION contactos_satelites_despues_de_x_fecha2(
    fecha_contacto_aportada timestamp,
    id_satelite_aportado integer
)
    RETURNS TABLE(
                     estacion INT,
                     fecha_contacto TIMESTAMP,
                     duracion_minutos INT
    )
AS $$
BEGIN
    RETURN QUERY
    SELECT c.id_estacion,
        c.fecha_contacto,
        c.duracion_minutos
    FROM CONTACTO_ESTACION c
    WHERE extract(YEAR FROM c.fecha_contacto) > fecha_contacto_aportada
      AND c.id_satelite = id_satelite_aportado;
END;
$$
LANGUAGE plpgsql
-- CORREGIDO POR GPT Y SOFI

--4) Listar todas las imágenes capturadas mostrando el id_imagen, fecha_captura, id_sensor y un número de fila
-- ordenado por fecha de captura dentro de cada sensor además de la fecha de la primera imagen tomada por
-- ese sensor

--FUNCTION VENTANA
SELECT id_imagen, fecha_captura, id_sensor,
ROW_NUMBER() OVER (
    PARTITION BY
        id_sensor
    ORDER BY fecha_captura
    ) as fila,
MIN(fecha_captura) OVER (
    partition by id_sensor
    ) as primera_imagen
FROM IMAGENES_CAPTURADAS

-- segun gpt: el segundo row_number esta mal, pq pide: mostrar la fecha de la primera imagen tomada por ese sensor
-- y eso es una funcion tipio min()
-- Calcula la fecha mínima dentro de cada sensor

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


    --5a) Es posible plantear con una sentencia declarativa un control que
    -- no permita agregar imágenes a satélites
    -- que están activos? Si su respuesta es positiva plantee el control; caso contrario justifique porque.


    --rta
    -- Si es posible mediante Triggers, estos sirven para que al realizar una operacion como actualizar, eliminar o agregar,
    -- verifiquen ciertas reglas. En este caso se podria realizar que no permita agregar imagenes a satelites
    -- que estan activos mediante condiciones y excepciones. Hay que controlar tanto en Satelite como en Sensor, como es +1
    -- tabla se puede hacer con Assertion tambien. No es soportado en Postgres pero si en el estandar SQL

    -- CORRECCION: UN TRIGGER NO ES DECLARATIVO, ES PROCEDURAL. ASI Q SOLO MENCIONAR ASSERTIONS

    -- debemos controlar los siguientes atributos:
    -- tabla: Satelite
    -- id_satelite, estado ('A)

    -- tabla: Sensor
    -- id_imagen, id_sensor
    CREATE ASSERTION ck_impedir_agregar_imagenes_con_satelites_activos
           CHECK (
            NOT EXISTS(
            SELECT 1
                FROM Sateltite s
                JOIN Sensor
                USING (id_satelite)
                JOIN IMAGEN_CAPTURADA
                USING (id_sensor)
                WHERE s.ESTADO = 'A'
           )
    )

--perfect!, lo unico a tener en cuenta es que los using solo sirven cuando los atributos tienen el mismo nombre en todas las tablas

------------------------------------------------------------------------------------------------------------------------

--5b)  En caso de que sea posible plantee de manera procedural lo requerido en el punto 5.a

CREATE OR REPLACE FUNCTION fn_impedir_agregar_satelite_activo_con_imagen()
RETURNS TRIGGER AS $$
declare cant int;
    BEGIN
    IF NEW.estado = 'A' THEN

        SELECT count(*) into cant -- o podria ser if exist una imagen capturada tirar exception
        FROM SATELITE
        JOIN SENSOR USING (id_satelite)
        JOIN IMAGENES_CAPTURADAS
        USING (id_sensor)
        WHERE new.id_satelite = SATELITE.id_satelite;
    end if;

    IF cant > 0 THEN
        RAISE EXCEPTION
            'No se puede activar el satélite porque tiene imágenes capturadas';
    END IF;

    RETURN NEW;

end;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_impedir_agregar_satelite_activo_con_imagen
    BEFORE UPDATE OF estado ON SATELITE
    FOR EACH ROW EXECUTE FUNCTION fn_impedir_agregar_satelite_activo_con_imagen();

----
-- ESTE QUE HICE RECIEN ESTA MAL, POR QUE?
-- PORQUE PODEMOS VERIFICAR SIN LA TABLA IMAGEN CAPTURA AL SELECCIONAR, USAMOS SOLO EL ID_SENSOR,
-- COMPARAMOS EL ID_SENSOR QUE QUIEREN AGREGAR EN IMAGENES CAPTURADAS CON EL DE LA TABLA, Y ASI
--EVITAMOS 2 JOINS
CREATE OR REPLACE FUNCTION fn_impedir_agregar_imagen_con_satelite_activo()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM IMAGENES_CAPTURADAS
                 JOIN SENSOR USING (id_sensor)
                 JOIN SATELITE USING (id_satelite)
        WHERE upper(SATELITE.estado) LIKE 'A'
          AND NEW.id_imagen = IMAGENES_CAPTURADAS.id_imagen;
    ) THEN RAISE EXCEPTION
            'No se puede agregar una imagen capturada de un satélite con estado activo';
    END IF;

    RETURN NEW;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER tr_impedir_imagen_con_satelite_activo
    BEFORE INSERT OR UPDATE ON IMAGENES_CAPTURADAS
    FOR EACH ROW EXECUTE FUNCTION fn_impedir_agregar_imagen_con_satelite_activo();

-- CORRECCION
CREATE OR REPLACE FUNCTION fn_impedir_agregar_imagen_con_satelite_activo()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM SENSOR
        JOIN SATELITE
        USING (id_satelite)
        WHERE SENSOR.id_sensor = new.id_sensor
        AND SATELITE.estado = 'A'
    ) THEN RAISE EXCEPTION
        'No se puede agregar una imagen capturada de un satélite con estado activo';
END IF;

    RETURN NEW;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER tr_impedir_imagen_con_satelite_activo
    BEFORE INSERT OR UPDATE OF id_sensor ON IMAGENES_CAPTURADAS
    FOR EACH ROW EXECUTE FUNCTION fn_impedir_agregar_imagen_con_satelite_activo();

