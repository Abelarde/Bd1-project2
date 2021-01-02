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
/*Mostrar el número de cliente, nombre, apellido y total del cliente que más 
productos ha comprado.*/
    