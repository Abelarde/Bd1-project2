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


    