


/*PARTE 2*/
--Ejercicio 1 A. No puede haber voluntarios de más de 70 años.
ALTER TABLE esq_voluntarios_voluntario
ADD CONSTRAINT a_voluntario
CHECK (age(fecha_nacimiento) < 70);

--B. Ningún voluntario puede aportar más horas que las de su coordinador.
ALTER TABLE esq_voluntarios_voluntario
ADD CONSTRAINT b_voluntario
CHECK (NOT EXISTS
    (SELECT horas_aportadas, nro_voluntario
    FROM esq_voluntarios_voluntario v1
    WHERE nro_voluntario IN (
        SELECT id_coordinador
        FROM esq_voluntarios_voluntario v2
        WHERE v1.horas_aportadas > v2.horas_aportadas
)));

--C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y mínimos consignados en la tarea.
CREATE ASSERTION c_voluntario
CHECK (NOT EXISTS(
    SELECT horas_aportadas
    FROM esq_voluntarios_voluntario v1
    INNER JOIN esq_voluntarios_tarea t
    ON (v1.id_tarea= t.id_tarea)
    WHERE (horas_aportads NOT BETWEEN t.min_horas AND t.max_horas)
))

--D. Todos los voluntarios deben realizar la misma tarea que su coordinador.
ALTER TABLE esq_voluntarios_voluntario
ADD CONSTRAINT d_voluntario
CHECK (NOT EXISTS (
    SELECT id_tarea
    FROM esq_voluntarios_voluntario v1
    INNER JOIN esq_voluntarios_voluntario v2
    ON (v1.nro_voluntario = v2.id_coordinador)
    WHERE v1.id_tarea <> v2.id_tarea)
);

--E. Los voluntarios no pueden cambiar de institución más de tres veces en el año.
ALTER TABLE esq_voluntarios_historico
ADD CONSTRAINT e_historico
CHECK (NOT EXISTS(
    SELECT 1
    FROM esq_voluntarios_historico
    WHERE extract(YEAR FROM (fecha_fin)) = EXTRACT (YEAR FROM (CURRENT_DATE))
    GROUP BY nro_voluntario
    HAVING COUNT(DISTINCT id_institucion)> 3))

--F. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.
ALTER TABLE esq_voluntarios_historico
ADD CONSTRAINT f_historico
CHECK (fecha_inicio < fecha_fin);

/* EJERCICIO 2 */

-- A. Para cada tarea el sueldo máximo debe ser mayor que el sueldo mínimo.
ALTER TABLE esq_peliculas_tarea
ADD CONSTRAINT a_pelicula
CHECK (sueldo_maximo > sueldo_minimo);

-- B. No puede haber más de 70 empleados en cada departamento.

ALTER TABLE esq_peliculas_empleado
ADD CONSTRAINT b_pelicula
CHECK ( NOT EXISTS (
    SELECT 1
    FROM esq_peliculas_empleado
    GROUP BY id_departamento, id_empleado
    HAVING count(id_empleado)>70
))

--C. Los empleados deben tener jefes que pertenezcan al mismo departamento.
ALTER TABLE pelicula
ADD CONSTRAINT c_pelicula
CHECK (NOT EXISTS (
    SELECT 1
    FROM empleado e
    INNER JOIN empleado e2
    ON(e.id_empleado= e2.id_jefe)
    WHERE e.id_departamento <> e2.id_departamento
))

--D. Todas las entregas, tienen que ser de películas de un mismo idioma.
CREATE ASSERTION d_pelicula
CHECK (NOT EXISTS (
    SELECT 1
    FROM pelicula p
    INNER JOIN renglon_entrega re
    ON (p.codigo_pelicula  = re.codigo_pelicula)
    GROUP  BY re.nro_entrega
    HAVING count(DISTINCT p.idioma) > 1
))

--E. No pueden haber más de 10 empresas productoras por ciudad.
 ALTER TABLE pelicula
 ADD CONSTRAINT  e_pelicula
 CHECK ( NOT EXISTS(
     SELECT 1
     FROM empresa_productora e
     GROUP BY id_ciudad
     HAVING count (codigo_productora) > 10
 ) )

--F. Para cada película, si el formato es 8mm, el idioma tiene que ser francés.
ALTER TABLE pelicula
ADD CONSTRAINT f_pelicula
CHECK (( formato='Formato 8' AND idioma= 'Francés')
    OR (formato <> 'Formato 8'));

--G. El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su distribuidor mayorista.
CREATE ASSERTION g_pelicula
CHECK( NOT EXISTS(
    SELECT 1
    FROM  nacional n
    INNER JOIN distribuidor d1
    ON (d1.id_distribuidor= n.id_distribuidor)
    INNER JOIN distribuidor d2
    ON (d2.id_distribuidor=n.id_distrib_mayorista)
    WHERE SUBSTRING(d1.telefono, 1,3) <> SUBSTRING (d2.telefono, 1,3)
    --OTRA FORMA DE HACERLO---> left(d.telefono,3) = left(m.telefono,3)
))

