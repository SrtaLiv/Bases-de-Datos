set search_path to final_29_02_2024;
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

UPDATE plan SET nombre = 'Plan Basico' WHERE idArea = 'A' AND cod_plan = 1;
INSERT INTO plan VALUES('A', 1, 'Basico', 2020, 'T'),
('B', 2, 'Promo verano', 2024, 'P'),
('C', 3, 'Plan Familiar', 2021, 'T'),
('A', 4, 'Promo Estudiantes', 2023, 'P');

INSERT INTO PLAN_PROMO VALUES('A', 4, 'Ser estudiante de una universidad publica', 15.00), ('B', 2, 'Sea verano', 57.00);

INSERT INTO PLAN_TRAD VALUES('A', 1,'Ninguna relevante');
INSERT INTO PLAN_TRAD VALUES('C', 3, 'Hecho para familias con mas de 4 integrantes');

INSERT INTO usuario VALUES (1,'Messi Lionel', 'Miami','2025-10-12'::date),
                           (2,'Martinez Emiliano', 'Mar del plata','2025-09-25'::date),
                           (3,'Vazquez Martin', 'Tandil','2026-01-15'::date),
                           (4,'Leiva Lucas', 'Tandil','2025-12-01'::date),
                           (5,'Storni Alfonsina', 'Mar del plata','2024-03-08'::date),
                           (6,'Petroleo Venezolano', 'Mar del plata','2025-08-07'::date);

INSERT INTO gestion VALUES (1,1,'Quiere contratar un plan para digitalizar la empresa','A',1,'2025-12-10'::date),
                           (2,1,'Quiere un plan para transportar a los hijos al colegio','A',4,'2025-03-01'::date),
                           (2,2,'Quiere una promo para irse de vacaciones a Ibiza','B',2,'2025-01-03'::date),
                           (3,1,'Quiere un plan para los telefonos de su familia','C',3,'2024-02-25'::date),
                           (4,1,'Quiere una promo para ir a Cuba','B',2,'2026-01-04'::date),
                           (5,1,'Quiere un plan para DirecTV','A',1,'2025-06-10'::date),
                           (6,1,'Quiere un plan para tener wifi en la carcel','A',1,'2026-01-10'::date),
                           (6,2,'Quiere un plan para que su familia viaje a visitarlo a la carcerl','C',3,'2026-01-12'::date);

INSERT INTO asignacion VALUES (1,'A',1,'2025-12-10'::date,'2025-12-25'::date,2),
                              (4,'A',2,'2025-03-01'::date,'2025-06-01'::date,3),
                              (2,'B',2,'2025-12-10'::date,'2025-12-25'::date,5),
                              (3,'C',3,'2024-01-10'::date,'2024-07-10'::date,6),
                              (2,'B',4,'2026-01-01'::date,null,3),
                              (1,'A',5,'2025-05-10'::date,null,4),
                              (3,'C',6,'2025-12-01'::date,null,20);

--V1 con los datos de los usuarios de Tandil o Mar del Plata que no
-- registran gestiones sobre planes promocionales durante el corriente año.

CREATE VIEW V1 AS
SELECT u.nroUsuario, u.apell_nombre, u.ciudad, EXTRACT (YEAR FROM u.fecha_alta) as anio_alta
FROM usuario u
WHERE (u.ciudad ilike 'tandil' OR u.ciudad ilike 'mar del plata')
AND NOT EXISTS (SELECT 1 FROM gestion g
                JOIN plan_promo p
                ON (g.idArea = p.idArea AND g.cod_plan = p.cod_plan)
                WHERE usuario = u.nroUsuario
                AND EXTRACT (YEAR FROM fecha) = EXTRACT (YEAR FROM CURRENT_DATE));

/*
V2 con los datos completos de todos los planes ofrecidos,
incluyendo también los atributos: caract_cond (con su
característica o condición, según sea plan tradicional o
promocional) y descuento (con el valor de descuento ofrecido si
es promocional, o 0 si es tradicional).

CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio,
tipo_plan, caract_cond, descuento) AS ... ;
*/
CREATE VIEW V2 AS
SELECT p.cod_plan, p.idarea, p.nombre, p.anio_inicio, p.tipo_plan, COALESCE(pp.condicion, pt.caracteristica) as caract_cond, COALESCE(pp.descuento, 0) as descuento
FROM plan p
LEFT JOIN plan_promo pp USING(idarea, cod_plan)
LEFT JOIN plan_trad pt USING(idArea, cod_plan);


