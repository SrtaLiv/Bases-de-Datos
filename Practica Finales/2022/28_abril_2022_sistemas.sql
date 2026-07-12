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

-- 1a) Las oficinas de supérficie menor a 50 m2 no pueden tener mas de 10 puestos de trabajo

-- oficina: superficie, capacidad
ALTER TABLE OFICINA ADD CONSTRAINT ck_capacidad check (
    (superficie < 50 AND capacidad <= 10) OR superficie > 50
    )

-- Se hace chequeo de tupla ya que solo debemos revisar los valores de Superficie y Capacidad, esos mismos
    -- estan en una unica tabla y en una misma fila

-- CASOS LOS QUE SI
-- SUPERFICIE 20 Y CAPACIDAD 8
-- SUPERFICIE 102 Y CAPACIDAD 12
-- SUPERFICIE 102 Y CAPACIDAD 120

-- LOS QUE NO
-- SUPERFICIE 90 Y CAPACIDAD 12
-- SUPERFICIE 90 Y CAPACIDAD 120

-- Unn alquiler debe tener fecha de inicio al menos 3 dias posterior a la fecha de alta del cliente asociado
-- Alquiler: fecha_inicio ,
-- Cliente: fecha_alta

-- posterior es siguiente, ej de caso que si:
-- Alquiler fecha inicio: 2-11-2022 ----- Fecha alta cliente:  31-02-2022
-- Ej caso que no
-- Alquiler fecha inicio: 20-03-2022 ----- Fecha alta cliente:  20-04-2022

CREATE ASSERTION ck_fecha_limite CHECK(
       NOT EXISTS(
        SELECT 1
        FROM alquiler a
        join cliente c using(id_cliente)
        where  (fecha_inicio -  fecha_alta) < 3
       )
)

-- Cada alquiler puede abarcar una cant abritraria de oficinas pero de hasta 3 zonas diferentes
-- alquiler_oficina
-- nro_zona, id_alquiler

ALTER TABLE alquiler_oficina ADD CONSTRAINT ck_alquiler CHECK(
    NOT EXISTS(
        SELECT 1
        FROM alquiler_oficina
        GROUP BY id_alquiler
        HAVING count(distinct nro_zona) > 3
    )
    );

-- l.b) Identifique y explique brevemente los eventos críticos requeridos para asegurar el
-- cumplimiento mediante triggers de las restricciones del Ej. 1.a) que no pueden ser
-- incorporadas en PostgreSQL Incluya Ia implementación completa en PostgreSQL
-- (encabezados y funciones) de los triggers requeridos

---- 1a) Las oficinas de supérficie menor a 50 m2 no pueden tener mas de 10 puestos de trabajo

-- oficina: superficie, capacidad
ALTER TABLE OFICINA ADD CONSTRAINT ck_capacidad check (
    (superficie < 50 AND capacidad <= 10) OR superficie > 50
    );

-- lOS EVENTOS criticos son:
-- update en superficie  y capacidad
-- insert superficie y capacidad

CREATE FUNCTION fn_ej1a() RETURNS TRIGGER AS $$
    declare cantSuperficie int;
BEGIN
    IF tg_op = 'INSERT' THEN
        SELECT superficie into cantSuperficie
        FROM OFICINA
        WHERE id_ofic = new.id_ofic
        AND nro_zona = new.nro_zona
        GROUP BY id_ofic;

        IF (cantSuperficie >= 50) THEN raise exception 'La oficinano puede tener mas de 3 zonas';
    return new;
end;
    $$;

CREATE TRIGGER tr_ej1a
BEFORE INSERT OR UPDATE OF superficie, capacidad ON OFICINA
FOR EACH ROW EXECUTE FUNCTION fn_ej1a();