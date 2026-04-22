-- AUTOR
CREATE TABLE AUTOR (
    nro_autor INT PRIMARY KEY,
    nombre_apellido VARCHAR(30)
);

-- TITULO
CREATE TABLE TITULO (
    nro_trabajo INT PRIMARY KEY,
    titulo VARCHAR(60),
    nro_autor INT,
    FOREIGN KEY (nro_autor) REFERENCES AUTOR(nro_autor)
);

-- EDITORIAL
CREATE TABLE EDITORIAL (
    id_editorial INT PRIMARY KEY,
    nombre_editorial VARCHAR(60)
);

-- LIBRO
CREATE TABLE LIBRO (
    nro_trabajo INT,
    nombre_apellido VARCHAR(60),
    id_editorial INT,
    edicion INT,
    encuadernacion INT,
    anio_copyright INT,
    PRIMARY KEY (nro_trabajo, id_editorial),
    FOREIGN KEY (nro_trabajo) REFERENCES TITULO(nro_trabajo),
    FOREIGN KEY (id_editorial) REFERENCES EDITORIAL(id_editorial)
);

-- CONEXION
CREATE TABLE CONEXION (
    id_conexion INT PRIMARY KEY,
    descripcion_cod VARCHAR(60)
);

-- CLIENTE
CREATE TABLE CLIENTE (
    nro_cliente INT PRIMARY KEY,
    nombre VARCHAR(60),
    apellido VARCHAR(60),
    calle VARCHAR(30),
    ciudad VARCHAR(30),
    provincia VARCHAR(30),
    cod_postal INT,
    telefono_contacto VARCHAR(15)
);

-- VOLUMEN (clave compuesta: id_inventario + id_venta + cod_conocimiento)
CREATE TABLE VOLUMEN (
    id_inventario INT,
    fecha_comprar DATE,
    precio_venta DECIMAL(8,2),
    precio_vendido DECIMAL(8,2),
    id_venta INT,
    cod_conocimiento INT,
    ISBN CHAR(17),
    PRIMARY KEY (id_inventario, id_venta, cod_conocimiento),
    FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta)  -- asumiendo que VENTA existe
);

-- VENTA (asumo estructura mínima porque en la imagen solo aparece como nombre)
CREATE TABLE VENTA (
    id_venta INT PRIMARY KEY,
    fecha_venta DATE,
    nro_cliente INT,
    FOREIGN KEY (nro_cliente) REFERENCES CLIENTE(nro_cliente)
);


-- Agregar FK de VOLUMEN a VENTA después de crear VENTA
-- (si ya lo hicimos antes, no es necesario, pero lo pongo por claridad)
-- Ya está arriba.

-- AUTORES
INSERT INTO AUTOR (nro_autor, nombre_apellido) VALUES
(1, 'Gabriel García Márquez'),
(2, 'J.K. Rowling'),
(3, 'George Orwell');

-- TITULOS
INSERT INTO TITULO (nro_trabajo, titulo, nro_autor) VALUES
(101, 'Cien años de soledad', 1),
(102, 'Harry Potter y la piedra filosofal', 2),
(103, '1984', 3);

-- EDITORIALES
INSERT INTO EDITORIAL (id_editorial, nombre_editorial) VALUES
(10, 'Sudamericana'),
(20, 'Salamandra'),
(30, 'Debolsillo');

-- LIBROS
INSERT INTO LIBRO (nro_trabajo, nombre_apellido, id_editorial, edicion, encuadernacion, anio_copyright) VALUES
(101, 'Gabriel García Márquez', 10, 1, 1, 1967),
(102, 'J.K. Rowling', 20, 1, 1, 1997),
(103, 'George Orwell', 30, 3, 2, 1949);

-- CLIENTES
INSERT INTO CLIENTE (nro_cliente, nombre, apellido, calle, ciudad, provincia, cod_postal, telefono_contacto) VALUES
(501, 'Carlos', 'Pérez', 'Av. Siempre Viva 123', 'Córdoba', 'Córdoba', 5000, '3511234567'),
(502, 'Ana', 'Gómez', 'San Martín 456', 'Rosario', 'Santa Fe', 2000, '3419876543');

-- VENTAS
INSERT INTO VENTA (id_venta, fecha_venta, nro_cliente) VALUES
(9001, '2025-01-15', 501),
(9002, '2025-02-20', 502);

-- VOLUMENES
INSERT INTO VOLUMEN (id_inventario, fecha_comprar, precio_venta, precio_vendido, id_venta, cod_conocimiento, ISBN) VALUES
(10001, '2024-12-01', 25000.00, 25000.00, 9001, 1, '978-84-376-0494-7'),
(10002, '2024-12-10', 32000.00, 30000.00, 9002, 2, '978-84-9838-737-5');

-- CONEXION (si es independiente)
INSERT INTO CONEXION (id_conexion, descripcion_cod) VALUES
(1, 'Conexión estándar'),
(2, 'Conexión premium');

