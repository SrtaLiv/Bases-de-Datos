CREATE TABLE Pais (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO Pais (nombre) VALUES ('Argentina'), ('Brasil'), ('Chile');

--Todo el acceso a cursores en PL/pgSQL es a través de variables del tipo cursor, las cuales son siempre del tipo de datos especial refcursor.
--Una forma de crear una variable tipo cursor es declararla como de tipo refcursor o usar la sintaxis de declaración de cursor, la cual en general es:

CREATE FUNCTION verificarRegistros() RETURNS TEXT AS $$
DECLARE
    cur1 CURSOR FOR SELECT * FROM Pais;  -- Declarar el cursor para la consulta
    mifila Pais%ROWTYPE;  -- Declarar una variable del tipo de fila de la tabla Pais
    mensaje TEXT DEFAULT 'No hay registros';  -- Mensaje predeterminado
BEGIN
    OPEN cur1;  -- Abrir el cursor
    FETCH cur1 INTO mifila;  -- Obtener la primera fila del cursor

    IF FOUND THEN  -- Verificar si se encontró alguna fila
        mensaje := 'Hay registros en la tabla';  -- Actualizar el mensaje si se encontraron registros
    END IF;

    CLOSE cur1;  -- Cerrar el cursor

    RETURN mensaje;  -- Devolver el mensaje
END;
$$ LANGUAGE plpgsql;


SELECT verificarRegistros();
