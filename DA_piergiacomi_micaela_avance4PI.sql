/*AVANCE 4  - MICAELA PIERGIACOMI*/
-- Selecciono la Tabla FastFood_DB

USE FastFood_DB;

/* 1 - Listar todos los productos y sus categorías
Pregunta: ¿Cómo puedo obtener una lista de todos los productos junto con sus categorías?*/

SELECT 
P.Nombre AS Producto,  -- DIMENSION
C.Nombre AS Categoria  -- DIMENSION
FROM Categorias AS C -- TABLA BASE 
INNER JOIN PRODUCTOS AS P -- uso INNER JOIN 
ON  C.CategoriaID = P.CategoriaID; -- UNIFICO CLAVE PRIMARIA Y FORANEA


/* 2 - Obtener empleados y su sucursal asignada
Pregunta: ¿Cómo puedo saber a qué sucursal está asignado cada empleado?*/

SELECT
E.Nombre AS Empleado, -- DIMENSION
S.Nombre AS Sucursal -- DIMENSION
FROM Empleados AS E -- TABLA BASE 
INNER JOIN Sucursales AS S 
ON S.SucursalID = E.SucursalID; -- UNIFICO CLAVE PRIMARIA Y FORANEA


/* 3 - Identificar productos sin categoría asignada
Pregunta: ¿Existen productos que no tienen una categoría asignada?*/

SELECT 
    P.Nombre AS Producto, -- DIMENSION
    C.Nombre AS Categoria -- DIMENSION
FROM 
    Productos AS P -- TABLA BASE 
LEFT JOIN 
    Categorias AS C ON P.CategoriaID = C.CategoriaID -- UNIFICO CLAVE PRIMARIA Y FORANEA
WHERE 
    C.CategoriaID IS NULL;
------
-- No existen productos sin categorias Asignadas

SELECT *
FROM Productos AS P -- TABLA BASE 
RIGHT JOIN 
    Categorias AS C ON P.CategoriaID = C.CategoriaID -- UNIFICO POR CLAVE PRIMARIA Y FORANEA
WHERE 
    C.CategoriaID IS NULL;


/* 4 - Detalle completo de órdenes
Pregunta: ¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo cliente, 
empleado que tomó la orden, y el mensajero que la entregó?*/

SELECT
	O.OrdenID, o.TotalCompra, O.FechaOrdenLista, -- DIMENSION
	C.Nombre AS NombreCliente,-- DIMENSION
	E.Nombre AS NombreEmpleado,-- DIMENSION
	M.Nombre AS NombreMensajero,-- DIMENSION
	OO.Descripcion AS Origen,-- DIMENSION
	TP.Descripcion AS TipodePago-- DIMENSION
FROM Ordenes AS O -- TABLA BASE
INNER JOIN Clientes AS C ON c.ClienteID = o.ClienteID
INNER JOIN Empleados AS E ON e.EmpleadoID = o.EmpleadoID
INNER JOIN Mensajeros AS M ON m.MensajeroID = o.MensajeroID
INNER JOIN OrigenesOrden AS OO ON OO.OrigenID = O.OrigenID
INNER JOIN TiposPago AS TP ON TP.TipoPagoID = O.TipoPagoID; -- UNIFICO TABLAS A TRAVES DE CLAVES PRIMARIAS Y FORANEAS


/* 5 - Productos vendidos por sucursal
Pregunta: ¿Cuántos productos de cada tipo se han vendido en cada sucursal?*/

SELECT 
	P.Nombre AS Producto, -- DIMENSION
	S.Nombre AS Sucursal, -- DIMENSION
		SUM (DO.Cantidad) AS Cantidad -- METRICA CAMPO CANTIDAD DE LA TABLA DETALLEORDENES
FROM DetalleOrdenes AS DO
INNER JOIN Ordenes AS O ON DO.OrdenID = O.OrdenID
INNER JOIN Productos AS P ON DO.ProductoID = P.ProductoID 
INNER JOIN Sucursales AS S ON S.SucursalID = O.SucursalID -- UNIFICO TABLAS A TRAVES DE CLAVES PRIMARIAS Y FORANEAS
GROUP BY P.Nombre, S.Nombre

/* Se sumaria la cantidad de articulos vendidos por productos y sucursal*/