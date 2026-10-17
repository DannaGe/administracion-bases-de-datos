-- Danna Geraldine Avila Garcia 
-- 26 de Marzo del 2025
-- 3 Unidad
-- Práctica 3.1 Administrador de espacio

-- Crear la base de datos
create database Banco
ON Primary
(
	Name = 'Banco_dat',
	Filename = 'C:\Banco\Primary\Banco_dat.mdf',
	size = 5MB, --1GB, 5GB, 1 TB
	maxsize = 22MB,
	filegrowth = 1MB
),
FILEGROUP Banco_FG2
(
	Name = 'Banco_sec1', -- Nombre logico sirve para ubicarlo en la base de datos
	Filename = 'C:\Banco\Banco_FG2\Banco_sec1.ndf',
	size = 5MB, --1GB, 5GB, 1 TB
	maxsize = 914MB,
	filegrowth = 1MB
),
FILEGROUP Banco_FG3
(
	Name = 'Banco_sec2',
	Filename = 'C:\Banco\Banco_FG3\Banco_sec2.ndf',
	size = 5MB, --1GB, 5GB, 1 TB
	maxsize = 914MB,
	filegrowth = 1MB
),
FILEGROUP Banco_FG4
(
	Name = 'Banco_sec3',
	Filename = 'C:\Banco\Banco_FG4\Banco_sec3.ndf',
	size = 5MB, --1GB, 5GB, 1 TB
	maxsize = 914MB,
	filegrowth = 1MB
)
LOG ON
(
	Name = 'Banco_log',
	Filename = 'C:\Banco\Log\Banco_log.log',
	size = 2MB, --1GB, 5GB, 1 TB
	maxsize = 830MB,
	filegrowth = 1MB
)

-- Usar la base de datos
use Banco
-- Espacio total libre de la base de datos
exec sp_spaceused
-- Rutas, archivos fisicos, tamaño, uso y filegroups
exec sp_helpdb Banco;

-- Para ver informacion de cada archivo logico de la base de datos
exec sp_helpfilegroup 'Primary';

-- ======================================================================================
-- Esquemas de la base de datos banco 
-- ======================================================================================

-- Cuenta
create schema Account authorization dbo
go

-- Sucursales o Ramas
create schema Branch authorization dbo
go

-- Pagos
create schema Payments authorization dbo
go

-- Cargos
create schema Charges authorization dbo
go

-- Para ver los esquemas 
select * from sys.schemas where principal_id = 1;

-- ================================================================================
-- Particionamiento (Fragmentación) de tablas
-- ================================================================================

-- 1.- Crear la funcion de partición
--     Aplicar en la tabla de operaciones de acuerdo a la fecha
--     Crear 3 cuatrimestres
create partition function pf_cuatrimestre(date)
as range left for values ('2024-04-30', '2024-08-31', '2025-12-31') -- left incluye el limite superior

-- 2.- Crear el esquema de particion
create partition scheme ps_cuatrimestre
as  partition pf_cuatrimestre
to (Banco_FG2, Banco_FG3, Banco_FG4, "Primary")
go


-- ================================================================================
-- Tablas de la base de datos, asignadas a esquemas y filegroups
-- ================================================================================

-- Sucursal
create table Branch.Sucursal(
	idSucursal int not null,
	nombre varchar(50) not null,
	direccion varchar(60) not null,
	activo float default 0,
	ciudad varchar(20) not null,
	constraint pk_idSucursal primary key(idSucursal),
	constraint chk_activo check(activo >= 0)
) on Banco_FG2;

--Creacion del esquema de particionamiento
-- URL: https://www.gpsos.es/2019/04/particionamiento-de-tablas-e-indices-t-sql-en-sql-server/
--Paso 1: Creacion de la funcion de particion

