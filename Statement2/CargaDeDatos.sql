USE `CPM`;

DROP TABLE IF EXISTS `CentroDeDatos`.`TemporalUno`;
CREATE TABLE TemporalUno(
INVENTO VARCHAR(255) ,
INVENTOR VARCHAR(255) ,
PROFESIONAL_ASIGANDO_AL_INVENTO VARCHAR(255) ,
EL_PROFESIONAL_ES_JEFE_DEL_AREA VARCHAR(255) ,
FECHA_CONTRATO_PROFESIONAL DATE ,
SALARIO INT ,
COMISION INT ,
AREA_INVEST_DEL_PROF VARCHAR(255) ,
RANKING INT ,
ANIO_DEL_INVENTO INT ,
PAIS_DEL_INVENTO VARCHAR(255) ,
PAIS_DEL_INVENTOR VARCHAR(255) ,
REGION_DEL_PAIS VARCHAR(255) NOT NULL,
CAPITAL VARCHAR(255) NOT NULL,
POBLACION_DEL_PAIS INT NOT NULL,
AREA_EN_KM2 INT NOT NULL,
FRONTERA_CON VARCHAR(255) ,
NORTE CHAR(1) ,
SUR CHAR(1) ,
ESTE CHAR(1) ,
OESTE CHAR(1) 
);

LOAD DATA INFILE '/var/lib/mysql-files/uno.csv'
INTO TABLE TemporalUno
character set utf8mb4 
fields terminated by ',' 
optionally enclosed by '\''
lines terminated by '\n'
ignore 1 lines
(
@INVENTO,
@INVENTOR,
@PROFESIONAL_ASIGANDO_AL_INVENTO,
@EL_PROFESIONAL_ES_JEFE_DEL_AREA,
@FECHA_CONTRATO_PROFESIONAL,
@SALARIO,
@COMISION,
@AREA_INVEST_DEL_PROF,
@RANKING,
@ANIO_DEL_INVENTO,
@PAIS_DEL_INVENTO,
@PAIS_DEL_INVENTOR,
@REGION_DEL_PAIS,
@CAPITAL,
@POBLACION_DEL_PAIS,
@AREA_EN_KM2,
@FRONTERA_CON,
@NORTE,
@SUR,
@ESTE,
@OESTE  
)
set
INVENTO = nullif(@INVENTO, ''),
INVENTOR = nullif(@INVENTOR, ''),
PROFESIONAL_ASIGANDO_AL_INVENTO = nullif(@PROFESIONAL_ASIGANDO_AL_INVENTO, ''),
EL_PROFESIONAL_ES_JEFE_DEL_AREA = nullif(@EL_PROFESIONAL_ES_JEFE_DEL_AREA, ''),
FECHA_CONTRATO_PROFESIONAL = nullif(@FECHA_CONTRATO_PROFESIONAL, ''),
SALARIO = nullif(@SALARIO, ''),
COMISION = nullif(@COMISION, ''),
AREA_INVEST_DEL_PROF = nullif(@AREA_INVEST_DEL_PROF, ''),
RANKING = nullif(@RANKING, ''),
ANIO_DEL_INVENTO = nullif(@ANIO_DEL_INVENTO, ''),
PAIS_DEL_INVENTO = nullif(@PAIS_DEL_INVENTO, ''),
PAIS_DEL_INVENTOR = nullif(@PAIS_DEL_INVENTOR, ''),
REGION_DEL_PAIS = nullif(@REGION_DEL_PAIS, ''),
CAPITAL = nullif(@CAPITAL, ''),
POBLACION_DEL_PAIS = nullif(@POBLACION_DEL_PAIS, ''),
AREA_EN_KM2 = nullif(@AREA_EN_KM2, ''),
FRONTERA_CON = nullif(@FRONTERA_CON, ''),
NORTE = nullif(@NORTE, ''),
SUR = nullif(@SUR, ''),
ESTE = nullif(@ESTE, ''),
OESTE = nullif(@OESTE, '')
;


