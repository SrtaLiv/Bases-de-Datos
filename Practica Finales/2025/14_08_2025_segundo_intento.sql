
CREATE TABLE productos_cliente (
                                   id_cliente int  NOT NULL,
                                   nombre varchar(120)  NOT NULL,
                                   apellido varchar(120)  NOT NULL,
                                   email varchar(120)  NOT NULL,
                                   cantidad_productos varchar(120)  NOT NULL DEFAULT 0, -- cantidad_productos corresponde a la cant de productos pedidos.
                                   fecha_ultimo_pedido varchar(120)  NOT NULL DEFAULT 0 --es la fecha correspondiente al último pedido
);

-- Nota en caso que un cliente no registre pedidos, se deberá indicar apropiadamente. NO ENTIENDO ESTE
CREATE OR REPLACE PROCEDURE llenar_db()
AS $$
BEGIN
    INSERT INTO productos_cliente(
        id_cliente, nombre, apellido, email, cantidad_productos, fecha_ultimo_pedido
    )SELECT c.id_cliente, c.nombre, c.apellido, c.email,
            count(DP.id_producto) AS cantidad_productos, max(p.fecha) as fecha_ultimo_pedido
    FROM CLIENTE c
             JOIN DIRECCION_ENTREGA dr on dr.cliente_id = c.id_cliente
             JOIN PEDIDO P on dr.id_direccion = P.id_direccion
             JOIN DETALLE_PEDIDO JOIN DETALLE_PEDIDO DP on P.id_pedido = DP.id_pedido
    group by c.id_cliente;
END;
$$ language 'plpgsql';

CALL llenar_db();


CREATE FUNCTION fn_clientes_registrados() RETURNS TRIGGER AS $$
BEGIN
    IF (tg_op = 'INSERT' AND (NEW.CLIENT)) THEN
        INSERT INTO productos_cliente(
            id_cliente, nombre, apellido, email, cantidad_productos, fecha_ultimo_pedido
        )
        SELECT c.id_cliente, c.nombre, c.apellido, c.email,
               count(DP.id_producto) AS cantidad_productos, max(p.fecha) as fecha_ultimo_pedido
        FROM CLIENTE c
                 JOIN DIRECCION_ENTREGA dr on dr.cliente_id = c.id_cliente
                 JOIN PEDIDO P on dr.id_direccion = P.id_direccion
                 JOIN DETALLE_PEDIDO JOIN DETALLE_PEDIDO DP on P.id_pedido = DP.id_pedido
        group by c.id_cliente;
    end if;

    IF (tg_op = 'UPDATE' AND (NEW.ID_CLIENTE OR NEW.ID_PEDIDO)) THEN
        UPDATE productos_cliente
        set cantidad_productos = (
            SELECT count(DP.cantidad)
            FROM CLIENTE c
                     JOIN DIRECCION_ENTREGA dr on dr.cliente_id = c.id_cliente
                     JOIN PEDIDO P on dr.id_direccion = P.id_direccion
                     JOIN DETALLE_PEDIDO JOIN DETALLE_PEDIDO DP on P.id_pedido = DP.id_pedido
            WHERE id_cliente = NEW.ID_CLIENTE
        ),
            fecha_ultimo_pedido =
                (
                    SELECT max(fecha)
                    FROM PEDIDO
                             JOIN DIRECCION_ENTREGA ON PEDIDO.id_direccion = DIRECCION_ENTREGA.id_direccion
                             JOIN CLIENTE ON CLIENTE.id_cliente = DIRECCION_ENTREGA.cliente_id
                    WHERE id_cliente = NEW.ID_CLIENTE
                )
        WHERE id_cliente = NEW.ID_CLIENTE;
        RETURN new;
    end if;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER tr_clientes
    BEFORE INSERT OR UPDATE ON CLIENTE
EXECUTE FUNCTION fn_clientes_registrados();

CREATE TRIGGER tr_clientes
    BEFORE INSERT OR UPDATE ON PEDIDO
EXECUTE FUNCTION fn_clientes_registrados();

CALL fn_clientes_registrados();