--EJERCICIO 3
ALTER TABLE p5p1e1_articulo
ADD COLUMN fecha_publicacion DATE;

UPDATE p5p1e1_articulo SET fecha_publicacion= '2023-05-30' WHERE id_articulo=23;

ALTER TABLE p5p1e1_articulo
ALTER COLUMN fecha_publicacion SET NOT NULL;

ALTER TABLE p5p1e1_articulo
ADD COLUMN nacionalidad varchar(20);

UPDATE p5p1e1_articulo SET nacionalidad= ' IN' WHERE id_articulo=23;

--A. Controlar que las nacionalidades sean Argentina, Español, Inglés, Alemán o Chilena.
ALTER TABLE P5P1E1_ARTICULO
ADD CONSTRAINT a_articulo
CHECK (nacionalidad= 'AR' OR nacionalidad='ES' OR nacionalidad = ' IN' OR nacionalidad = ' AL' OR nacionalidad = 'CH');

SELECT *
FROM p5p1e1_articulo;

--B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
ALTER TABLE P5P1E1_ARTICULO
ADD CONSTRAINT  b_articulo
CHECK ( (extract(year FROM fecha_publicacion)) >= 2010);

--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT c_contiene
CHECK ( NOT EXISTS(
    SELECT 1
    FROM p5p1e1_contiene
    GROUP BY cod_palabra, idioma
    HAVING count(*) > 5
));

/*D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
artículos que contengan hasta 10 palabras claves.*/
CREATE ASSERTION d_contiene_articulo
CHECK ( NOT EXISTS (
        SELECT 1
    FROM p5p1e1_articulo a
    INNER JOIN p5p1e1_contiene c
    ON (a.id_articulo= c.id_articulo)
    WHERE (a.nacionalidad= 'AR')
    GROUP BY a.id_articulo
    HAVING (count(c.cod_palabra) >= 15) )

    OR (
    SELECT 1
    FROM p5p1e1_articulo a
    INNER JOIN p5p1e1_contiene c
    ON (a.id_articulo= c.id_articulo)
    WHERE (a.nacionalidad <> 'AR'
    GROUP BY a.id_articulo
    HAVING (count(c.cod_palabra) > 10)
    )

));







--EJERCICIO 4

    -- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 21:22:26.905

-- tables
-- Table: P5P2E4_ALGORITMO
CREATE TABLE P5P2E4_ALGORITMO (
    id_algoritmo int  NOT NULL,
    nombre_metadata varchar(40)  NOT NULL,
    descripcion varchar(256)  NOT NULL,
    costo_computacional varchar(15)  NOT NULL,
    CONSTRAINT PK_P5P2E4_ALGORITMO PRIMARY KEY (id_algoritmo)
);

-- Table: P5P2E4_IMAGEN_MEDICA
CREATE TABLE P5P2E4_IMAGEN_MEDICA (
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    modalidad varchar(80)  NOT NULL,
    descripcion varchar(180)  NOT NULL,
    descripcion_breve varchar(80)  NULL,
    CONSTRAINT PK_P5P2E4_IMAGEN_MEDICA PRIMARY KEY (id_paciente,id_imagen)
);

-- Table: P5P2E4_PACIENTE
CREATE TABLE P5P2E4_PACIENTE (
    id_paciente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    domicilio varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    CONSTRAINT PK_P5P2E4_PACIENTE PRIMARY KEY (id_paciente)
);

-- Table: P5P2E4_PROCESAMIENTO
CREATE TABLE P5P2E4_PROCESAMIENTO (
    id_algoritmo int  NOT NULL,
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    nro_secuencia int  NOT NULL,
    parametro decimal(15,3)  NOT NULL,
    CONSTRAINT PK_P5P2E4_PROCESAMIENTO PRIMARY KEY (id_algoritmo,id_paciente,id_imagen,nro_secuencia)
);

