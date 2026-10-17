-- ================================
-- Elaborado: Danna Geraldine Avila Garcia
-- 02 de Mayo del 2025
-- Usuarios, Roles, Permisos y Login en SQL SERVER
-- Northwind
-- ================================

USE Northwind;
GO

-- ================================
-- Usuario: CARLOS - ROL VENTAS
-- ================================

-- Paso 1: Crear login
CREATE LOGIN carlos 
WITH PASSWORD = '$2025_Carlos', 
     DEFAULT_DATABASE = [Northwind];
GO

-- Paso 2: Crear usuario en la base de datos
CREATE USER carlos FOR LOGIN carlos;

-- Paso 3: Crear rol
CREATE ROLE rol_ventas;

-- Paso 4: Agregar usuario al rol
ALTER ROLE rol_ventas ADD MEMBER carlos;

-- Paso 5: Asignar permisos al rol
GRANT SELECT ON OBJECT::[dbo].[Customers] TO rol_ventas;
GRANT SELECT ON OBJECT::[dbo].[Orders] TO rol_ventas;
GRANT SELECT ON OBJECT::[dbo].[Products] TO rol_ventas;
GRANT INSERT ON OBJECT::[dbo].[Orders] TO rol_ventas;
GRANT UPDATE ON OBJECT::[dbo].[Orders](ShippedDate) TO rol_ventas;
GO

select* from Orders;

-- ================================
-- Usuario: DIEGO - ROL BODEGA
-- ================================

CREATE LOGIN diego 
WITH PASSWORD = '$2025_Diego', 
     DEFAULT_DATABASE = [Northwind];
GO

CREATE USER diego FOR LOGIN diego;

CREATE ROLE rol_bodega;

ALTER ROLE rol_bodega ADD MEMBER diego;

GRANT SELECT ON OBJECT::[dbo].[Products] TO rol_bodega;
GRANT UPDATE ON OBJECT::[dbo].[Products](UnitsInStock, UnitsOnOrder) TO rol_bodega;
GO

-- ================================
-- Usuario: LUPITA - ROL COMPRAS
-- ================================

CREATE LOGIN lupita 
WITH PASSWORD = '$2025_Lupita', 
     DEFAULT_DATABASE = [Northwind];
GO

CREATE USER lupita FOR LOGIN lupita;

CREATE ROLE rol_compras;

ALTER ROLE rol_compras ADD MEMBER lupita;

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[dbo].[Suppliers] TO rol_compras;
GRANT INSERT ON OBJECT::[dbo].[Products] TO rol_compras;
GRANT UPDATE ON OBJECT::[dbo].[Products](UnitPrice, SupplierID) TO rol_compras;
GO

-- ================================
-- Usuario: PATRICIA - ROL ADMIN
-- ================================

CREATE LOGIN patricia 
WITH PASSWORD = '$2025_Patricia', 
     DEFAULT_DATABASE = [Northwind];
GO

CREATE USER patricia FOR LOGIN patricia;

CREATE ROLE rol_admin;

ALTER ROLE rol_admin ADD MEMBER patricia;

-- Permiso total
EXEC sp_addrolemember 'db_owner', 'patricia';
GO











