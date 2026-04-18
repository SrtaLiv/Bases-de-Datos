set search_path to final_15_07_2022;
-- =========================
--  TABLAS BASE
-- =========================

CREATE TABLE servicio (
    id_area    char(3)      NOT NULL,
    id_serv    int          NOT NULL,
    nombre     varchar(50)  NOT NULL,
    importe    decimal(8,2) NOT NULL,
    tipo_serv  char(1)      NOT NULL,
    CONSTRAINT servicio_pk PRIMARY KEY (id_area, id_serv)
);

CREATE TABLE usuario (
    nroUsuario  int          NOT NULL,
    apellido    varchar(30)  NOT NULL,
    nombre      varchar(30)  NOT NULL,
    ciudad      varchar(20)  NOT NULL,
    fecha_alta  date         NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY (nroUsuario)
);

CREATE TABLE asignacion (
    id_area       char(3)  NOT NULL,
    id_serv       int      NOT NULL,
    nro_usuario   int      NOT NULL,
    fecha_desde   date     NOT NULL,
    fecha_hasta   date     NULL,
    descuento     int      NOT NULL,
    CONSTRAINT asignacion_pk PRIMARY KEY (id_area, id_serv, nro_usuario)
);

CREATE TABLE reclamo (
    usuario     int       NOT NULL,
    nro_reclamo int       NOT NULL,
    motivo      char(80)  NOT NULL,
    id_area     char(3)   NULL,
    id_serv     int       NULL,
    fecha       date      NOT NULL,
    atendido    boolean   NOT NULL,
    CONSTRAINT reclamo_pk PRIMARY KEY (usuario, nro_reclamo)
);

-- =========================
--  SUBTIPOS DE SERVICIO
-- =========================

CREATE TABLE serv_trad (
    id_area        char(3)      NOT NULL,
    id_serv        int          NOT NULL,
    caracteristica varchar(80)  NOT NULL,
    CONSTRAINT serv_trad_pk PRIMARY KEY (id_area, id_serv)
);

CREATE TABLE serv_avanz (
    id_area    char(3)      NOT NULL,
    id_serv    int          NOT NULL,
    condicion  varchar(80)  NOT NULL,
    CONSTRAINT serv_avanz_pk PRIMARY KEY (id_area, id_serv)
);

-- =========================
--  FOREIGN KEYS
-- =========================

-- ASIGNACION -> SERVICIO, USUARIO
ALTER TABLE asignacion
  ADD CONSTRAINT fk_asignacion_servicio
  FOREIGN KEY (id_area, id_serv)
  REFERENCES servicio (id_area, id_serv);

ALTER TABLE asignacion
  ADD CONSTRAINT fk_asignacion_usuario
  FOREIGN KEY (nro_usuario)
  REFERENCES usuario (nroUsuario);

-- SUBTIPOS -> SERVICIO
ALTER TABLE serv_trad
  ADD CONSTRAINT fk_serv_trad_servicio
  FOREIGN KEY (id_area, id_serv)
  REFERENCES servicio (id_area, id_serv);

ALTER TABLE serv_avanz
  ADD CONSTRAINT fk_serv_avanz_servicio
  FOREIGN KEY (id_area, id_serv)
  REFERENCES servicio (id_area, id_serv);

-- RECLAMO -> USUARIO
ALTER TABLE reclamo
  ADD CONSTRAINT fk_reclamo_usuario
  FOREIGN KEY (usuario)
  REFERENCES usuario (nroUsuario);

-- RECLAMO -> SERVICIO (opcional: puede ser NULL)
ALTER TABLE reclamo
  ADD CONSTRAINT fk_reclamo_servicio
  FOREIGN KEY (id_area, id_serv)
  REFERENCES servicio (id_area, id_serv);


ALTER TABLE reclamo
  ADD CONSTRAINT chk_reclamo_servicio_ambos_null
  CHECK ((id_area IS NULL AND id_serv IS NULL) OR (id_area IS NOT NULL AND id_serv IS NOT NULL));