SELECT c.nro_cliente, c.nombre, c.apellido, count(DISTINCT t.nro_autor) as
cantidad_autores_distintos
FROM CLIENTE c
JOIN VENTA V on c.nro_cliente = V.nro_cliente
JOIN VOLUMEN vol on V.id_venta = vol.id_venta
JOIN LIBRO i ON v.id_venta = vol.id_venta
JOIN TITULO T on i.nro_trabajo = T.nro_trabajo
GROUP BY c.nro_cliente, c.nombre, c.apellido
HAVING count(distinct t.nro_autor) >= 3
ORDER BY c.nro_cliente;

--obtener los clientes que han realizado compras de libros de al menos 3
-- autores distins

-- 2) utilizando el esuqema de las librerias
-- cree una vista denominada vista_libros_cuero que contenga los datos
--solo de los libros encuadernados en cuero, incluya el ISBN, titulo, id_editorial
--edicion, anio_copyright
--b la vista creada anteriormente, podria haber sido actuablizable?

CREATE VIEW vista_libros_cuero AS
    SELECT vl.ISBN, t.titulo, vl.id_editorial, vl.edicion, vl.anio_copyright
    FROM LIBRO vl
    WHERE vl.encuadernacion ILIKE '%CUERO%'
    AND nro_trabajo IN (
        SELECT nro_trabajo
        FROM TITULO t
        where vl.nro_trabajo = t.nro_trabajo
        )

CREATE VIEW vista_libros_cuero AS
    SELECT vl.ISBN, t.titulo, vl.id_editorial, vl.edicion, vl.anio_copyright
    FROM LIBRO vl
    jOIN TITULO t oN vl.nro_trabajo = t.nro_trabajo
    WHERE vl.encuadernacion ILIKE '%CUERO%'

-- No es una vista actualizable, ya que se basa en los datos de 2 tablas.

--- incorpore los sigueintes contorles en sql estandar mediante recurso mas restrictivo
--1) para cada libro en stock (Tabla Volumen) si el id de venta es distinto de
-- nulo el precio vendido tambien debe ser distinto de nulo

-- lo que no quiero que pase es que si el id de venta is null Y
-- el precio_vendido is null
alter tabla volumen add constraint ck_ej1 CHECK(
                   (v.id_venta IS NULL AND
                 v.precio_vendido IS NULL)
                OR (v.id_venta iS NOT NULL or precio_vendido IS NULL)
)

-- id_venta IS NOT NULL AND preico_vendido IS NOT NULL - PASA
-- id_venta IS NULL AND preico_vendido IS NULL - NO PUEDE PASAR

-- id_venta IS NOT NULL AND preico_vendido IS NULL - NO PUEDE PASAR
-- id_venta IS NULL AND preico_vendido IS NOT NULL - NO PUEDE PASAR


--controlar que no haya mas de 10 volumenes nuevos (condicion del libro igual a 1)
--para cada libro en stock (registros en la tabla volumen)

      alter table volumen add constraint ck_ej2 check (
          not exists(
          SELECT 1
FROM VOLUMEN
WHERE cod_condicion = 1
GROUP v.isbn
HAVING COUNT(*) > 10)
          )

--4) Escriba los triggers completos necesarios de aquellos chequos que no
-- pueden ser soportados por PostgreSQL de manera declarativa

CREATE OR REPLACE FUNCTION fn_check()
RETURNS TRIGGER AS $$
BEGIN
    if (select count(*)
        FROM VOLUMEN v
        WHERE v.isbn = new.isbdn
        AND v.cod_condicion ? 1) > 10
    then raise exception 'no puede';
    end if;
    return new;
end;
    $$;

CREATE TRIGGER tr_check
BEFORE INSERT OR UPDATE ON VOLUMEN
FOR EACH ROW
EXECUTE FUNCTION fn_check();

--5) Se desea crear una tabla denominada VENTAS_DIARIAS con el moonto total
--vendido y la cantidad de libros vendidos diariamente

CREATE TABLE VENTAS_DIARIAS (
    monto_total_vendido int,
    cantidad_libros_vendidos_diariamente int
);

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_CANT_PROD()
RETURNS Trigger AS $$
    BEGIN
        UPDATE VENTAS_DIARIAS
        SET monto_total_vendido = (
            select sum(vol.precio_vendido)
            from venta
            join volumen vol on venta.id_venta = vol.id_venta
            where v.fecha_venta = current_date --mismo dia mes y año de hoy
            ),
        cantidad_libros_vendidos_diariamente = (
                select count(VOLUMEN.ISBN)
                from volumen
                join venta using (id_venta)
                where v.fecha_venta = current_date --mismo dia mes y año de hoy
            );
    end;
$$ language 'plpgsql';

create trigger tr_actualizar
AFTER INSERT OR UPDATE OR DELETE ON VOLUMEN
    FOR EACH ROW
    EXECUTE FUNCTION FN_ACTUALIZAR_CANT_PROD();

--pregunta6

-- que sucede si una vista con WITH CHECK OPTION incluye otra vista
--con su propia clausula WITH CHECK OPTION?


-- OPC 3: Se aplican las restricciones de ambas vistas, garantizando
-- que las operaciones cumplan todos los cliterios

-- Cuando es util utilzar la accion ON DELETE SET DEFAULT en una FK?

-- LA 2) Cuando se desea que el valor de la clave foranea en la tabla
-- refenciante cambie  a un valor predeterminado al eliminarse
-- el registro en la tbala refeenciada

-- Que diferencia tiene un control declarativo sobre un trigger?
-- 1