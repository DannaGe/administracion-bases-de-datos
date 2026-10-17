-- Crear base de datos TiendaOnline con configuraciones por defecto
CREATE DATABASE TiendaOnline;

-- Tabla de Clientes
CREATE TABLE Clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla de Productos
CREATE TABLE Productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    precio NUMERIC(10, 2),
    stock INTEGER
);

-- Insertar clientes
INSERT INTO Clientes (nombre, correo) VALUES
('Ana López', 'ana.lopez@gmail.com'),
('Carlos Ramírez', 'carlos.ramirez@yahoo.com'),
('María Pérez', 'maria.perez@outlook.com');

-- Insertar productos
INSERT INTO Productos (nombre, precio, stock) VALUES
('Huaraches Dama', 499.99, 20),
('Sandalias Caballero', 599.50, 15),
('Tenis Niña', 450.00, 30);

Select * from Productos;
