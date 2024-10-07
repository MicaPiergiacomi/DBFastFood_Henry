/*AVANCE 1  - MICAELA PIERGIACOMI*/

-- Creacion de DATABASE para Fast Food de PI
CREATE DATABASE FastFood_DB
ON 
( NAME = 'FastFood_DB_Data',
  FILENAME = 'C:\SQL_DB\DB_PI\FastFood_DB_Data.mdf',
  SIZE = 50MB,
  MAXSIZE = 1GB,
  FILEGROWTH = 5MB )
LOG ON
( NAME = 'FastFood_DB_Log',
  FILENAME = 'C:\SQL_DB\DB_PI\FastFood_DB_Log.ldf',
  SIZE = 25MB,
  MAXSIZE = 256MB,
  FILEGROWTH = 5MB );

-- Utilizacion de DB creada anteriormente

USE FastFood_DB;

-- Creacion de Tablas.

CREATE TABLE Categorias(
	CategoriaID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255));

ALTER TABLE Categorias
ALTER COLUMN Nombre VARCHAR (255) NOT NULL; 

CREATE TABLE Productos(
	ProductoID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (255) NOT NULL,  -- Mandatorio
	CategoriaID INT,
	Precio DECIMAL(10,2) NOT NULL);

CREATE TABLE Ordenes(
	OrdenID INT PRIMARY KEY IDENTITY,
	ClienteID INT,
	EmpleadoID INT,
	SucursalID INT,
	MensajeroID INT,
	TipoPagoID INT,
	OrigenID INT,
	HorarioVenta VARCHAR(50), -- Jornadas: mañana, tarde, noche
	TotalCompra DECIMAL (10,2),
	KilometrosRecorrer DECIMAL (10,2),
	FechaDespacho DATETIME, 
	FechaEntrega DATETIME,
	FechaOrdenTomada DATETIME,
	FechaOrdenLista DATETIME);


CREATE TABLE DetalleOrdenes(
	OrdenID INT,
	ProductoID INT,
	PRIMARY KEY(OrdenID,ProductoID));

-- Creacion de relacion Tablas Productos en tabla DetalleOrden

ALTER TABLE DetalleOrdenes
	ADD CONSTRAINT FK_Producto_DetalleOrden
	FOREIGN KEY(ProductoID) REFERENCES Productos(ProductoID);

-- Se agregan columnas en tabla DetalleOrdenes

ALTER TABLE DetalleOrdenes
	ADD Cantidad INT;

ALTER TABLE DetalleOrdenes
	ADD Precio DECIMAL (10,2) NOT NULL;


------ CREACION DE TABLAS

CREATE TABLE OrigenesOrden(
	OrigenID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR (255));

CREATE TABLE Clientes(
	ClienteID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (255) NOT NULL,
	Direccion VARCHAR (255) NOT NULL);

CREATE TABLE Sucursales(
	SucursalID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (255) NOT NULL,
	Direccion VARCHAR (255) NOT NULL);

CREATE TABLE Empleados(
	EmpleadoID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (255) NOT NULL,
	Posicion VARCHAR (255) NOT NULL,
	Departamento VARCHAR (255) NOT NULL, 
	SucursalID INT,
	Rol VARCHAR (255) NOT NULL);

CREATE TABLE Mensajeros(
	MensajeroID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (255) NOT NULL,
	EsExterno VARCHAR (255) NOT NULL); -- NO SERIA BIT? VALOR 0 Y 1

CREATE TABLE TiposPago(
	TipoPagoID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR (255) NOT NULL);

-- Creacion de relacion Tablas Productos en tabla DetalleOrden

ALTER TABLE Productos
	ADD CONSTRAINT FK_Categoria
	FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_Origen
	FOREIGN KEY (OrigenID) REFERENCES OrigenesOrden(OrigenID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_TipoPago
	FOREIGN KEY (TipoPagoID) REFERENCES TiposPago(TipoPagoID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_Mensajero
	FOREIGN KEY (MensajeroID) REFERENCES Mensajeros(MensajeroID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_Sucursal
	FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_Empleado
	FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID);

ALTER TABLE Ordenes
	ADD CONSTRAINT FK_Cliente
	FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID);

ALTER TABLE Empleados
	ADD CONSTRAINT FK_Sucursal_Empleado
	FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID);

ALTER TABLE DetalleOrdenes
	ADD CONSTRAINT FK_Ordenes
	FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID);