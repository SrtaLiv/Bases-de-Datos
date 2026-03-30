-- esquema
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-06-01 17:51:47.998

-- tables
-- Table: CATEGORIA
CREATE TABLE CATEGORIA (
                           id_tipo_cat int  NOT NULL,
                           id_categoria int  NOT NULL,
                           nombre varchar(100)  NOT NULL,
                           descripcion text  NULL,
                           CONSTRAINT Categorias_pk PRIMARY KEY (id_categoria,id_tipo_cat)
);

-- Table: CLIENTE
CREATE TABLE CLIENTE (
                         id_cliente int  NOT NULL,
                         nombre varchar(100)  NOT NULL,
                         apellido varchar(100)  NOT NULL,
                         email varchar(100)  NOT NULL,
                         telefono varchar(20)  NULL,
                         CONSTRAINT Clientes_pk PRIMARY KEY (id_cliente)
);

-- Table: DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
                                id_producto int  NOT NULL,
                                id_pedido int  NOT NULL,
                                cantidad int  NOT NULL,
                                precio_unitario decimal(10,2)  NOT NULL,
                                CONSTRAINT DetallePedido_pk PRIMARY KEY (id_producto,id_pedido)
);

-- Table: DIRECCION_ENTREGA
CREATE TABLE DIRECCION_ENTREGA (
                                   id_direccion int  NOT NULL,
                                   cliente_id int  NOT NULL,
                                   direccion varchar(255)  NULL,
                                   ciudad varchar(100)  NULL,
                                   cp varchar(10)  NULL,
                                   CONSTRAINT DireccionesEntrega_pk PRIMARY KEY (id_direccion)
);

-- Table: HISTORIAL_CAMBIO_ESTADO
CREATE TABLE HISTORIAL_CAMBIO_ESTADO (
                                         id_historial int  NOT NULL,
                                         pedido_id int  NOT NULL,
                                         fecha date  NOT NULL,
                                         estado_anterior varchar(50)  NOT NULL,
                                         estado_nuevo varchar(50)  NOT NULL,
                                         CONSTRAINT HistorialCambiosEstado_pk PRIMARY KEY (id_historial)
);

-- Table: PEDIDO
CREATE TABLE PEDIDO (
                        id_pedido int  NOT NULL,
                        fecha date  NOT NULL,
                        estado varchar(50)  NOT NULL,
                        id_direccion int  NOT NULL,
                        CONSTRAINT Pedidos_pk PRIMARY KEY (id_pedido)
);

-- Table: PRODUCTO
CREATE TABLE PRODUCTO (
                          id_producto int  NOT NULL,
                          nombre varchar(100)  NOT NULL,
                          precio decimal(10,2)  NOT NULL,
                          stock int  NOT NULL,
                          id_proveedor int  NOT NULL,
                          id_tipo_cat int  NULL,
                          id_categoria int  NULL,
                          CONSTRAINT Productos_pk PRIMARY KEY (id_producto)
);

-- Table: PROVEEDOR
CREATE TABLE PROVEEDOR (
                           id_proveedor int  NOT NULL,
                           nombre varchar(100)  NOT NULL,
                           email varchar(100)  NOT NULL,
                           telefono varchar(20)  NOT NULL,
                           CONSTRAINT Proveedores_pk PRIMARY KEY (id_proveedor)
);

-- Table: TIPO_CATEGORIA
CREATE TABLE TIPO_CATEGORIA (
                                id_tipo_cat int  NOT NULL,
                                nombre_tipo_cat varchar(120)  NOT NULL,
                                CONSTRAINT TIPO_CATEGORIA_pk PRIMARY KEY (id_tipo_cat)
);

