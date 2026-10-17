-- -----------------------------------------------
-- Roles, usuarios y permisos en MySQL Server
-- Fecha: 10 de Abril del 2024
-- Autor: Danna Geraldine Avila Garcia
-- -----------------------------------------------

-- Ver el usuario actual
SELECT CURRENT_USER();

-- Ver los usuarios existentes
select * from mysql.user;

-- ---------------------------------------------------
-- CREACIÓN DE USUARIOS
-- ---------------------------------------------------

-- CREATE USER 'adminroot'@'localhost' solo se puede conectar en esa computadora a la bd de manera fisica
-- CREATE USER 'adminroot'@'%' se puede conectar cualquiera
-- CREATE USER 'adminroot'@'192.168.10.9' solo se puede conectar esa direccion ip

-- Crear un usuario 'adminroot' con permisos de administracion
CREATE USER 'adminroot'@'localhost' identified BY 'Enter12345';

-- Crear usuarios 'guest' con permisos de lectura
CREATE USER 'guest'@'localhost' identified BY 'Enter12345';

-- ---------------------------------------------------
-- ASIGNACIÓN DE PRIVILEGIOS
-- ---------------------------------------------------

-- Permisos de administrador de todas las bases de datos
-- *.* quiere decir que tiene permisos de todas las bases de datos y todas las tablas
GRANT ALL privileges ON *.* TO 'adminroot'@'localhost';


-- Privilegios o permisos que existen 
-- CREATE  PERMITE CREAR BD
-- DROP
-- DELETE 
-- INSERT
-- UPDATE
-- SELECT 
-- GRANT OPTION - PERMITE DAR PERMISOS A OTROS USUARIOS
-- ALL PRIVILEGES - PERMITE DAR TODOS LOS PERMISOS EN UNA SOLA INSTRUCCIÓN

-- Permisos de lectura de la base de datos PruebaA de la tabla Clientes
GRANT SELECT ON PruebaA.Clientes TO 'guest'@'localhost';


-- Permiso para ejecutar procedimiento almacenado específico
GRANT EXECUTE ON PROCEDURE pruebaa.inserta_cliente TO 'guest'@'localhost';

-- Permitir que guest pueda otorgar permisos sobre tabla Clientes
GRANT GRANT OPTION ON pruebaa.Clientes to 'guest'@'localhost';

-- -------------------------------------------------------------------------------------------
-- Fecha: 11 de Abril del 2024
-- -------------------------------------------------------------------------------------------

-- Crear un usuario 'usr1'
-- Crear usuario con acceso remoto
CREATE USER 'user1'@'%' identified BY 'Enter12345';

-- Permisos de lectura a la tabla categories sobre la base de datos 'northind'
GRANT SELECT ON Northwind.categories TO 'user1'@'%';

-- Crear un usuario 'user2'
-- Permiso 'Insertar' en la tabla 'order'
-- Permiso de 'Lectura' de productos
-- Permiso 'eliminar' de la tabla 'employees'
-- Permiso 'Actualizacion' a products

-- Crear usuario 2 'user
-- Crear usuario con IP específica
CREATE USER 'user2'@'127.0.0.1' IDENTIFIED BY 'Enter12345';

-- Permiso 'Insertar' en la orders
GRANT INSERT ON Northwind.orders TO 'user2'@'127.0.0.1';

-- Permiso 'lectura' en la products
GRANT SELECT ON Northwind.products TO 'user2'@'127.0.0.1';

-- Permiso 'eliminar' en la employees
GRANT SELECT, DELETE ON Northwind.employees TO 'user2'@'127.0.0.1';

-- Lectura y actualización en products
GRANT SELECT, UPDATE ON Northwind.products  TO 'user2'@'127.0.0.1';


-- Quitar permisos 
-- REVOKE DELECT ON Northwind.produts FROM 'user3'@'localhost';

-- Crear usuario 3 'user'
-- Crear usuario local con permisos mixtos
CREATE USER 'user3'@'localhost' IDENTIFIED BY 'Enter12345';

-- Permisos específicos por columna y tabla
-- Leer (ProductID, productName, Unit) y actualizar (productName, Unit)
GRANT SELECT (ProductID, ProductName, Unit), UPDATE (ProductName, Unit)
ON Northwind.products TO 'user3'@'localhost';
-- Eliminar e insertar en products
GRANT DELETE, INSERT ON Northwind.products TO 'user3'@'localhost';
-- Lectura e inserción en orderdetails
GRANT SELECT, INSERT ON Northwind.orderdetails TO 'user3'@'localhost';