DROP TABLE IF EXISTS `CentroDeDatos`.`TemporalDos`;
CREATE TABLE TemporalDos(
NOMBRE_ENCUESTA VARCHAR(255) NOT NULL,
PREGUNTA VARCHAR(255) NOT NULL,
RESPUESTAS_POSIBLES VARCHAR(255) NOT NULL,
RESPUESTA_CORRECTA  VARCHAR(255) , -- aqui hacer algo cuando venga null 
PAIS VARCHAR(255) NOT NULL,
RESPUESTA_PAIS VARCHAR(255) NOT NULL
);

LOAD DATA INFILE '/var/lib/mysql-files/dos.csv'
INTO TABLE TemporalDos
character set utf8mb4 
fields terminated by ',' 
optionally enclosed by '\''
lines terminated by '\n'
ignore 1 lines
(
@NOMBRE_ENCUESTA,
@PREGUNTA,
@RESPUESTAS_POSIBLES,
@RESPUESTA_CORRECTA, 
@PAIS,
@RESPUESTA_PAIS
)
set
NOMBRE_ENCUESTA = nullif(@NOMBRE_ENCUESTA , ''),
PREGUNTA = nullif(@PREGUNTA , ''),
RESPUESTAS_POSIBLES = nullif(@RESPUESTAS_POSIBLES , ''),
RESPUESTA_CORRECTA  = nullif(@RESPUESTA_CORRECTA , ''), 
PAIS = nullif(@PAIS , ''),
RESPUESTA_PAIS = nullif(@RESPUESTA_PAIS , '')
;


DROP TABLE IF EXISTS `CentroDeDatos`.`TemporalTres`;
CREATE TABLE TemporalTres(
NOMBRE_REGION VARCHAR(255) NOT NULL,
REGION_PADRE VARCHAR(255)
);

LOAD DATA INFILE '/var/lib/mysql-files/tres.csv'
INTO TABLE TemporalTres
character set utf8mb4 
fields terminated by ',' 
optionally enclosed by '\''
lines terminated by '\n'
ignore 1 lines
(
@NOMBRE_REGION,
@REGION_PADRE 
)
set
NOMBRE_REGION = nullif(@NOMBRE_REGION , ''),
REGION_PADRE = nullif(@REGION_PADRE , '')
;

-- --------------------------------- RESPUESTA ----------------------------------------
INSERT INTO Respuesta(nombre)
SELECT RESPUESTAS_POSIBLES
FROM TemporalDos
WHERE RESPUESTAS_POSIBLES IS NOT NULL
UNION
SELECT RESPUESTA_CORRECTA
FROM TemporalDos
WHERE RESPUESTA_CORRECTA IS NOT NULL;

-- --------------------------------- ENCUESTA ----------------------------------------
INSERT INTO Encuesta(nombre)
SELECT DISTINCT NOMBRE_ENCUESTA
FROM TemporalDos;

-- --------------------------------- PREGUNTA ----------------------------------------
INSERT INTO Pregunta(nombre, Respuesta_idRespuestaCorrecta)
SELECT DISTINCT PREGUNTA, Respuesta.idRespuesta
FROM TemporalDos
LEFT JOIN Respuesta
ON TemporalDos.RESPUESTA_CORRECTA = Respuesta.nombre;

-- --------------------------------- PREGUNTARESPUESTA ----------------------------------------
INSERT INTO PreguntaRespuesta(Pregunta_idPregunta, Respuesta_idRespuesta)
SELECT DISTINCT Pregunta.idPregunta, Respuesta.idRespuesta
FROM TemporalDos
INNER JOIN Pregunta
ON TemporalDos.PREGUNTA = Pregunta.nombre
INNER JOIN Respuesta
ON TemporalDos.RESPUESTAS_POSIBLES = Respuesta.nombre;

-- --------------------------------- PROFESIONAL ----------------------------------------
INSERT INTO Profesional(nombre, salario, comision, fechaInicioFunciones)
SELECT DISTINCT PROFESIONAL_ASIGANDO_AL_INVENTO, SALARIO, COMISION, FECHA_CONTRATO_PROFESIONAL
FROM TemporalUno
WHERE PROFESIONAL_ASIGANDO_AL_INVENTO IS NOT NULL;

