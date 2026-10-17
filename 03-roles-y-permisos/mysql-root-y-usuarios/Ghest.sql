-- -----------------------------------------------
-- Roles, usuarios y permisos en MYsql Server
-- Fecha: 10 de Abril del 2024
-- Autor: Danna Geraldine Avila Garcia
-- -----------------------------------------------
use PruebaA;

select * from clientes;

INSERT INTO Clientes(nombre) VALUES('Joselito');

CALL inserta_cliente('Lizbeth');

CREATE USER 'user01'@'localhost'
