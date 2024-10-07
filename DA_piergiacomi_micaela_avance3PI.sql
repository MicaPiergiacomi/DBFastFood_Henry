/*AVANCE 3  - MICAELA PIERGIACOMI*/

USE FastFood_DB;

/*1 Total de ventas globales
Pregunta: �Cu�l es el total de ventas (TotalCompra) a nivel global?*/

SELECT SUM (Totalcompra) AS TotalCompraGlobal -- METRICA
FROM ORDENES;

/*2 	Promedio de precios de productos por categor�a
Pregunta: �Cu�l es el precio promedio de los productos dentro de cada categor�a?*/

SELECT	CategoriaID,  -- DIMENSION
		CONVERT (DECIMAL (10,2), AVG (Precio)) AS PrecioPromedioProducto -- METRICA, (SE ACHICA LA CANTIDAD DE DECIMALES TRAIDOS)
FROM Productos
GROUP BY CategoriaID;


/*3	Orden m�nima y m�xima por sucursal
Pregunta: �Cu�l es el valor de la orden m�nima y m�xima por cada sucursal?*/

SELECT  SucursalID,  -- DIMENSION
		MIN (TotalCompra)  AS OrdenMinima,  -- METRICA
		MAX (TotalCompra) AS OrdenMaxima -- METRICA
FROM ORDENES 
GROUP BY SucursalID;


/*4	Mayor n�mero de kil�metros recorridos para entrega
Pregunta: �Cu�l es el mayor n�mero de kil�metros recorridos para una entrega?*/

SELECT MAX (KilometrosRecorrer) AS KmRecorridosMax -- METRICA
FROM Ordenes;

/*5	Promedio de cantidad de productos por orden
Pregunta: �Cu�l es la cantidad promedio de productos por orden?*/

SELECT AVG (Cantidad) AS CantidadPromProdOrden -- METRICA
FROM DetalleOrdenes;

/*6
Total de ventas por tipo de pago
Pregunta: �Cu�l es el total de ventas por cada tipo de pago?*/

SELECT TipoPagoID, SUM (TotalCompra) AS TotalVenta -- METRICA
FROM Ordenes
GROUP BY TipoPagoID;

/*7
Sucursal con la venta promedio m�s alta
Pregunta: �Cu�l sucursal tiene la venta promedio m�s alta?*/

SELECT TOP 1 SucursalID, AVG (TotalCompra) AS VentaPromedio  -- METRICA
FROM Ordenes
GROUP BY SucursalID
ORDER BY VentaPromedio DESC;

/*8	Sucursal con la mayor cantidad de ventas por encima de un umbral
Pregunta: �Cu�les son las sucursales que han generado ventas por orden por encima de $100, y 
c�mo se comparan en t�rminos del total de ventas?*/

SELECT SucursalID, 
	COUNT (OrdenID) AS NumOrdenes, -- METRICA
	SUM (TotalCompra) AS TotalVentas -- METRICA
FROM Ordenes
GROUP BY SucursalID
HAVING SUM(TotalCompra) > 100  AND COUNT(OrdenID) = 5;
-- No hay sucursales que tengan ventas con ordenes por encima de $100

/*9 	Comparaci�n de ventas promedio antes y despu�s de una fecha espec�fica
Pregunta: �C�mo se comparan las ventas promedio antes y despu�s del 1 de julio de 2023?*/

SELECT 
	'Antes del 01-07-2023' AS Periodo, 
	AVG(TotalCompra) AS VentasPromedio -- METRICA
FROM Ordenes
WHERE FechaOrdenTomada < '2023-07-01'
UNION -- Conecta dos consultas
SELECT 
	'Despues del 01-07-2023' AS Periodo, 
	AVG(TotalCompra) AS VentasPromedio -- METRICA
FROM Ordenes
WHERE FechaOrdenTomada >= '2023-07-01'

/*10 	An�lisis de actividad de ventas por horario
Pregunta: �Durante qu� horario del d�a (ma�ana, tarde, noche) se registra la mayor cantidad de ventas, 
cu�l es el valor promedio de estas ventas, y cu�l ha sido la venta m�xima alcanzada?*/

SELECT HorarioVenta,
	COUNT(OrdenID) AS NumVentas,
	AVG(TotalCompra) AS PromedioVentas$,
	MAX (Totalcompra) AS VentaMaxima
FROM Ordenes
GROUP BY HorarioVenta
ORDER BY NumVentas DESC, PromedioVentas$ DESC;