-- foreign keys
-- Reference: CATEGORIA_TIPO_CATEGORIA (table: CATEGORIA)
ALTER TABLE CATEGORIA ADD CONSTRAINT CATEGORIA_TIPO_CATEGORIA
    FOREIGN KEY (id_tipo_cat)
        REFERENCES TIPO_CATEGORIA (id_tipo_cat)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: DetallePedido_Pedidos (table: DETALLE_PEDIDO)
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT DetallePedido_Pedidos
    FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: DetallePedido_Productos (table: DETALLE_PEDIDO)
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT DetallePedido_Productos
    FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO (id_producto)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_1
    FOREIGN KEY (id_proveedor)
        REFERENCES PROVEEDOR (id_proveedor)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: DIRECCION_ENTREGA)
ALTER TABLE DIRECCION_ENTREGA ADD CONSTRAINT FK_5
    FOREIGN KEY (cliente_id)
        REFERENCES CLIENTE (id_cliente)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_6 (table: HISTORIAL_CAMBIO_ESTADO)
ALTER TABLE HISTORIAL_CAMBIO_ESTADO ADD CONSTRAINT FK_6
    FOREIGN KEY (pedido_id)
        REFERENCES PEDIDO (id_pedido)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: PEDIDO_DIRECCION_ENTREGA (table: PEDIDO)
ALTER TABLE PEDIDO ADD CONSTRAINT PEDIDO_DIRECCION_ENTREGA
    FOREIGN KEY (id_direccion)
        REFERENCES DIRECCION_ENTREGA (id_direccion)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: PRODUCTO_CATEGORIA (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT PRODUCTO_CATEGORIA
    FOREIGN KEY (id_categoria, id_tipo_cat)
        REFERENCES CATEGORIA (id_categoria, id_tipo_cat)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.

--Verificar que cada pedido sólo incluya un producto sin categoría.
-- tablas: detalle_pedido: cantidad, id_producto, id_pedidio
-- prodcuto:id_categoria = null
--
CREATE ASSERTION ck_productos_sin_categoria_x_pedido CHECK(
       NOT EXISTS(
            SELECT 1 FROM
            DETALLE_PEDIDO dp
            JOIN PRODUCTO p
            USING (id_producto)
            WHERE id_categoria IS NULL
            GROUP BY dp.id_pedido
            HAVING COUNT(*) > 1
       )
)


--La fecha en el historial de cambios debe ser posterior o igual a la del pedido
--tabla: historial_cambio_estado: id_historial, fecha, pedido_id
--tabla: pedido: id_pedido, fecha

CREATE ASSERTION ck_fecha CHECK (
       NOT EXISTS(
        SELECT 1
        FROM PEDIDO p
        JOIN HISTORIAL_CAMBIO_ESTADO h
        ON p.id_pedido = h.pedido_id
        WHERE h.fecha <= p.fecha
       )
)


--2.a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
       -- actualizable en PostgreSQL, siempre que sea posible:

---  V1: que contenga todos los datos de los pedidos cuyo monto total sea mayor a $100.00
CREATE VIEW V1 AS (
SELECT *
FROM PEDIDO p
WHERE EXISTS(
    SELECT 1
    FROM DETALLE_PEDIDO d
    group by p.id_pedido = d.id_pedido
    HAVING SUM (precio_unitario * cantidad) > 100000
)
)

--Respuesta correcta Las respuestas correctas son:
-- Contiene todos los datos de los pedidos cuyo monto total sea mayor a $100.000,
-- Está correctamente correlacionada la consulta con la subconsulta,
-- Filtra correctamente los pedidos cuyo monto total es mayor a $100.000,
-- Es automáticamente actualizable en PostgreSQ


--- V2: Que liste todos los productos indicando el nombre, precio, stock, el nombre de su categoría y el nombre de
-- su tipo categoría. Debe incluir los productos sin categoría
CREATE VIEW V2 AS
(
SELECT p.nombre, p.precio, p.stock, p.nombre, c.nombre, t.nombre_tipo_cat
FROM PRODUCTO p
         LEFT JOIN CATEGORIA c
                   USING (id_categoria, id_tipo_cat)
         LEFT JOIN TIPO_CATEGORIA t
                   USING (id_tipo_cat)
    )

-------------

-- --3) Para el
--     esquema dado, se ha creado la tabla productos_cliente donde se requiere registrar la siguiente
-- información para todos los clientes que están registrados en la base:
-- id_cliente, nombre, apellido, email, cantidad_productos, fecha_ultimo_pedido
-- donde, para cada cliente:
-- - cantidad_productos corresponde a la cantidad de productos pedidos.
-- - fecha_ultimo_pedido es la fecha correspondiente al último pedido.

