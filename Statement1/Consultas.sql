USE `CentroDeDatos`;

-- ---------------------------- CONSULTA 1 -----------------------------------
/*Mostrar el número de cliente, nombre, apellido y total del cliente que más 
productos ha comprado.*/

SELECT SUM(Comodin1.TotalProducto) AS Total,
Persona_Tipo.idPersona_Tipo AS codigo, 
Persona.nombre
FROM
	(((SELECT SUM(DET.cantidad) as TotalProducto, DET.idTransaccion
	FROM DetalleTransaccion AS DET
	GROUP BY DET.idTransaccion) AS Comodin1 INNER JOIN Transaccion
    ON Comodin1.idTransaccion = Transaccion.idTransaccion) INNER JOIN Persona_Tipo
    ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo) INNER JOIN Persona
    ON Persona_Tipo.idPersona = Persona.idPersona
    WHERE Persona_Tipo.idTipo = 1
    GROUP BY Persona_Tipo.idPersona_Tipo
    ORDER BY Total DESC
    LIMIT 1;
    

-- ---------------------------- CONSULTA 2 -----------------------------------
/*Mostrar el número de mes de la fecha de registro, nombre y apellido de 
todos los clientes que más han comprado y los que menos han comprado (en dinero) 
utilizando una sola consulta.*/

(SELECT SUM(Comodin1.subtotal) AS Total, Comodin1.nombre, EXTRACT(MONTH FROM Comodin1.fechaRegistro)
FROM
	(SELECT SUM(DetalleTransaccion.cantidad*Producto.precio) as subtotal,
	Persona.nombre, Persona_Tipo.fechaRegistro
	FROM DetalleTransaccion
	INNER JOIN Producto
	ON DetalleTransaccion.idProducto = Producto.idProducto
	INNER JOIN Transaccion 
	ON DetalleTransaccion.idTransaccion = Transaccion.idTransaccion
	INNER JOIN Persona_Tipo 
	ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
	INNER JOIN Persona 
	ON Persona_Tipo.idPersona = Persona.idPersona
    WHERE Persona_Tipo.idTipo = 1
	GROUP BY DetalleTransaccion.idTransaccion) AS Comodin1
	GROUP BY Comodin1.nombre, Comodin1.fechaRegistro
    ORDER BY Total DESC
    LIMIT 5)

UNION

(SELECT SUM(Comodin1.subtotal) AS Total, Comodin1.nombre, EXTRACT(MONTH FROM Comodin1.fechaRegistro)
FROM
	(SELECT SUM(DetalleTransaccion.cantidad*Producto.precio) as subtotal,
	Persona.nombre, Persona_Tipo.fechaRegistro
	FROM DetalleTransaccion
	INNER JOIN Producto
	ON DetalleTransaccion.idProducto = Producto.idProducto
	INNER JOIN Transaccion 
	ON DetalleTransaccion.idTransaccion = Transaccion.idTransaccion
	INNER JOIN Persona_Tipo 
	ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
	INNER JOIN Persona 
	ON Persona_Tipo.idPersona = Persona.idPersona
    WHERE Persona_Tipo.idTipo = 1
	GROUP BY DetalleTransaccion.idTransaccion) AS Comodin1
	GROUP BY Comodin1.nombre, Comodin1.fechaRegistro
    ORDER BY Total ASC
    LIMIT 5);


-- ---------------------------- CONSULTA 3 -----------------------------------
/*Mostrar el top 5 de proveedores que más productos han vendido (en dinero) de 
la categoría de productos ‘Fresh Vegetables’.*/
    
SELECT SUM(Comodin1.subTotal) AS Total,
Persona.nombre
FROM  
	(SELECT  DetalleTransaccion.idTransaccion, SUM(DetalleTransaccion.cantidad*Producto.precio) AS subTotal
	FROM DetalleTransaccion
	INNER JOIN Producto
	ON DetalleTransaccion.idProducto = Producto.idProducto
	INNER JOIN CategoriaProducto
	ON Producto.idCategoriaProducto = CategoriaProducto.idCategoriaProducto
	WHERE CategoriaProducto.nombre = 'Fresh Vegetables'
	GROUP BY DetalleTransaccion.idTransaccion) AS Comodin1 
	INNER JOIN Transaccion 
	ON Comodin1.idTransaccion = Transaccion.idTransaccion
	INNER JOIN Persona_Tipo 
	ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
	INNER JOIN Persona 
	ON Persona_Tipo.idPersona = Persona.idPersona
    WHERE Persona_Tipo.idTipo = 2
    GROUP BY Persona.nombre
    LIMIT 5;