INSERT INTO USUARIO VALUES(1, 'Murgades', 'Faustino', 'Bolivar', '2025-12-11'::date),
                          (2, 'Monti', 'Benjamin', 'Mar del Plata', '2023-03-10'::date),
                          (3,'Lanfranconi','Ignacio','Mar del Plata', '2026-01-01'::date),
                          (4,'Dimuro', 'Mateo', 'Balcarce', CURRENT_DATE),
                          (5, 'Holzmann', 'Aitor', 'Necochea', '2025-04-12'::date);

INSERT INTO servicio VALUES ('A',1,'Servicio de internet',40000,'T'),
                            ('A',2,'Servicio de luz',10000,'T'),
                            ('B',1,'Servicio de gas',2000,'T'),
                            ('B',3,'Servicio de gas',25000,'A'),
                            ('B',2,'Servicio de cloacas',700,'T'),
                            ('C',1,'Servicio de joda',400000,'A'),
                            ('D',1,'Servicio de limpieza',12000,'A');

INSERT INTO asignacion VALUES('A',1,1,'2025-12-25'::date, NULL, 500),
                             ('A',2,2,'2023-11-23'::date, '2025-10-22'::date, 600),
                             ('B',1,3,'2026-01-05'::date, NULL, 1000);

UPDATE asignacion set DESCUENTO = 20 WHERE id_area = 'A' AND id_serv = 1 AND nro_usuario = 1;
UPDATE asignacion set DESCUENTO = 50 WHERE id_area = 'B' AND id_serv = 1 AND nro_usuario = 3;
UPDATE asignacion SET descuento = 50 WHERE id_area = 'A' AND id_serv=2 AND nro_usuario = 2;

INSERT INTO serv_trad VALUES ('A',1,'Brinda servicios de internet para el hogar/empresa'),
                             ('A',2,'Brinda servicios de luz para el hogar/empresa'),
                             ('B',1,'Brinda servicios de gas para el hogar'),
                             ('B',2,'Brinda servicios de cloacas');

INSERT INTO serv_avanz VALUES ('B',3,'Tiene que tener doble chequeo con profesional matriculado'),
                              ('C',1,'Tiene que ser mayores de 18 años'),
                              ('D',1,'Tienen que ofrecer traslado y comida, no menos de 4hs diarias');


--Se requiere incorporar los siguientes controles sobre la BD. En cada caso provea la sentencia correspondiente
--en SQL estandar con el recurso declarativo más restrictivo y justifique su elección:

--a) Durante el mes de diciembre no se pueden aplicar descuentos mayores al 20% en los servicios que se
--asignen a usuarios.
ALTER TABLE asignacion ADD CONSTRAINT auno
CHECK (EXTRACT (MONTH FROM fecha_desde) != 12 OR descuento <= 20);

--b) Al registrarse un reclamo de un usuario debe controlarse que, de especificarse el servicio al que se refiere,
--éste debe estar entre los servicios asignados al usuario.
lo que esta mal: exista un reclamo con id_serv not null y que no exista una asignacion de ese servicio a ese usuario
CREATE ASSERTION as1
CHECK NOT EXISTS (
    SELECT 1
    FROM reclamo r
    WHERE R.id_serv IS NOT NULL AND r.id_area IS NOT NULL AND NOT EXISTS (SELECT 1 FROM asignacion a WHERE r.id_serv = a.id_serv AND r.usuario = a.nro_usuario AND r.id_area = a.id_area)
)

--c) A cada usuario se le puede aplicar descuento en no más de 2 servicios de cada tipo.
       lo que esta mal: que exista un usuario tal que existan mas de dos asignaciones relacionadas a ese usuario en un mismo tipo