-- Nota -- : en caso que un cliente no registre pedidos, se deberá indicar apropiadamente.

-- a)
-- Implemente el método más adecuado en PostgreSQL que permita completar dicha tabla con la información
-- de todos los clientes a partir de los datos existentes en la base. Explique su solución e incluya
-- la sentencia que debería utilizar un usuario para la ejecución del mismo.

-- Nota: no puede utilizar sentencias de bucle (for, loop, etc.) para resolverlo.

-- hay un ejerciciio muy parecido en el tp 6.2 ej 2 c

CREATE TABLE productos_cliente (
                                   id_cliente            INT           NOT NULL,
                                   nombre                VARCHAR(100)  NOT NULL,
                                   apellido              VARCHAR(100)  NOT NULL,
                                   email                 VARCHAR(100)  NOT NULL,
                                   cantidad_productos    INT,
                                   fecha_ultimo_pedido   DATE,
                                   CONSTRAINT productos_cliente_pk PRIMARY KEY (id_cliente)
);

CREATE OR REPLACE PROCEDURE sp_cargar_productos_cliente()
    LANGUAGE SQL
AS $$
    -- Limpiamos la tabla antes de cargar para evitar duplicados
TRUNCATE TABLE productos_cliente;

INSERT INTO productos_cliente (
    id_cliente,
    nombre,
    apellido,
    email,
    cantidad_productos,
    fecha_ultimo_pedido
)
SELECT
    c.id_cliente,
    c.nombre,
    c.apellido,
    c.email,
    SUM(dp.cantidad)            AS cantidad_productos, -- sumara todos los pedidos, la cantidad dedetalle pedido
    MAX(p.fecha)                AS fecha_ultimo_pedido --agarra la más reciente → ej

-- 10/06/2024 que es su último pedido
FROM CLIENTE c
         -- LEFT JOIN para incluir clientes SIN pedidos
         LEFT JOIN DIRECCION_ENTREGA de  ON de.cliente_id   = c.id_cliente
         LEFT JOIN PEDIDO p              ON p.id_direccion  = de.id_direccion
         LEFT JOIN DETALLE_PEDIDO dp     ON dp.id_pedido    = p.id_pedido
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido,
    c.email;
$$;

CALL sp_cargar_productos_cliente();

--3.b) Indique y justifique todos los eventos críticos necesarios para mantener los datos actualizados en la tabla
-- productos_cliente  cuando se produzcan actualizaciones en la base. Incluya la declaración de los triggers
-- correspondientes en PostgreSQL y escriba la implementación de la/s función/es requerida/s para operaciones
-- de insert.



CREATE OR REPLACE FUNCTION fn_actualizar_productos_cliente()
RETURNS TRIGGER AS $$
begin
    CALL sp_cargar_productos_cliente();
    RETURN NULL;
end;
$$;

CREATE TRIGGER tr_cliente
    AFTER INSERT OR UPDATE OR DELETE
    ON CLIENTE
    FOR EACH STATEMENT
EXECUTE FUNCTION fn_actualizar_productos_cliente();

CREATE TRIGGER tr_eventos_entrega
    BEFORE INSERT OR UPDATE  ON DIRECCION_ENTREGA
    FOR EACH ROW EXECUTE PROCEDURE  fn_actualizar_productos_cliente();

CREATE TRIGGER tr_eventos_pedido
    BEFORE INSERT OR UPDATE  ON PEDIDO
    FOR EACH ROW EXECUTE PROCEDURE  fn_actualizar_productos_cliente();

CREATE TRIGGER tr_detalle_pedido
    BEFORE INSERT OR UPDATE  ON PEDIDO
    FOR EACH ROW EXECUTE PROCEDURE  fn_actualizar_productos_cliente();