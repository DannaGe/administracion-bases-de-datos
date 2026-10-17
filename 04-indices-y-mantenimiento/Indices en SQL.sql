-- -------------------------------------------------------------------------------
-- Tema 4.2 Indices en SQL
-- Fecha: 7 de Mayo del 2025
-- Autor: Danna Geraldine Avila Garcia
-- -------------------------------------------------------------------------------

-- 1. Crear indices agrupados
-- Crear una tabla clientes con la misma estructura
create table Clientes(
	id_cliente varchar(5),
	nombre varchar(30),
	direccion varchar(60),
	ciudad varchar(15), 
	pais varchar(15)
);

-- Mostrar los indices
EXEC sp_helpindex 'clientes';

-- Insertar registro de la tabla customers
INSERT INTO Clientes(id_cliente, nombre, direccion, ciudad, pais)
SELECT CustomerID, ContactName, Address, City, Country
FROM Customers;

Select * from Clientes;

-- Crear una llave primaria por nombre
CREATE CLUSTERED INDEX PK_Clientes_nombre ON clientes(nombre);

-- Mostrar los indices
EXEC sp_helpindex 'clientes';

-- Eliminar un indice 
DROP INDEX PK_Clientes_nombre ON Clientes;

-- Crear una llave primaria en una tabla
ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes_nombre primary key(nombre);

-- Solucion
ALTER TABLE Clientes
ALTER COLUMN nombre varchar(30) not null;

-- Crear una llave primaria en una tabla
ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes_nombre primary key(nombre);

-- Mostrar los indices
EXEC sp_helpindex 'clientes';

Select * from Clientes;

-- Crear un indice no-agrupados (nonclustered)
CREATE INDEX IDX_Clientes_id_Cliente  ON Clientes(id_cliente);

-- Mostrar los indices
EXEC sp_helpindex 'clientes';

SELECT * FROM Clientes WHERE id_cliente = 'FAMIA'; -- este se ejecuta en mostrar plan de ejecucion estimado (Ctrl + L)

-- Crear indices compuestos 
CREATE INDEX IDX_Clientes_pais_ciudad ON Clientes(Pais, Ciudad);

-- 4.- Crear un indice compuesto. Es el que esta formado por mas de 1 columna
-- Crear un indice compuesto: Pais y Ciudad
CREATE INDEX IDX_Clientes_pais_ciudad ON Clientes(Pais, Ciudad);

exec sp_helpindex clientes

-- 3.- Crear indices unicos
SELECT * FROM Clientes;

-- Para poder crear el indice unico por ID de aqui no me funciono
-- Eliminar una llave primaria 
ALTER TABLE Clientes
DROP CONSTRAINT PK_Clientes_nombre;

CREATE UNIQUE INDEX IDX_Clientes_idcliente
ON Clientes(id_cliente);

-- Crear un indice compuesto unico
CREATE UNIQUE INDEX IDX_Clientes_nombre_direccion_pais
ON Clientes(nombre, direccion, pais);

