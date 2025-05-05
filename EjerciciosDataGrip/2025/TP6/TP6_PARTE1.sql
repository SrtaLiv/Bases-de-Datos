-- Ejercicio 1
-- Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
-- el ejercicio 3 del Práctico 5 Parte 2; cuyo script de creación del esquema se encuentra aquí.
-- Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron las de los items
-- C y D; la solución declarativa está aquí

-- C. Cada palabra clave puede aparecer como máximo en 5 artículos.
-- cod_palabra, id_articulo (tabla contiene)

CREATE OR REPLACE FUNCTION fn_max_palabras()
RETURNS Trigger AS $$
DECLARE cant integer;
BEGIN
    SELECT count(p5p2e3_contiene.id_articulo) INTO cant
    FROM unc_46203524.p5p2e3_contiene
    WHERE idioma = new.idioma
    AND cod_palabra = new.cod_palabra;

    IF cant > 4 THEN
        RAISE EXCEPTION 'Ya hay mas de 5 particulos.';
    end if;
    RETURN new;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_palabras
BEFORE INSERT OR UPDATE OF cod_palabra, idioma ON p5p2e3_contiene -- o id_articulo?
FOR EACH ROW
EXECUTE FUNCTION fn_max_palabras();

-----------------------------------------------------------------------------------------------------------------------

-- D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
-- claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
-- artículos que contengan hasta 10 palabras claves.

CREATE OR REPLACE FUNCTION fn_max_autores()
RETURNS TRIGGER AS $$
    declare nac P5P2E3_ARTICULO.NACIONALIDAD%type;
    declare cant integer;
BEGIN
    -- PRIMER INTENTO
    -- ❌ No se pueden usar dos INTO en una sola consulta.
    -- ✅ Debés hacer dos consultas separadas: (GRACIAS CHAT!!)
    --SELECT count(c.id_articulo) INTO cant
    --FROM unc_46203524.p5p2e3_contiene c
    --JOIN unc_46203524.p5p2e3_articulo a
    --ON c.id_articulo = a.id_articulo
    --AND a.nacionalidad INTO autor;

    -- SEGUNDO INTENTO:
    --  🔴 Esto devolverá múltiples filas (una por artículo),
    --  y INTO cant espera una sola fila. Resultado: error en tiempo de ejecución (“more than one row returned”).
    --SELECT count(*) INTO cant
    --FROM unc_46203524.p5p2e3_contiene
    --GROUP BY p5p2e3_contiene.id_articulo;

    --🔴 Esto también puede devolver muchas filas (todos los autores argentinos),
    -- y otra vez falla por la misma razón.
    --SELECT nacionalidad INTO nacionalidad
    --FROM unc_46203524.p5p2e3_articulo
    --WHERE nacionalidad = 'Argentina';

    -- CORRECTO,
    -- ESTO DEVUELVE SOLO UNA FILA PORUQE FILTRAMOS POR EL ARTICULO MISMO, O SEA EL ARTIUCLO QUE SE
    -- ESTA TRATANDO DE INSERTAR

    --NEW es una fila virtual que existe solo dentro del trigger y contiene los datos que
    -- se están intentando insertar (o los nuevos valores en un UPDATE).

    -- Contar cuántas palabras clave tiene el artículo
    SELECT COUNT(*) INTO cant
    FROM unc_46203524.p5p2e3_contiene
    WHERE id_articulo = NEW.id_articulo;

    -- Obtener la nacionalidad del autor del artículo
    SELECT nacionalidad INTO nac
    FROM unc_46203524.p5p2e3_articulo
    WHERE id_articulo = NEW.id_articulo;

    IF (nac <> 'Argentina' AND cant > 9)
     THEN raise exception 'no puede insertar mas de 10 palabras claves';

    ELSIF nac = 'Argentina' and cant > 14
        THEN raise exception 'no puede insertar mas de 15 palabras claves';
    END IF;

RETURN NEW;
end;
    $$
LANGUAGE 'plpgsql';