-- foreign keys
-- Reference: FK_P5P2E4_IMAGEN_MEDICA_PACIENTE (table: P5P2E4_IMAGEN_MEDICA)
ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD CONSTRAINT FK_P5P2E4_IMAGEN_MEDICA_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES P5P2E4_PACIENTE (id_paciente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_ALGORITMO (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_ALGORITMO
    FOREIGN KEY (id_algoritmo)
    REFERENCES P5P2E4_ALGORITMO (id_algoritmo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA
    FOREIGN KEY (id_paciente, id_imagen)
    REFERENCES P5P2E4_IMAGEN_MEDICA (id_paciente, id_imagen)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

/*A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA
CONVENCIONAL, FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON
FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,*/
ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD CONSTRAINT a_imagen_medica
CHECK (modalidad IN  ('RADIOLOGIA CONVENCIONAL', 'FLUOROSCOPIA', 'ESTUDIOS RADIOGRAFICOS CON
FLUOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFIA'));

/*B. Cada imagen no debe tener más de 5 procesamientos.*/

ALTER TABLE P5P2E4_PROCESAMIENTO
ADD CONSTRAINT b_procedimiento
CHECK ( NOT EXISTS(
    SELECT 1
    FROM P5P2E4_PROCESAMIENTO
    GROUP BY id_imagen
    HAVING count(nro_secuencia) > 5
) )

/* C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
que la segunda no sea menor que la primera. */

ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD COLUMN fecha_imagen DATE;

ALTER TABLE P5P2E4_PROCESAMIENTO
ADD COLUMN fecha_procesamiento DATE;

CREATE ASSERTION c_img_procedimiento
CHECK ( NOT EXISTS (
    SELECT 1
    FROM p5p2e4_imagen_medica i
    INNER JOIN P5P2E4_PROCESAMIENTO p
    ON i.id_imagen = p.id_imagen AND i.id_paciente = p.id_paciente
    WHERE p.fecha_procesamiento < i.fecha_imagen
));


-- D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.

ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD CONSTRAINT d_imagen_medica
CHECK ( NOT EXISTS(
        SELECT 1
        FROM P5P2E4_IMAGEN_MEDICA i
        WHERE i.modalidad = 'FLUOROSCOPIA'
        GROUP BY i.id_paciente, extract(year from i.fecha_imagen)
        HAVING (COUNT(*) > 2)
));

/* E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de
FLUOROSCOPIA */

CREATE ASSERTION e_algoritmo_img
CHECK ( NOT EXISTS (
    SELECT 1
    FROM P5P2E4_ALGORITMO a
    INNER JOIN P5P2E4_PROCESAMIENTO p ON p.id_algoritmo = a.id_algoritmo
    INNER JOIN P5P2E4_IMAGEN_MEDICA i ON p.id_paciente = i.id_paciente
    AND p.id_imagen = i.id_imagen
    WHERE a.costo_computacional = 'O(n)' AND (i.modalidad = 'FLUOROSCOPIA')
))




/* EJERCICIO 5 */

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

-- tables
-- Table: P5P2E5_CLIENTE
CREATE TABLE P5P2E5_CLIENTE (
    id_cliente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    estado char(5)  NOT NULL,
    CONSTRAINT PK_P5P2E5_CLIENTE PRIMARY KEY (id_cliente)
);

-- Table: P5P2E5_FECHA_LIQ
CREATE TABLE P5P2E5_FECHA_LIQ (
    dia_liq int  NOT NULL,
    mes_liq int  NOT NULL,
    cant_dias int  NOT NULL,
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq,mes_liq)
);

-- Table: P5P2E5_PRENDA
CREATE TABLE P5P2E5_PRENDA (
    id_prenda int  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    tipo varchar(40)  NOT NULL,
    categoria varchar(80)  NOT NULL,
    CONSTRAINT PK_P5P2E5_PRENDA PRIMARY KEY (id_prenda)
);

-- Table: P5P2E5_VENTA
CREATE TABLE P5P2E5_VENTA (
    id_venta int  NOT NULL,
    descuento decimal(10,2)  NOT NULL,
    fecha timestamp  NOT NULL,
    id_prenda int  NOT NULL,
    id_cliente int  NOT NULL,
    CONSTRAINT PK_P5P2E5_VENTA PRIMARY KEY (id_venta)
);

-- foreign keys
-- Reference: FK_P5P2E5_VENTA_CLIENTE (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES P5P2E5_CLIENTE (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E5_VENTA_PRENDA (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_PRENDA
    FOREIGN KEY (id_prenda)
    REFERENCES P5P2E5_PRENDA (id_prenda)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

--A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.

ALTER TABLE P5P2E5_VENTA
ADD CONSTRAINT a_venta
CHECK (descuento between 0 and 100)

-- B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
CREATE ASSERTION b_venta
CHECK ( NOT EXISTS (
    SELECT 1
    FROM P5P2E5_VENTA v, P5P2E5_FECHA_LIQ l
    WHERE (extract(day from v.fecha) = l.dia_liq)
    OR (extract(month from v.fecha) = l.mes_liq)
    AND descuento < 30
));

-- C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
ALTER TABLE P5P2E5_FECHA_LIQ
ADD CONSTRAINT c_fecha_liq
CHECK ( NOT EXISTS(
    SELECT 1
    FROM P5P2E5_FECHA_LIQ
    WHERE (mes_liq IN (07, 12)) AND cant_dias > 5
) )

-- D. Las prendas de categoría ‘oferta’ no tienen descuentos.

CREATE ASSERTION d_prenda_venta
CHECK ( NOT EXISTS (
    SELECT 1
    FROM P5P2E5_PRENDA P
    INNER JOIN P5P2E5_VENTA V on P.id_prenda = V.id_prenda
    WHERE (P.categoria = 'Oferta' AND v.descuento IS NOT NULL)
    OR (P.categoria <> 'Oferta')
))
