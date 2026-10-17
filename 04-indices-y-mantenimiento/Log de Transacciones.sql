-- -------------------------------------------------------------------------------
-- Tema 4.1 Log de Transacciones
-- Fecha: 7 de Mayo del 2025
-- Autor: Danna Geraldine Avila Garcia
-- -------------------------------------------------------------------------------

use Northwind;

-- 1.- Ver el tamaño del log de transacciones
DBCC SQLPERF(LOGSPACE);

-- 2.- Como poder reducir o liberar el espacio de log de transacciones
-- Certificar que no exitan transacciones activas
DBCC OPENTRAN('Northwind');

-- Conocer el nombre de log de transacciones
SELECT name as logical_name, type_desc, physical_name
FROM sys.database_files
WHERE type_desc='LOG';

-- Reducir espacios
DBCC SHRINKFILE(stylishsteps_log, 4); -- si lo redujo estaba en 7 y lo redujo a 5.8125