-- b)
--Respecto de las vistas V1 y V2 anteriores que no resulten
--actualizables por parte del SGBD, provea una implementación
--completa en PostgreSQL para posibilitar la propagación
--adecuada de inserciones. Explique su solución y ejemplifique a
--partir de una sentencia SQL concreta.

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



--a) Cada usuario puede tener hasta 3 asignaciones de planes
--diferentes por año (Nota: considere sólo la fecha desde cuándo
--se realiza la asignación).
que no exista un usario con mas de 3 asignaciones de planes diferentes por año

ALTER TABLE 2a ADD CONSTRAINT
CHECK NOT EXISTS (
    SELECT a.nroUsuario, COUNT(*)
    FROM asignacion a
    GROUP BY a.nroUsuario, EXTRACT (YEAR FROM a.fecha_desde)
    HAVING COUNT(*) > 1;
    );

--Eventos criticos: update en nrousuario, update en fecha_desde, insert en asignacion
SELECT * FROM ASIGNACION;
CREATE OR REPLACE FUNCTION fn_ej2a()
RETURNS TRIGGER AS $$
DECLARE
    cant_usuario INTEGER;
BEGIN
    SELECT COUNT(*) INTO cant_usuario FROM asignacion a
                                      WHERE a.nroUsuario = NEW.nroUsuario AND EXTRACT(YEAR FROM a.fecha_desde) = EXTRACT(YEAR FROM NEW.fecha_desde)
                                        AND NOT (
                                        a.cod_plan = OLD.cod_plan
                                        AND a.idArea   = OLD.idArea
                                        AND a.nroUsuario = OLD.nroUsuario
                                        );


        IF (cant_usuario) >= 3 THEN
            RAISE EXCEPTION 'ERROR';
        end if;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER tr2a
BEFORE INSERT ON ASIGNACION
FOR EACH ROW EXECUTE FUNCTION fn_ej2a();

CREATE TRIGGER tr2aa
BEFORE UPDATE OF nroUsuario, fecha_desde ON ASIGNACION
FOR EACH ROW
WHEN (
    (OLD.nroUsuario IS DISTINCT FROM NEW.nroUsuario)
    OR
    OLD.fecha_desde IS DISTINCT FROM NEW.fecha_desde
    )
EXECUTE FUNCTION fn_ej2a();


SELECT COUNT(*) FROM asignacion a
                                      WHERE a.nroUsuario = 2
                                      GROUP BY a.nroUsuario, EXTRACT (YEAR FROM a.fecha_desde);



--b) En toda gestión realizada por un usuario debe controlarse
--que, en caso de asociarse a un plan, éste corresponda a uno de
--los planes que el usuario tiene asignado y durante el periodo de
--vigencia del mismo.


CREATE ASSERTION gestion_plan_valido
CHECK (
        NOT EXISTS (
            SELECT 1
            FROM gestion g
            WHERE g.cod_plan IS NOT NULL AND g.idarea IS NOT NULL
              AND NOT EXISTS (
                    SELECT 1
                    FROM asignacion a
                    WHERE a.nroUsuario = g.usuario
                      AND a.cod_plan   = g.cod_plan
                      AND a.idArea     = g.idArea
                      AND (a.fecha_hasta IS NULL OR a.fecha_hasta >= CURRENT_DATE)
              )
        )
);

/*
Controlar que:
    UPDATE EN GESTION acerca de id_area y cod plan -> pueden hacer dos cosas, o ponerlo nulo(esto no se debe controlar ya que si se pone nulo no afecta a la consigna)
        pero si pasa de nulo a valores,si se deberia controlar , leugo se debe controlar cambiar el atributo usuario tambien en fecha de gestion, ya que si cambio la fecha en gestion puede
       ser que se escape de la vigencia de la asignacion
    INSERT en gestion -> si cod plan e idarea no son nulos se deben controlar que tenga asignaciones validas o no?? tengo dudas con este
    update en asignacion acerca de nrousuario o de codplan o de idarea o de fecha_hasta
    DELETE EN asignacion debo ver si puedo o está atado a una gestion

LA CONSIGNA DECIA SOLAMENTE LAS INSERCIONES OR LO TANTO SOLO ME FIJO LA DE GESTION
*/
CREATE OR REPLACE FUNCTION ej3b()
RETURNS TRIGGER AS $$
BEGIN
        IF (NOT EXISTS (
                    SELECT 1
                    FROM asignacion a
                    WHERE a.nroUsuario = new.usuario
                      AND a.cod_plan   = new.cod_plan
                      AND a.idArea     = new.idArea
                      AND (a.fecha_hasta IS NULL OR a.fecha_hasta >= CURRENT_DATE))) then
            raise exception 'El usuario no tiene asignado ese plan de manera vigente';
        end if;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER tr_ej3b
