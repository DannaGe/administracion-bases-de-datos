-- -------------------------------------------------------------------------------
-- Tema 4.2 Índices en PostgreSQL (basado en Northwind)
-- Elaborado por: Danna Geraldine Avila Garcia
-- Fecha: 9 de Mayo de 2025
-- -------------------------------------------------------------------------------
-- 1. Crear índices agrupados
-- Crear una tabla clientes con la misma estructura
CREATE TABLE Clientes (
	id_cliente VARCHAR(5),
	nombre VARCHAR(50),
	direccion VARCHAR(90),
	ciudad VARCHAR(15), 
	pais VARCHAR(15)
);

-- Mostrar los índices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'clientes';

Select * from Customers;

-- Insertar registro de la tabla customers
INSERT INTO clientes(id_cliente, nombre, direccion, ciudad, pais)
SELECT customer_id, company_name, address, city, country
FROM Customers;

Select * from Clientes;

-- Crear una llave primaria por nombre
ALTER TABLE Clientes
ADD CONSTRAINT pk_Clientes_nombre PRIMARY KEY(nombre);

-- Mostrar los índices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'clientes';

-- Eliminar un índice
ALTER TABLE Clientes
DROP CONSTRAINT IF EXISTS pk_Clientes_nombre;

-- Crear una llave primaria en una tabla
ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes_nombre PRIMARY KEY(nombre);

-- Solución este ya no fue necesario pero aun asi lo corri
ALTER TABLE Clientes
ALTER COLUMN nombre TYPE VARCHAR(50),
ALTER COLUMN nombre SET NOT NULL;

-- Crear una llave primaria en una tabla este ya no fue necesario pero aun asi lo corri
ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes_nombre PRIMARY KEY(nombre);

-- Mostrar los índices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'clientes';

Select * from Clientes;

-- Crear un índice no-agrupado (nonclustered)
CREATE INDEX IDX_Clientes_id_Cliente ON Clientes(id_cliente);

-- Mostrar los índices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'clientes';








