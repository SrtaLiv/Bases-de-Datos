-- Ejercicio 1


-- Indique si las siguientes operaciones serian aceptadas o rechazadas por el DBMS, justificando en cada caso
-- (se han omitido las sentencias de conexión de usuarios y otros detalles no relevantes). Se recomienda probarlo sobre
-- PostgreSQL, adaptando cada sentencia a su base de datos según la sintaxis particular.


--1) U1:
CREATE TABLE Stocks_peli ;
-- procede

--2) U1:
CREATE TABLE Peli_en_video ... ;
-- procede

3) U1: GRANT ALL PRIVILEGES ON Stocks_peli, Peli_en_video
	TO U5 WITH GRANT OPTION;
-- procede, u5 puede propagar a otros privilegios

4) U1: GRANT UPDATE ON Stocks_peli
	TO U2, U3 WITH GRANT OPTION;
-- Procede, u2 y u3 ahora puden actualizar en Stock_peli y dar permisos a otros.

5) U2: UPDATE Peli_en_video ...;
-- No tiene permiso U2 para actualizar Peli_en_video.

6) U5: GRANT INSERT, UPDATE ON Stocks_peli
	TO U3;
-- Procede, u5 teiene permisos otorgados por u1

7) U2: GRANT UPDATE ON Stocks_peli
	TO U4 WITH GRANT OPTION;
-- Procede, u2 tiene permiso de actualizar y dar permisos en stocks_peli

8) U2: GRANT INSERT ON Stocks_peli TO U4;
-- no procede, u2 solo tiene permiso de actualizar y propagar update

9) U1: REVOKE UPDATE ON Stocks_peli
	TO U2, U3 CASCADE;
-- Procede, u2, u3, u4 se queda sin permisos

10) U4: GRANT UPDATE ON Stocks_peli
	TO U6 ;
-- no procede, u4 se queda sin permisos

11) U2: UPDATE Peli_en_video ....;
-- u2 no tiene permiso de actualizar

12) U3: UPDATE Stocks_peli .....;
--  no procede, u1 le quito los permsos a stocks_peli,

13) U3: GRANT UPDATE ON Stocks_peli
	TO U4;
-- no procede, u1, le quito los permisos a u3

15) U4: UPDATE Stocks_peli ...;
-- no procede pq U1: REVOKE UPDATE ON Stocks_peli TO U2, U3 CASCADE; y u2 le habia dado permiso a u4

Nota: la notación es U: OP, significando que el usuario U intenta ejecutar la operación OP. Los ‘...’ indican que la operación está incompleta, sin embargo, esto no es relevante para la resolución del ejercicio (el objetivo es analizar si el usuario en cuestión tiene autorización para efectuar el tipo de operación indicada sobre el objeto del base indicado).

---------------------------------------------------------------------------------------------------------------

--Ejercicio 2
--Considere la siguiente fracción del esquema del usuario db_instal que registra datos de
-- las instalaciones de servicios a clientes

-- 1- Suponga que db_instal ejecuta las siguientes sentencias:
--    GRANT SELECT ON instalacion TO adm WITH GRANT OPTION;
--    GRANT UPDATE ON instalacion TO adm WITH GRANT OPTION;
--    GRANT DELETE ON instalacion TO adm;
--
--
-- 2- Luego el usuario adm ejecuta las siguientes sentencias:
--    GRANT SELECT ON instalacion TO doc;
--    GRANT UPDATE(cantHoras, tarea) ON instalacion TO doc WITH GRANT OPTION;
--    GRANT DELETE ON instalacion TO doc;
--
--
-- a) Realice el grafo de permisos correspondiente a las sentencias indicadas en 1 y 2. Analice qué sucede en cada caso y si alguna de ellas arroja algún error
-- b) Establezca los permisos que conserva el usuario doc sobre la tabla instalacion, si el usuario db_instal ejecuta las siguientes sentencias (considere la posibilidad de error):
--    REVOKE SELECT ON instalacion FROM adm CASCADE;
--    REVOKE UPDATE(tarea) ON instalacion FROM adm CASCADE;


