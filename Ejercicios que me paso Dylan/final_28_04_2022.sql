set search_path to final_28_04_2022;

CREATE TABLE cliente (
    id_cliente   INT PRIMARY KEY,
    apellido     VARCHAR(60) NOT NULL,
    nombre       VARCHAR(40) NOT NULL,
    fecha_alta   DATE NOT NULL,
    telefono     VARCHAR(20) NOT NULL
);

CREATE TABLE zona (
    nro_zona       INT PRIMARY KEY,
    descripcion    VARCHAR(80) NOT NULL,
    capacidad_max  INT NOT NULL,
    ubicacion      VARCHAR(80) NOT NULL
);

CREATE TABLE oficina (
    id_ofic        INT NOT NULL,
    nro_zona       INT NOT NULL,
    ubicacion      VARCHAR(40) NOT NULL,
    costo_diario   DECIMAL(10,2) NOT NULL,
    capacidad      INT NOT NULL,
    superficie     DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (id_ofic, nro_zona),
    FOREIGN KEY (nro_zona) REFERENCES zona(nro_zona)
);

CREATE TABLE alquiler (
    id_alquiler    INT PRIMARY KEY,
    id_cliente     INT NOT NULL,
    fecha_inicio   DATE NOT NULL,
    fecha_fin      DATE,              -- N en el diagrama
    importe_total  DECIMAL(10,2),      -- N en el diagrama
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE alquiler_oficina (
    id_alquiler  INT NOT NULL,
    id_ofic      INT NOT NULL,
    nro_zona     INT NOT NULL,
    observacion  VARCHAR(80),          -- N en el diagrama
    PRIMARY KEY (id_alquiler, id_ofic, nro_zona),
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler),
    FOREIGN KEY (id_ofic, nro_zona) REFERENCES oficina(id_ofic, nro_zona)
);

INSERT INTO zona VALUES
(1, 'Microcentro', 500, 'CABA'),
(2, 'Palermo', 300, 'CABA'),
(3, 'Nueva Córdoba', 200, 'Córdoba'),
(4, 'Centro', 250, 'Rosario');

INSERT INTO cliente VALUES
(1, 'González', 'María', '2023-03-10', '11-4567-1234'),
(2, 'Pérez', 'Juan', '2023-06-05', '351-6123456'),
(3, 'López', 'Ana', '2024-01-20', '341-5987456'),
(4, 'Martínez', 'Lucas', '2024-08-02', '11-3344-7788');


INSERT INTO oficina VALUES
(1, 1, 'Av. Corrientes 450', 15000.00, 20, 120.50),
(2, 1, 'Florida 320', 22000.00, 35, 200.00),
(1, 2, 'Av. Santa Fe 3800', 18000.00, 25, 140.00),
(2, 2, 'Honduras 5500', 13000.00, 15, 95.00),
(1, 3, 'Bv. San Juan 600', 10000.00, 18, 110.00),
(1, 4, 'Peatonal Córdoba 900', 12000.00, 22, 130.00);
INSERT INTO alquiler VALUES
(1, 1, '2024-02-01', '2024-02-10', 150000.00),
(2, 2, '2024-03-05', NULL, NULL),
(3, 3, '2024-01-15', '2024-01-20', 60000.00);

INSERT INTO alquiler_oficina VALUES
(1, 1, 1, 'Reuniones comerciales'),
(1, 2, 1, 'Equipo de soporte'),
(2, 1, 2, 'Startup de diseño'),
(3, 1, 3, 'Consultoría contable');

--Las oficinas de superficie menor a 50m2 no pueden tener mas de 10 puestos de trabajo

ALTER TABLE OFICINA ADD CONSTRAINT a1
CHECK(superficie>=50 OR capacidad <= 10)


--un alquiler debe tener fecha de inicio al menos 3 dias posterior a la fecha de alta del cliente asociado
lo que esta mal que exista un alquiler con fecha de inicio hasta 3 dias posterior a la fecha de alta del cliente asociado
CREATE ASSERTION chk_alquiler
CHECK(NOT EXISTS(SELECT 1
FROM alquiler a
JOIN cliente c USING(id_cliente)
WHERE ABS(fecha_alta-fecha_inicio) < 3))



A CHEQUEAR:
       update en fecha_inicio de alquiler
       insert en alquiler hay que ver fecha_inicio
       update en fecha_alta de cliente

CREATE OR REPLACE FUNCTION fn_chequeo()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS(
    SELECT 1
    FROM cliente
    WHERE id_cliente = new.id_cliente
    AND ABS(fecha_alta-new.fecha_inicio) < 3) THEN
        raise exception 'no puede realizar esa operacion por las fechas';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_chequeo
