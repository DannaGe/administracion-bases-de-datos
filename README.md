# Administración de Bases de Datos

Prácticas de administración de bases de datos con SQL Server, MySQL y PostgreSQL:
espacio y particionamiento, seguridad, índices, respaldo y contenedores con Docker.
Instituto Tecnológico de Jiquilpan – Ingeniería en Sistemas Computacionales (2025)

## Contenido

### 01-docker
Despliegue de bases de datos con contenedores: MySQL, PostgreSQL con pgAdmin y
una aplicación Node.js conectada a MySQL, con Docker Compose.

### 02-espacio-y-particionamiento
- **Administración de espacio** en SQL Server: creación de la base de datos
  Banco con archivos de datos y de registro.
- **Particionamiento horizontal** en SQL Server (base Empresa).
- **Fragmentación de tablas e inserción masiva de datos (Bulk)** en SQL Server
  (base Pedidos).
- **Tablespaces y particionamiento** en PostgreSQL (base Hospital).

### 03-roles-usuarios-y-permisos
Creación de usuarios, roles y permisos en MySQL y SQL Server: usuario
administrador, usuario invitado, procedimientos almacenados con acceso
controlado.

### 04-indices-y-mantenimiento
Índices en PostgreSQL y SQL Server, inserción de un millón de registros para
comparar el rendimiento y log de transacciones.

### 05-respaldo-y-recuperacion
Respaldo y restauración de bases de datos en SQL Server y PostgreSQL.

## Cómo usarlo
Los scripts usan la base de datos de ejemplo Northwind. Para las prácticas de
Docker, copia `.env.example` como `.env`, cambia las contraseñas y ejecuta
`docker compose up`.

## Tecnologías
SQL Server · MySQL · PostgreSQL · Docker · Docker Compose · Node.js · T-SQL