BEFORE INSERT ON GESTION
FOR EACH ROW
WHEN(
    new.idarea IS NOT NULL
    AND
    new.cod_plan IS NOT NULL
     )
EXECUTE FUNCTION ej3b();


--c) Una vez indicada la fecha_hasta correspondiente a una
--asignación, ésta podrá modificarse pero no nulificarse.
-- Trigger para evitar que fecha_hasta sea nulificada después de haber sido establecida
CREATE OR REPLACE FUNCTION check_fecha_hasta_modification()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.fecha_hasta IS NOT NULL AND NEW.fecha_hasta IS NULL THEN
        RAISE EXCEPTION 'No se puede nulificar fecha_hasta';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_fecha_hasta
BEFORE UPDATE ON ASIGNACION
FOR EACH ROW
EXECUTE FUNCTION check_fecha_hasta_modification();


/*
EMPLEADO(idEmp, nombre)
PROYECTO(idProy, nombre)
ASIGNADO(idEmp, idProy, fecha_desde, fecha_hasta)
HORAS(idEmp, idProy, fecha, horas)
Un empleado solo puede registrar horas en proyectos a los que esté asignado y durante el período de vigencia de la asignación.
*/
/*
el caso prohibido es que un empleado registre horas en proyectos a los que NO este asignado durante el periodo de vigencia
probablemente sea algo como QUE NO
EXISTA 1 REGISTRO DONDE NO EXISTA un empleado asignado en proyecto
*/
CREATE OR REPLACE FUNCTION EJ2321()
RETURNS TRIGGER AS $$
BEGIN


    IF(NOT EXISTS(
        SELECT 1 FROM
            asignado a
            WHERE a.idEmp = NEW.idemp AND a.idProy = NEW.idproy AND NEW.fecha <= a.fecha_hasta AND new.fecha >= fecha_desde
        )) THEN
        RAISE EXCEPTION 'no se puedeee';
    end if;
    RETURN NEW;
end;
$$

CREATE TRIGGER TREJ2321
BEFORE INSERT ON HORAS
FOR EACH ROW EXECUTE FUNCTION EJ2321();

/*
CLIENTE(idCliente, nombre, activo)
FACTURA(idFactura, idCliente, fecha)

Toda factura debe pertenecer a un cliente activo.
 */

 --LO QUE ESTARIA MAL: exista una factura que no pertenezca a un cliente activo.

 CREATE OR REPLACE FUNCTION ej_prueba()
 RETURNS TRIGGER AS $$
 BEGIN
     IF (NOT EXISTS(SELECT 1 FROM cliente WHERE idcliente = NEW.idcliente AND activo)) THEN
         RAISE EXCEPTION 'MAL';
     end if;
 RETURN NEW;
 END;
 $$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_ej_preuba
BEFORE INSERT ON FACTURA
FOR EACH ROW EXECUTE FUNCTION ej_prueba();

/*
MATERIA(idMateria, nombre)
INSCRIPCION(idMateria, idAlumno)

No debe existir una materia sin al menos un alumno inscripto.
 */

 --que exista una materia donde no exista un alumno inscripto
CREATE OR REPLACE FUNCTION ej2_prueba()
 RETURNS TRIGGER AS $$
BEGIN
    IF (NOT EXISTS(SELECT 1 FROM inscripcion WHERE idMateria = NEW.idmateria)) THEN
        RAISE EXCEPTION 'MALL';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_ej2_prueba
BEFORE INSERT ON materia
FOR EACH ROW EXECUTE FUNCTION ej2_prueba();

