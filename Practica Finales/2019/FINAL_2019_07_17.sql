CREATE TABLE INGENIERO (
    id_ingeniero int PRIMARY KEY,
    nombre varchar(60) NOT NULL,
    apellido varchar(90) NOT NULL,
    contacto varchar NULL,
    especialidad varchar NOT NULL,
    remuneracion decimal(8,2)
);

CREATE TABLE SECTOR(
    id_sector int PRIMARY KEY,
    descripcion varchar,
    ubicacion varchar,
    cant_empleados int
);

CREATE TABLE PROYECTO (
    id_sector int,
    nro_proyecto int,
    nombre varchar(255),
    presupuesto decimal(12,2),
    fecha_ini date,
    fecha_fin date,
    director int,
    PRIMARY KEY (id_sector, nro_proyecto)
);

CREATE TABLE TRABAJA(
    horas_sem int NULL,
    id_ingeniero int,
    id_sector int,
    nro_proyecto int,
    PRIMARY KEY (id_ingeniero, id_sector, nro_proyecto)
);

-- Luego agregas las claves foráneas

ALTER TABLE PROYECTO
ADD CONSTRAINT fk_proyecto_sector
FOREIGN KEY (id_sector)
REFERENCES SECTOR(id_sector)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROYECTO
ADD CONSTRAINT fk_proyecto_director
FOREIGN KEY (director)
REFERENCES INGENIERO(id_ingeniero)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE TRABAJA
ADD CONSTRAINT fk_trabaja_ingeniero
FOREIGN KEY (id_ingeniero)
REFERENCES INGENIERO(id_ingeniero)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TRABAJA
ADD CONSTRAINT fk_trabaja_proyecto
FOREIGN KEY (id_sector, nro_proyecto)
REFERENCES PROYECTO(id_sector, nro_proyecto)
ON DELETE CASCADE
ON UPDATE CASCADE;


-- Especificar acciones referenciales
-- Si se elimina un INGENIERO, también se borren sus registros en TRABAJA.
-- Si se actualiza el ID de un proyecto, también se actualicen las claves foráneas.
ALTER TABLE TRABAJA
ADD CONSTRAINT fk_ingeniero
FOREIGN KEY (id_ingeniero)
REFERENCES INGENIERO(id_ingeniero)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TRABAJA
ADD CONSTRAINT fk_proyecto
FOREIGN KEY (id_sector, nro_proyecto)
REFERENCES PROYECTO(id_sector, nro_proyecto)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Un update restrict en la tabla proyecto, para que no se pueda actualizar un id_sector si no existe en la tabla sector

-- 2) Para cada una de llas sig operaicons segun lo definido, analice en que casos procederian y posibles resultados no
-- acumulativos.


-- INGENIEROS
INSERT INTO INGENIERO VALUES (1, 'Ana', 'García', 'ana@correo.com', 'Civil', 120000);
INSERT INTO INGENIERO VALUES (2, 'Juan', 'Pérez', 'juan@correo.com', 'Electrónica', 130000);
INSERT INTO INGENIERO VALUES (3, 'Laura', 'López', 'laura@correo.com', 'Industrial', 125000);

-- SECTORES
INSERT INTO SECTOR VALUES (1, 'Infraestructura', 'Planta A', 50);
INSERT INTO SECTOR VALUES (2, 'Tecnología', 'Planta B', 40);
INSERT INTO SECTOR VALUES (3, 'Calidad', 'Planta C', 35);
INSERT INTO SECTOR VALUES (5, 'Logística', 'Planta D', 20);

-- PROYECTOS
-- Sector 1, con fecha_fin cargada
INSERT INTO PROYECTO VALUES (1, 101, 'Reforma Planta A', 500000, '2023-01-01', '2023-12-31', 1);
-- Sector 2, con fecha_fin cargada
INSERT INTO PROYECTO VALUES (2, 201, 'Nuevo Servidor', 300000, '2023-06-01', '2024-06-01', 2);
-- Sector 3, SIN fecha_fin (NULL) para probar caso (c)
INSERT INTO PROYECTO VALUES (3, 301, 'Control Calidad', 150000, '2023-03-01', NULL, 3);
-- Sector 5, para el update
INSERT INTO PROYECTO VALUES (5, 501, 'Gestión de Stock', 200000, '2024-01-01', '2024-12-31', 1);
INSERT INTO PROYECTO VALUES (2, 301, 'Control Calidad', 150000, '2023-03-01', NULL, 3);