---------------------------------------------------------------------------------------------------------------

-- Ejercicio 3
-- Considere la base de Voluntarios y suponga que las siguientes acciones son ejecutadas por un usuario U0 con
-- privilegios de administrador, salvo que se especifique otro usuario.
-- Resuelva los siguientes ítems mediante las sentencias provistas por el estándar SQL para el control de acceso
-- . Considerando que las operaciones se realizan en el orden indicado, explique en caso de que algún ítem no pueda ser ejecutado.
-- a)Conceder al usuario U1 todos los privilegios sobre la tabla Institución, con posibilidad de concederlos a otros usuarios.
-- b)Permitir que el usuario U2 sólo consulte los datos de la tabla Voluntario.
-- C)Permitir que U2 autorice a U3 para que pueda insertar en la tabla Voluntario.
-- D) Dar a todos los usuarios del sistema privilegios de inserción y actualización sobre la tabla Tarea.
-- E) ¿Cuál sería la diferencia si se incluye o no la cláusula WITH GRANT OPTION?
-- F) Retirar el privilegio de borrado sobre Institución a U1.
-- G) Quitar el privilegio de inserción a todos los usuarios sobre la tabla Tarea ¿Qué usuario podría entonces insertar datos en esa tabla?

--a)Conceder al usuario U1 todos los privilegios sobre la tabla Institución, con posibilidad de concederlos a otros usuarios.
U1: GRANT ALL PRIVILEGES ON institucion
	TO U1 WITH GRANT OPTION;

--b)Permitir que el usuario U2 sólo consulte los datos de la tabla Voluntario
U1:GRANT SELECT ON Voluntario TO U2;

-- C)Permitir que U2 autorice a U3 para que pueda insertar en la tabla Voluntario.
U1: GRANT INSERT ON VOLUNTARIO TO U2 WITH GRANT OPTION ;
U2: GRANT INSERT ON VOLUNTARIO TO U3;

-- D) Dar a todos los usuarios del sistema privilegios de inserción y actualización sobre la tabla Tarea.

GRANT INSERT, UPDATE ON TAREA TO PUBLIC;

-- E)  ¿Cuál sería la diferencia si se incluye o no la cláusula WITH GRANT OPTION?
-- SI NO SE INCLUYE GRANT OPTIONS LOS USUARIOS PUEDEN INSERTAR O ACTUALIZAR EN TAREA. SI SE LE AGREGA EL WITH GRANT
-- OPTION, PODRAN DARLE PERMISO DE INSERTAR O ACTUALIZAR EN TAREA A OTROS USUARIOS

-- F) Retirar el privilegio de borrado sobre Institución a U1.
REVOKE DELETE ON Institucion FROM U1 CASCADE;

-- G) Quitar el privilegio de inserción a todos los usuarios sobre la tabla Tarea ¿Qué usuario podría entonces insertar datos en esa tabla?


-- repaso:
--B. Cada imagen no debe tener más de 5 procesamientos.
-- ID_IMAGEN, ID_PACIENTE,
-- NRO_SECUENCIA
CREATE FUNCTION controlar_procesamientos()
RETURNS TRIGGER AS $$
DECLARE CANT INT;
BEGIN
    SELECT NRO_SECUENCIA INTO CANT
    FROM PROCESAMIENTO
    WHERE ID_IMAGEN = NEW.ID_IMAGEN
    AND ID_PACIENTE = NEW.ID_PACIENTE
    GROUP BY ID_IMAGEN, ID_PACIENTE;

    IF CANT > 4 THEN
        RAISE EXCEPTION 'La %, del paciente % no debe tener mas de 5 ' ||
            'procesamientos', new.id_imagen, new.id_paciente;
    end if;
    RETURN NEW;
