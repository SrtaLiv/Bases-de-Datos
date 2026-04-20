
-- tables
-- Table: ACTOR
CREATE TABLE ACTOR (
    id_actor int  NOT NULL,
    pais_origen varchar(30)  NOT NULL,
    nombre_real varchar(50)  NOT NULL,
    nombre_fantasia varchar(50)  NOT NULL,
    fecha_nacim date  NOT NULL,
    ciudad_residencia varchar(50)  NULL,
    pais_residencia varchar(30)  NULL,
    CONSTRAINT ACTOR_pk PRIMARY KEY (id_actor,pais_origen)
);

-- Table: ACTUA
CREATE TABLE ACTUA (
    id_personaje int  NOT NULL,
    id_actor int  NOT NULL,
    pais_origen varchar(30)  NOT NULL,
    monto_facturado decimal(10,2)  NOT NULL,
    idContenido int  NOT NULL,
    CONSTRAINT ACTUA_pk PRIMARY KEY (id_personaje,id_actor,pais_origen)
);

-- Table: CAPITULO
CREATE TABLE CAPITULO (
    Nro_temporada int  NOT NULL,
    idContenido int  NOT NULL,
    NroCapitulo int  NOT NULL,
    titulo varchar(80)  NOT NULL,
    fecha_aparicion date  NOT NULL,
    CONSTRAINT CAPITULO_pk PRIMARY KEY (Nro_temporada,idContenido,NroCapitulo)
);

-- Table: CONTENIDO
CREATE TABLE CONTENIDO (
    idContenido int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    tipo char(1)  NOT NULL,
    CONSTRAINT CONTENIDO_pk PRIMARY KEY (idContenido)
);

-- Table: PELICULA
CREATE TABLE PELICULA (
    idContenido int  NOT NULL,
    descripcion varchar(250)  NOT NULL,
    fecha_estreno date  NOT NULL,
    CONSTRAINT PELICULA_pk PRIMARY KEY (idContenido)
);

-- Table: PERSONAJE
CREATE TABLE PERSONAJE (
    id_personaje int  NOT NULL,
    nombre_apellido varchar(50)  NOT NULL,
    descripcion varchar(200)  NOT NULL,
    CONSTRAINT PERSONAJE_pk PRIMARY KEY (id_personaje)
);

-- Table: SERIE
CREATE TABLE SERIE (
    idContenido int  NOT NULL,
    resumen varchar(200)  NOT NULL,
    CONSTRAINT SERIE_pk PRIMARY KEY (idContenido)
);

-- Table: TEMPORADA
CREATE TABLE TEMPORADA (
    Nro_temporada int  NOT NULL,
    idContenido int  NOT NULL,
    CONSTRAINT TEMPORADA_pk PRIMARY KEY (Nro_temporada,idContenido)
);

