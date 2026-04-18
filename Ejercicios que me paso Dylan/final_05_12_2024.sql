set search_path to final_05_12_2024;
CREATE TABLE Agricultor (
    ID_Agricultor serial  NOT NULL,
    Nombre varchar(100)  NOT NULL,
    Email varchar(100)  NOT NULL,
    Telefono varchar(15)  NULL,
    Fecha_registro date  NULL,
    CONSTRAINT Agricultores_pk PRIMARY KEY (ID_Agricultor)
);

-- Table: Cosecha
CREATE TABLE Cosecha (
    ID_Cultivo int  NOT NULL,
    Nro_cosecha int  NOT NULL,
    Fecha_Cosecha date  NOT NULL,
    Cantidad_cosechada decimal(10,2)  NOT NULL,
    Precio_estimado decimal(10,2)  NOT NULL,
    CONSTRAINT Cosechas_pk PRIMARY KEY (ID_Cultivo,Nro_cosecha)
);

-- Table: Cultivo
CREATE TABLE Cultivo (
    ID_Cultivo serial  NOT NULL,
    Nombre_cultivo varchar(100)  NOT NULL,
    Tipo varchar(50)  NOT NULL,
    Fecha_siembra date  NOT NULL,
    ID_agricultor int  NULL,
    CONSTRAINT Cultivos_pk PRIMARY KEY (ID_Cultivo)
);

-- Table: Inventario
CREATE TABLE Inventario (
    ID_Cultivo int  NOT NULL,
    ID_Proveedor int  NOT NULL,
    Cantidad_recibida decimal(10,2)  NOT NULL,
    Fecha_recepcion date  NOT NULL,
    CONSTRAINT Inventario_pk PRIMARY KEY (ID_Cultivo,ID_Proveedor)
);

-- Table: Proveedor
CREATE TABLE Proveedor (
    ID_Proveedor serial  NOT NULL,
    Nombre varchar(100)  NOT NULL,
    Rubro varchar(100)  NOT NULL,
    Telefono varchar(15)  NULL,
    Email varchar(100)  NULL,
    CONSTRAINT Proveedores_pk PRIMARY KEY (ID_Proveedor)
);

-- Table: Venta
CREATE TABLE Venta (
    ID_Cultivo int  NOT NULL,
    Nro_cosecha int  NOT NULL,
    Fecha_Venta date  NOT NULL,
    Cantidad_vendida decimal(10,2)  NOT NULL,
    Precio_unitario decimal(10,2)  NOT NULL,
    CONSTRAINT Ventas_pk PRIMARY KEY (Fecha_Venta,Nro_cosecha,ID_Cultivo)
);

-- foreign keys
-- Reference: FK_cosecha_cultivo (table: Cosecha)
ALTER TABLE Cosecha ADD CONSTRAINT FK_cosecha_cultivo
    FOREIGN KEY (ID_Cultivo)
    REFERENCES Cultivo (ID_Cultivo)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_cultivo_agricultor (table: Cultivo)
