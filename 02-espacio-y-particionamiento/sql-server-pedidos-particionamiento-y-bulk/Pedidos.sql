-- ------------------------------------------------------------------
-- Danna Geraldine Avila Garcia
-- 04 de Abril de 2025
-- Particionamiento de tablas (Fragmentacion)
-- Utilizando Bulk de datos (Insercion masiva de datos)
-- ------------------------------------------------------------------

create database Pedidos
on primary (
	Name = 'Pedidos_dat', --nombre lógico
	Filename = 'C:\Pedidos\Primary\Pedidos_dat.mdf', --nombre físico
	size = 10MB,
	maxsize = 500MB,
	filegrowth = 10MB
)
LOG ON(
	Name = 'Pedidos_log',
	Filename = 'C:\Pedidos\Log\Pedidos_log.ldf', 
	size = 10MB,
	maxsize = 1GB,
	filegrowth = 5MB
)

-- Usar la base de Datos
use Pedidos

-- Algunas observaciones
-- Obtener un ID Unico
select NEWID()

-- checksum(). Obtiene la suma calculado sobre lista de valores
select CHECKSUM(NEWID()) 

-- abs(). Obtiene el valor de la sume
select abs( checksum(newid()) )

-- getdate(). Obtiene la fecha del sistema
select getdate()

-- dateadd(). Regresa una fecha de acuerdo a los parametros
select dateadd(hour, 5, getdate())

-- Agregar dias a la fecha actual
select dateadd(day, 5, getdate())

-- Dias que sean trascurrido en este año
select datediff(day, '2025-01-01', getdate() )

-- Rand(). Devuelve un valor entre 0 y 1
select rand()

-- Round(). Redondea un valor numerico y depende de la precicion adecuada
select round(123.44123, 1)

-- Como general numeros aleatorios entre 1 y 100
SELECT FLOOR(RAND() * 100) + 1 AS NumeroAleatorio;

SELECT FLOOR( RAND()*(100-1)+1);

SELECT ROUND( RAND() * 100, 0)

-- Generar numeros aleatorios entre 500 y 1000
SELECT FLOOR(RAND() * (1000 - 500 + 1)) + 500 AS NumeroAleatorio;

-- Crear la tabla Pedidos
CREATE TABLE Pedidos(
	idPedido int identity(1,1),
	identificadorUnico UNIQUEIDENTIFIER default newid(),
	fechaPedido date,
	idVendedor int,
	idEmpresa int,
	CONSTRAINT pk_idPedido primary key(idPedido)
)

-- Crear un procedimiento almacenado que inserte datos masivos
-- Bulk_Insert

CREATE PROCEDURE InstarPedidos
AS
	DECLARE @FechaInicial Date = '2021-01-01'
	DECLARE @DiasTranscurridos INT = DATEDIFF(DAY, @FechaInicial, GETDATE())
	DECLARE @x int = 1
	DECLARE @numero_registros INT = 500000

	WHILE @x <= @numero_registros
	BEGIN
		INSERT INTO Pedidos(fechaPedido, idVendedor, idEmpresa)
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		UNION
		SELECT DATEADD(day, abs(checksum(newid())) % @DiasTranscurridos, @FechaInicial),
		ROUND( RAND() * 100, 0),
		FLOOR( RAND()*(1000-500)+500)
		
		SET @x = @x +1
	END

-- Ejecutar el procedimiento almacenado
exec InstarPedidos

-- Agregar FileGroup
ALTER DATABASE Pedidos
ADD FILEGROUP Pedidos2021_FG1
ALTER DATABASE Pedidos
ADD FILEGROUP Pedidos2022_FG2
ALTER DATABASE Pedidos
ADD FILEGROUP Pedidos2023_FG3
ALTER DATABASE Pedidos
ADD FILEGROUP Pedidos2024_FG4
ALTER DATABASE Pedidos
ADD FILEGROUP Pedidos2025_FG5

