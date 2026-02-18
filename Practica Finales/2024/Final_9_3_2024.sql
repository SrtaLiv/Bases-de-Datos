CREATE TABLE CLIENTE (
    zona char(2)  NOT NULL,
    nroC int  NOT NULL,
    apell_nombre varchar(50)  NOT NULL,
    ciudad varchar(20)  NOT NULL,
    fecha_alta date  NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (zona,nroC)
);

CREATE TABLE INSTALACION (
    Zona char(2)  NOT NULL,
    NroC int  NOT NULL,
    idServ int  NOT NULL,
    fecha_instalacion date  NOT NULL,
    cantHoras int  NOT NULL,
    tarea varchar(50)  NOT NULL,
    CONSTRAINT PK_INSTALACION PRIMARY KEY (Zona,NroC,idServ)
);

CREATE TABLE SERVICIO (
    idServ int  NOT NULL,
    nombreServ varchar(50)  NOT NULL,
    anio_comienzo int  NOT NULL,
    anio_fin int  NULL,
    tipoServ char(1)  NOT NULL,
    CONSTRAINT PK_SERVICIO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_MONITOREO (
    idServ int  NOT NULL,
    caracteristica varchar(80)  NOT NULL,
    CONSTRAINT PK_SERV_MONITOREO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_VIGILANCIA (
    idServ int  NOT NULL,
    situacion varchar(80)  NOT NULL,
    CONSTRAINT PK_SERV_VIGILANCIA PRIMARY KEY (idServ)
);

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_CLIENTE
    FOREIGN KEY (Zona, NroC)
    REFERENCES CLIENTE (zona, nroC)
;

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)
;

ALTER TABLE SERV_MONITOREO ADD CONSTRAINT FK_SMONITOREO_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)
;

ALTER TABLE SERV_VIGILANCIA ADD CONSTRAINT FK_SVIGILANCIA_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)
;

-- Considere que el esquema corresponde a un sistema de gestión de servicios a clientes (script). De cada cliente
-- se registra su identificador, apellido y nombre, ciudad y fecha de alta, además las instalaciones de servicios que
-- posee y sus características. De los servicios se almacena su identificador, nombre, año de comienzo y de fin, más
-- el tipo de servicio, que puede ser de monitoreo (M) o de vigilancia (V).

-- Sobre el esquema dado (link), incorpore los siguientes controles en SQL estándar mediante el recurso declarativo
-- más restrictivo y utilizando sólo las tablas y atributos necesarios. Justifique el tipo de restricción definida en cada
-- caso.
-- a) Los clientes con menos de 3 años de antigüedad pueden tener hasta 3 servicios instalados de cada tipo.
-- b) La fecha de instalación de cada servicio no puede ser anterior ni posterior a los años de comienzo y de fin,
-- respectivamente, asociadas a dicho servicio.
-- c) El año de comienzo de los servicios que son de vigilancia debe ser posterior a 2020.

-- A, LOS CLIENTES CON MENOS DE 3 AÑOS DE ANTIGUEDAD PUEDEN TENER MAS DE 3 SERVICIOS INSTALADOS DE CADA TIPO

-- nroC, zona, fecha_alta (DE 3 AÑOS DE ANTIGUEDAD)
-- tipoServ, if tipo V < 2 if tipo M < 2
create assertion ck_control
CHECK(
       NOT EXISTS(
       SELECT 1
        FROM unc_46203524.cliente c
        JOIN unc_46203524.instalacion i
        USING (zona, nroc)
        JOIN unc_46203524.servicio s
        USING (idserv)
        extract(year from now()) - extract(year from c.fecha_alta) < 3
        GROUP BY c.zona, c.nroC, s.tipoServ
        HAVING count(*) > 3;
               )
);

     SELECT *
        FROM unc_46203524.cliente c
        JOIN unc_46203524.instalacion i
        USING (zona, nroc)
        JOIN unc_46203524.servicio s
        USING (idserv)
        extract(year from now()) - extract(year from c.fecha_alta) < 3
        GROUP BY c.zona, c.nroC, s.tipoServ
        HAVING count(*) > 3;

INSERT INTO cliente (zona, nroC, apell_nombre, ciudad, fecha_alta)
VALUES ('A1', 101, 'Gomez Laura', 'Cordoba', CURRENT_DATE - INTERVAL '2 years');

