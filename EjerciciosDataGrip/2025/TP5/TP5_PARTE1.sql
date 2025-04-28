-- **********************************************************************************************
-- EJERCICIO 1
-- a) Cómo debería implementar las Restricciones de Integridad Referencial (RIR) si se desea que
-- cada vez que se elimine un registro de la tabla PALABRA, también se eliminen los artículos
-- que la referencian en la tabla CONTIENE.

ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT fk_p5p1e1_contiene_palabra
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra (idioma, cod_palabra)
ON DELETE CASCADE ;

ALTER TABLE p5p1e1_contiene
DROP CONSTRAINT fk_p5p1e1_contiene_palabra;

INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES
(1, 'ES', 101),  -- artículo 1 contiene "inteligencia"
(1, 'EN', 201),  -- artículo 1 contiene "security"
(2, 'ES', 102),  -- artículo 2 contiene "programación"
(2, 'EN', 202),  -- artículo 2 contiene "web"
(3, 'ES', 103);  -- artículo 3 contiene "seguridad"

INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES
('ES', 101, 'inteligencia'),
('ES', 102, 'programación'),
('ES', 103, 'seguridad'),
('EN', 201, 'security'),
('EN', 202, 'web');

INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES
(1, 'Inteligencia Artificial', 'Olivia'),
(2, 'Programación Web', 'Carlos'),
(3, 'Ciberseguridad Hoy', 'Ana');

-- B)Verifique qué sucede con las palabras contenidas en cada artículo, al eliminar una palabra,
-- si definen la Acción Referencial para las bajas (ON DELETE) de la RIR correspondiente
-- como:
-- ii) Restrict
-- iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON
-- DELETE y ON UPDATE?

ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT fk_p5p1e1_contiene_palabra
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra (idioma, cod_palabra)
ON DELETE RESTRICT ;
--  NO podés eliminar un registro de la tabla p5p1e1_palabra si está siendo usado en p5p1e1_contiene.
--  Solo te va a dejar eliminar un registro de p5p1e1_palabra si ese registro NO está siendo usado en p5p1e1_contiene.

ALTER TABLE p5p1e1_contiene DROP CONSTRAINT fk_p5p1e1_contiene_palabra;

-- **********************************************************************************************
-- EJERCICIO 2 A
-- 2025/CLASES/EMPLEADO_TRABAJA_EN_PROYECTO_AUSPICIO.sql

-- a) Indique el resultado de las siguientes operaciones, teniendo en cuenta las acciones
-- referenciales e instancias dadas. En caso de que la operación no se pueda realizar, indicar qué
-- regla/s entra/n en conflicto y cuál es la causa. En caso de que sea aceptada, comente el
-- resultado que produciría (NOTA: en cada caso considere el efecto sobre la instancia original de
-- la BD, los resultados no son acumulativos).

-- b.1)
delete from tp5_p1_ej2_proyecto where id_proyecto = 3;
-- pasa ya que la tabla proyectos no tiene referencias en ninguna otra tabla

-- b.2)
update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;
-- pasa ya que la tabla proyectos no tiene referencias en ninguna otra tabla

-- b.3)
delete from tp5_p1_ej2_proyecto where id_proyecto = 1;
-- delete en restrict, NO se puede eliminar ya q hay referencia de id_proyecto = 1 en la tabla trabaja en

-- b.4)
delete from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;
-- referencias en empleado -> trabaja_en | empleado -> auspicio
-- en trabaja_en se eliminara la fila ya q es cascade
-- en auspicio las PK de empleado quedaran como NULL

-- b.5)
update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;
-- Se cambia simple, ya q es la tabla referenciada, no la de proyecto.
-- Y aparte existe el id_proyecto = 3, sino existia daba error


-- b.6)
update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;
-- no se puede actualizar porque hay referencias en trabaja_en y el update es RESTRICT


