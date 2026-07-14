Ejercicio 1


Indique si las siguientes operaciones serian aceptadas o rechazadas por el DBMS,
          justificando en cada caso (se han omitido las sentencias de conexión de usuarios
          y otros detalles no relevantes). Se recomienda probarlo sobre PostgreSQL,
          adaptando cada sentencia a su base de datos según la sintaxis particular.
1) U1: CREATE TABLE Stocks_peli ... ;
2) U1: CREATE TABLE Peli_en_video ... ;
3) U1: GRANT ALL PRIVILEGES ON Stocks_peli, Peli_en_video
	TO U5 WITH GRANT OPTION;
4) U1: GRANT UPDATE ON Stocks_peli
                 TO U2, U3 WITH GRANT OPTION;
5) U2: UPDATE Peli_en_video ...;
6) U5: GRANT INSERT, UPDATE ON Stocks_peli
                         TO U3;
7) U2: GRANT UPDATE ON Stocks_peli
                 TO U4 WITH GRANT OPTION;
8) U2: GRANT INSERT ON Stocks_peli
	TO U4;
9) U1: REVOKE UPDATE ON Stocks_peli
                  TO U2, U3 CASCADE;
10) U4: GRANT UPDATE ON Stocks_peli
                  TO U6 ;
11) U2: UPDATE Peli_en_video ....;
12) U3: UPDATE Stocks_peli .....;
13) U3: GRANT UPDATE ON Stocks_peli
                  TO U4;
15) U4: UPDATE Stocks_peli ...;

--u1: admin de todo
--u5: sotck_peli, peli_en_video: todos los permisos y puede cederlos
--u2: stock_peli: update y puede cederlos
--u3: stock_peli: update y puede cederlos. Insert en stock peli

-- 5) U2: UPDATE Peli_en_video ...; NO PUEDE

-- U3: INSERT, UPDATE ON Stocks_peli
-- u4: update on sotck_peli y puede cederlos
-- u2, u3, u4: sin update en stock peli
-- 10) no pasa.
-- 11) no pasa
-- 12) no pasa
-- 13) no pasa
-- 15) no pasa

Nota: la notación es U: OP, significando que el usuario U intenta ejecutar la operación OP.
    Los ‘...’ indican que la operación está incompleta, sin embargo, esto no es
            relevante para la resolución del ejercicio (el objetivo es analizar si el usuario
            en cuestión tiene autorización para efectuar el tipo de operación indicada sobre el
            objeto del base indicado).


1- Suponga que db_instal ejecuta las siguientes sentencias:
GRANT SELECT ON instalacion TO adm WITH GRANT OPTION;
GRANT UPDATE ON instalacion TO adm WITH GRANT OPTION;
GRANT DELETE ON instalacion TO adm;


2- Luego el usuario adm ejecuta las siguientes sentencias:
   GRANT SELECT ON instalacion TO doc;
GRANT UPDATE(cantHoras, tarea) ON instalacion TO doc WITH GRANT OPTION;
GRANT DELETE ON instalacion TO doc;


a) Realice el grafo de permisos correspondiente a las sentencias indicadas en 1 y 2.
 Analice qué sucede en cada caso y si alguna de ellas arroja algún error
b) Establezca los permisos que conserva el usuario doc sobre la tabla
 instalacion, si el usuario db_instal ejecuta las siguientes sentencias (considere la posibilidad de error):
   REVOKE SELECT ON instalacion FROM adm CASCADE;
REVOKE UPDATE(tarea) ON instalacion FROM adm CASCADE;

-- INSTALCION: adm -> select WGO
-- INSTALCION: adm -> UPDATE WGO
-- INSTALCION: adm -> DELETE

-- doc -> select
-- doc -> update cantHoras, tareas WGO
-- doc -> delete

-- se le van todos los permisos al doc de SELECT.
-- a doc le queda update de cantHoras con wgo, y le queda el delete.
-- a adm le queda grant update en instalacion menos de la tarea y el delete.