-- ---------------------------- CONSULTA 4 -----------------------------------
/*Mostrar el nombre del proveedor, número de teléfono, número de orden, total 
de la orden por la cual se haya obtenido la menor cantidad de producto.*/    

SELECT Comodin1.idTransaccion, Comodin1.totalProductos, Comodin1.totalDineroDeLaTransaccion,
Persona.nombre, Persona.telefono
FROM
(SELECT DetalleTransaccion.idTransaccion, SUM(DetalleTransaccion.cantidad) AS totalProductos, SUM(DetalleTransaccion.cantidad*Producto.precio) AS totalDineroDeLaTransaccion
FROM DetalleTransaccion
INNER JOIN Producto
ON DetalleTransaccion.idProducto = Producto.idProducto
GROUP BY DetalleTransaccion.idTransaccion) AS Comodin1 INNER JOIN Transaccion
ON Comodin1.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Persona 
ON Persona_Tipo.idPersona = Persona.idPersona
WHERE Persona_Tipo.idTipo = 2
ORDER BY Comodin1.totalProductos, Comodin1.totalDineroDeLaTransaccion
LIMIT 14;


-- ---------------------------- CONSULTA 5 -----------------------------------
/*Mostrar el top 10 de los clientes que más productos han comprado de la categoría ‘Seafood’.*/ 

SELECT * FROM DetalleTransaccion;

SELECT SUM(Comodin1.totalProducto) AS total,
Persona.nombre
FROM
	(SELECT DetalleTransaccion.idTransaccion, SUM(DetalleTransaccion.cantidad) totalProducto,
	CategoriaProducto.nombre
	FROM DetalleTransaccion
	INNER JOIN Producto
	ON DetalleTransaccion.idProducto = Producto.idProducto
	INNER JOIN CategoriaProducto
	ON Producto.idCategoriaProducto = CategoriaProducto.idCategoriaProducto
	WHERE CategoriaProducto.nombre = 'Seafood'
	GROUP BY DetalleTransaccion.idTransaccion, CategoriaProducto.nombre
	ORDER BY totalProducto DESC) AS Comodin1 
	INNER JOIN Transaccion 
	ON Comodin1.idTransaccion = Transaccion.idTransaccion
	INNER JOIN Persona_Tipo 
	ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
	INNER JOIN Persona 
	ON Persona_Tipo.idPersona = Persona.idPersona
    WHERE Persona_Tipo.idTipo = 1
    GROUP BY Persona.nombre
    ORDER BY total DESC
	LIMIT 10;

-- ---------------------------- CONSULTA 6 -----------------------------------
/*Mostrar el porcentaje de clientes que le corresponden a cada región.*/ 


SELECT COUNT(Region.nombre) AS totalRegion, (COUNT(Region.nombre)/91)*100 AS Porcentaje,
Region.nombre
FROM Persona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
INNER JOIN Region
ON Ciudad.idCiudad = Region.idRegion
WHERE Persona_Tipo.idTipo = 1
GROUP BY Region.nombre;

-- ---------------------------- CONSULTA 7 -----------------------------------
/*Mostrar las ciudades en donde más se consume el 
producto “Tortillas” de la categoría “Refrigerated Items”.*/ 

SELECT SUM(Comodin1.cantidad) AS Total,
Ciudad.nombre
FROM
(SELECT DetalleTransaccion.idTransaccion, DetalleTransaccion.cantidad,
Producto.nombre AS ProductoNombre, CategoriaProducto.nombre AS CategoriaNombre
FROM DetalleTransaccion
INNER JOIN Producto
ON DetalleTransaccion.idProducto = Producto.idProducto
INNER JOIN CategoriaProducto
ON Producto.idCategoriaProducto = CategoriaProducto.idCategoriaProducto
WHERE Producto.nombre = 'Tortillas' AND CategoriaProducto.nombre = 'Refrigerated Items') AS Comodin1
INNER JOIN Transaccion
ON Comodin1.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
WHERE Persona_Tipo.idTipo = 1
GROUP BY Ciudad.nombre
ORDER BY Total DESC;


-- ---------------------------- CONSULTA 8 -----------------------------------
/*Mostrar la cantidad de clientes que hay en las ciudades agrupadas 
por su letra inicial, es decir, agrupar las ciudades con A y mostrar 
la cantidad de clientes, lo mismo para las que inicien con B y así sucesivamente.*/ 

SELECT COUNT(Ciudad.nombre) AS totalEnCiudad,
UPPER(LEFT(Ciudad.nombre, 1)) AS first_char 
FROM Persona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
WHERE Persona_Tipo.idTipo = 1
GROUP BY first_char
ORDER BY first_char;


