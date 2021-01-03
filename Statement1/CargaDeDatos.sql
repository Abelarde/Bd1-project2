USE `CentroDeDatos`;

DROP TABLE IF EXISTS `CentroDeDatos`.`Temporal`;
CREATE TABLE Temporal(
nombre_compania VARCHAR(255) NOT NULL,
contacto_compania VARCHAR(255) NOT NULL,
correo_compania VARCHAR(255) NOT NULL,
telefono_compania VARCHAR(255) NOT NULL,
tipo CHAR(1) NOT NULL,
nombre VARCHAR(255) NOT NULL,
correo VARCHAR(255) NOT NULL,
telefono VARCHAR(255) NOT NULL,
fecha_registro DATE NOT NULL,
direccion VARCHAR(255) NOT NULL,
ciudad VARCHAR(255) NOT NULL,
codigo_postal INT NOT NULL,
region VARCHAR(255) NOT NULL,
producto VARCHAR(255) NOT NULL,
categoria_producto VARCHAR(255) NOT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL
);

LOAD DATA INFILE '/var/lib/mysql-files/Enunciado1.csv'
INTO TABLE Temporal
character set latin1 -- 'utf8' 'utf8mb4'
fields terminated by ';' -- optionally enclosed by '\''
lines terminated by '\n'
ignore 1 lines
(nombre_compania,contacto_compania,correo_compania,telefono_compania,
tipo,nombre,correo,telefono,@var1,
direccion,ciudad,codigo_postal,region,
producto,categoria_producto,cantidad,precio_unitario)
set fecha_registro = STR_TO_DATE(@var1, '%d/%m/%Y');

/*
set nomb_encuesta = nullif(@nomb_encuesta, ''),
	res_posible = nullif(@res_posible, ''),
    r1 = nullif(@r1, '')
    ;
*/

-- --------------------------------- REGION ----------------------------------------
INSERT INTO Region(nombre)
SELECT DISTINCT region
FROM Temporal
ORDER BY region;

-- ----------------------------- CATEGORIA_PRODUCTO --------------------------------
INSERT INTO CategoriaProducto(nombre)
SELECT DISTINCT categoria_producto
FROM Temporal
ORDER BY categoria_producto;

-- --------------------------------- COMPANIA ----------------------------------------
INSERT INTO Compania(nombre, contacto, correo, telefono)
SELECT DISTINCT nombre_compania,contacto_compania,correo_compania,telefono_compania
FROM Temporal
ORDER BY nombre_compania;

-- --------------------------------- PRODUCTO ----------------------------------------
INSERT INTO Producto(nombre, precio, idCategoriaProducto)
SELECT DISTINCT TE.producto, TE.precio_unitario, CA.idCategoriaProducto
FROM Temporal AS TE, CategoriaProducto AS CA
WHERE TE.categoria_producto = CA.nombre
ORDER BY producto;

-- --------------------------------- CIUDAD ----------------------------------------
INSERT INTO Ciudad(nombre, idRegion)
SELECT DISTINCT T.ciudad, R.idRegion -- union or join -- 2 sentencias -- al final solo una tabla
FROM Temporal AS T, Region AS R
WHERE T.region = R.nombre
ORDER BY T.ciudad;

-- --------------------------------- DIRECCION ----------------------------------------
INSERT INTO Direccion(nombre)
SELECT DISTINCT direccion -- union or join -- 2 sentencias -- al final solo una tabla
FROM Temporal 
ORDER BY direccion;

-- --------------------------------- CODIGO POSTAL ----------------------------------------
INSERT INTO CodigoPostal(nombre, idCiudad, idDireccion)
SELECT DISTINCT T.codigo_postal, C.idCiudad, D.idDireccion -- union or join -- 2 sentencias -- al final solo una tabla
FROM Temporal AS T, Ciudad AS C, Direccion AS D
WHERE T.ciudad = C.nombre AND T.direccion = D.nombre
ORDER BY T.codigo_postal;

-- --------------------------------- PERSONA ----------------------------------------
INSERT INTO Persona(nombre, correo, telefono)
SELECT DISTINCT TE.nombre, TE.correo, TE.telefono
FROM Temporal AS TE
ORDER BY nombre;

-- --------------------------------- TIPO ----------------------------------------
INSERT INTO Tipo(nombre)
SELECT DISTINCT tipo
FROM Temporal
ORDER BY tipo;

-- --------------------------------- PERSONA_TIPO ----------------------------------------
INSERT INTO Persona_Tipo(fechaRegistro, idDireccion, idTipo, idPersona)
SELECT DISTINCT T.fecha_registro, D.idDireccion, TI.idTipo, P.idPersona  -- union or join -- 2 sentencias -- al final solo una tabla
FROM Temporal AS T, Tipo AS TI, Persona AS P, Direccion AS D
WHERE T.tipo =  TI.nombre AND T.nombre = P.nombre AND T.direccion = D.nombre;
-- ORDER BY TI.idTipo, P.idPersona;

-- -------------------------------- TRANSACCION -----------------------------------
INSERT INTO Transaccion(idCompania, idPersona_Tipo)
SELECT DISTINCT CO.idCompania, PE_TI.idPersona_Tipo
FROM Temporal AS TE, Compania AS CO, Persona_Tipo AS PE_TI
WHERE TE.nombre_compania = CO.nombre AND 
	PE_TI.idTipo = 
	(SELECT TI.idTipo
	FROM Tipo AS TI
    WHERE TE.tipo = TI.nombre) 
    AND 
    PE_TI.idPersona =
    (SELECT PE.idPersona
    FROM Persona AS PE
    WHERE TE.nombre = PE.nombre);

-- --------------------------------- DETALLEORDEN ----------------------------------------
INSERT INTO DetalleTransaccion(cantidad, idProducto, idTransaccion)
SELECT TE.cantidad, PR.idProducto, TR.idTransaccion
FROM Temporal AS TE, Producto AS PR, Transaccion AS TR
WHERE TE.producto = PR.nombre AND 
	TR.idCompania = 
	(SELECT CO.idCompania
	FROM Compania AS CO
    WHERE TE.nombre_compania = CO.nombre) 
    AND 
    TR.idPersona_Tipo =
    (SELECT PE_TI.idPersona_Tipo
    FROM Persona_Tipo AS PE_TI
    WHERE PE_TI.idTipo = 
	(SELECT TI.idTipo
	FROM Tipo AS TI
    WHERE TE.tipo = TI.nombre) 
    AND 
    PE_TI.idPersona =
    (SELECT PE.idPersona
    FROM Persona AS PE
    WHERE TE.nombre = PE.nombre));
    
/*
(SELECT TR.idTransaccion
FROM Transaccion AS TR, Temporal AS TE
WHERE TR.idCompania = 
	(SELECT CO.idCompania
	FROM Compania AS CO
    WHERE TE.nombre_compania = CO.nombre) 
    AND 
    TR.idPersona =
    (SELECT PE.idPersona
    FROM Persona AS PE
    WHERE TE.nombre = PE.nombre ))
*/    