-- TRABAJA (uno para cada proyecto)
INSERT INTO TRABAJA VALUES (15, 1, 1, 101); -- Ana en proyecto 101
INSERT INTO TRABAJA VALUES (20, 2, 2, 201); -- Juan en proyecto 201
INSERT INTO TRABAJA VALUES (30, 2, 5, 501); -- Juan en proyecto 501

INSERT INTO TRABAJA VALUES (30, 2, 2, 301); -- Juan en proyecto 501

-- A) delete from trabaja where id_sector = 2
-- b) UPDATE TRABAJA SET horassem = 20 where sector = 5
-- c) delete from proyecto where f_fin is null
-- d) delete from ingeniero

-- a)
DELETE FROM TRABAJA WHERE TRABAJA.id_sector = 2;
-- Procede, es una tabla "hija" que depende del padre, si se eliminara desde por ejemplo id_sector ahi si afectaria
-- la restriccion referencial
-- trbaja es la tabla dependiente o hija, y proyecto es la tabla referenciada o padre.

-- b)
UPDATE TRABAJA SET horas_sem = 231323 where TRABAJA.id_sector = 5;
-- procede sin problema, poruqe es una tabla hija

delete from proyecto where PROYECTO.fecha_fin is null;
-- EN PROYECTO tenemos a la dependiente Trabaja con update on cascade, por lo tanto si elimino en proyecto
-- se eliminara tambien en trbaaja

-------------------------------------------------------------------------------------------------------------------------
-- 3) Plantee Implementación completa en SOL estándar de las siguientes restriccores de integridad, mediante el recurso
-- ceciarativo restrictivo (explique y justifique su elección).

-- a) Los proyectos sin fecha de finalización asignada no deben superar 100000 de presupuesto
-- TUPLA

-- CONTRARIO: PROYECTOS CON FECHA DE FINALIZACION SUPERANDO 100000
ALTER TABLE proyecto
ADD CONSTRAINT ck_proyecto_max_presupuesto
CHECK (
    PROYECTO.fecha_fin IS not NULL
    OR PROYECTO.presupuesto <= 100000);

-- b) El director asignadc a un proyecto debe haber trabajado al menos
-- en 5 proyectos ya finalizados en el mismo sector

ALTER TABLE proyecto
ADD CONSTRAINT ck_proyecto_max_presupuesto
CHECK (
    NOT EXISTS (SELECT 1
                FROM PROYECTO p_nuevo
                WHERE NOT (
                    (SELECT COUNT(*)
                     FROM PROYECTO p_antiguo
                     WHERE p_antiguo.director = p_nuevo.director
                       AND p_antiguo.id_sector = p_nuevo.id_sector
                       AND p_antiguo.fecha_fin IS NOT NULL) >= 5
                    ))
    );


-- c) Er cada proyectc pueden trabajar 10 Ingenieros como máximo.
-- EN CADA PROYECTO NO PUEDEN HABER MENOS DE 10 INGENIEROS
CREATE ASSERTION max_10_ingenieros_por_proyecto
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM TRABAJA
        GROUP BY id_sector, nro_proyecto
        HAVING COUNT(id_ingeniero) > 10
    )
);

-- 4) Esciba en postgres un trigger para satisfacer la restriccion 3. b
-- b) El director asignadc a un proyecto debe haber trabajado al menos en 5 proyectos ya finalizados en el mismo sector

-- luego implementar de forma completa y eficiente una funcioin asociada a nserciones
-- c) provea una operacion concreta sobrne la DB que despertaria el trigger deinidio en 4.b


-- 6) En cada caso explique brevement ey ejemplifia
-- para que se utiliza la clausula mathc, donde se incoprota y en que casos es posible utilizarla?
-- b) en que casos resutla de utilidad un FULL, LEFT, RIGHT JOIN en una consulta?
-- c) Que difrencia existe entre count(distinct cant_empleados), count(*), count(cant_empleados)¡ que ocurriria en cada
-- caso si la coluna cant_empleados pudiera contener valores nulois