BEFORE INSERT ON alquiler
FOR EACH ROW EXECUTE FUNCTION fn_chequeo();

CREATE TRIGGER tr_chequeo_up
BEFORE UPDATE OF fecha_inicio, id_cliente ON alquiler
FOR EACH ROW EXECUTE FUNCTION fn_chequeo();


CREATE OR REPLACE FUNCTION fn_chequeo_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS(
    SELECT 1
    FROM alquiler
    WHERE id_cliente = new.id_cliente
    AND ABS(new.fecha_alta-fecha_inicio) < 3) THEN
        raise exception 'no puede realizar esa operacion por las fechas';
    end if;
    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_chequeo_update_cliente
BEFORE UPDATE OF fecha_alta ON cliente
FOR EACH ROW EXECUTE FUNCTION fn_chequeo_cliente();





begin;
UPDATE cliente set fecha_alta = '2024-01-16'::date WHERE id_cliente=3;
rollback;

--Cada alquiler puede abarcar una cantidad arbitraria de oficinas pero de hasta 3 zonas diferentes
lo malo:
que exista un alquiler que abarque oficinas de mas de 3 zonas diferentes
ALTER TABLE alquiler_oficina ADD CONSTRAINT chk_oficzonas3
CHECK(NOT EXISTS(SELECT 1
                 FROM alquiler_oficina
                 GROUP BY id_alquiler
                 HAVING COUNT(DISTINCT nro_zona) >3));



chequear para un trigger:: UPDATE DE nro_zona, update de id_alquiler
          insert de alquiler_oficina

CREATE OR REPLACE FUNCTION fn_chequear_alquiler_ofic()
RETURNS TRIGGER AS $$
DECLARE
    cant INTEGER;
begin
    SELECT COUNT(DISTINCT nro_zona) into cant
    FROM (
        SELECT nro_zona
        FROM alquiler_oficina
        WHERE id_alquiler = NEW.id_alquiler
        UNION
        SELECT NEW.nro_zona
    ) t;

    IF cant > 3 THEN
        RAISE EXCEPTION 'no se puede hacer eso';
    end if;


    RETURN NEW;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_chequear_alq_ofic
BEFORE INSERT OR UPDATE OF nro_zona, id_alquiler
ON alquiler_oficina
FOR EACH ROW
EXECUTE FUNCTION fn_chequear_alquiler_ofic();



SELECT COUNT(DISTINCT nro_zona)
FROM alquiler_oficina ao
WHERE 2= ao.id_alquiler;

SELECT * FROM alquiler_oficina

SELECT * FROM alquiler_oficina;
BEGIN;
INSERT INTO alquiler_oficina VALUES(2,1,1,'Para prueba'),
                                   (2,1,3,'Prueba 2');
rollback;


--V1 Datos completos de los alquileres iniciados en los ultimos 3 meses y aun vigentes, que abarcan mas de 10 oficinas y totalizan mas de 1000 de superficie

SELECT *
FROM alquiler a
WHERE EXISTS (SELECT 1
              FROM alquiler_oficina ao JOIN oficina o USING(id_ofic, nro_zona)
              WHERE a.id_alquiler = ao.id_alquiler
                AND AGE(CURRENT_DATE, a.fecha_inicio) < INTERVAL '3 MONTHS' AND(a.fecha_fin IS NULL OR a.fecha_fin>= CURRENT_DATE)
              GROUP BY a.id_alquiler
              HAVING COUNT(*) > 10 AND SUM(o.superficie) > 1000);

--V2 Datos completos de los clientes con alta posterior al 2020 y de las oficinas de mas de 50m2 que cada uno ha habilitado
SELECT c.*, o.*
FROM cliente c
JOIN alquiler a USING(id_cliente)
JOIN alquiler_oficina ao on a.id_alquiler = ao.id_alquiler
JOIN oficina o USING(id_ofic, nro_zona)
WHERE EXTRACT (YEAR FROM fecha_alta) > 2020 AND o.superficie > 50;

--V3 Datos de las zonas en las que no se han registrado alquileres durante el año actual

lo que esta bien: una zona tal que no exista alquileres registrados durante el año actual en esa zona

SELECT z.*
FROM zona z
WHERE NOT EXISTS(SELECT 1
                 FROM alquiler_oficina ao JOIN alquiler a USING(id_alquiler)
                 WHERE ao.nro_zona = z.nro_zona
                   AND EXTRACT(YEAR FROM a.fecha_inicio) = (EXTRACT (YEAR FROM CURRENT_DATE)));
