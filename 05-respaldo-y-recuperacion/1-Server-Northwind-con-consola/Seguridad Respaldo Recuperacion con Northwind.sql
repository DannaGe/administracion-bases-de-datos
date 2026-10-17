-- ---------------------------------------------------------------------
-- Autor: Danna Geraldine Avila Garcia
-- Fecha: 26 de Mayo del 2025
-- Tema: Unidad 5 SEGURIDAD Respaldo y Reparacion 
-- ----------------------------------------------------------------------
 

-- 1.- CREAR EL RESPALDO DE LA BASE DE DATOS

BACKUP DATABASE Northwind
TO DISK = 'C:\Backups\NorthwindRespaldo.bak'
WITH FORMAT, INIT,
     NAME = 'Respaldo Completo de Northwind';
BACKUP DATABASE Northwind
TO DISK = 'C:\Backups\NorthwindRespaldo.bak'
WITH FORMAT, INIT,
     NAME = 'Respaldo Completo de Northwind';


-- 2.- ELIMINAR LA BASE DE DATOS
-- asegurarse que no se esté usando la base de datos

USE master;
GO
ALTER DATABASE Northwind SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Northwind;


-- 3.- RESTAURAR LA BASE DE DATOS 

RESTORE DATABASE Northwind
FROM DISK = 'C:\Backups\NorthwindRespaldo.bak'
WITH REPLACE;


-- 4.- VERIFICA QUE FUNCIONÓ

USE Northwind;
GO
SELECT * FROM Categories;