ALTER TABLE Cultivo ADD CONSTRAINT FK_cultivo_agricultor
    FOREIGN KEY (ID_agricultor)
    REFERENCES Agricultor (ID_Agricultor)
    ON DELETE  SET NULL
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_cultivo (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_cultivo
    FOREIGN KEY (ID_Cultivo)
    REFERENCES Cultivo (ID_Cultivo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_proveedor (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_proveedor
    FOREIGN KEY (ID_Proveedor)
    REFERENCES Proveedor (ID_Proveedor)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_venta_cosecha (table: Venta)
ALTER TABLE Venta ADD CONSTRAINT FK_venta_cosecha
    FOREIGN KEY (ID_Cultivo, Nro_cosecha)
    REFERENCES Cosecha (ID_Cultivo, Nro_cosecha)
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;


INSERT INTO proveedor VALUES(1, 'Hernan Cobo', 'Pesticidas', '2284237654', 'Cobito@profesunicen.com'),
                            (2, 'Martin Vazquez', 'Alimento para animales', '2494556643', 'ElVasco@labset.com'),
                            (3, 'Luis Berdun', 'Madera', NULL, 'Berdun@POO.com'),
                            (4, 'Lucas Leiva', 'Alimento para animales', NULL, NULL),
                            (5, 'Graciela Discreta', 'Animales', '666', NULL);

insert into agricultor (nombre, email, telefono, fecha_registro)
    VALUES ('Maduro Nicolas','MaduroTomate@agricultor.com','6623899','2025-06-10'::date),
           ('Cañamo Jonny','JonnyFumo@agricultor.com','32986547','2025-10-11'::date),
           ('Sojuda Martin','Solosoja@agricultor.com','89544785',null),
           ('Maiziño Marcelo','MarMaiz@agricultor.com','20294577','2026-01-10'::date),
           ('Trigger Esteban','EsteTrigger@agricultor.com','112599867','2024-09-08'::date),
           ('Lechugo Fernando','Lechufer@agricultor.com','203095347',null);

insert into cultivo (nombre_cultivo, tipo, fecha_siembra, id_agricultor)
    VALUES ('Cultivo de tomate','Fruta','2025-09-12'::date,1),
           ('Cultivo de cañamo','Estupefaciente','2025-12-04'::date,2),
           ('Cultivo de Soja','Verdura','2026-01-02'::date,3),
           ('Cultivo de Maiz','Verdura','2026-01-12'::date,4),
           ('Cultivo de Trigo','Verdura','2024-10-20'::date,5),
           ('Cultivo de Lechuga','Verdura','2025-09-12'::date,6),
           ('Cultivo de tomate','Fruta','2026-01-10'::date,1),
           ('Cultivo de cañamo','Estupefaciente','2025-12-20'::date,2);

INSERT INTO inventario VALUES(1,1, 500.00, '24-02-2024'::date),
                             (2,2,600.00, CURRENT_DATE),
                             (3,3, 20.50, '26-12-2025'::date),
                             (4, 4, 200.00, '30-12-2025'::date),
                             (4, 2, 750.50, CURRENT_DATE),
                             (1, 3, 850.60, '01-01-2026'::date);

insert into cosecha VALUES (1,1,'2025-12-12'::date,100000,8000),
                           (2,2,'2026-01-04'::date,5000,25000),
                           (3,3,'2026-04-06'::date,30000,15000),
                           (4,4,'2026-04-12'::date,77000,14000),
                           (5,5,'2025-01-12'::date,100000,12000),
                           (6,6,'2025-08-12'::date,94000,4000),
                           (8,7,'2026-01-14'::date,7000,35000);

INSERT INTO venta VALUES(1,1,CURRENT_DATE, 2000.00, 50.00)
INSERT INTO venta VALUES (2, 2,'26-12-2025'::date, 1500.00, 30.00);
INSERT INTO venta VALUES (3, 3, '31-12-2025'::date, 3200.50, 80.00);
INSERT INTO venta VALUES (4, 4, '10-01-2026'::date, 750.00, 15.00);
INSERT INTO venta VALUES (5, 5, '24-02-2024'::date, 4100.00, 120.00);
INSERT INTO venta VALUES (6, 6, CURRENT_DATE, 980.75, 25.00);
/*
Controlar que los proveedores tengan registrado un teléfono o un email.
Seleccione la opción que considera correcta, de acuerdo a lo solicitado y justifique claramente (debajo de la
pregunta 1.c )
 */

 ALTER TABLE proveedor ADD CONSTRAINT prove1
 CHECK(telefono is not null OR email is not null);

--Verificar que la cantidad total vendida de cada cosecha no exceda la cantidad cosechada de la misma.
que no exista una cosecha tal que no exista una venta asociada con mas cantidad_vendida
CREATE ASSERTION ass1
CHECK (NOT EXISTS(SELECT 1 FROM cosecha c JOIN venta v USING(id_cultivo, nro_cosecha)
       GROUP BY id_cultivo, nro_cosecha having c.cantidad_cosechada < SUM(v.cantidad_vendida)))


       SELECT 1 FROM cosecha c JOIN venta v USING(id_cultivo, nro_cosecha)
       GROUP BY id_cultivo, nro_cosecha
       having c.cantidad_cosechada < SUM(v.cantidad_vendida);


/*
1.c) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
tablas/atributos necesarios.

- Para cada cultivo, los números de cosecha deben reflejar el orden cronológico de las fechas de cosecha; es
decir, un número de cosecha mayor debe corresponder a una fecha de cosecha posterior para el mismo cultivo.
 */
insert into cosecha VALUES (1,2,'2025-12-10'::date,20000,4000);
 por cada cultivo (separo/ agrupo por id_cultivo) el nro_cosecha debe estar en orden cronologico con las fechas de cosecha
 nro cosecha 1 : fecha hoy
 nro cosecha 2 : fecha mañana

 lo que estaria mal: que exista una cosecha tal que tenga una fecha_cosecha > a una fecha_cosecha con nro_cosecha menor
se busca que no exista una cosecha tal que e

NOT EXISTS(
SELECT 1
FROM cosecha c1
WHERE NOT EXISTS(SELECT 1 FROM cosecha c2 WHERE c1.ID_Cultivo = c2.ID_Cultivo AND c2.nro_cosecha > c1.nro_cosecha AND  c1.fecha_cosecha < c2.fecha_cosecha)
)


SELECT * FROM COSECHA;
 C1 5  fecha hoy      c2.fecha > c1.fecha AND c2.nro>c1.nro   BIEN  -> NOT EXISTS -> FALSE
 C2 10 FECHA MAÑANA


SELECT 1
FROM cosecha c
    WHERE EXISTS (
    SELECt 1
    FROM cosecha c2
    WHERE c.id_cultivo = c2.id_cultivo AND
    c.nro_cosecha > c2.nro_cosecha AND
    c.fecha_cosecha <= c2.fecha_cosecha);
/*
V1: que contenga los datos de los cultivos sembrados durante el corriente año que no registren inventario de
productos adquiridos al proveedor 'Lucas Leiva'.
*/
CREATE VIEW V1 AS
SELECT c.*
FROM cultivo c
WHERE EXTRACT(YEAR FROM c.fecha_siembra) = EXTRACT(YEAR FROM current_date) AND NOT EXISTS (SELECT 1
                                                                                           FROM inventario i join proveedor p USING(id_proveedor)
                                                                                           WHERE p.nombre = 'Lucas Leiva' AND c.id_cultivo = i.id_cultivo);
/*
- V2: que contenga para cada cosecha con al menos 3 ventas realizadas, el identificador de la cosecha, la
cantidad total vendida y la fecha de la última venta registrada.
*/
CREATE VIEW V2
SELECT co.id_cultivo, COUNT(*) as cant_total_vendida, MAX(Fecha_Venta) as ultima_fecha
FROM cosecha co
JOIN venta v USING(ID_Cultivo,Nro_cosecha)
GROUP BY co.id_cultivo, co.Nro_cosecha
HAVING COUNT(*) >= 3;

INSERT INTO venta VALUES(1,1, '2026-01-05'::DATE, 50000.00, 50.00),
                        (1,1, '2026-01-06', 50000.00, 50.00);
/*
- V3: que contenga los datos de los cultivos que han tenido el mayor promedio de cantidad vendida el año
actual.
 */

CREATE VIEW V3 AS
 SELECT cu.*
 FROM cultivo cu
 JOIN venta v USING(ID_Cultivo)
 GROUP BY cu.ID_Cultivo
 HAVING AVG(v.cantidad_vendida) = (SELECT AVG(v.cantidad_vendida)
                                    FROM CULTIVO Cu2
                                    JOIN venta v USING(ID_Cultivo)
                                    WHERE EXTRACT(YEAR FROM v.Fecha_Venta) = EXTRACT(YEAR FROM current_date)
                                    GROUP BY cu2.ID_Cultivo
                                    ORDER BY AVG(v.cantidad_vendida) DESC
                                    LIMIT 1);
insert into venta VALUES (4,4,'2026-01-05'::date,60050,25.00),
                         (4,4,'2026-02-05'::date,41200,25.00);


 SELECT * FROM V3;

SELECT cu2.ID_Cultivo, AVG(v.cantidad_vendida)
FROM CULTIVO Cu2
JOIN venta v USING(ID_Cultivo)
WHERE EXTRACT(YEAR FROM v.Fecha_Venta) = EXTRACT(YEAR FROM current_date)
GROUP BY cu2.ID_Cultivo
ORDER BY AVG(v.cantidad_vendida) DESC
LIMIT 1;



/*
🟦 PATRÓN A — “Todos los que están en X deben cumplir Y”
Se usa cuando:
cada fila necesita otra fila relacionada para ser válida.
   Forma lógica:

No existe un X que no tenga Y

   NOT EXISTS (
    SELECT 1
    FROM X x
    WHERE NOT EXISTS (
        SELECT 1
        FROM Y y
        WHERE y corresponde a x
    )
)

---------------------------------------------------------------
No debe existir una combinación inválida”
SELECT ...
FROM T t1
WHERE EXISTS (
    SELECT 1
    FROM T t2
    WHERE conflicto t1 t2
)
Se usa cuando:
ninguna fila necesita otra;
solo que no haya dos que estén en conflicto.
Cómo decidir en 10 segundos en el parcial


Preguntate:

“¿Una fila sola puede ser válida sin otra?”

Respuesta	                  Patrón
❌ No, necesita algo	    🟦 A
✅ Sí, solo no debe chocar	🟥 B

*/
/*

MEDICO(idMedico, nombre)
GUARDIA(idMedico, fecha)
ATENCION(idMedico, fecha, paciente)

Todo médico que tenga una guardia asignada debe haber atendido al menos un paciente ese día.

Patron A, ya que si inserto un medico con guardia asignada, depende del paciente.

Lo que esta mal:
        existe un medico con una guardia asignada y no existe que haya atendido un paciente
   lo que hay que controlar entonces es que no exista un medico con una guardia asignada tal que no exista una atencion a un paciente ese dia

NOT EXISTS(
    SELECT g.*
    FROM guardia g
    WHERE NOT EXISTS(SELECT 1 FROM atencion WHERE a.idmedico = g.idmedico AND g.fecha = a.fecha)
)
*/

/*
CLIENTE(
   idCliente PK,
   nombre
)

CONTRATO(
   idContrato PK,
   idCliente FK → CLIENTE,
   fecha_desde,
   fecha_hasta
)

FACTURA(
   idFactura PK,
   idCliente FK → CLIENTE,
   fecha
)

Un cliente solo puede tener facturas durante períodos en los que tenga un contrato vigente.
fecha_desde <= fecha
AND (fecha_hasta IS NULL OR fecha_hasta >= fecha)


el caso mal: un cliente tiene una factura tal que no existe un contrato vigente

lo que buscamos evitar: no exista una factura asociada a un cliente tal que no existe un contrato vigente

NOT EXISTS(
    SELECT 1
    FROM factura f
    WHERE NOT EXISTS (SELECT 1 FROM CONTRATO c WHERE f.idcliente = c.idcliente AND fecha_desde <= fecha
    AND (fecha_hasta IS NULL OR fecha_hasta >= fecha))
)

*/

/*
VUELO(
   idVuelo PK,
   avion
)

TRAMO(
   idTramo PK,
   idVuelo FK → VUELO,
   hora_salida,
   hora_llegada
)
Un avión no puede tener dos tramos que se superpongan en horario.
 */
/*
SELECT *
FROM tramo t1
WHERE EXISTS (
    SELECT 1
    FROM tramo t2
    WHERE t1.idvuelo = t2.idvuelo
      AND t1.hora_inicio < t2.hora_fin
      AND t2.hora_inicio < t1.hora_fin
      AND (
           t1.hora_inicio <> t2.hora_inicio
        OR t1.hora_fin    <> t2.hora_fin
      )
)


ALUMNO(
   idAlumno PK,
   nombre
)

MATERIA(
   idMateria PK,
   obligatoria BOOLEAN
)

INSCRIPCION(
   idAlumno FK → ALUMNO,
   idMateria FK → MATERIA,
   PK(idAlumno, idMateria)
)
Todo alumno debe estar inscripto en todas las materias obligatorias.

SELECT *
FROM alumno a
WHERE NOT EXISTS (SELECT idMateria
                  FROM materia where obligatoria = true
                    EXCEPT
                  select idMateria
                  from inscripcion
                  where a.idalumno = i.idalumno)


Todo auto que pase por esta carretera debera tener licencia valida

Lo que esta mal: exista un auto que pase por la carretera y no exista una licencia valida asociada a ese auto


           que no exista un auto que pase por la carretera y no exista una licencia valida asociada a ese auto

AUTO
idauto

REGISTRO
si paso por la carretera x auto con x persona

PERSONA
licencia boolean
NOT EXISTS
(
 SELECT 1 FROM registro r
 WHERE NOT EXISTS(SELECT 1 FROM persona where r.dni = p.dni AND p.licencia = true)
)

*/


-- 3) Para el esquema dado, se ha creado la tabla cultivos_agricultor donde se requiere registrar la siguiente
-- información para todos los agricultores que están registrados en la base:
--
-- id_agricultor, nombre, fecha_registro, cantidad_cultivos, fecha_ultima_siembra
-- donde, para cada agricultor:

-- - cantidad_cultivos corresponde a la cantidad de cultivos que registra
-- - fecha_ultima_siembra es la fecha correspondiente a la última siembra que realizó

-- Nota: en caso que un agricultor no registre cultivos, se deberá indicar apropiadamente.
-- a) Implemente el método más adecuado en PostgreSQL que permita completar dicha tabla con la información
-- de todos los agricultores a partir de los datos existentes en la base.
-- Explique su solución e incluya la sentencia
-- que debería utilizar un usuario para la ejecución del mismo.
-- Nota: no puede utilizar sentencias de bucle (for, loop, etc.) para resolverlo.

CREATE TABLE cultivos_agricultor (
    id_agricultor int,
    nombre varchar(100),
    fecha_registro date,
    cantidad_cultivos bigint,
    fecha_ultima_siembra date
);

CREATE OR REPLACE PROCEDURE llenar_cultivos_agricultor()
AS $$
BEGIN
    INSERT INTO cultivos_agricultor
    SELECT a.ID_Agricultor, a.nombre, a.fecha_registro, COUNT(c.id_cultivo),  MAX(c.Fecha_siembra)
        FROM agricultor a
        LEFT JOIN cultivo c ON (c.id_agricultor = a.id_agricultor)
    GROUP BY a.id_agricultor, a.nombre, a.fecha_registro;
END;
$$ language 'plpgsql';

CALL llenar_cultivos_agricultor();

SELECT * FROM cultivos_agricultor;

-- 3.b) Indique y justifique todos los eventos críticos necesarios para mantener los datos actualizados en la tabla
-- cultivos_agricultor cuando se produzcan actualizaciones en la base. Incluya la declaración de los triggers
-- correspondientes en PostgreSQL y escriba la implementación de la/s función/es requerida/s para operaciones
-- de insert.
/*
Eventos criticos:
UPDATE EN CULTIVO -> id_Agricultor puede pasar de nulo a uno o viceversa.
UPDATE EN CULTIVO -> fecha_siembra cambiaria el fecha_ultima_siembra
INSERT EN CULTIVO -> insertar en cultivo podria hacer cambiar la cantidad_cultivos de agricultor
DELETE EN CULTIVO

INSERT EN agricultor -> agregarlo a la tabla.
UPDATE EN agricultor -> nombre, fecha_registro.
DELETE EN agricultor
*/