------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION insertar()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO cliente VALUES(NEW.id_cliente, NEW.apellido, NEW.nombre, NEW.fecha_alta, NEW.telefono);
    INSERT INTO oficina VALUES(NEW.id_ofic, NEW.nro_zona, NEW.ubicacion, NEW.costo_diario, NEW.capacidad, NEW.superficie);
    RETURN NULL;
end;
$$ language 'plpgsql';


CREATE OR REPLACE FUNCTION fn_instead_insert_v2()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(YEAR FROM NEW.fecha_alta) <= 2020 THEN
        RAISE EXCEPTION 'fecha_alta no cumple la condición de la vista';
    END IF;

    IF NEW.superficie <= 50 THEN
        RAISE EXCEPTION 'superficie no cumple la condición de la vista';
    END IF;

    -- 3Insertar cliente si no existe
    IF NOT EXISTS (
        SELECT 1
        FROM cliente c
        WHERE c.id_cliente = NEW.id_cliente
    ) THEN
        INSERT INTO cliente VALUES(NEW.id_cliente, NEW.apellido, NEW.nombre, NEW.fecha_alta, NEW.telefono);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM oficina o
        WHERE o.id_ofic = NEW.id_ofic
          AND o.nro_zona = NEW.nro_zona
    ) THEN
        INSERT INTO oficina VALUES(NEW.id_ofic, NEW.nro_zona, NEW.ubicacion, NEW.costo_diario, NEW.capacidad, NEW.superficie);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_insertar
INSTEAD OF INSERT ON V2
FOR EACH ROW EXECUTE FUNCTION insertar();

a zona se le agrega una columna llamada total_alquiler luego de que la base tiene datos, la suma de todos los alquileres (importe_total) de cada zona en el año actual

CREATE OR REPLACE PROCEDURE cargar_total_alquiler_zona()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE zona z
    SET total_alquiler = COALESCE((
        SELECT SUM(a.importe_total)
        FROM alquiler_oficina ao
        JOIN alquiler a ON a.id_alquiler = ao.id_alquiler
        WHERE ao.nro_zona = z.nro_zona
          AND EXTRACT(YEAR FROM a.fecha_inicio) = EXTRACT(YEAR FROM CURRENT_DATE)
    ), 0);
END;
$$;
CALL cargar_total_alquiler_zona();

SELECT z.*, a.*
FROM zona z
JOIN alquiler_oficina USING(nro_zona)
JOIN alquiler a USING (id_alquiler)



CREATE TABLE tabla_temp(idTemp SERIAL PRIMARY KEY,cant integer);

CREATE TABLE HIS_ENTREGA(
  nro_registro SERIAL,
  fecha DATE NOT NULL,
  operacion varchar(30),
  cant_reg_afectados bigint NOT NULL,
  usuario varchar(30) NOT NULL,
  tabla varchar(30) NOT NULL,
 CONSTRAINT his_entrega_pk PRIMARY KEY (nro_registro));

CREATE OR REPLACE FUNCTION sumarFilas()
RETURNS TRIGGER AS $$
BEGIN
   INSERT INTO tabla_temp(cant) VALUES (1);
RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER sumarFilas
BEFORE INSERT OR UPDATE OR DELETE ON p_entrega
FOR EACH ROW EXECUTE FUNCTION sumarFilas();

CREATE OR REPLACE TRIGGER sumarFilas
BEFORE INSERT OR UPDATE OR DELETE ON p_renglon_entrega
FOR EACH ROW EXECUTE FUNCTION sumarFilas();

CREATE OR REPLACE FUNCTION updateLogEntregas()
RETURNS TRIGGER AS $$
DECLARE
  cant_reg integer;
BEGIN
    cant_reg=(SELECT COUNT(cant) FROM tabla_temp);
    DELETE FROM tabla_temp;
    INSERT INTO his_entrega(fecha,cant_reg_afectados,usuario,operacion,tabla)
      VALUES(CURRENT_TIMESTAMP, cant_reg,CURRENT_USER,TG_OP,TG_TABLE_NAME);
RETURN NEW;
END $$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER updateLogEntregasE
AFTER INSERT OR DELETE OR UPDATE ON p_entrega
FOR EACH STATEMENT EXECUTE FUNCTION updateLogEntregas();

CREATE OR REPLACE TRIGGER updateLogEntregasR
AFTER INSERT OR DELETE OR UPDATE ON p_renglon_entrega
FOR EACH STATEMENT EXECUTE FUNCTION updateLogEntregas();

1ERO BEFORE STATEMENT
2DO BEFORE ROW
3ERO AFTER ROW
4TO AFTER STATEMENT