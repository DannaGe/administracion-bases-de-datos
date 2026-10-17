-- -----------------------------------------------
-- Roles, usuarios y permisos en MYsql Server
-- Fecha: 10 de Abril del 2024
-- Autor: Danna Geraldine Avila Garcia
-- -----------------------------------------------
CREATE DATABASE PruebaA;

use PruebaA;

CREATE TABLE Clientes(
	id_cliente int auto_increment,
    nombre varchar(50),
    primary key(id_cliente)
);

INSERT INTO Clientes(nombre) VALUES('Enrique');
INSERT INTO Clientes(nombre) VALUES('Pedro');
INSERT INTO Clientes(nombre) VALUES('Juan');

Select * from Clientes;

-- PROCEDIEMIENTO QUE INSERTA UN REGISTRO
DELIMITER $$
create procedure inserta_cliente( in nom  varchar(50))
Begin
	INSERT INTO Clientes(nombre) VALUES(nom);
End
$$

CALL inserta_cliente('Josefina');

delete from clientes where id_cliente = 1;