-- --------------------------------- AREAINVESTIGACION ----------------------------------------
INSERT INTO AreaInvestigacion(nombre, ranking, Profesional_idProfesionalJefe, Profesional_idProfesionalJefeJefe)
SELECT ComodinA.nombre, ComodinA.ranking, ComodinA.idJefe, ComodinB.idJefeJefe
FROM
(SELECT DISTINCT AREA_INVEST_DEL_PROF AS nombre, RANKING AS ranking, Comodin1.idJefe AS idJefe
FROM TemporalUno
LEFT JOIN
(SELECT DISTINCT PROFESIONAL_ASIGANDO_AL_INVENTO AS idJefeJefe, Profesional.idProfesional AS idJefe, 
EL_PROFESIONAL_ES_JEFE_DEL_AREA AS nomAr
FROM TemporalUno
INNER JOIN Profesional
ON TemporalUno.PROFESIONAL_ASIGANDO_AL_INVENTO = Profesional.nombre
WHERE (EL_PROFESIONAL_ES_JEFE_DEL_AREA  IS NOT NULL)) AS Comodin1
ON Comodin1.nomAr = TemporalUno.AREA_INVEST_DEL_PROF
WHERE AREA_INVEST_DEL_PROF IS NOT NULL) AS ComodinA ,

(SELECT DISTINCT PROFESIONAL_ASIGANDO_AL_INVENTO, Profesional.idProfesional AS idJefeJefe, EL_PROFESIONAL_ES_JEFE_DEL_AREA
FROM TemporalUno
INNER JOIN Profesional
ON TemporalUno.PROFESIONAL_ASIGANDO_AL_INVENTO = Profesional.nombre
WHERE (EL_PROFESIONAL_ES_JEFE_DEL_AREA  IS NOT NULL) AND (EL_PROFESIONAL_ES_JEFE_DEL_AREA = 'TODAS')) AS ComodinB;


-- --------------------------------- PROFESIONAL_AREAINVESTIGACION ----------------------------------------
INSERT INTO ProfesionalAreaInvestigacion(AreaInvestigacion_idAreaInvestigacion, Profesional_idProfesional)
SELECT DISTINCT AreaInvestigacion.idAreaInvestigacion, Profesional.idProfesional
FROM TemporalUno
INNER JOIN Profesional
ON TemporalUno.PROFESIONAL_ASIGANDO_AL_INVENTO = Profesional.nombre
INNER JOIN AreaInvestigacion
ON TemporalUno.AREA_INVEST_DEL_PROF = AreaInvestigacion.nombre
WHERE (PROFESIONAL_ASIGANDO_AL_INVENTO IS NOT NULL) AND (Profesional.idProfesional IS NOT NULL) 
AND (Profesional.idProfesional IS NOT NULL);


-- --------------------------------- INVENTO ----------------------------------------
INSERT INTO Invento(nombre, anio, Profesional_idProfesional)
SELECT DISTINCT INVENTO, ANIO_DEL_INVENTO, Profesional.idProfesional
FROM TemporalUno
INNER JOIN Profesional
ON TemporalUno.PROFESIONAL_ASIGANDO_AL_INVENTO = Profesional.nombre;


-- --------------------------------- REGION ----------------------------------------
INSERT INTO Region(nombre)
SELECT DISTINCT REGION_PADRE
FROM TemporalTres
WHERE REGION_PADRE IS NOT NULL;

INSERT INTO Region(nombre, Region_idRegion)
SELECT TemporalTres.NOMBRE_REGION, Region.idRegion
FROM TemporalTres
INNER JOIN Region
ON TemporalTres.REGION_PADRE = Region.nombre;


-- --------------------------------- PAIS ----------------------------------------
INSERT INTO Pais(nombre, capital, ar, poblacion, Region_idRegion)
SELECT  ComodinA.pais, ComodinB.capital, ComodinB.ar, ComodinB.poblacion, Region.idRegion
FROM
(SELECT PAIS_DEL_INVENTO AS pais
FROM TemporalUno
WHERE PAIS_DEL_INVENTO IS NOT NULL
UNION
SELECT FRONTERA_CON
FROM TemporalUno
WHERE FRONTERA_CON IS NOT NULL
UNION
SELECT PAIS_DEL_INVENTOR
FROM TemporalUno
WHERE PAIS_DEL_INVENTOR IS NOT NULL) AS ComodinA
LEFT JOIN
(SELECT DISTINCT PAIS_DEL_INVENTOR AS pais, CAPITAL AS capital, AREA_EN_KM2 AS ar, POBLACION_DEL_PAIS AS poblacion, REGION_DEL_PAIS AS region
FROM TemporalUno) AS ComodinB
ON ComodinA.pais = ComodinB.pais
LEFT JOIN Region
ON ComodinB.region = Region.nombre
WHERE ComodinA.pais IS NOT NULL;