-- EL TRIGGER SE ACTIVA CUANDO SE INSERTA O ACTUALIZA EL AUTOR
CREATE TRIGGER tr_max_palabras_por_nacionalidad
BEFORE INSERT OR UPDATE OF id_articulo ON unc_46203524.p5p2e3_contiene -- o id_articulo?
FOR EACH ROW EXECUTE PROCEDURE  fn_max_autores();


----------------------------------------------------------------------------------------------------------------

-- Ejercicio 2
-- Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
-- el ejercicio 4 del Práctico 5 Parte 2; cuyo script de creación del esquema se encuentra aquí.
-- Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron las de los items
-- B, C, D, E; la solución declarativa está aquí

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

-- B, B. Cada imagen no debe tener más de 5 procesamientos.
CREATE OR REPLACE FUNCTION fn_max_procesamiento()
RETURNS TRIGGER AS $$
    declare cantProcesamientos int;

    BEGIN
        SELECT count(*) INTO cantProcesamientos
        FROM unc_46203524.p5p2e4_procesamiento
        WHERE  id_imagen = new.id_imagen
        AND id_paciente = NEW.id_paciente;

        IF cantProcesamientos > 4 THEN
            RAISE EXCEPTION 'Más de 5 procesamientos para la imagen % del paciente %', NEW.id_imagen, NEW.id_paciente;
        end if;
        RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_max_procesamiento
BEFORE INSERT OR UPDATE OF id_imagen, id_paciente
ON unc_46203524.p5p2e4_procesamiento
FOR EACH ROW EXECUTE PROCEDURE fn_max_procesamiento();

INSERT INTO unc_46203524.p5p2e4_paciente VALUES (1,'Todesco', 'Olivia', 'asd', now());
INSERT INTO unc_46203524.p5p2e4_imagen_medica VALUES (1,1,'afk', 'afk');
INSERT INTO unc_46203524.p5p2e4_algoritmo VALUES (1,1,'afk', 'afk');

INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 1, 10);
INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 2, 10);
INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 3, 10);
INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 4, 10);
INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 5, 10);
INSERT INTO unc_46203524.p5p2e4_procesamiento VALUES (1, 1, 1, 6, 10);

-- C,
-- Agregue dos atributos de tipo fecha a las tablas Imagen_medica y
-- Procesamiento, una
-- indica la fecha de la imagen y la otra la fecha de procesamiento de la
-- imagen y controle
-- que la segunda no sea menor que la primera.
ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD COLUMN fecha_img date;
ALTER TABLE P5P2E4_PROCESAMIENTO ADD COLUMN fecha_procesamiento_img date;

-- que imagen de procesamiento no sea menor que fecha de imagen
-- lo contrario: que la img_procesamiento sea mayor a fecha_img

-- fecha_img = 04/04/2024
-- fecha_proc_img =   04/03/2024 --> ERROR! la img de proc no debe ser menor a fecha img

CREATE OR REPLACE FUNCTION fn_ctrl_fechas()
RETURNS TRIGGER AS $$
    -- declare fechaAux date;
    BEGIN
       -- SELECT m.fecha_img INTO fechaAux
        -- FROM P5P2E4_IMAGEN_MEDICA m
        -- WHERE id_imagen = new.id_imagen
        -- AND id_paciente = new.id_paciente;

        --IF fechaAux > new.fecha_procesamiento_img

       -- OTRA FORMA:
        IF new.fecha_procesamiento_img <
            (SELECT m.fecha_img
                FROM P5P2E4_IMAGEN_MEDICA m
                WHERE id_imagen = new.id_imagen
                AND id_paciente = new.id_paciente
                )
        THEN RAISE EXCEPTION 'La fecha ingresada de procesamiento %, no debe ser menor a la fecha de la imagen %', new.fecha_procesamiento_img;
        end if;

        RETURN new;
    end;
    $$;

CREATE TRIGGER tr_max_procesamiento
BEFORE INSERT OR UPDATE OF id_imagen, id_paciente, fecha_procesamiento_img
ON unc_46203524.p5p2e4_procesamiento
FOR EACH ROW EXECUTE PROCEDURE fn_ctrl_fechas();

