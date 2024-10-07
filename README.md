## Introducción
El presente informe representa un proyecto dedicado a la creación de una base de datos diseñada para garantizar la escalabilidad y eficiencia en la toma de decisiones. En este proyecto, se propuso desarrollar una base de datos que no solo sea capaz de almacenar el volúmen de información requerida, sino también de proporcionar acceso rápido y seguro a los datos relevantes para la toma de decisiones estratégicas. Con un enfoque en la escalabilidad, se busca asegurar que la base de datos pueda adaptarse y crecer junto con las necesidades cambiantes de la organización, sin comprometer su rendimiento.
En las siguientes secciones, se detallarán los procesos y metodologías utilizados para diseñar, implementar y optimizar la base de datos, así como los resultados obtenidos y las recomendaciones para su uso continuo y mejora.

## Desarrollo del proyecto
En el primer avance, se generó la base de datos utilizando sentencias DDL (Data Definition Language) como CREATE, ALTER y DROP. Se diseñó un esquema relacional que incluyó la creación de tablas, la definición de campos y se establecieron las relaciones, incorporando claves primarias y foráneas a partir del entendimiento del modelo semántico proporcionado.
En el segundo avance comenzó el proceso de poblado de tablas de datos, utilizando sentencias DML (Data Manipulation Language) como INSERT, UPDATE y DELETE, las cuales fueron utilizadas para gestionar la información almacenada en la base de datos. También se realizaron las primeras consultas.
En el tercer avance se llevaron a cabo consultas más avanzadas utilizando funciones de agregación como SUM, COUNT, AVG, MIN y MAX. Se tuvo en cuenta el uso del GROUP BY, ORDER BY y HAVING para estructurar las consultas.
En el cuarto avance, las consultas se tornaron más interesantes al considerar el uso de múltiples tablas en una sola consulta, empleando JOINs, alias y teniendo en cuenta la importancia del orden en la query. Con esta combinación de información, los resultados obtenidos fueron más completos.


## Resultados y consultas
El siguiente esquema relacional se desarrolló a partir de la creación de tablas donde se definieron los campos a analizar y se establecieron las relaciones entre tablas a partir de claves primarias y foráneas.


Debido a la escasez de entradas en las tablas consideradas principales (Tablas Ordenes y DetalleOrdenes) las consultas pueden tornarse poco relevantes. Aquí se presentan los resultados obtenidos de las siguientes consultas.


#### Consulta 1: Eficiencia de los mensajeros:
¿Cuál es el tiempo promedio desde el despacho hasta la entrega de los pedidos por los mensajeros?
A partir de la prompt realizada, se descubrió que el tiempo promedio de despacho a entrega de los pedidos por los mensajeros es 30 minutos. Se utilizó la sentencia DATADIFF en minutos para realizar la diferencia entre horarios de las columnas de la tabla Ordenes. 

Prompt consulta 1 
```sql
SELECT 
    AVG(DATEDIFF(minute, FechaDespacho, FechaEntrega)) AS TiempoPromedioEntrega 
FROM Ordenes;
```

#### Consulta 2: Análisis de Ventas por Origen de Orden: 
 ¿Qué canal de ventas genera más ingresos?
Las ventas realizadas de manera presencial fueron las que más ingresos atrajeron a la empresa por sobre otros canales de venta. 
La consulta 2 fue realizada con el comando JOIN que permitió comparar datos de dos tablas, Ordenes, como principal, y OrigenesOrden. Se realizó la suma de cada venta por cada OrigenOrden, donde los resultados de las sumas de OrdenesOrigen de venta se pidió que ordene los resultados de manera descendiente, y para solo traer el OrigenOrden con mas ingresos se procede a llamar con un TOP 1

Prompt consulta 2 
```sql
	SELECT TOP 1 
	OO.Descripcion,
	SUM(O.TotalCompra) AS TotalCompraPorOrigen 
FROM Ordenes AS O
INNER JOIN OrigenesOrden AS OO ON O.OrigenID = OO.OrigenID
GROUP BY OO.Descripcion
ORDER BY TotalCompraPorOrigen DESC;
```

#### Consulta 3: Productividad de los Empleados: 
¿Cuál es el volumen de ventas promedio gestionado por empleado?
Aclaración: que se consideró volumen de ventas promedio a un volumen de cantidad de órdenes, no de volumen de cantidad de dinero.
El resultado de esta consulta reflejó que cada empleado realizó una única venta.

Prompt consulta 3 
```sql
SELECT 
	E.Nombre AS Empleado,
	COUNT(O.OrdenID) AS VolumenVentas
FROM Ordenes AS O 
INNER JOIN Empleados AS E ON O.EmpleadoID = E.EmpleadoID
GROUP BY E.Nombre
ORDER BY VolumenVentas DESC;
```

#### Consulta 4: Análisis de Demanda por Horario y Día: 
¿Cómo varía la demanda de productos a lo largo del día? 
La única orden que tiene productos asociados es la Nro.1 indicada en la tabla DetalleOrden, y por lo tanto los resultados están únicamente vinculados en el horario de la mañana. La cantidad de productos vendidos a la mañana es de 55.  