-- foreign keys
-- Reference: FK_ACTUA_ACTOR (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_ACTOR
    FOREIGN KEY (id_actor, pais_origen)
    REFERENCES ACTOR (id_actor, pais_origen)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ACTUA_CONTENIDO (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ACTUA_PERSONAJE (table: ACTUA)
ALTER TABLE ACTUA ADD CONSTRAINT FK_ACTUA_PERSONAJE
    FOREIGN KEY (id_personaje)
    REFERENCES PERSONAJE (id_personaje)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_CAPITULO_TEMPORADA (table: CAPITULO)
ALTER TABLE CAPITULO ADD CONSTRAINT FK_CAPITULO_TEMPORADA
    FOREIGN KEY (Nro_temporada, idContenido)
    REFERENCES TEMPORADA (Nro_temporada, idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PELICULA_CONTENIDO (table: PELICULA)
ALTER TABLE PELICULA ADD CONSTRAINT FK_PELICULA_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_SERIE_CONTENIDO (table: SERIE)
ALTER TABLE SERIE ADD CONSTRAINT FK_SERIE_CONTENIDO
    FOREIGN KEY (idContenido)
    REFERENCES CONTENIDO (idContenido)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_TEMPORADA_SERIE (table: TEMPORADA)
ALTER TABLE TEMPORADA ADD CONSTRAINT FK_TEMPORADA_SERIE
    FOREIGN KEY (idContenido)
    REFERENCES SERIE (idContenido)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 1
-- Según las acciones referenciales especificadas en el script de creación, analice los posibles efectos de cada una
-- de las siguientes operaciones sobre la BD, justificando a partir de los aspectos conceptuales involucrados (Nota:
-- considere que en cada caso existen tupla/s afectada/s según los valores dados y que los resultados no son
-- acumulativos):

--A)
UPDATE contenido SET idContenido = 234 WHERE idContenido = 123;
-- se puede actualizar correctamente siempre y cuando no haya PELICULAS con ese ID, ya que
-- por default tiene restrict. Pero si en contrenido, no hay ninguna FK en pelicula
--podria proceder correctamente, Mismo escenario con Actua. Si tuviera CASCADE para
--pelicula y actua, procederia.
-- Se propaga correctamnte en pelicula, serie, temporada por cascade pero en ACTUA
-- impediria hacerlo, asi que se rechaza toa la transaccion

-- CORRECCION, se rechaza por ener on delet eno action por defecot.

-- b)
delete from serie where idContenido = 345;

-- si hay referencias en TEMPORADA de SERIE, no se podra eliminar proque por defcto tiene
-- delete RESTRICT. solo se podra hacer la operacixon si no hay referencia

-- CORRECCION:
-- Es cierto que no se podra eliminar, pero no es que por defcto tiene restrict. En realidad tiene por defecto
-- ON DELETE NO ACTION, que esto actua como un restrict pero espera al final de la transaccion para ejecutarse.
-- pero al sumar el NOT DEFERREABLE, si se comporta como el restrict (on delete no action + not deferreable).

delete from actor where pais_origen= 'Brasil';
-- rechazada, porque entre entre actor y actua hay cascade, ahi si pasaria
-- pero si vamos a actua y personaje tambien pasaria por el cascade,
--el problema esta entre actua y CONTENIDO ahi el delete es restrict.
-- por lo tanto si se elimina un actor que actua y tiene contenido SE RECHAZARIA
-- PERO SI NO HAY REFERENCIAS SI SE PODRIA ELIMINAR

--CORRECCION: no es delete restrict, sino NO ACTION DELETE.

--Ejercicio 2
-- Considere las siguientes restricciones de integridad (En cada caso indique y justifique el recurso declarativo más
-- restrictivo necesario para definirla e incluya su implementación completa según el estándar SQL. Si en algún
-- caso no es posible, explique por qué y cómo se podría implementar)

-- a) No puede haber temporadas de series con más de 12 capítulos.
--EN MIS PALABRAS: una temporada de una serie no puede tener mas de 12 capitulos, deben ser menos.
--Nro_temporada, NroCapitulo < 12 caps
--NO SE SI NECESITO LAS 3 TABLAS O CON USAR CAPITULO Y SERIE ESTOY!
CREATE ASSERTION ej_2_a CHECK (
       NOT EXISTS(
            SELECT 1 FROM CAPITULO
            GROUP BY Nro_temporada, idcontenido
            HAVING count(*) > 12
       )
)

--b) Los actores no pueden facturar más de 50.0000 en actuaciones de películas si han participado en series.
-- ACTUA: monto_facturado, id_actor, if tiene idContenido en la tabla Pelicula AND if EXISTE 1 idContenido en SERIE
create assertion ej_2_b CHECK(
       NOT EXISTS(
       SELECT 1
            FROM ACTUA a
            JOIN CONTENIDO c
            USING (idContenido)
            WHERE (monto_facturado > 50000
            AND c.tipo ILIKE 'P' ) AND EXISTS (
                SELECT 1
                FROM CONTENIDO cc --versificar que no haya ocntenido de series en el actor
       -- CORRECCION FALTA VERIFICAR QUE SEA DEL MISMO ACGTOR
       JOIN ACTOR USING(idContenido, id_actor, pais_origen)
                where cc.tipo = 'S'
                AND a.idContenido = cc.idContenido
            )
       )
)