CREATE OR REPLACE FUNCTION mantener_actualizada_de_cultivo()
RETURNS TRIGGER AS $$
    DECLARE
        fecha_agricultor DATE;
BEGIN

    SELECT fecha_ultima_siembra INTO fecha_agricultor FROM cultivos_agricultor WHERE id_agricultor = NEW.id_agricultor;

    IF (NEW.fecha_siembra > fecha_agricultor) THEN
        UPDATE cultivos_agricultor SET fecha_ultima_siembra = NEW.fecha_siembra, cantidad_cultivos = cantidad_cultivos+1
                                       WHERE id_agricultor = NEW.ID_agricultor;
    end if;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER tr_mantener_actualizada
AFTER INSERT ON cultivo
FOR EACH ROW
WHEN ( cultivo.id_agricultor IS NOT NULL )
EXECUTE FUNCTION mantener_actualizada_de_cultivo();


CREATE OR REPLACE FUNCTION mantener_actualizada_de_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO cultivos_agricultor VALUES (NEW.ID_Agricultor, NEW.nombre, NEW.fecha_registro, 0, NULL);
    RETURN NEW;
end;
$$ language 'plpgsql';
CREATE TRIGGER tr_mantener_act
AFTER INSERT ON agricultor
FOR EACH ROW EXECUTE FUNCTION mantener_actualizada_de_insert();

