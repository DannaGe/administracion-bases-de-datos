-- Danna Geraldine Avila Garcia 
-- 2 de Abril del 2025
-- 3 Unidad

-- --------------------------------------------------------
-- Particionamiento horizontal
-- --------------------------------------------------------

CREATE DATABASE Empresa
ON PRIMARY
(
	Name = 'EmpresaData',
	FileName = 'C:\Empresa\Primary\EmpresaData.mdf',
	size= 100MB,
	filegrowth = 10MB
)
LOG ON
(
	Name = 'EmpresaLog',
	FileName = 'C:\Empresa\Log\EmpresaLog.ldf',
	size= 100MB,
	filegrowth = 10MB
)

-- Usar la Base de Datos
use Empresa;

-- 1. Crear los fileGroups y archivos asociados
ALTER DATABASE Empresa ADD FILEGROUP Particion1_FG1
ALTER DATABASE Empresa ADD FILEGROUP Particion2_FG2
ALTER DATABASE Empresa ADD FILEGROUP Particion3_FG3
go

-- Mostrar los filegroup
SELECT NAME AS MisFileGroup
FROM SYS.filegroups
WHERE TYPE='FG';


-- 2. Crear los archivos y asociarlos a los FileGroup
ALTER DATABASE Empresa ADD FILE
(
	Name = 'Particion1_FG1',
	FileName = 'C:\Empresa\Particion1_FG1\Particion1_FG1.ndf',
	size= 100MB,
	filegrowth = 10MB
)TO FILEGROUP Particion1_FG1;

ALTER DATABASE Empresa ADD FILE
(
	Name = 'Particion2_FG2',
	FileName = 'C:\Empresa\Particion2_FG2\Particion2_FG2.ndf',
	size= 100MB,
	filegrowth = 10MB
)TO FILEGROUP Particion2_FG2;

ALTER DATABASE Empresa ADD FILE
(
	Name = 'Particion3_FG3',
	FileName = 'C:\Empresa\Particion3_FG3\Particion3_FG3.ndf',
	size= 100MB,
	filegrowth = 10MB
)TO FILEGROUP Particion3_FG3;

-- Para eliminar un filegroup
DELETE FROM SYS.filegroups
WHERE NAME = 'Particion1_FG2';

-- Para eliminar un archivo asociado al filegroup
ALTER DATABASE Empresa
REMOVE FILE Particion1_FG2;

-- ---------------------------------------------------------------------
-- Funcion y Esquema de particion
-- Grupo 'I', 'P', 'Z' la z no se agregue porque ya iria en otro grupo
-- ---------------------------------------------------------------------
-- 1. Funcion de particion
CREATE PARTITION FUNCTION pf_id_cliente( varchar(5) )
AS RANGE LEFT FOR values ( 'I','P' )

-- 2. Esquema de particion
CREATE PARTITION SCHEME ps_id_cliente
AS PARTITION pf_id_cliente
TO (Particion1_FG1, Particion2_FG2, Particion3_FG3)

-- Crear una tabla de nombre Clientes
CREATE TABLE Clientes(
	Codigo varchar(5),
	Nombre varchar(30),
	Empresa varchar(40),
	Direccion varchar(60),
	Ciudad varchar(15),
	Region varchar(15),
	CodigoPostal varchar(10),
	Pais varchar(15),
	Telefono varchar(24),
	constraint pk_Codigo primary key(Codigo)
)ON ps_id_cliente(Codigo);

-- Insertar registros de la tabla Customer de Northwind
INSERT INTO Clientes(Codigo, Nombre, Empresa, Direccion, 
					Ciudad, Region, 
					CodigoPostal, Pais, Telefono)

SELECT CustomerID,ContactName,CompanyName,Address,
		City,Region,
        PostalCode,Country,Phone
FROM Northwind.dbo.Customers;

-- Consulta 
select * from Clientes;

-- Consultar los datos y mostrar las particiones
SELECT Codigo, Empresa, $partition.pf_id_cliente(Codigo) as Paticion 
FROM Clientes;