end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER TR_CONTROLAR_PROCESAMIENTOS
BEFORE INSERT OR UPDATE OF ID_IMAGEN, ID_PACIENTE
ON PROCESAMIENTO EXECUTE PROCEDURE controlar_procesamientos();

--C. C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
-- indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
-- que la segunda no sea menor que la primera.

ALTER TABLE IMAGEN_MEDICA ADD COLUMN
FECHA_IMAGEN date;

ALTER TABLE PROCESAMIENTO ADD COLUMN
FECHA_PROCESAMIENTO DATE;

CREATE FUNCTION CONTROLAR_FECHAS() RETURNS TRIGGER AS $$
    DECLARE
    fechaP date;
    fechaI date;
BEGIN
        SELECT max(FECHA_PROCESAMIENTO) INTO fechap
        FROM PROCESAMIENTO P
        WHERE NEW.ID_IMAGEN = P.ID_IMAGEN
        AND new.id_paciente = p.id_paciente;

        SELECT max(FECHA_IMAGEN) INTO fechaI
        FROM IMAGEN_MEDICA I
        WHERE NEW.ID_IMAGEN = P.ID_IMAGEN
        AND new.id_paciente = p.id_paciente;

        IF fechaP < fechaI THEN
            RAISE EXCEPTION 'LA FECHA DE PROCESAMIENTO, NO PUEDE SER MENOR A LA FECHA DE IMAGEN';
        end if;
    RETURN NEW;
end;
    $$
LANGUAGE plpgsql;


CREATE TRIGGER TR_CONTROL_IMAGEN
BEFORE INSERT OR UPDATE OF ID_IMAGEN, ID_PACIENTE, FECHA_IMAGEN
ON IMAGEN_MEDICA
FOR EACH ROW
EXECUTE PROCEDURE CONTROLAR_FECHAS();

CREATE TRIGGER TR_CONTROL_PROCESAMIENTO
BEFORE INSERT OR UPDATE OF ID_IMAGEN, ID_PACIENTE, FECHA_PROCESAMIENTO
ON PROCESAMIENTO
FOR EACH ROW
EXECUTE PROCEDURE CONTROLAR_FECHAS();


CREATE OR REPLACE FUNCTION FN_FECHA_IMG_PROC()
RETURNS Trigger AS $$
-- declare  fecha date;
BEGIN
   IF (NEW.fecha_img >
         (SELECT max(fecha_proc)
		 FROM p5p2e4_procesamiento p
		 WHERE NEW.id_paciente = p.id_paciente AND
               NEW.id_imagen = p.id_imagen) ) THEN
	RAISE EXCEPTION 'Fecha de procesamiento menor que el %; fecha de la imagen % del paciente %', NEW.fecha_img, NEW.id_imagen, NEW.id_paciente;
   END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FECHA_IMG_PROC
BEFORE UPDATE OF fecha_img
ON p5p2e4_imagen_medica
    FOR EACH ROW EXECUTE PROCEDURE FN_FECHA_IMG_PROC();

CREATE OR REPLACE FUNCTION FN_FECHA_PROC_IMG()
RETURNS Trigger AS $$
BEGIN
   IF (NEW.fecha_proc >
         (SELECT fecha_img
		 FROM p5p2e4_imagen_medica i
		 WHERE NEW.id_paciente = i.id_paciente AND
               NEW.id_imagen = i.id_imagen) ) THEN
	RAISE EXCEPTION 'Fecha de la imagen % del paciente % es mayor que la de procesamiento %', NEW.id_imagen, NEW.id_paciente, NEW.fecha_proc;
   END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FECHA_PROC_IMG
BEFORE INSERT OR UPDATE OF fecha_proc, id_imagen, id_paciente
ON p5p2e4_procesamiento
    FOR EACH ROW EXECUTE PROCEDURE FN_FECHA_PROC_IMG();