-- a)
-- La clausula MATCH se utiliza para analizar si se puede insertar
-- cuando es match simple se puede insertar si todas las columnas son null, no es necesario que coincida con la PK
-- de la tabla referenciada, y se pueden ingresar datos aleatorios si no se controla correctamente.

-- MATCH PARTIAL, este no puede poner datos random en la fk,
       -- si la fk completa esta en null este la acepta, si la columna
-- es null la acepta, LOS VALORES NO NULOS DEBEN COINCIDIR SI O SI CON LA PK REFERENCIADA

-- MATCH FULL, o esta todo bien o esta todo mal, es decir o estan ambas fk presentes o estan las 2 nulas. No se permite
-- que este una y otra nula. Si cumple con full cumple con el resto.

-- El full, es util cuando necesitas registros tanto de la primera tabla y de la segunda. Habran duplicados ya que
-- obtendra todos los registros que coincidan. Va a obtener tambien las columas tanto de PROYECTO ocmo de TRABAJA
-- donde coincida el ON


-- b)
-- Si es LEFT, solo obtendra los registros que coincidan con la primer tabla sin la segunda.

SELECT *
FROM proyecto
FULL JOIN trabaja
ON proyecto.id_sector = trabaja.id_sector
AND proyecto.nro_proyecto = trabaja.nro_proyecto;

SELECT * FROM PROYECTO;
SELECT * FROM TRABAJA;


SELECT *
FROM unc_46203524.proyecto
FULL JOIN unc_46203524.ingeniero
ON ingeniero.id_ingeniero = proyecto.director;
-- ESTO ME TRAE TODOS LOS PROYECTOS, INCLUYENDO A LOS INGENIEROS SIN PROYECTOS COMO OLIVIA

SELECT *
FROM unc_46203524.ingeniero
RIGHT JOIN unc_46203524.proyecto
ON ingeniero.id_ingeniero = proyecto.director;
-- ESTO ME TRAE TODOS LOS INGENIEROS QUE TENGAN PROYECTOS. OLIVIA NO TIENE NINGUN PROYECTO, NO SE PROYECTA.
-- SI NO CUMPLE CON LA TABLA DE LA DERECHA INGENIERO LAS COINCIDENCIAS DE PROYECTO, NO SE PROYECTA.

SELECT *
FROM unc_46203524.ingeniero
LEFT JOIN unc_46203524.proyecto
ON ingeniero.id_ingeniero = proyecto.director;
-- TRAE TODOS LOS INGENIEROS, MAS TODOS LOS INGENIEROS CON PROYECTOS SI EXISTEN. OLIVIA TIENE PROYECTO NULL
-- PUEDE HABER REPTEIDOS SI HAY MAS DE UN INGENIERO POR PROYECTO, PARA EVITAR ESTO SE PUEDE USAR DISTINCT

-- explicar la diferencia entre count(distinct cant_empleados), count(*), count(cant_empleados)? Que ocurriria
-- en cada caso si la columna cant_empleados pudera contener valores nullos?

select * from unc_46203524.sector;

SELECT COUNT(DISTINCT sector.cant_empleados)
FROM unc_46203524.sector;

SELECT COUNT(*)
FROM unc_46203524.sector;

SELECT COUNT(cant_empleados)
FROM unc_46203524.sector;

SELECT c.id_ciudad, c.nombre_ciudad
FROM unc_esq_peliculas.ciudad c
LEFT JOIN unc_esq_peliculas.departamento d ON c.id_ciudad = d.id_ciudad
WHERE d.id_ciudad IS NULL
AND c.nombre_ciudad LIKE 'G%'
ORDER BY c.id_pais DESC
LIMIT 3;

SELECT c.id_ciudad, c.nombre_ciudad
FROM unc_esq_peliculas.ciudad c
WHERE NOT EXISTS(
SELECT 1
FROM unc_esq_peliculas.departamento d
WHERE c.id_ciudad = d.id_ciudad
)
AND c.nombre_ciudad LIKE 'G%'
ORDER BY c.id_pais DESC
LIMIT 3;