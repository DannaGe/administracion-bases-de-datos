-- -----------------------------------------------
-- Roles, usuarios y permisos en MySQL Server
-- Fecha: 28 de Abril del 2024
-- Autor: Danna Geraldine Avila Garcia
-- -----------------------------------------------

-- Asumimos que la base de datos Northwind ya está creada y las tablas definidas
USE Northwind;

-- Eliminar roles existentes si es necesario
DROP ROLE IF EXISTS rol_ventas, rol_bodega, rol_compras, rol_admin;

-- Crear los roles
CREATE ROLE rol_ventas;
CREATE ROLE rol_bodega;
CREATE ROLE rol_compras;
CREATE ROLE rol_admin;

-- Asignar permisos para rol_ventas
-- Puede ver clientes y órdenes, pero no modificarlos
GRANT SELECT ON Northwind.Customers TO rol_ventas;
GRANT SELECT ON Northwind.Orders TO rol_ventas;
GRANT SELECT ON Northwind.OrderDetails TO rol_ventas;

-- Asignar permisos para rol_bodega
-- Puede ver productos y stock, y actualizar cantidades
GRANT SELECT, UPDATE ON Northwind.Products TO rol_bodega;

-- Asignar permisos para rol_compras
-- Puede ver y registrar nuevos proveedores y productos
GRANT SELECT, INSERT ON Northwind.Suppliers TO rol_compras;
GRANT SELECT, INSERT ON Northwind.Products TO rol_compras;

-- Asignar permisos para rol_admin
-- Tiene todos los permisos sobre toda la base de datos
GRANT ALL PRIVILEGES ON Northwind.* TO rol_admin;

-- Crear usuarios y asignar contraseñas
-- Usuarios rol_ventas
CREATE USER IF NOT EXISTS 'Carlos'@'%' IDENTIFIED BY '$2025_Carlos';
CREATE USER IF NOT EXISTS 'Laura'@'%' IDENTIFIED BY '$2025_Laura';
CREATE USER IF NOT EXISTS 'Antonio'@'%' IDENTIFIED BY '$2025_Antonio';

-- Usuarios rol_bodega
CREATE USER IF NOT EXISTS 'Xochitl'@'%' IDENTIFIED BY '$2025_Xochitl';
CREATE USER IF NOT EXISTS 'Pedro'@'%' IDENTIFIED BY '$2025_Pedro';
CREATE USER IF NOT EXISTS 'Luis'@'%' IDENTIFIED BY '$2025_Luis';

-- Usuarios rol_compras
CREATE USER IF NOT EXISTS 'Patricia'@'%' IDENTIFIED BY '$2025_Patricia';
CREATE USER IF NOT EXISTS 'Lupita'@'%' IDENTIFIED BY '$2025_Lupita';

-- Usuario rol_admin
CREATE USER IF NOT EXISTS 'Piter'@'%' IDENTIFIED BY '$2025_Piter';

-- Asignar roles a usuarios
-- Asignar rol_ventas
GRANT rol_ventas TO 'Carlos'@'%', 'Laura'@'%', 'Antonio'@'%';

-- Asignar rol_bodega
GRANT rol_bodega TO 'Xochitl'@'%', 'Pedro'@'%', 'Luis'@'%';

-- Asignar rol_compras
GRANT rol_compras TO 'Patricia'@'%', 'Lupita'@'%';

-- Asignar rol_admin
GRANT rol_admin TO 'Piter'@'%';

-- Activar los roles por defecto para todos los usuarios
SET DEFAULT ROLE ALL TO
    'Carlos'@'%', 'Laura'@'%', 'Antonio'@'%',
    'Xochitl'@'%', 'Pedro'@'%', 'Luis'@'%',
    'Patricia'@'%', 'Lupita'@'%', 'Piter'@'%';

-- Verificar la configuración
SELECT USER FROM mysql.user WHERE USER IN ('Carlos', 'Laura', 'Antonio', 'Xochitl', 'Pedro', 'Luis', 'Patricia', 'Lupita', 'Piter');
SHOW GRANTS FOR rol_ventas;
SHOW GRANTS FOR rol_bodega;
SHOW GRANTS FOR rol_compras;
SHOW GRANTS FOR rol_admin;