/*==============================================================*/
/* Table: Cliente                                               */
/*==============================================================*/
create table Branch.Cliente (
   NoCliente            int                  not null,
   Nombre               varchar(50)          not null,
   Direccion            varchar(60)          null,
   Telefono             char(12)             not null,
   email                varchar(60)          not null,
   claveIFE             varchar(15)          null,
   idSucursal			int					 not null,
   constraint PK_CLIENTE primary key (NoCliente),
   constraint chk_email check (email like '%@%.%'),
   constraint chk_telefono check
   (telefono like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-
   [0-9][0-9][0-9][0-9]'),
   constraint fk_suc_cte foreign key (idSucursal)
   references Branch.Sucursal (idSucursal) 
)  on Banco_FG2;



/*==============================================================*/
/* Table: CatPrestamo                                           */
/*==============================================================*/
create table Payments.CatPrestamo (
   idTipoPrest          int                  not null,
   importe              float                not null,
   interes              float                not null,
   meses                int                  not null,
   mensualidad          as					 
   ((1+(interes/100))*importe)/meses,
   constraint PK_CATPRESTAMO primary key (idTipoPrest),
   constraint chk_importe check (importe>0),
   constraint chk_interes check (interes>0)
)  on Banco_FG3;


/*==============================================================*/
/* Table: Cuenta                                                */
/*==============================================================*/
create table Account.Cuenta (
   NoCuenta             int                  not null,
   NoCliente            int                  not null,
   Saldo                float                not null default 0,
   Fecha                date                 
   not null default getdate(),
   idsucursal           int                  not null,
   saldoMin             float                not null,
   constraint PK_CUENTA primary key (NoCuenta),
   constraint chk_saldo check (saldo>=0),
   constraint fk_cuen_clien foreign key (NoCliente)
   references Branch.Cliente (NoCliente),
   constraint fk_suc_cuenta foreign key (idsucursal)
   references Branch.Sucursal (idsucursal)
)  on "Primary";


/*==============================================================*/
/* Table: Operaciones                                           */
/*==============================================================*/
create table Account.Operaciones (
   folio                int                  not null,
   NoCuenta             int                  not null,
   Cantidad             float                not null,
   TOpr                 char                 not null,
   Fecha                date                 
   not null default getdate(),
   Hora                 time                 
   not null default getdate(),
   constraint pk_operaciones primary key(folio,fecha),
   constraint chk_cantidad check (Cantidad>0),
   constraint chk_topr check (TOpr in('R','D')),
   constraint fk_oper_cuenta foreign key (NoCuenta)
   references Account.Cuenta (NoCuenta)
)  on ps_cuatrimestre(Fecha);


/*==============================================================*/
/* Table: Prestamo                                              */
/*==============================================================*/
create table Payments.Prestamo (
   noPrestamo           int                  not null,
   nocliente            int                  not null,
   idsucursal           int                  not null,
   idTipoPrest          int                  not null,
   fecha                date                 
   not null default getdate(),
   cantPagada           float                not null,
   cantPagar            float                not null,
   diaPago              as                   datepart(dd,fecha),
   estatus              char                 not null,
   constraint pk_prestamo primary key (noPrestamo),
   constraint chk_cantPagar check (cantPagar>=0),
   constraint chk_cantPagada check (cantPagada>=0),
   constraint chk_estatusp check(estatus in('P','C')),
   constraint fk_prestamo_sucursal foreign key (idsucursal)
   references Branch.Sucursal (idsucursal),
   constraint fk_prestamo_catPrestamo foreign key (idTipoPrest)
   references Payments.CatPrestamo (idTipoPrest) ,
   constraint fk_prest_cliente foreign key (nocliente)
   references Branch.Cliente (NoCliente)
)  on Banco_FG3;



/*==============================================================*/
/* Table: Tarjeta                                               */
/*==============================================================*/
create table Account.Tarjeta (
   NoTarjeta            int                  not null,
   FechaExp             date                 default getdate(),
   FechaVen             as                  
    dateadd(YEAR,5,fechaExp),
   nocuenta             int                  not null,
   nip                  char(4)              null default '1111',
   estatus				char				 not null default 'A',
   costo				int					 not null default 150,
   constraint pk_tarjeta primary key (NoTarjeta),
   constraint chk_check_st_tar check(estatus in('A','B','C')),
   constraint chk_nip check (nip like '[0-9][0-9][0-9][0-9]'),
   constraint fk_cuenta_tarjeta foreign key (nocuenta)
   references Account.Cuenta (NoCuenta)
)  on "Primary";


/*==============================================================*/
/* Table: Transferencia                                         */
/*==============================================================*/
create table Account.Transferencia(
   folio                int                  not null,
   NoCuentaOri          int                  not null,
   NoCuentaDes          int                  not null,
   fecha                date				 
   not null default getdate(),
   hora                 time         		
    not null default getdate(),
   cantidad             float                not null,
   constraint pk_transferencias primary key (folio,fecha),
   constraint chk_can_trans check (cantidad>0),
   constraint chk_cuentas check (NoCuentaOri<>NoCuentaDes),
   constraint fk_transfer_cuentaOri foreign key (NoCuentaOri)
   references Account.Cuenta (NoCuenta),
   constraint fk_transfer_cuentaDes foreign key (NoCuentaDes)
   references Account.Cuenta (NoCuenta)
)  on ps_cuatrimestre(fecha);


/*==============================================================*/
/* Table: pagos                                                 */
/*==============================================================*/
create table Payments.pagos (
   folio                int                  not null,
   noPrestamo           int                  not null,
   fecha                date                 
   not null default getdate(),
   importe              float                not null,
   constraint pk_pagos primary key (folio,fecha),
   constraint chk_imp_pago check (importe>0),
   constraint fk_pagos_prestamo foreign key (noPrestamo)
   references Payments.Prestamo (noPrestamo)
)  on ps_cuatrimestre(fecha);


/*==============================================================*/
/* Table: TipoComisiones                                            */
/*==============================================================*/
create table Charges.TipoComisiones(
   idTipoCom           int				    not null,
   nombre              varchar(60)			not null,
   descrip             varchar(60)          not null,
   porComision		   int					not null,
   constraint pk_comisiones primary key (idTipoCom),
   constraint chk_por_comision check (porComision>0) 
)  on Banco_FG4;


/*==============================================================*/
/* Table: Comisiones                                            */
/*==============================================================*/
create table Charges.comisiones(
	idcomision      int				  not null,
	fecha           date              not null default getdate(),
	importe         float			  not null,
	folioOperacion  int				  not null,
	idTipoCom		int				  not null,
	idSucursal		int				  not null,
	constraint fk_tipos_com foreign key(idTipoCom) 
	references Charges.TipoComisiones(idTipoCom),
	constraint chk_importe_com check(importe>0),    
	constraint fk_com_suc foreign key(idsucursal) 
	references branch.sucursal (idsucursal),
	constraint pk_comisiones_ap primary key(idComision)
)   on Banco_FG4;