----------------------------------------------------------
-- respuesta catedra
CREATE OR REPLACE FUNCTION FN_FECHA_IMG_PROC()
    RETURNS Trigger AS $$
-- declare  fecha date;
BEGIN
    -- SELECT max(fecha_proc) into fecha
--		 FROM p5p2e4_procesamiento p
--		 WHERE NEW.id_paciente = p.id_paciente AND
--             NEW.id_imagen = p.id_imagen
--  IF ( NEW.fecha_img > fecha)

    IF (NEW.fecha_img >
        (SELECT max(fecha_procesamiento_img)
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
--    IF (NEW.fecha_proc > asi lo puso la catedra pero creo q esta mal
IF (NEW.fecha_proc <
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



-- D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
CREATE OR REPLACE FUNCTION  fn_max_fluoroscopia_anual()
RETURNS TRIGGER AS $$
    DECLARE cant int;
    BEGIN
            SELECT count(*) INTO cant
            FROM P5P2E4_IMAGEN_MEDICA
            WHERE id_paciente = new.id_paciente
            AND modalidad = new.modalidad
            AND EXTRACT(YEAR FROM fecha_img) = EXTRACT(YEAR FROM NEW.fecha_img)

        IF new.modalidad = 'FLUOROSCOPIA' AND cant >= 2 THEN
            RAISE EXCEPTION 'El paciente % ya tene 2 estudios el tipo % en el anio %',
                id_paciente, modalidad, fecha_img;
        END IF;

        RAISE EXCEPTION 'El paciente no puede realizar 2 fluroscopia
        anuales';
    end;
    $$
LANGUAGE plpgsql;


CREATE TRIGGER tr_max_fluoroscopia_anual
BEFORE INSERT OR UPDATE OF modalidad, id_paciente
ON P5P2E4_IMAGEN_MEDICA
FOR EACH ROW EXECUTE PROCEDURE fn_max_fluoroscopia_anual();


-- E; No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA
-- TIPO - GENERAL

-- SE APLICAN ALGORITMOS DE COSTO COMP A IMG FLUOROSCOPIA
CREATE ASSERTION ck_fluoroscopia_algoritmos
CHECK(
       NOT EXISTS(
            SELECT 1
            FROM p5p2e4_algoritmo a
            JOIN P5P2E4_PROCESAMIENTO p
            USING (id_algoritmo)
            JOIN p5p2e4_imagen_medica i
            USING (id_paciente, id_imagen)
            WHERE a.costo_computacional = 'O(n)'
            AND i.modalidad = 'FLUOROSCOPIA'
       )
)

SELECT 1
FROM p5p2e4_algoritmo a
         JOIN P5P2E4_PROCESAMIENTO p
              USING (id_algoritmo)
         JOIN p5p2e4_imagen_medica i
              USING (id_paciente, id_imagen)
WHERE a.nombre_metadata = 'O(n)'
  AND i.modalidad = 'FLUOROSCOPIA'



------------------------------------------------------------------------
-- EJERCICIO 3

-- Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
-- el ejercicio 5 del Práctico 5 Parte 2; cuyo script de creación del esquema se encuentra aquí.
-- Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron B, C, D, E

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

-- B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
-- if es fecha liq y dto es < 0.30 error
CREATE OR REPLACE FUNCTION fn_dtos_liquidacion()
RETURNS TRIGGER AS $$
    -- DECLARE descu int;
    declare es_fecha_liq boolean;
BEGIN
    -- Verificamos si la fecha de la venta coincide con una fecha de liquidación
    SELECT EXISTS (
        SELECT 1
        FROM p5p2e5_fecha_liq
        WHERE extract(DAY FROM NEW.fecha) = dia_liq
        AND EXTRACT(MONTH FROM NEW.fecha) = mes_liq
    ) INTO es_fecha_liq;

    -- Si es fecha de liquidación y el descuento es menor o igual a 0.30, error
    IF es_fecha_liq AND NEW.descuento <= 0.30 THEN
        RAISE EXCEPTION 'El descuento en fecha de liquidación no puede ser menor o igual al 30%%';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- INSERT AFECTA, UPDATE TAMBIEN, DELETE NO
CREATE TRIGGER tr_dtos_liquidacion
BEFORE INSERT OR UPDATE OF descuento, id_venta
ON P5P2E5_VENTA
FOR EACH ROW EXECUTE PROCEDURE fn_dtos_liquidacion();


-- C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
CREATE OR REPLACE FUNCTION fn_cant_dias_liquidacion_por_mes()
RETURNS TRIGGER AS $$
    DECLARE max int;
BEGIN
        -- Solo actua si el mes_liq es JULIO o DICIEMBRE
        IF NEW.mes_liq = 'JULIO' OR NEW.mes_liq = 'DICIEMBRE' THEN
            SELECT COUNT(*)
            INTO max
            FROM p5p2e5_fecha_liq
            WHERE mes_liq = NEW.mes_liq;

            --if new.cant_dias >=5
            IF max >= 5 THEN
                RAISE EXCEPTION 'No se pueden registrar más de 5 días de liquidación para %', NEW.mes_liq;
            END IF;
    end if;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_cant_dias_liquidacion_por_mes
BEFORE INSERT OR UPDATE OF dia_liq, mes_liq ON P5P2E5_FECHA_LIQ
when new.mes_liq = julio ahi se ahorra

FOR EACH ROW EXECUTE PROCEDURE fn_cant_dias_liquidacion_por_mes();

-- D. Las prendas de categoría ‘oferta’ no tienen descuentos.
CREATE OR REPLACE FUNCTION  fn_oferta_sin_descuento()
CREATE OR REPLACE FUNCTION fn_oferta_sin_descuento()
    RETURNS TRIGGER AS $$
DECLARE
    cat TEXT;
BEGIN
    SELECT categoria INTO cat
    FROM p5p2e5_prenda
    WHERE id_prenda = NEW.id_prenda;

    IF cat = 'Oferta' THEN
        RAISE EXCEPTION 'LAS PRENDAS EN OFERTA NO TIENEN DESCUENTO';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_oferta_sin_descuento
BEFORE INSERT OR UPDATE OF id_venta, descuento ON P5P2E5_VENTA
FOR EACH ROW
WHEN ( NEW.descuento > 0 )
EXECUTE PROCEDURE  fn_oferta_sin_descuento();

--CREATE ASSERTION
--SELECT 1
--FROM prenda p
 --        JOIN venta v ON (p.id_prenda = v.id_prenda)
--WHERE p.categoria = 'OFERTA'
-- AND v.descuento > 0;

-- EJERCICIO 4
CREATE TABLE Pelicula AS
SELECT * FROM unc_esq_peliculas.pelicula;

CREATE TABLE estadistica AS
SELECT genero, COUNT(*) total_peliculas, count (distinct idioma) cantidad_idiomas
FROM Pelicula GROUP BY genero;

-- c) Cree un trigger que cada vez que se realice una modificación en la tabla película (la creada
-- en su esquema) tiene que actualizar la tabla estadística.No se olvide de identificar:
-- i) la granularidad del trigger.
-- ii) Eventos ante los cuales se debe disparar.
-- iii) Analice si conviene modificar por cada operación de actualización o reconstruirla de
-- cero.

CREATE OR REPLACE FUNCTION fn_actualizar_estadisticas()
    RETURNS TRIGGER AS $$
BEGIN
    -- Limpiar tabla estadística
    DELETE FROM estadistica;

    -- Volver a cargar los datos actualizados
    INSERT INTO estadistica (genero, total_peliculas, cantidad_idiomas)
    SELECT genero, COUNT(*) AS total_peliculas, COUNT(DISTINCT idioma) AS cantidad_idiomas
    FROM pelicula
    GROUP BY genero;

    RETURN NULL; -- Porque es AFTER STATEMENT
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para los tres eventos
CREATE TRIGGER tr_actualizar_estadisticas
    AFTER INSERT OR UPDATE OR DELETE ON pelicula
    FOR EACH STATEMENT
EXECUTE FUNCTION fn_actualizar_estadisticas();

-- Es más fácil y seguro reconstruirla desde cero cada vez, porque si borrás una película,
-- actualizar una fila específica en estadística sería más complejo.