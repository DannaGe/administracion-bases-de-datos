-- ---------------------------------------------------------------------
-- Tema: Uso de indices
-- ----------------------------------------------------------------------


-- Crear una Base de Datos Prueba para realizar unas pruebas de indices
Create database db_indices;
use db_indices;

-- Crear la tabla DemoDatos
CREATE TABLE DemoDatos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100),
    Edad INT,
    Ciudad NVARCHAR(100),
    Correo NVARCHAR(150),
    RFC NVARCHAR(13),
    FechaRegistro DATETIME
);

-- Insertar UN millon de registros, 
CREATE PROCEDURE InsertarRegistrosDemoDatos
    @Total INT = 1000000
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 0;

    WHILE @i < @Total
    BEGIN
        INSERT INTO dbo.DemoDatos (Nombre, Edad, Ciudad, Correo, RFC, FechaRegistro)
        SELECT
            LEFT(NEWID(), ABS(CHECKSUM(NEWID()) % 20 + 5)), -- Nombre
            ABS(CHECKSUM(NEWID())) % 60 + 18,               -- Edad
            LEFT(NEWID(), ABS(CHECKSUM(NEWID()) % 15 + 5)), -- Ciudad
            CONCAT(LEFT(NEWID(), 10), '@jiquilpan.tecnm.mx'),         -- Correo
            LEFT(NEWID(), 13),                              -- RFC
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3650), GETDATE()) -- Fecha
        SET @i += 1
    END
END;

-- Ejecutar el procedimiento
exec InsertarRegistrosDemoDatos;


-- Verificar
select * from DemoDatos;

-- Buscar el numero de personas que viven por ciudad
SELECT ciudad, count(*)
FROM demodatos
GROUP BY(ciudad);

CREATE INDEX IDX_DemoDatos_Ciudad ON DemoDatos(ciudad);

-- Listar los indices
exec sp_helpindex demodatos;

-- Para eliminar un indice
Drop index IDX_DemoDatos_Ciudad_Correo ON DemoDatos;

select top 10*from demodatos;


-- Para conocer el grado de fragmentación de los indices
SELECT 
    dbschemas.name AS Esquema,
    dbtables.name AS Tabla,
    dbindexes.name AS Indice,
    indexstats.avg_fragmentation_in_percent AS Fragmentacion
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') AS indexstats
JOIN sys.tables dbtables ON dbtables.object_id = indexstats.object_id
JOIN sys.schemas dbschemas ON dbtables.schema_id = dbschemas.schema_id
JOIN sys.indexes dbindexes ON dbindexes.object_id = indexstats.object_id 
    AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.index_id > 0
ORDER BY indexstats.avg_fragmentation_in_percent DESC;

-- Para Reorganizar y reconstruir indices
ALTER INDEX OrderID ON [Order Details]
REORGANIZE;

ALTER INDEX EmployeeID ON Orders
REBUILD;

-- Conocer el número de páginas que utiliza el indice
SELECT 
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.page_count,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('Orders'), NULL, NULL, 'DETAILED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE i.name = 'EmployeeID'; -- o el nombre que tenga tu índice

-- UPDATE STATISTICS [Order Details];