*/

-- 4) Dada la siguiente vista creada en PostgreSQL sobre el esquema dado:.
-- create view V_Ventas_Cosecha as
-- select v.*, c.Fecha_Cosecha, c.Cantidad_cosechada
-- from Venta v join Cosecha using (ID_Cultivo, Nro_cosecha)
-- where Cantidad_vendida > 10000 ;
--4.a) Complete convenientemente la implementación del trigger a continuación para que permita eliminar tuplas
-- de la vista


create view V_Ventas_Cosecha as
select v.*, c.Fecha_Cosecha, c.Cantidad_cosechada
from Venta v join Cosecha c using (ID_Cultivo, Nro_cosecha)
where Cantidad_vendida > 10000 ;
select * from v_ventas_cosecha;

CREATE OR REPLACE FUNCTION eliminar_tabla()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM venta WHERE OLD.id_cultivo = venta.id_cultivo AND OLD.Nro_cosecha = venta.nro_cosecha AND OLD.fecha_Venta = venta.Fecha_Venta;
    RETURN NULL;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_eliminar_tablas
INSTEAD OF DELETE ON V_ventas_cosecha
FOR EACH ROW EXECUTE FUNCTION eliminar_tabla();

-- 4.b) Detalle cómo implementaría actualizaciones sobre la vista para el resto de las operaciones.