-- Servicios tipo M (Monitoreo)
INSERT INTO servicio (idServ, nombreServ, anio_comienzo, anio_fin, tipoServ)
VALUES
(1, 'Camara', 2019, NULL, 'M'),
(2, 'Sensor', 2019, NULL, 'M'),
(3, 'Alarma', 2020, NULL, 'M'),
(4, 'Detector', 2020, NULL, 'M');

-- Servicios tipo V (Vigilancia)
INSERT INTO servicio (idServ, nombreServ, anio_comienzo, anio_fin, tipoServ)
VALUES
(5, 'Guardia', 2021, NULL, 'V'),
(6, 'Patrulla', 2022, NULL, 'V');

-- Le instalamos 4 servicios tipo M (¡esto debería violar la regla!)
INSERT INTO instalacion (zona, nroC, idServ, fecha_instalacion, cantHoras, tarea)
VALUES
('A1', 101, 1, CURRENT_DATE, 10, 'Instalación camara'),
('A1', 101, 2, CURRENT_DATE, 5, 'Instalación sensor'),
('A1', 101, 3, CURRENT_DATE, 3, 'Instalación alarma'),
('A1', 101, 4, CURRENT_DATE, 2, 'Instalación detector');

-- Le instalamos 2 servicios tipo V (esto está permitido)
INSERT INTO instalacion (zona, nroC, idServ, fecha_instalacion, cantHoras, tarea)
VALUES
('A1', 101, 5, CURRENT_DATE, 4, 'Instalación guardia'),
('A1', 101, 6, CURRENT_DATE, 6, 'Instalación patrulla');

SELECT
  c.zona,
  c.nroC,
  s.tipoServ,
  COUNT(*) AS cantidad_servicios
FROM cliente c
JOIN instalacion i USING (zona, nroC)
JOIN servicio s USING (idServ)
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM c.fecha_alta) < 3
GROUP BY c.zona, c.nroC, s.tipoServ
HAVING COUNT(*) > 3;

select count(c.anio_fin)
from servicio c

create assertion as_ej_1_b check (
not exists (select 1
from instalacion i
join servicio s on i.idserv = s.idserv
where (EXTRACT('YEAR' FROM i.fecha_instalcion) >= s.anio_comienzo)
and (s.anio_fin is null or (EXTRACT('YEAR' FROM i.fecha_instalcion) <= s.anio_fin)));

-- c) El año de comienzo de los servicios que son de vigilancia debe ser posterior a 2020.
ALTER TABLE servicio
ADD CONSTRAINT ck_anio_comienzo
CHECK (
  (tipoServ = 'V' AND anio_comienzo > 2020) OR tipoServ <> 'V'
);



-- Considere que en la tabla Servicio del esquema dado (link), se ha agregado un atributo cant_clientes en el cual
-- se requiere registrar la cantidad de clientes a los que se ha instalado cada servicio.
-- Explique e implemente en forma completa y de modo eficiente en PostgreSQL una solución que en cada caso
-- permita:
-- a) establecer el valor inicial de cant_clientes a partir de los datos ya existentes en la BD.
-- b) mantener automáticamente actualizado el atributo cant_clientes ante operaciones sobre la BD

update servicio s set cant_clientes = (
select count(*)
from instalacion i
where i.idserv = s.idserv) WHERE idserv = s.idserv ;

-- B
CREATE OR REPLACE FUNCTION FN_ej_2_b() RETURNS TRIGGER AS $$
BEGIN
IF tg_op = 'INSERT' THEN
UPDATE servicio SET cant_clientes = cant_clientes + 1 WHERE idserv = NEW.idserv;
RETURN NEW;

ELSIF tg_op = 'UPDATE' THEN
    UPDATE servicio SET cant_clientes = cant_clientes + 1 WHERE idserv = NEW.idserv;
    UPDATE servicio SET cant_clientes = cant_clientes - 1 WHERE idserv = OLD.idserv;
RETURN NEW;

ELSE tg_op = 'DELETE' THEN
    UPDATE servicio SET cant_clientes = cant_clientes - 1 WHERE idserv = OLD.idserv;
RETURN OLD;

END IF;
END IF;
END $$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER TR_ej_2_c
AFTER INSERT OR DELETE OR UPDATE OF idserv
ON instalacion
FOR EACH ROW
EXECUTE FUNCTION FN_ej_2_b();