CHECK NOT EXISTS
       (
    SELECT 1
    FROM usuario u1
    WHERE (SELECT count(*)
              FROM asignacion a2
              JOIN SERVICIO USING(id_area, id_serv)
              WHERE u1.nrousuario = a2.nro_usuario AND s.tipo_serv = 'T' AND descuento > 0) > 2 OR (SELECT count(*)
                                                                                    FROM asignacion a2
                                                                                    JOIN SERVICIO USING(id_area, id_serv)
                                                                                    WHERE u1.nrousuario = a2.nro_usuario AND s.tipo_serv = 'A' AND descuento > 0) > 2
       )


--b) Al registrarse un reclamo de un usuario debe controlarse que, de especificarse el servicio al que se refiere,
--éste debe estar entre los servicios asignados al usuario.
lo que esta mal: exista un reclamo con id_serv not null y que no exista una asignacion de ese servicio a ese usuario
CREATE ASSERTION as1
CHECK NOT EXISTS (
    SELECT 1
    FROM reclamo r
    WHERE R.id_serv IS NOT NULL AND r.id_area IS NOT NULL AND NOT EXISTS (SELECT 1 FROM asignacion a WHERE r.id_serv = a.id_serv AND r.usuario = a.nro_usuario AND r.id_area = a.id_area)
)

CHEQUEAR: DELETE EN ASIGNACION.
          INSERT EN RECLAMO

          UPDATE EN RECLAMO -> chequera si pasa de null a un servicio id_area y id_serv, depsues si cambia id_area e id_serv;

          UPDATE EN id_area id_serv, nro_usuario en ASIGNACION -> se encargan rir

CREATE OR REPLACE FUNCTION fn_delete_asig()
RETURNS TRIGGER AS $$
BEGIN
    IF(EXISTS(SELECT 1 FROM reclamo r WHERE r.id_serv IS NOT NULL AND r.id_area IS NOT NULL
                                        AND r.id_serv = OLD.id_serv AND r.usuario = OLD.nro_usuario AND r.id_area = OLD.id_area)) then
        RAISE EXCEPTION 'no te deja lero lero lalalal ';
    end if;
    RETURN OLD;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_delete_asig
BEFORE DELETE ON asignacion
FOR EACH ROW EXECUTE FUNCTION fn_delete_asig();


CREATE OR REPLACE FUNCTION fn_insertupdate_reclamo()
RETURNS TRIGGER AS $$
BEGIN
    IF(NOT EXISTS(SELECT 1 FROM ASIGNACION a WHERE a.id_serv = NEW.id_serv AND a.nro_usuario = NEW.usuario AND a.id_area = NEW.id_area)) then
        RAISE EXCEPTION 'no te deja lero lero lalalal ';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_insert_reclamo
BEFORE INSERT ON reclamo
FOR EACH ROW WHEN (NEW.id_serv IS NOT NULL AND NEW.id_area IS NOT NULL) EXECUTE FUNCTION fn_insertupdate_reclamo();


CREATE TRIGGER tr_update_reclamo
BEFORE UPDATE OF id_serv, id_area ON reclamo
FOR EACH ROW WHEN (NEW.id_serv IS NOT NULL AND NEW.id_area IS NOT NULL) EXECUTE FUNCTION fn_insertupdate_reclamo();
/*
Ejercicio 3
Defina las siguientes vistas en PostgreSQL sobre la BD dodo, teniendo en cuenta de construirlas de manera
optimizado (considerando sólo los tablas y atributos necesarios). Siempre que sea posible, deben resultar
automáticamente actualizables: do 10 contrario, justifique.

a) VISTA, que contenga el identificador. fecha y motivo de los reclamos por servicios avanzados
correspondientes a usuarios de Tandil. indicando en cada caso si fueron atendidos o no.
b) VISTAZ con los datos de todos los usuarios registrados en 10 BD y el detalle de los reclamos que hon
efectuado durante el corriente año. en coso do que posean.
 */

 --a) VISTA_1, que contenga el identificador. fecha y motivo de los reclamos por servicios avanzados