-- ---------------------------- CONSULTA 9 -----------------------------------
/*Mostrar el porcentaje de las categorías más vendidas de cada
ciudad de la siguiente manera: Ciudad, Categoría, Porcentaje De Mercado*/ 

SELECT ComodinA.CantidadProductosDeEsaCategoria, ComodinA.CATNO, ComodinA.CINO, ComodinA.CIID,
ComodinB.Denominador, (ComodinA.CantidadProductosDeEsaCategoria/ComodinB.Denominador)*100 AS Porcentaje
FROM
(SELECT SUM(DetalleTransaccion.cantidad) AS CantidadProductosDeEsaCategoria,
CategoriaProducto.nombre AS CATNO, Ciudad.nombre AS CINO, Ciudad.idCiudad AS CIID
FROM DetalleTransaccion
INNER JOIN Producto
ON DetalleTransaccion.idProducto = Producto.idProducto
INNER JOIN CategoriaProducto
ON Producto.idCategoriaProducto = CategoriaProducto.idCategoriaProducto
INNER JOIN Transaccion
ON DetalleTransaccion.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
WHERE Persona_Tipo.idTipo = 1
GROUP BY CategoriaProducto.nombre, Ciudad.nombre, Ciudad.idCiudad
ORDER BY Ciudad.nombre) AS ComodinA

INNER JOIN 

(SELECT SUM(Comodin1.CantidadProductosDeEsaCategoria) AS Denominador, Comodin1.CI
FROM
(SELECT SUM(DetalleTransaccion.cantidad) AS CantidadProductosDeEsaCategoria,
CategoriaProducto.nombre, Ciudad.idCiudad AS CI
FROM DetalleTransaccion
INNER JOIN Producto
ON DetalleTransaccion.idProducto = Producto.idProducto
INNER JOIN CategoriaProducto
ON Producto.idCategoriaProducto = CategoriaProducto.idCategoriaProducto
INNER JOIN Transaccion
ON DetalleTransaccion.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
WHERE Persona_Tipo.idTipo = 1
GROUP BY CategoriaProducto.nombre, Ciudad.idCiudad
ORDER BY Ciudad.nombre) AS Comodin1
GROUP BY Comodin1.CI) AS ComodinB
ON ComodinA.CIID = ComodinB.CI;


-- ---------------------------- CONSULTA 10 -----------------------------------
/*Mostrar los clientes que hayan consumido más que el promedio que consume 
la ciudad de Frankfort.*/ 
-- ComodinA.idTransaccion,
-- no me dice si de dinero, cantidad de productos, para Clientes y para Frankfort

SELECT ComodinC.cliente, ComodinC.promedioCliente, ComodinB.promedioFrankfort
FROM
(SELECT Persona.nombre as cliente, AVG(ComodinA.totalProductos) promedioCliente
FROM
(SELECT DetalleTransaccion.idTransaccion AS idTransaccion, SUM(DetalleTransaccion.cantidad) AS totalProductos
FROM DetalleTransaccion
GROUP BY DetalleTransaccion.idTransaccion) AS ComodinA
INNER JOIN Transaccion
ON ComodinA.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Persona 
ON Persona_Tipo.idPersona = Persona.idPersona
WHERE Persona_Tipo.idTipo = 1
GROUP BY cliente) AS ComodinC,

(SELECT AVG(ComodinA.totalProductos) promedioFrankfort, Ciudad.nombre AS nombreFrankfort
FROM
(SELECT DetalleTransaccion.idTransaccion AS idTransaccion, SUM(DetalleTransaccion.cantidad) AS totalProductos
FROM DetalleTransaccion
GROUP BY DetalleTransaccion.idTransaccion) AS ComodinA
INNER JOIN Transaccion
ON ComodinA.idTransaccion = Transaccion.idTransaccion
INNER JOIN Persona_Tipo 
ON Transaccion.idPersona_Tipo = Persona_Tipo.idPersona_Tipo
INNER JOIN Direccion
ON Persona_Tipo.idDireccion = Direccion.idDireccion
INNER JOIN CodigoPostal
ON Direccion.idDireccion = CodigoPostal.idDireccion
INNER JOIN Ciudad
ON CodigoPostal.idCiudad = Ciudad.idCiudad
WHERE Persona_Tipo.idTipo = 1 AND Ciudad.nombre = 'Frankfort'
GROUP BY nombreFrankfort) AS ComodinB
WHERE ComodinC.promedioCliente > ComodinB.promedioFrankfort;



