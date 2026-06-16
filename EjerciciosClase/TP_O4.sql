select nro_autor, nombre_apellido
FROM autor;

select nro_autor || nombre_apellido as "nombre_apellido"
FROM autor

select nro_autor || nombre_apellido
FROM autor

select nro_autor || nombre_apellido as datos
FROM autor

select extract((month from pedido.fecha) and (year from pedido.fecha))
from pedido