SELECT 1
FROM ACTUA a
JOIN CONTENIDO c
USING (idContenido)
WHERE (monto_facturado > 50000
AND c.tipo ILIKE 'P' ) AND EXISTS (
    SELECT 1
    FROM CONTENIDO cc --versificar que no haya ocntenido de series en el actor
    where cc.tipo = 'S'
    AND a.idContenido = cc.idContenido
)

-------------------

-- c) La fecha de estreno de una película no puede ser postergada por más de 12 meses.
-- PELICULA: fecha_estreno, no puede ser CURRENT_DATE + 12 meses.. algo asi

 ALTER TABLE PELICULA ADD CONSTRAINT chk_fecha_lanzamiento CHECK (fecha_estreno <= current_date +  INTERVAL '12 months');

--hacer aputne d einterval

-----

--Ejercicio 3
-- a) Escriba en PostgreSQL los encabezamientos completos con sus funciones correspondientes para todos los
-- triggers requeridos de forma de implementar las restricciones 2.b) y 2.c).

--b) Los actores no pueden facturar más de 50.0000 en actuaciones de películas si han participado en series.
-- ACTUA: monto_facturado, id_actor, if tiene idContenido en la tabla contenido AND if EXISTE 1 tipo = 's'
create assertion ej_2_b CHECK(
       NOT EXISTS(
       SELECT 1
            FROM ACTUA a
            JOIN CONTENIDO c
            USING (idContenido)
            WHERE (monto_facturado > 50000
            AND c.tipo ILIKE 'P' ) AND EXISTS (
                SELECT 1
                FROM CONTENIDO cc --versificar que no haya ocntenido de series en el actor
                where cc.tipo = 'S'
                AND a.idContenido = cc.idContenido
            )
       )
)

CREATE FUNCTION fn_ej_3_del_2b()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(
            SELECT 1
            FROM ACTUA a
            JOIN CONTENIDO c
            USING (idContenido)
            WHERE (a.id_actor = new.id_actor)
            and (monto_facturado > 50000
            AND c.tipo ILIKE 'P' ) AND EXISTS (
                SELECT 1
                FROM CONTENIDO cc --versificar que no haya ocntenido de series en el actor
                where cc.tipo = 'S'
                AND a.idContenido = cc.idContenido
            )
       ) THEN RAISE EXCEPTION 'NO PUEDE HABER UN ACTOR CON > 50000 FACTURADOS EN 1 PELI SI PARTICIPO EN UNA SERIe';
    END IF;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER tr_ej_3_del_2b
BEFORE INSERT OR UPDATE ON ACTUA
FOR EACH ROW EXECUTE FUNCTION fn_ej_3_del_2b();

--Explique en forma breve y concisa los aspectos conceptuales sobre la implementación procedural de
-- restricciones y compare con el modo declarativo.

-- La implementacion procedural (triggers) se utiliza principalmente para activar eventos, se puede utilizar para 1,
-- o mas tablas, ya sea para controlar inserts, delete, update, antes o despues de realizar la operacion. Es una funcion
-- o procedimiento, que ademas ptiene distintas funciones, se pueden declarar varibales, tirar excepciones y tambien controlar
    -- aspectos dependiendo de la operacion (tp_op), dependiendo del nombre de una tabla (tg_table), si vienen
    -- nuevos o viejos registros.
-- Mientras que la forma declarativa de assertions es la manera mas restrictiva en SQL de controlar tablas pero
    -- La forma declarativa de assertions no es soportada en PostgreSQL, pero si en el SQL ESTANDAR.
    --Entre las implementcaiones declarativas tmabien tenemos el check, este sirve para cuando afecta a  1 fila o tuplas
    -- este si es soportado por postgres

--Comparación: Usar CHECK si es suficiente.
-- Usar ASSERTION (si el motor lo soporta) para restricciones inter-tabla.
-- Usar TRIGGER cuando se necesita acceso al valor anterior (OLD), lógica compleja, o el motor no soporta ASSERTION (como PostgreSQL).

