USE `CPM`;


-- ---------------------------- CONSULTA 1 -----------------------------------
/*Desplegar el nombre de cada jefe seguido de todos sus subalternos, para todos
los profesionales ordenados por el jefe alfabéticamente.*/

SELECT Comodin1.ar AS AREA, Profesional.nombre AS JEFE, Comodin1.subalterno 
FROM
(SELECT AreaInvestigacion.nombre AS ar, 
AreaInvestigacion.Profesional_idProfesionalJefe AS jefe,
Profesional.nombre  AS subalterno
FROM ProfesionalAreaInvestigacion
INNER JOIN Profesional
ON ProfesionalAreaInvestigacion.Profesional_idProfesional = Profesional.idProfesional
INNER JOIN AreaInvestigacion
ON ProfesionalAreaInvestigacion.AreaInvestigacion_idAreaInvestigacion = AreaInvestigacion.idAreaInvestigacion) AS Comodin1
INNER JOIN Profesional
ON Comodin1.jefe = Profesional.idProfesional
ORDER BY Profesional.nombre;

-- ---------------------------- CONSULTA 2 -----------------------------------
/*Desplegar todos los profesionales, y su salario cuyo salario es mayor al
promedio del salario de los profesionales en su misma área.*/

SELECT ComodinB.area, ComodinB.nombre, ComodinB.salario
FROM
(SELECT ProfesionalAreaInvestigacion.AreaInvestigacion_idAreaInvestigacion AS area,
ProfesionalAreaInvestigacion.Profesional_idProfesional AS idProfesional,
Profesional.nombre AS nombre,
Profesional.salario AS salario
FROM ProfesionalAreaInvestigacion
INNER JOIN Profesional
ON ProfesionalAreaInvestigacion.Profesional_idProfesional = Profesional.idProfesional) AS ComodinB,
(SELECT ProfesionalAreaInvestigacion.AreaInvestigacion_idAreaInvestigacion AS area,
AVG(Profesional.salario) AS promedio
FROM ProfesionalAreaInvestigacion
INNER JOIN Profesional
ON ProfesionalAreaInvestigacion.Profesional_idProfesional = Profesional.idProfesional
GROUP BY area) AS ComodinA
WHERE (ComodinB.salario > ComodinA.promedio) AND (ComodinB.area = ComodinA.area);


-- ---------------------------- CONSULTA 3 -----------------------------------
/*Desplegar la suma del área de todos los países agrupados por la inicial de su
nombre.*/

SELECT SUM(Pais.ar),
UPPER(LEFT(Pais.nombre, 1)) AS first_char 
FROM Pais
GROUP BY first_char
ORDER BY first_char;


-- ---------------------------- CONSULTA 4 -----------------------------------
/*Desplegar el nombre de todos los inventores que Inicien con B y terminen con r
o con n que tengan inventos del siglo 19*/

SELECT DISTINCT ComodinA.nombreInventor, Invento.anio, Invento.nombre
FROM
(SELECT Patente.Inventor_idInventor, Inventor.nombre AS nombreInventor, Patente.Invento_idInvento AS idInvento
FROM Patente
INNER JOIN Inventor
WHERE (Inventor.nombre LIKE 'B%' OR 'b%') AND (Inventor.nombre LIKE '%r' OR '%n' OR '%R' OR '%N')) AS ComodinA
INNER JOIN Invento
ON ComodinA.idInvento = Invento.idInvento
WHERE Invento.anio BETWEEN 1801 AND 1900;


-- ---------------------------- CONSULTA 5 -----------------------------------
/*Desplegar el nombre del país y el área de todos los países que tienen mas de
siete fronteras ordenarlos por el de mayor área.*/

SELECT Pais.ar, Pais.nombre, COUNT(Frontera.Pais_idPaisPrincipal) AS totalFrontera
FROM Frontera
INNER JOIN Pais
ON Frontera.Pais_idPaisPrincipal = Pais.idPais
GROUP BY Frontera.Pais_idPaisPrincipal
HAVING totalFrontera > 7
ORDER BY Pais.ar;


-- ---------------------------- CONSULTA 6 -----------------------------------
/*Desplegar el nombre del profesional, su salario, su comisión y el total de salario
(sueldo mas comisión) de todos los profesionales con comisión mayor que el
25% de su salario.*/

SELECT Profesional.nombre, Profesional.salario, Profesional.comision, SUM(Profesional.salario+Profesional.comision) AS totalSalario
FROM Profesional
GROUP BY Profesional.nombre, Profesional.salario, Profesional.comision
HAVING Profesional.comision > ((25/100)*Profesional.salario);


-- ---------------------------- CONSULTA 7 -----------------------------------
/*Desplegar los países cuya población sea mayor a la población de los países
centroamericanos juntos.*/

SELECT Pais.nombre, Pais.poblacion
FROM Pais,
(SELECT SUM(Pais.poblacion) AS total, Region.nombre
FROM Pais
INNER JOIN Region
ON Pais.Region_idRegion = Region.idRegion
WHERE Region.nombre = 'Centro America'
GROUP BY Region.nombre) AS ComodinA
WHERE Pais.poblacion > ComodinA.total;


-- ---------------------------- CONSULTA 8 -----------------------------------
/*Desplegar el nombre de todos los inventos inventados el mismo año que BENZ
invento algún invento.*/

SELECT Invento.nombre, Invento.anio
FROM Invento,
(SELECT  Inventor.nombre AS inventor, Invento.nombre AS invento, Invento.anio AS anio
FROM Patente
INNER JOIN Inventor
ON Patente.Inventor_idInventor = Inventor.idInventor
INNER JOIN Invento
ON Patente.Invento_idInvento = Invento.idInvento
WHERE Inventor.nombre = 'BENZ') AS ComodinA
WHERE Invento.anio = ComodinA.anio;


-- ---------------------------- CONSULTA 9 -----------------------------------
/*Desplegar los nombres y el número de habitantes de todas las islas que tiene
un área mayor o igual al área de Japón*/


SELECT ComodinA.nombreIsla, ComodinA.poblacionIsla, ComodinA.areaIsla
FROM
(SELECT Frontera.Pais_idPaisPrincipal AS idIsla, Pais.nombre AS nombreIsla, 
Pais.poblacion AS poblacionIsla, Pais.ar AS areaIsla
FROM Frontera
INNER JOIN Pais
ON Frontera.Pais_idPaisPrincipal = Pais.idPais
WHERE Frontera.norte IS NULL AND Frontera.sur IS NULL AND Frontera.este IS NULL AND Frontera.oeste IS NULL) AS ComodinA
,
(SELECT Pais.nombre, Pais.poblacion, Pais.ar AS areaJapon
FROM Pais
WHERE Pais.nombre = 'Japon') AS ComodinB
WHERE ComodinA.areaIsla >= ComodinB.areaJapon;


-- ---------------------------- CONSULTA 10 -----------------------------------
/*Desplegar el nombre del profesional su salario y su comisión de los empleados
cuyo salario es mayor que el doble de su comisión.*/

SELECT Profesional.nombre, Profesional.salario, Profesional.comision
FROM Profesional
WHERE Profesional.salario > (2*Profesional.comision);