-- EJERCICIO 2 B
-- b) Indique el resultado de la siguiente operaciones justificando su elección:
-- update auspicio set id_proyecto= 66, nro_empleado = 10
-- where id_proyecto = 22
-- and tipo_empleado = &#39;A&#39;
-- and nro_empleado = 5;
-- (suponga que existe la tupla asociada)
-- i. realiza la modificación si existe el proyecto 22 y el empleado TipoE = &#39;A&#39; ,NroE = 5
-- ii. realiza la modificación si existe el proyecto 22 sin importar si existe el empleado TipoE =
-- &#39;A&#39; ,NroE = 5

update unc_46203524.tp5_p1_ej2_auspicio
set id_proyecto= 66, nro_empleado = 10
where id_proyecto = 22
and tipo_empleado = 'A'
and nro_empleado = 5;
-- hola amigos de youtube comio estan?
    

-- I. En auspicio proyecto el update es RESTRICT.
-- en auspicio empleado el update es restrict tambien
-- en verdad, si hacemos la modificacion en la tabla AUSPICIO, pasa ya que puede tener FK que no sean reales
-- ya que esta en match simple por lo cual no afeecta a las tablas "padres"

-- II. Es verdadero


-- EJERCICIO 2 D
-- Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas, según se considere
-- para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO match: i) simple, ii)
-- parcial, o iii) full:

-- a. insert into Auspicio values (1, Dell , B, null);
-- b. insert into Auspicio values (2, Oracle, null, null);
-- c. insert into Auspicio values (3, Google, A, 3);
-- d. insert into Auspicio values (1, HP, null, 3);

-- A) insert into Auspicio values (1, Dell , B, null);
-- AUSPICIO - EMPLEADO
-- SIMPLE: PASA
-- PARCIAL: PASA PQ EXISTE EL TIPO_EMPLEADO B
-- FULL: NO PASA, DEBEN SER LOS 2 NULL O LAS FK TODAS VALIDAS

-- b. insert into Auspicio values (2, Oracle, null, null);
-- AUSPICIO - EMPLEADO
-- SIMPLE: PASA
-- PARCIAL: PASA
-- FULL: PASA

-- c. insert into Auspicio values (3, Google, A, 3);
-- SIMPLE: PASA
-- PARCIAL: NO PASA, NO EXISTE EL NRO EMPLEADO 3
-- FULL: NO PASA, NO EXISTE EL NRO_EMPLEADO 3

-- d. insert into Auspicio values (1, HP, null, 3);
-- SIMPLE: PASA
-- PARCIAL: NO PASA, NO EXISTE EL NRO EMPLEADO 3
-- FULL: NO PASA, NO EXISTE EL NRO_EMPLEADO 3

-- | ************************************************************************* |
-- | *****************************  Ejercicio 3  ***************************** |
-- | ************************************************************************* |
-- SI, estoy al pedo y hago estas decoraciones :D

-- a. Se podrá declarar como acción referencial de la (RIR) FK_RUTA_CIUDAD_DESDE
-- DELETE CASCADE y para la RIR FK_Ruta_ciudad_hasta DELETE RESTRICT ?


-- b. Es posible colocar DELETE SET NULL o UPDATE SET NULL como acción
-- referencial de la RIR FK_RUTA_CARRETERA ?


--a.¿Se puede poner DELETE CASCADE en FK_RUTA_CIUDAD_DESDE y DELETE RESTRICT en FK_RUTA_CIUDAD_HASTA?

--✅ Sí, es posible técnicamente, pero depende de la lógica del negocio que quieras aplicar:
--DELETE CASCADE en FK_RUTA_CIUDAD_DESDE:
-- Si borrás una ciudad origen, automáticamente se borrarían las rutas que tienen esa ciudad como punto de partida.
-- DELETE RESTRICT en FK_RUTA_CIUDAD_HASTA:
-- No te dejaría borrar una ciudad destino si está referenciada en alguna ruta.
-- Conclusión: Es posible configurarlo así. Deberías evaluar si tiene sentido en tu caso de uso.
-- b.¿Se puede poner DELETE SET NULL o UPDATE SET NULL en FK_RUTA_CARRETERA?
-- ⛔ No, no se puede directamente, porque nro_carretera en la tabla RUTA forma parte de la clave primaria (PK).
-- Las claves primarias no pueden contener valores NULL.
-- Conclusión: No podés usar SET NULL en una FK que es parte de la PK. Tendrías que rediseñar si querés permitir eso.