----
--
-- Ejercicio 4
-- a) Defina las siguientes vistas, de manera que siempre que sea posible resulten actualizables en PostgreSQL:
-- Vista1, con los datos completos de los actores que actúan en películas estrenadas el año actual.
-- Vista2, con los datos completos de las series de más de 3 temporadas en las que participan actores de origen
-- español.
-- Justifique en cada caso por qué las vistas anteriores son actualizables o por qué esto no sería posible.

CREATE VIEW V1 AS
    SELECT * -- ESTARIA BIEN ASI O DEBO PONER LOS ATRIBUTOS 1 POR 1?
    from ACTOR
    WHERE EXISTS(
        SELECT 1
        FROM ACTUA
        WHERE ACTOR.id_actor = ACTUA.id_actor
        AND ACTOR.pais_origen = ACTUA.pais_origen
        AND EXISTS(
            SELECT 1
            FROM PELICULA
            WHERE ACTUA.idContenido = PELICULA.idContenido
            AND extract(YEAR FROM CURRENT_DATE) = extract(YEAR FROM PELICULA.fecha_estreno)
        )
    )

-- Vista2, con los datos completos de las series de más de 3 temporadas en las que participan actores de origen
-- español.
CREATE VIEW V2 AS
    SELECT *
    FROM SERIE
    WHERE EXISTS(
        SELECT 1
        FROM TEMPORADA
        WHERE SERIE.idContenido = TEMPORADA.idContenido
        GROUP BY TEMPORADA.idContenido
        HAVING count(*) > 3
        AND EXISTS(
            SELECT 1
            FROM ACTUA
            WHERE SERIE.idContenido = ACTUA.id_actor
            AND ACTUA.pais_origen = 'ESPAÑA'
        )
    )
----

-- b) Explique la diferencia de utilizar WITH CHECK OPTION y no usarla, a partir de una sentencia SQL de actualización
-- concreta sobre alguna de estas vistas.

-- Si usaramos check opcion para la vista 2 hace que solo se puedan insertar o actualizar registros que cumplan las
--condiciones de esa vista.

--insert valido:
INSERT INTO SERIE (idContenido, resumen) VALUES (1, 'SERIE1');
INSERT INTO TEMPORADA (nro_temporada, idcontenido) VALUES (1, 1);
INSERT INTO TEMPORADA (nro_temporada, idcontenido) VALUES (2, 1);
INSERT INTO TEMPORADA (nro_temporada, idcontenido) VALUES (3, 1);
INSERT INTO TEMPORADA (nro_temporada, idcontenido) VALUES (4, 1);
INSERT INTO ACTOR (id_actor, pais_origen, nombre_real, nombre_fantasia, fecha_nacim, ciudad_residencia, pais_residencia)
VALUES (1, 'ARGENTINA', 'CAMILO', 'CAMI', 23-12-2003, 'BS AS', 'TANDIL');

--SERIA INVALIDO CON WITH CHECK OPTION PORUQE SOLO PERMITE QUE LOS ESPAÑOLES TENGAN SERIES CON + 3 TEMPORADAS
    --WITH CHECK OPTION solo aplica cuando operás SOBRE LA VISTA


--por lo que vi e la corrreccion esto esta mal porque en realidad se deberia hacer inserciones o actualizaciones
-- a la vista, no a la tabla directa (segun el enunciado)

--to do: agrgarlo al resumen

-- c) Explique cómo se puede forzar una actualización sobre una vista que resulta no actualizable. Ejemplifique a
-- partir de alguna de las vistas anteriores, incluyendo una implementación completa adecuada para inserciones.
-- Se puede hacer uqe una vista sea actualizable forzandola mediante el INSTEAD OF.
-- TO DO: estudiarlo mas y afgregarlo al resumen

--Ejercicio 5
-- Responda en forma clara y concisa, justificando en cada caso:
-- a) ¿Cuándo dos transacciones pueden entrar en conflicto? Plantee 2 transacciones (especificando la secuencia
-- de operaciones) sobre la BD dada y ejemplifique un posible conflicto entre ellas.

--NO ENTENDI MUY BIEN

.