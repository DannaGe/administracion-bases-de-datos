-- -----------------------------------------------
-- Roles, usuarios y permisos en PostgreSQL
-- Fecha: 29 de Abril del 2024
-- Autor: Danna Geraldine Avila Garcia
-- -----------------------------------------------

-- Conectarse a la base de datos northwind
\c northwind;

-- 1. Eliminar roles existentes si ya están creados
DROP ROLE IF EXISTS rol_ventas, rol_bodega, rol_compras, rol_admin;

-- 2. Crear roles (sin privilegios aún)
CREATE ROLE rol_ventas;
CREATE ROLE rol_bodega;
CREATE ROLE rol_compras;
CREATE ROLE rol_admin;

-- 3. Crear usuarios y asignarles directamente sus roles

-- Usuarios de rol_ventas
CREATE ROLE Carlos LOGIN PASSWORD '$2025_Carlos';
GRANT rol_ventas TO Carlos;

-- Usuarios de rol_bodega
CREATE ROLE Luis LOGIN PASSWORD '$2025_Luis';
GRANT rol_bodega TO Luis;

-- Usuarios de rol_compras
CREATE ROLE Patricia LOGIN PASSWORD '$2025_Patricia';
GRANT rol_compras TO Patricia;

-- Usuario de rol_admin
CREATE ROLE Piter LOGIN PASSWORD '$2025_Piter';
GRANT rol_admin TO Piter;

-- 4. Asignar permisos a los roles
-- rol_ventas: solo lectura sobre clientes y órdenes
GRANT SELECT ON customers, orders, order_details TO rol_ventas;

-- rol_bodega: lectura y actualización de productos
GRANT SELECT, UPDATE ON Products TO rol_bodega;

-- rol_compras: lectura e inserción de proveedores y productos
GRANT SELECT, INSERT ON Suppliers TO rol_compras;
GRANT SELECT, INSERT ON Products TO rol_compras;

-- rol_admin: todos los privilegios sobre todas las tablas y secuencias
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rol_admin;


-- -----------------------------------------------------

-- Verificar que los roles y usuarios estén configurados
\du