CREATE OR REPLACE FUNCTION eliminar_tabla()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE cosecha SET fecha_cosecha = new.fecha_cosecha, cantidad_cosechada = new.cantidad_cosechada
        WHERE id_cultivo = OLD.id_cultivo AND nro_cosecha = OLD.nro_cosecha;
    UPDATE venta SET id_cultivo = new.id_cultivo, nro_cosecha = new.nro_cosecha, fecha_venta = new.fecha_venta, Precio_unitario = new.precio_unitario
        WHERE id_cultivo = OLD.id_cultivo AND nro_cosecha = OLD.nro_cosecha AND fecha_venta = OLD.fecha_venta;
    RETURN NULL;
end;
$$ language 'plpgsql';

CREATE TRIGGER tr_eliminar_tablas
INSTEAD OF UPDATE ON V_ventas_cosecha
FOR EACH ROW EXECUTE FUNCTION eliminar_tabla();

SELECT * FROM cosecha WHERE ID_Cultivo = 2 AND Nro_cosecha = 2;






--7.1) Después de ejecutar estos comandos, ¿cuáles de las siguientes afirmaciones son ciertas?
--a) alice puede leer y modificar la tabla cosecha. -> SI
--b) bob puede otorgar permisos sobre la tabla venta a otros usuarios. -> SI
--c) charlie puede añadir nuevos empleados a la tabla agricultor. -> NO
--d) Los usuarios del rol managers tienen permisos para modificar el contenido de la tabla agricultor. -> NO
--e) bob puede eliminar la tabla venta. -> SI  -> Esta mal, bob puede borrar tuplas no la tabla

