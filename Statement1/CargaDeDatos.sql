USE `CentroDeDatos`;

DROP TABLE IF EXISTS `CentroDeDatos`.`Temporal`;

CREATE TABLE Temporal(
nombre_compania VARCHAR(255) NOT NULL,
contacto_compania VARCHAR(255) NOT NULL,
correo_compania VARCHAR(255) NOT NULL,
telefono_compania VARCHAR(255) NOT NULL,
tipo CHAR(1 CHAR) NOT NULL,
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
character set latin1
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
(nombre_compania,contacto_compania,correo_compania,telefono_compania,
tipo,nombre,correo,telefono,@var1,
direccion,ciudad,codigo_postal,region,
producto,categoria_producto,cantidad,precio_unitario)
set fecha_registro = STR_TO_DATE(@var1, '%d/%m/%Y');
