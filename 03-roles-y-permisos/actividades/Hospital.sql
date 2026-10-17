-- Danna Geraldine Avila Garcia
-- 3 de Abril del 2025
-- 3 Unidad - Particionamiento en PostgreSQL1.

/* 1.- Asignar un Espacio Inicial a la Base de Datos
En PostgreSQL, no se puede definir un tamaño fijo para la base de datos como en SQL Server, 
pero se puede controlar el almacenamiento mediante tablespaces.

Creamos un tablespace para almacenar la base de datos del hospital. */
CREATE TABLESPACE hospital_space LOCATION 'C:\PostgreSQL\Tablespaces\Hospital'
WITH (seq_page_cost=1.0); -- Ajuste de costos de acceso a disco

-- Luego, creamos la base de datos dentro de ese tablespace:
CREATE DATABASE HospitalDB
WITH OWNER postgres -- propiedad del usuario postgres.
TEMPLATE template0 -- es una plantilla especial y limpia en PostgreSQL.
ENCODING 'UTF8' -- estándar de codificación de caracteres permitiendo el almacenamiento y manipulación de caracteres de múltiples idiomas.
TABLESPACE hospital_space;
/* Esto indica que la base de datos se almacenará en el tablespace llamado hospital_space. 
Un tablespace en PostgreSQL es un área de almacenamiento en disco donde se guardan los objetos de la base de datos
Esto permite organizar el almacenamiento en una ubicación específica. */

/* 2.- CREAR LOS ESQUEMAS
Los esquemas ayudan a organizar las tablas y otros objetos de la base de datos */

CREATE SCHEMA administracion;  -- Esquema para la administración del hospital
CREATE SCHEMA pacientes;       -- Esquema para almacenar información de los pacientes
CREATE SCHEMA consulta;        -- Esquema para almacenar registros de consultas médicas

/* 3.- CREAR LAS PARTICIONES
La tabla de citas médicas se particionará por el año de la cita (FechaCita)

Crear la tabla 'Citas' en el esquema 'pacientes', particionada por el rango de fechas */
CREATE TABLE pacientes.Citas (
    CitaID SERIAL,                 -- Identificador único de la cita (con incremento automático)
    PacienteNombre VARCHAR(100),    -- Nombre del paciente
    FechaCita DATE NOT NULL,        -- Fecha de la cita médica
    Medico VARCHAR(100),            -- Nombre del médico
    Especialidad VARCHAR(50),       -- Especialidad del médico
    PRIMARY KEY (CitaID, FechaCita) -- Clave primaria compuesta por CitaID y FechaCita
) PARTITION BY RANGE (FechaCita);  -- La partición se hace por el rango de fechas de las citas

/* 3.1.- DEFINIR INCREMENTO EN LA SECUENCIA PARA CitaID (opcional si se desea un incremento diferente al default)
Crear una secuencia con un incremento específico (por ejemplo, 10) -*-/
CREATE SEQUENCE pacientes.cita_id_seq -- esta es la secuencia que se esta creando dentro del esquema paciente
START 1 -- La secuencia comienza en 1
INCREMENT 10  -- El incremento se establece aquí  el incremento es de 10 en 10 (puedes cambiar el valor según lo necesites)
MAXVALUE 1000;  -- Establece un tope para la secuencia a 1000 */

/* Esto significa que la secuencia generará números de la siguiente forma: 1, 11, 21, 31, ..., 991, 
pero cuando intente generar el siguiente número, el valor será restringido por el MAXVALUE 1000.
Asignar la secuencia al campo CitaID al momento de la creación de la tabla
Esto se hace dentro de la misma definición de la tabla al usar el tipo SERIAL para CitaID

4.- CREAR PARTICIONES PARA AÑOS (2023 y 2024)
Partición para citas del año 2023 */
CREATE TABLE pacientes.Citas_2023
PARTITION OF pacientes.Citas
FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');  -- Citas del 2023

-- Partición para citas del año 2024
CREATE TABLE pacientes.Citas_2024
PARTITION OF pacientes.Citas
FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');  -- Citas del 2024

/* 5.- INSERTAR DATOS
Insertar algunos registros de citas médicas en las particiones correspondientes */

INSERT INTO pacientes.Citas (PacienteNombre, FechaCita, Medico, Especialidad)
VALUES 
    ('Juan Pérez', '2023-05-20', 'Dra. Gómez', 'Cardiología'),
    ('Ana Torres', '2024-03-15', 'Dr. Rodríguez', 'Pediatría'),
    ('Luis Méndez', '2023-10-10', 'Dra. Herrera', 'Neurología');

/* 6.- CONSULTAR LOS DATOS Y MOSTRAR EN QUÉ PARTICIÓN SE ALMACENARON
Consulta para verificar en qué partición se han almacenado las citas médicas */

SELECT CitaID, PacienteNombre, FechaCita, Medico, Especialidad,
       CASE 
           WHEN FechaCita BETWEEN '2023-01-01' AND '2023-12-31' THEN 'Citas_2023'  -- Citas de 2023
           WHEN FechaCita BETWEEN '2024-01-01' AND '2024-12-31' THEN 'Citas_2024'  -- Citas de 2024
           ELSE 'Otra Partición'  -- En caso de que la fecha esté fuera de los rangos
       END AS Particion
FROM pacientes.Citas;  -- Selección de las citas médicas de la base de datos