-- --------------------------------- FRONTERA ----------------------------------------
INSERT INTO Frontera(Pais_idPaisPrincipal, Pais_idPaisSecundario)
SELECT ComodinA.idPaisPrincipal, Pais.idPais
FROM
(SELECT DISTINCT Pais.nombre, Pais.idPais AS idPaisPrincipal, TemporalUno.FRONTERA_CON AS nombreSec
FROM Pais
INNER JOIN TemporalUno
ON Pais.nombre = TemporalUno.PAIS_DEL_INVENTOR) AS ComodinA
LEFT JOIN Pais
ON ComodinA.nombreSec = Pais.nombre;

-- select distinct FRONTERA_CON 
-- from TemporalUno;
-- select * from Pais;


-- --------------------------------- COORDENADA ----------------------------------------
INSERT INTO Coordenada(nombre)
VALUES('NORTE');
INSERT INTO Coordenada(nombre)
VALUES('SUR');
INSERT INTO Coordenada(nombre)
VALUES('ESTE');
INSERT INTO Coordenada(nombre)
VALUES('OESTE');

/*
-- --------------------------------- FRONTERA_COORDENADA ----------------------------------------
INSERT INTO FronteraCoordenada(Coordenada_idCoordenada, Frontera_idFrontera)
SELECT ComodinA.nombrePrincipal, ComodinA.idPaisPrincipal, ComodinA.nombreSec, Pais.idPais,
ComodinA.N, ComodinA.S, ComodinA.E, ComodinA.O
FROM
(SELECT DISTINCT Pais.nombre AS nombrePrincipal, Pais.idPais AS idPaisPrincipal, TemporalUno.FRONTERA_CON AS nombreSec,
TemporalUno.NORTE AS N, TemporalUno.SUR AS S, TemporalUno.ESTE AS E, TemporalUno.OESTE AS O
FROM Pais
INNER JOIN TemporalUno
ON Pais.nombre = TemporalUno.PAIS_DEL_INVENTOR) AS ComodinA
LEFT JOIN Pais
ON ComodinA.nombreSec = Pais.nombre;
*/

-- --------------------------------- INVENTOR ----------------------------------------
INSERT INTO Inventor(nombre, Pais_idPais)
SELECT DISTINCT INVENTOR, Pais.idPais
FROM TemporalUno
INNER JOIN Pais
ON TemporalUno.PAIS_DEL_INVENTOR = Pais.nombre
WHERE INVENTOR IS NOT NULL;

-- --------------------------------- PATENTE ----------------------------------------
INSERT INTO Patente(Invento_idInvento, Inventor_idInventor, Pais_idPais)
SELECT DISTINCT Invento.idInvento, Inventor.idInventor, Pais.idPais
FROM TemporalUno
INNER JOIN Invento
ON TemporalUno.INVENTO = Invento.nombre
INNER JOIN Inventor
ON TemporalUno.INVENTOR = Inventor.nombre
INNER JOIN Pais
ON TemporalUno.PAIS_DEL_INVENTO = Pais.nombre
WHERE INVENTO IS NOT NULL;


-- --------------------------------- ENCUESTA_PREGUNTA ----------------------------------------
INSERT INTO EncuestaPregunta(Encuesta_idEncuesta, Pregunta_idPregunta, Respuesta_idRespuestaPais,
Pais_idPais)
SELECT DISTINCT Encuesta.idEncuesta, Pregunta.idPregunta, Respuestas.idRespuesta, Pais.idPais
FROM TemporalDos
INNER JOIN Encuesta
ON TemporalDos.NOMBRE_ENCUESTA = Encuesta.nombre
INNER JOIN Pregunta
ON TemporalDos.PREGUNTA = Pregunta.nombre
INNER JOIN Respuesta
ON TemporalDos.RESPUESTA_PAIS = Respuesta.nombre
INNER JOIN Pais
ON TemporalDos.PAIS = Pais.nombre;
