Lo que tenia mal:
Al hacerlo before no considere que rechazaria todas las materias ya que todavia se estan creando, deberia ser after. ya que si, luego de ser creadas


--por cada año, el nombre del plan, la fecha de la
--primera asignación en dicho año(de ese plan), la cantidad de asignaciones
--realizadas de dicho plan y el promedio de dispositivos
--asignados en tal año.(de ese plan)
create table InformePlan (
    NombrePlan varchar(50) not null,
    Anio int,
    prim_fecha_asig date,
    cant_asig_plan int,
    prom_disposit int
);

CREATE OR REPLACE PROCEDURE llenar_informe(fecha1 DATE, fecha2 DATE)
AS $$
BEGIN
    TRUNCATE TABLE InformePlan;
    INSERT INTO InformePlan
    SELECT p.nombre, p.anio_inicio, MIN(a.fecha_desde) as prim_fecha_asig, COUNT(*) as cant_asig_plan, AVG(num_dispositivos)
    FROM plan p
    JOIN ASIGNACION a USING(idArea, cod_plan)
    WHERE a.fecha_desde >= fecha1 AND a.fecha_desde <= fecha2
    GROUP BY (p.nombre, p.anio_inicio);
end;
$$
/*
1- Vistas
 1B- Hacer trigger instead of de la vista para que sea actualizable la que no quedo actualizable (gralmente insertar pero puede ser borrar)
 1C- ¿Como controlarias el with check option de la vista si no lo tiene? -> Trigger instead of y chequear la condicion antes de inserta en tabla base.

2- Realizar restricciones en sql standard
 2A- ALTER TABLE, ASSERTION, y muy raro pero puede ser un trigger
 2B - Hacer el trigger completo del assertion (ya que estamos en postgres y no hay assertion)

3- Hacer procedimiento o funcion que llene tablas o actualizan tablas en base a condiciones -> si es una funcion lo llamas con un select * from funcion() si es un proced CALL funcion()
    CREATE OR REPLACE FUNCTION fn_ex()
    RETURNS TABLE(
        atr1 int,
        atr2 varchar
    )
    AS $$
    BEGIN
     return query(
        SELECT atr1, atr2
        FROM tabla1
     );
    END;

    $$ language 'plpgsql';

4 - Teoria de todo -> Transacciones, optimizacion/ heuristica del optimizador del sgbd, indices, RIRs (que eran, etc etc) los MATCHS

a) En BD relacionales, ¿qué aseguran las propiedades de
aislamiento y durabilidad de una transacción y cómo controla el
SGBD que se verifiquen?
b) En bases de datos de gran tamaño, ¿qué estrategias son
útiles para mejorar el rendimiento de consultas que utilizan
ensambles?

*/

