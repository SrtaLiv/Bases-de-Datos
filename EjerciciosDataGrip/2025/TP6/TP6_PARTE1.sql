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
--
-- D
--
-- E;