Usuario alice (gerente de proyectos).
Usuario bob (analista financiero).
Usuario charlie (interno).
Rol managers (incluye a alice).
Rol analysts (incluye a bob).

El DBA ejecuta las siguientes sentencias SQL para configurar los permisos iniciales:

GRANT SELECT, UPDATE ON cosecha TO 'alice';
GRANT SELECT ON venta TO 'analysts';
GRANT INSERT ON agricultor TO 'managers';
GRANT ALL PRIVILEGES ON venta TO 'bob' WITH GRANT OPTION;
GRANT SELECT ON cosecha, agricultor TO 'charlie';

REVOKE SELECT ON cosecha FROM 'charlie';
REVOKE INSERT ON agricultor FROM 'managers';
GRANT DELETE ON venta TO 'alice';

--a) charlie conserva el permiso de SELECT en la tabla agricultor pero no en cosecha. -> SI
--b) alice puede eliminar registros en la tabla venta pero no puede leerlos. -> NO
--c) El rol managers ya no puede insertar nuevos empleados en agricultor. -> SI
--d) bob pierde todos los permisos sobre venta debido al cambio en alice.;

7.3) Si alice también es añadida al rol analysts y el DBA ejecuta
REVOKE SELECT ON venta FROM 'analysts';
¿Qué sucede con el acceso de alice a la tabla venta?

--a) alice conserva el permiso de SELECT porque se otorga directamente. -> NO
--b) alice pierde completamente el permiso de SELECT en venta. -> SI
--c) alice solo conserva el permiso de UPDATE en venta. -> NO
--d) alice no puede ejecutar ninguna acción sobre venta. -> NO