/*
SOCIO(idSocio, nombre)
PRESTAMO(idSocio, idLibro, fecha_prestamo)
Un socio no puede tener más de 5 préstamos activos.
*/
el caso malo es que : un socio tenga mas de 5 prestamos activos
entonces lo que se busca evitar es que: exista un socio tal que existan mas de 5 prestamos activos a su nombre
entonces se debe controlar que : no exista un socio tal que no existan mas de 5 prestamos activos a su nombre
CREATE OR REPLACE FUNCTION ej2()
RETURNS TRIGGER AS $$
BEGIN
    IF (NOT EXISTS(SELECT 1 FROM prestamo where idsocio = NEW.idsocio GROUP BY idSocio HAVING COUNT(*) < 5) THEN
        RAISE EXCEPTION 'ERROR';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER trej2
BEFORE INSERT ON PRESTAMO
FOR EACH ROW EXECUTE FUNCTION ej2();

sirve pero es mas complicado, por lo tanto la opcion mas logica y sencilla es:



CREATE OR REPLACE FUNCTION ej2()
RETURNS TRIGGER AS $$
DECLARE
    cant INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO cant
    FROM prestamo
    WHERE idSocio = NEW.idSocio;

    IF cant >= 5 THEN
        RAISE EXCEPTION
            'El socio % ya tiene 5 préstamos activos', NEW.idSocio;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*
CLIENTE(idCliente, nombre)
SUSCRIPCION(idCliente, fecha_desde, fecha_hasta)
FACTURA(idFactura, idCliente, fecha)
Un cliente solo puede tener facturas durante períodos en los que tenga una suscripción vigente.
suscripcion vigente:
fecha_desde ≤ fecha  AND  (fecha_hasta IS NULL OR fecha_hasta ≥ fecha)
 El caso mal: Existe un cliente con facturas durante periodos donde tiene una suscripcion que no se encuentra vigente.d
 Hay que buscar que NO EXISTA un cliente tal que NO TENGA suscripciones vigentes
 */

CREATE OR REPLACE FUNCTION ExEj()
RETURNS TRIGGER AS $$
BEGIN
    IF (NOT EXISTS(SELECT 1
                   FROM suscripcion
                   WHERE idcliente = NEW.idcliente AND fecha_desde ≤ NEW.fecha  AND  (fecha_hasta IS NULL OR fecha_hasta ≥ NEW.fecha))) THEN
        RAISE EXCEPTION 'ERROR';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER trexEj
BEFORE INSERT ON FACTURA
FOR EACH ROW EXECUTE FUNCTION ExEj();

/*
CLIENTE(idCliente, nombre, activo)
PEDIDO(idPedido, idCliente, fecha)

Permitir INSERT sobre la vista V_Pedidos_Activos.
 */
CREATE VIEW V_Pedidos_Activos AS
SELECT p.idPedido, p.idCliente, p.fecha
FROM pedido p
JOIN cliente c ON c.idCliente = p.idCliente
WHERE c.activo = true;

CREATE OR REPLACE FUNCTION insertar()
RETURNS TRIGGER AS $$
BEGIN
    IF (EXISTS(SELECT 1 FROM cliente c WHERE c.idcliente = new.idCliente AND c.activo = True)) THEN
        INSERT INTO pedido VALUES(NEW.idpedido, new.idCliente, new.fecha);
    else
        RAISE EXCEPTION 'No se puede';
    end if;
    RETURN NULL;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_insertar
INSTEAD OF INSERT ON V_Pedidos_Activos
FOR EACH ROW EXECUTE FUNCTION insertar();
/*
INSTITUCION(idInst, nombre)
ESPECIALIDAD(idEsp, nombre)
TRABAJA(idInst, idEsp)

Obtener las instituciones donde trabaja al menos una persona de cada especialidad.
 */
/*
SELECT i.idInst
FROM institucion i
WHERE NOT EXISTS (
    SELECT e.idEsp
    FROM especialidad e
    EXCEPT
    SELECT t.idEsp
    FROM trabaja t
    WHERE t.idInst = i.idInst
);

que no exista una especialidad que no esté en esa institucion
Caso malo: uan institucion donde NO exista un trabaja una persona de cada especialidad
 QUIERO: instituciones
 Donde: trabajen al menos una persona de cada especialidad

quiero que exista una persona de cada especialidad dentro de mi institucion


*/
/*
ALUMNO(idAlumno)
MATERIA(idMateria, obligatoria)
INSCRIPCION(idAlumno, idMateria)

“Todo alumno debe estar inscripto en todas las materias obligatorias.”
no debe existir materia obligatoria donde el alumno no este inscripto
NOT EXISTS(
    SELECT *
    FROM materia
    WHERE obligatorio = true

    EXCEPT

    SELECT * FROM inscripcion WHERE idalumno = new.idalumno
)
*/



PROYECTO(idProy, nombre)
EMPLEADO(idEmp, nombre)
ASIGNADO(idEmp, idProy)
HORA(idEmp, idProy, fecha, horas)
    asignado: (4,4)
    HORA:     (4,4,hoy, 500)
Obtener los proyectos en los que todos los empleados asignados han registrado al menos una hora.

lo malo es: un proyecto donde no exista un empleado que haya registrado una hora

SELECT * FROM EMPLEADO e JOIN ASIgnado a where a.idproy = p.idProy AND NOT EXISTS(SELECT 1 FROM HORA h WHERE h.idEmp = e.idemp AND h.idproy = p.idproy)

SELECT *
FROM proyecto p -- obtengo los proyectos
WHERE NOT EXISTS(SELECT * ASIgnado a where a.idproy = p.idProy AND NOT EXISTS(SELECT 1 FROM HORA h WHERE h.idEmp = e.idemp AND h.idproy = p.idproy))

no existe un proyecto donde no exista condicion valida
existe un proyecto donde existe condicion valida
condicion valida : todos los empleados asignados registraron una hora