-- Asociar el archivo fisico con los filegroup
ALTER DATABASE Pedidos ADD FILE
(
	Name = 'Pedidos2021_FG1',
	FileName = 'C:\Pedidos\Pedidos2021_FG1\Pedidos2021_FG1.ndf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)TO FILEGROUP Pedidos2021_FG1

-- -----------------------------------------------------------
ALTER DATABASE Pedidos ADD FILE
(
	Name = 'Pedidos2022_FG2',
	FileName = 'C:\Pedidos\Pedidos2022_FG2\Pedidos2022_FG2.ndf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)TO FILEGROUP Pedidos2022_FG2

-- -----------------------------------------------------------
ALTER DATABASE Pedidos ADD FILE
(
	Name = 'Pedidos2023_FG3',
	FileName = 'C:\Pedidos\Pedidos2023_FG3\Pedidos2023_FG3.ndf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)TO FILEGROUP Pedidos2023_FG3

-- -----------------------------------------------------------
ALTER DATABASE Pedidos ADD FILE
(
	Name = 'Pedidos2024_FG4',
	FileName = 'C:\Pedidos\Pedidos2024_FG4\Pedidos2024_FG4.ndf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)TO FILEGROUP Pedidos2024_FG4

-- -----------------------------------------------------------
ALTER DATABASE Pedidos ADD FILE
(
	Name = 'Pedidos2025_FG5',
	FileName = 'C:\Pedidos\Pedidos2025_FG5\Pedidos2025_FG5.ndf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 5MB
)TO FILEGROUP Pedidos2025_FG5

-- Crear la funcion de partición
CREATE PARTITION FUNCTION pf_pedidosAnuales(date)
AS RANGE LEFT FOR VALUES(
	'2022-01-01',
	'2023-01-01',
	'2024-01-01',
	'2025-01-01',
	'2026-01-01'
)

-- Crear el esquema de particion
CREATE PARTITION SCHEME ps_pedidosAnuales
AS PARTITION pf_pedidosAnuales
TO(
	Pedidos2021_FG1,
	Pedidos2022_FG2,
	Pedidos2023_FG3,
	Pedidos2024_FG4,
	Pedidos2025_FG5,
	'Primary'
)

-- Crear la tabla Particionada
CREATE TABLE PedidosAnuales(
	idPedido int identity(1,1),
	identificadorUnico UNIQUEIDENTIFIER default newid(),
	fechaPedido date,
	idVendedor int,
	idEmpresa int,
	CONSTRAINT pk_idPedido_PA primary key(idPedido, fechaPedido)
)ON ps_pedidosAnuales(fechaPedido)

-- -----------------------------------------------------------
Set identity_insert PedidosAnuales ON;

-- Insertar datos
INSERT INTO PedidosAnuales(idPedido,
	identificadorUnico,
	fechaPedido,
	idVendedor,
	idEmpresa)
SELECT idPedido, identificadorUnico, fechaPedido, idVendedor, idEmpresa
from Pedidos;

set identity_insert PedidosAnuales OFF;

-- Realizar una consulta sobre la tabla PedidosAnuales
SELECT idPedido, identificadorUnico, fechaPedido, idVendedor, idEmpresa,
$partition.pf_pedidosAnuales(fechaPedido) as 'No. Particion'
FROM PedidosAnuales
WHERE idEmpresa = 500;

-- Contar el numero  de registros del año 2024
SELECT COUNT(*)
FROM PedidosAnuales
WHERE year(fechaPedido) = 2022;

-- Contar el numero de pedidos por año
SELECT YEAR(fechaPedido), COUNT(*) AS 'Total Pedidos'
FROM PedidosAnuales
GROUP BY (YEAR(fechaPedido))
order BY YEAR(fechaPedido);

-- Contar el numero de pedidos por año/particion
SELECT $partition.pf_pedidosAnuales(fechaPedido) as 'No. Particion',
	COUNT(*) AS 'Total Pedidos'
FROM PedidosAnuales
GROUP BY ($partition.pf_pedidosAnuales(fechaPedido));

-- Eliminar la base de datos
DROP database Pedidos;
DROP DATABASE Empresa;