--correspondientes a usuarios de Tandil. indicando en cada caso si fueron atendidos o no.
SELECT * FROM serv_avanz;
INSERT INTO reclamo VALUES (2,1,'Intento hakear la sede','A',2,'2025-10-20'::date,TRUE),
                           (1,1,'Poca gente en Bolivar',NULL,NULL,'2026-02-20'::date,FALSE),
                           (3,1,'Le llega consumo muy alto','B',1,'2025-12-12'::date,TRUE),
                           (5,1,'Le robaron el celular','A',1,'2025-08-10'::date,TRUE);
begin;
UPDATE reclamo SET id_serv = 3 WHERE usuario = 3 AND nro_reclamo = 1 AND id_area = 'B' AND id_serv = 1;
rollback;
SELECT * FROM RECLAMO;
usuario 3 nro reclamo 1 id area b id serv 3

CREATE VIEW
SELECT r.nro_reclamo, r.fecha, r.motivo, r.atendido
FROM reclamo r
WHERE EXISTS(SELECT 1 FROM usuario u WHERE u.nroUsuario = r.usuario AND ciudad ilike 'mar del plata') AND EXISTS(select 1 from serv_avanz s WHERE r.id_serv = s.id_serv AND r.id_area = s.id_area)

--b) VISTA2 con los datos de todos los usuarios registrados en la bd y el detalle de los reclamos que hon
--efectuado durante el corriente año. en caso de que posean.

SELECT u.*, COALESCE(r.motivo, 'No posee reclamo')
FROM usuario u
LEFT JOIN reclamo R on r.usuario = u.nroUsuario AND EXTRACT(YEAR FROM r.fecha) = EXTRACT(YEAR FROM CURRENT_DATE);

SELECT u.*, count(r.motivo)
FROM usuario u
LEFT JOIN reclamo R on r.usuario = u.nroUsuario AND EXTRACT(YEAR FROM r.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
group by u.nroUsuario;

SELECT u.*, count(r.motivo)
FROM usuario u
LEFT JOIN reclamo R on r.usuario = u.nroUsuario
WHERE EXTRACT(YEAR FROM r.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
group by u.nroUsuario;

/*
Ejercicio 5
Se requiere realizar las siguientes consultas sobre la BD dada:
a) listar los apellidos y nombres de los usuarios que solamente poseen asignaciones de servicios
tradicionales.



b) determinar si hay servicios asignados a todos los usuarios.
Provea en cada caso al menos 2 sentencias SQL diferentes que permitan resolverlas. Explique brevemente sus
soluciones.
*/

--a) listar los apellidos y nombres de los usuarios que solamente poseen asignaciones de servicios
--tradicionales.

SELECT u.apellido, u.nombre
FROM usuario u
JOIN asignacion a ON (a.nro_usuario = u.nroUsuario)
JOIN serv_trad using (id_area, id_serv)
WHERE NOT EXISTS ((SELECT 1 FROM asignacion a2 JOIN serv_avanz sa ON a2.id_area = sa.id_area AND a2.id_serv = sa.id_serv
                            WHERE a2.nro_usuario = a.nro_usuario));

SELECT u.apellido, u.nombre
FROM usuario u
WHERE EXISTS (SELECT 1 from asignacion a where a.nro_usuario = u.nroUsuario
                                           and EXISTS (SELECT 1 FROM serv_trad st where a.id_area = st.id_area AND a.id_serv = st.id_serv)
                                           AND NOT EXISTS ((SELECT 1 FROM asignacion a2 JOIN serv_avanz sa ON a2.id_area = sa.id_area AND a2.id_serv = sa.id_serv
                            WHERE a2.nro_usuario = a.nro_usuario)));

INSERT INTO asignacion VALUES ('B',3,1,CURRENT_DATE,null,15);
--b) determinar si hay servicios asignados a todos los usuarios.


SELECT *
FROM servicio s
WHERE NOT EXISTS (SELECT nroUsuario
                  FROM usuario
                  EXCEPT
                  SELECT a.nro_usuario
                  FROM asignacion a WHERE s.id_serv = a.id_serv AND s.id_area = a.id_area);




