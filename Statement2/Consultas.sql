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
WHERE (ComodinB.salario > ComodinA.promedio) AND (ComodinB.area = ComodinA.area)


-- ---------------------------- CONSULTA 3 -----------------------------------
/*Desplegar la suma del área de todos los países agrupados por la inicial de su
nombre.*/




-- ---------------------------- CONSULTA 4 -----------------------------------
/*Desplegar el nombre de todos los inventores que Inicien con B y terminen con r
o con n que tengan inventos del siglo 19*/




-- ---------------------------- CONSULTA 5 -----------------------------------
/*Desplegar el nombre del país y el área de todos los países que tienen mas de
siete fronteras ordenarlos por el de mayor área,*/