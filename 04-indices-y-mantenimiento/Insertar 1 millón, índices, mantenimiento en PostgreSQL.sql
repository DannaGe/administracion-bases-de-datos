-- =============================================
-- Script: Tarea de Base de Datos - PostgreSQL
-- Objetivo: Insertar 1 millón de registros, crear índices y mantenimiento
-- Autor: Danna Geraldine Avila Garcia
-- Fecha 23 de Mayo del 2025
-- =============================================

CREATE DATABASE tarea_indices;


-- =============================================
-- 1. CREACIÓN DE TABLA
-- =============================================
-- Creamos una tabla llamada 'empleados' con columnas comunes.
-- La columna 'id' es la clave primaria con incremento automático (SERIAL).
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    departamento TEXT,
    salario NUMERIC,
    fecha_ingreso DATE
);

-- =============================================
-- 2. INSERCIÓN MASIVA DE REGISTROS (1,000,000)
-- =============================================
-- Usamos generate_series para crear 1 millón de filas.
-- Los valores se generan aleatoriamente para simular datos reales.
INSERT INTO empleados (nombre, departamento, salario, fecha_ingreso)
SELECT
    'Empleado_' || g AS nombre,
    (ARRAY['Ventas','TI','RRHH','Finanzas','Marketing'])[ (random() * 5 + 1)::int ],
    round((random() * 50000 + 20000)::numeric, 2),
    NOW() - (random() * 3650)::int * INTERVAL '1 day'
FROM generate_series(1, 1000000) g;


-- =============================================
-- 3. CREACIÓN DE ÍNDICES
-- B-tree Filtros y rangos comunes	
-- Hash	Comparaciones exactas	
-- Compuesto Filtros combinados	
-- Funcional Buscar sobre funciones
-- Parcial	Filtrar por subconjuntos específicos	
-- =============================================

-- 3.1 Índice B-tree (predeterminado) sobre la columna 'nombre'.
-- Este tipo de índice es eficiente para búsquedas con igualdad o rangos.
-- El árbol B-tree almacena los valores ordenados en una estructura jerárquica que permite saltarse grandes porciones de datos 
-- innecesarios. Es como un árbol genealógico, pero balanceado para que todo sea rápido de encontrar.
CREATE INDEX idx_nombre ON empleados(nombre);

-- 3.2 Índice HASH sobre la columna 'departamento'.
-- Bueno para búsquedas con igualdad exacta, pero no soporta rangos.
-- Un índice hash es un tipo de índice que usa una función hash para transformar el valor de la columna en un número (el hash) y
-- luego lo almacena.
CREATE INDEX idx_departamento_hash ON empleados USING hash(departamento);

-- 3.3 Índice compuesto sobre 'salario' y 'fecha_ingreso'.
-- Útil para consultas que filtren por ambos campos o usen ordenamiento combinado.
-- Un índice compuesto es un índice que se construye sobre más de una columna.
-- La primera columna es salario. La segunda columna es fecha_ingreso.
-- PostgreSQL guarda internamente los registros ordenados primero por salario y luego por fecha_ingreso, 
-- como si fueran un índice telefónico con dos niveles de clasificación.
CREATE INDEX idx_salario_fecha ON empleados(salario, fecha_ingreso);

-- 3.4 Índice funcional sobre el resultado de LOWER(nombre).
-- Mejora el rendimiento de búsquedas insensibles a mayúsculas.
-- Un índice funcional se crea no sobre una columna directamente, sino sobre el resultado de una función aplicada a una columna. 
-- En este caso, usamos:LOWER(nombre) Que convierte todos los nombres a minúsculas, por ejemplo:
-- 'Juan' → 'juan', 'LUISA' → 'luisa'
CREATE INDEX idx_lower_nombre ON empleados(LOWER(nombre));

-- 3.5 Índice parcial sobre 'salario' sólo para empleados con salario > 60000.
-- Reduce tamaño y mejora rendimiento si las consultas aplican esa condición.
-- Un índice parcial es un índice que se crea solo sobre un subconjunto de filas de la tabla, según una condición WHERE.
-- En este caso, el índice solo incluye a los empleados cuyo salario es mayor a 60000.
CREATE INDEX idx_salario_alto ON empleados(salario) WHERE salario > 60000;

-- Mostrar los indices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'empleados';

-- Eliminar un indice
DROP INDEX nombre_del_indice;


-- =============================================
-- 4. MANTENIMIENTO Y RECUPERACIÓN DE ÍNDICES
-- =============================================
-- 4.1 Mostrar todos los índices de la tabla empleados
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'empleados';

-- 4.2 ANALYZE: Actualiza las estadísticas que el planificador usa para optimizar consultas
-- Se recomienda después de grandes inserciones o actualizaciones masivas.
ANALYZE empleados;

-- 4.3 REINDEX: Reconstruye un índice específico (útil en caso de corrupción o fragmentación)
REINDEX INDEX idx_nombre;
CREATE INDEX idx_nombre ON empleados(nombre);

-- 4.4 REINDEX TABLE: Reconstruye todos los índices de la tabla empleados
REINDEX TABLE empleados;

-- 4.5 VACUUM: Limpia espacio muerto (tuplas obsoletas) para liberar espacio físico
VACUUM empleados;

-- 4.6 VACUUM ANALYZE: Combina limpieza de espacio y actualización de estadísticas
VACUUM ANALYZE empleados;

-- 4.6.1 Para liberar espacio muerto (similar a reorganizar)
VACUUM VERBOSE empleados;

-- 4.6.2 Para liberar más espacio y hacer un "compactado fuerte":
VACUUM FULL VERBOSE empleados;

-- 4.7 EXPLAIN ANALYZE: Permite analizar el plan de ejecución de una consulta
-- Útil para verificar si los índices se usan correctamente
EXPLAIN ANALYZE
SELECT * FROM empleados WHERE nombre = 'Empleado_5000';

select * from empleados;

-- =============================================
-- 5. VER ESTADÍSTICAS Y FRAGMENTACIÓN (APROXIMADA)
-- =============================================
-- PostgreSQL no muestra fragmentación como SQL Server,
-- pero puedes revisar estadísticas útiles sobre el uso y tamaño de los índices.

-- Ver estadísticas de los índices de usuario
SELECT 
    psui.relname AS indice,
    pg_size_pretty(pg_relation_size(psui.indexrelid)) AS tamaño,
    psui.idx_scan AS num_lecturas,
    psui.idx_tup_read AS tuplas_leídas,
    psui.idx_tup_fetch AS tuplas_recuperadas
FROM 
    pg_stat_user_indexes psui
JOIN 
    pg_index pi ON pi.indexrelid = psui.indexrelid
WHERE 
    psui.relname LIKE 'idx_%';

-- Explicación:
-- - indice: nombre del índice
-- - tamaño: tamaño en disco (legible)
-- - num_lecturas: cuántas veces se ha usado ese índice en consultas
-- - tuplas_leídas: filas leídas a través del índice
-- - tuplas_recuperadas: filas que cumplieron con la condición del índice