Prompt consulta 4
```sql
SELECT 
O.HorarioVenta,
    	SUM(DO.ProductoID) AS DemandaProductos
FROM   DetalleOrdenes AS DO
LEFT JOIN Ordenes AS O ON DO.OrdenID = O.OrdenID
GROUP BY O.HorarioVenta;
```

#### Consulta 5: Comparación de Ventas Mensuales 
¿Cómo se comparan las ventas mensuales de este año con el año anterior?
En el caso de esta consulta, todas las ventas realizadas por la empresa fueron  ejecutadas en el año 2023, por lo tanto no se puede comparar con el año anterior. Se realizó la comparación mes a mes de las ventas del 2023. Da como resultado que en el mes 9 se obtuvo el ingreso mayor. 

Prompt consulta 5
```sql
SELECT YEAR(FechaOrdenTomada) AS periodoAnual, 
	MONTH(fechaOrdenTomada) AS periodoMensual,
	SUM(TotalCompra) AS TotalVentasMensual
FROM Ordenes
GROUP BY YEAR(FechaOrdenTomada), MONTH(FechaOrdenTomada);
```

#### Consulta 6 Análisis de Fidelidad del Cliente
¿Qué porcentaje de clientes son recurrentes versus nuevos clientes cada mes? 
En esta consulta se presenta un desafío, ya que en la tabla de Ordenes solo contiene una única entrada por cliente y con eso no se puede estimular el porcentaje de recurrencia de los mismos.
Prompt consulta 6
```sql
SELECT 
	C.Nombre,
	COUNT(O.ordenID) AS CantidadCompras
FROM Ordenes AS O
INNER JOIN Clientes  AS C on C.ClienteID = O.ClienteID
GROUP BY C.ClienteID, C.Nombre;
```
	
### Nuevas consultas
Considerando la falta de entradas en las Tablas Ordenes y DetalleOrdenes, pero teniendo en cuenta la ventana de análisis que arrojó la consulta 4, se realizaron nuevas consultas.

#### Consulta 7: Análisis de Demanda por Productos: 
Teniendo en cuenta que a la mañana se realizaron más ventas, ¿Cuáles fueron los productos más y menos vendidos ? 
La siguiente búsqueda recopila los datos de la Tabla DetalleOrdenes y con un llamado a las tablas Productos y Ordenes. Nos indica a partir del ORDER BY de la columna demandaProductos con orden descendente, que el producto más vendido fueron los Brownies con 10 unidades vendidas y el menos vendido Hamburguesa Deluxe con 1 unidad vendida.

Prompt consulta 7
```sql
SELECT 
	P.Nombre AS Producto,
    	SUM(DO.ProductoID) AS DemandaProductos
FROM  DetalleOrdenes AS DO
INNER JOIN Ordenes AS O ON DO.OrdenID = O.OrdenID
INNER JOIN Productos AS P ON P.ProductoID = DO.ProductoID
GROUP BY P.Nombre
ORDER BY DemandaProductos DESC;
```

## Recomendaciones estratégicas
Se recomienda reducir el tiempo de entrega mediante la incorporación de más mensajeros o la optimización de la logística en los viajes, ya que se observó que el tiempo de entrega fue similar tanto para viajes de 12,5 km como para viajes de 0,5 km.
Dado que las ventas realizadas de manera presencial generaron la mayor cantidad de ingresos, se sugiere promover otras formas de realización de pedidos mediante promociones.
Se observó que el horario de la mañana generó la menor cantidad de ingresos, por lo que se recomienda implementar promociones en los desayunos para atraer más clientes.
En relación con los empleados, se sugiere organizar un concurso para incentivar la generación de ingresos. 
Para fomentar la fidelidad de los clientes, se podría implementar un programa de fidelización que ofrezca descuentos exclusivos a los miembros del club de fidelidad.

## Optimización y sostenibilidad
Optimizar una base de datos para análisis externos y garantizar su sostenibilidad a largo plazo son procesos fundamentales para asegurar un rendimiento eficiente y duradero. Posibles estrategias:
Optimización para análisis externos:
Realizar un diseño adecuado del esquema de la base de datos. Utilizar un diseño relacional que refleje correctamente la estructura de los datos. Normalizar la base de datos para reducir la redundancia y mejorar la integridad de los datos.

## Garantizar la sostenibilidad a largo plazo:
Documentar la estructura de la base de datos y los procedimientos de mantenimiento. 

## Desafíos y soluciones
El mayor desafío encontrado en esta actividad fue no contar con una base de datos que contuviera un volumen más significativo de datos, aunque no fue esta una limitación. Otro desafío fue que las preguntas de las consultas no fueron del todo claras y se prestaban a diferentes interpretaciones.

## Reflexión personal
Durante este módulo, tuve la oportunidad de familiarizarme con SQL Server. En general, encontré que el contenido impartido fue de alta calidad y bien presentado. Sin embargo, considero que habría sido beneficioso para el proceso de aprendizaje contar con una base de datos más clara y amplia. Los análisis hechos fueron con muy poca información y no se prestaban para descubrir nuevos insights.

