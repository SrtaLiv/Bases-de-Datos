CREATE TABLE clientes (
                          id_cliente INT PRIMARY KEY,
                          nombre VARCHAR(50),
                          ciudad VARCHAR(50)
);

CREATE TABLE pedidos (
                         id_pedido INT PRIMARY KEY,
                         id_cliente INT,
                         producto VARCHAR(50),
                         total INT
);

CREATE TABLE pagos (
                       id_pago INT PRIMARY KEY,
                       id_pedido INT,
                       metodo VARCHAR(50)
);

INSERT INTO clientes VALUES
                         (1, 'Ana', 'Tandil'),
                         (2, 'Luis', 'Olavarría'),
                         (3, 'Marta', 'Azul'),
                         (4, 'Juan', 'Tandil');

INSERT INTO pedidos VALUES
                        (101, 1, 'Notebook', 800),
                        (102, 1, 'Mouse', 20),
                        (103, 2, 'Teclado', 50),
                        (104, 5, 'Monitor', 300);

INSERT INTO pagos VALUES
                      (1, 101, 'Tarjeta'),
                      (2, 103, 'Transferencia'),
                      (3, 999, 'Efectivo');

SELECT c.nombre, p.producto, p.total
FROM clientes c
         JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- 2. LEFT JOIN
SELECT c.nombre, p.producto
FROM clientes c
         LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- 3. RIGHT JOIN
SELECT c.nombre, p.producto
FROM clientes c
         RIGHT JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- 4. FULL JOIN
SELECT c.nombre, p.producto
FROM clientes c
         FULL JOIN pedidos p ON c.id_cliente = p.id_cliente;

CREATE TABLE alumnos (
                         id_alumno INT PRIMARY KEY,
                         nombre VARCHAR(50)
);

CREATE TABLE notas (
                       id_alumno INT,
                       materia VARCHAR(50),
                       nota INT
);

INSERT INTO alumnos VALUES
                        (1, 'Sofía'),
                        (2, 'Pedro'),
                        (3, 'Lucía');

INSERT INTO notas VALUES
                      (1, 'SQL', 9),
                      (2, 'Java', 7),
                      (4, 'Python', 8);

-- 8. NATURAL JOIN
SELECT *
FROM alumnos
         NATURAL JOIN notas;

--
--ejercicio slide 25

--¿Cuáles son las tareas cuyo promedio de horas aportadas por tarea de los
-- voluntarios nacidos a partir del año 1995
-- es superior al promedio general de dicho grupo de voluntarios?

SELECT id_tarea, avg(horas_aportadas)
FROM Voluntario
WHERE fecha_nacminiento > 1995
GROUP by id_tarea

CREATE TABLE invocador (
                           id INT PRIMARY KEY,
                           nombre VARCHAR(50),
                           linea VARCHAR(20),
                           campeon VARCHAR(30),
                           elo INT,
                           kills INT
);

INSERT INTO invocador VALUES
                          (1,'Olivia','Mid','Ahri',1800,12),
                          (2,'Juan','Top','Darius',1500,5),
                          (3,'Ana','ADC','Jinx',1700,10),
                          (4,'Pedro','Mid','Yasuo',2200,15),
                          (5,'Lucia','Support','Lulu',1400,2),
                          (6,'Martin','Jungla','Lee Sin',1900,8),
                          (7,'Sofia','ADC','Jinx',1600,11),
                          (8,'Tomas','Top','Garen',1300,4),
                          (9,'Carla','Mid','Ahri',2100,13),
                          (10,'Nico','Support','Thresh',1700,3),
                          (11,'Valen','Jungla','Lee Sin',2000,9),
                          (12,'Mora','ADC','KaiSa',2300,14);

--Ejercicio 1
--Mostrar las líneas cuyo elo promedio sea superior al elo promedio general.
SELECT invocador.linea FROM invocador
    gROUP BY invocador.linea
    HAVING avg(elo) > (
    SELECT avg(invocador.elo) FROM invocador
    )

--Ejercicio 2
-- Mostrar los campeones cuya cantidad de jugadores sea superior a la cantidad de jugadores que usan Lulu.
SELECT invocador.campeon, count(id) as cantidad_jugadires FROM invocador
GROUP BY campeon
HAVING count(id) > (
    SELECT count(id)
    FROM invocador
    WHERE campeon = 'Lulu'
    );

-- sett 100, ezreal 200, lulu, 20, luz 3.
-- rta: sett, ezreal

--Ejercicio 3
-- Mostrar las líneas cuya cantidad de jugadores sea superior al promedio de jugadores por línea.
SELECT linea, count(*) AS cantidad
FROM invocador
GROUP BY linea
HAVING count(*) > (
    SELECT avg(cantidad)
    FROM invocador
    GROUP BY linea
    )

SELECT linea, COUNT(*) AS cantidad
FROM invocador
GROUP BY linea
HAVING COUNT(*) >
       (
           SELECT AVG(cantidad)
           FROM (
                    SELECT COUNT(*) AS cantidad
                    FROM invocador
                    GROUP BY linea
                ) x
       );

--Ejemplo: Buscar todos los voluntarios que aportan más horas que el promedio de
-- horas aportadas por los voluntarios de la institución a la que pertenecen.
SELECT nro_volunatio
FROM Voluntario v1
WHERE hora_aportads >
(
    SELECT avg(horas_aportads)
    FROM voluntario v2
    WHERE v1.id_institucion = v2.id_institucion
    )

--Ejercicio 4
--Mostrar los campeones cuyo promedio de kills sea mayor al promedio general de kills.
SELECT invocador.campeon
FROM invocador
GROUP BY campeon
HAVING avg(kills) > (
    SELECT avg(kills)
    FROM (
        SELECT count(kills)
        FROM invocador
        GROUP BY kills
         )
    )

--Listar todas las instituciones que no poseen voluntarios
SELECT id_institucion
FROM INSTITUCION
WHERE NOT EXISTS(
    SELECT 1
    FROM VOLUNTARIO v
    WHERE v.ID_INSTITUCION = i.id_institucion
)