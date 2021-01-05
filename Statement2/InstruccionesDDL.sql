
DROP SCHEMA IF EXISTS `CPM` ;

CREATE SCHEMA IF NOT EXISTS `CPM` DEFAULT CHARACTER SET utf8mb4 ;
USE `CPM` ;


DROP TABLE IF EXISTS `CPM`.`Profesional` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Profesional` (
  `idProfesional` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `salario` INT NULL,
  `comision` INT NULL,
  `fechaInicioFunciones` DATE NULL,
  PRIMARY KEY (`idProfesional`))
ENGINE = InnoDB;


DROP TABLE IF EXISTS `CPM`.`Invento` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Invento` (
  `idInvento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `anio` INT NULL,
  `Profesional_idProfesional` INT NOT NULL,
  PRIMARY KEY (`idInvento`),
  CONSTRAINT `fk_Invento_Profesional1`
    FOREIGN KEY (`Profesional_idProfesional`)
    REFERENCES `CPM`.`Profesional` (`idProfesional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Invento_Profesional1_idx` ON `CPM`.`Invento` (`Profesional_idProfesional` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Region` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Region` (
  `idRegion` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `Region_idRegion` INT NULL,
  PRIMARY KEY (`idRegion`),
  CONSTRAINT `fk_Region_Region1`
    FOREIGN KEY (`Region_idRegion`)
    REFERENCES `CPM`.`Region` (`idRegion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Region_Region1_idx` ON `CPM`.`Region` (`Region_idRegion` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Pais` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Pais` (
  `idPais` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `capital` VARCHAR(255) NULL,
  `ar` INT NULL,
  `poblacion` INT NULL,
  `Region_idRegion` INT NULL,
  PRIMARY KEY (`idPais`),
  CONSTRAINT `fk_Pais_Region1`
    FOREIGN KEY (`Region_idRegion`)
    REFERENCES `CPM`.`Region` (`idRegion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Pais_Region1_idx` ON `CPM`.`Pais` (`Region_idRegion` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Inventor` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Inventor` (
  `idInventor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `Pais_idPais` INT NOT NULL,
  PRIMARY KEY (`idInventor`),
  CONSTRAINT `fk_Inventor_Pais1`
    FOREIGN KEY (`Pais_idPais`)
    REFERENCES `CPM`.`Pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Inventor_Pais1_idx` ON `CPM`.`Inventor` (`Pais_idPais` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Patente` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Patente` (
  `idPatente` INT NOT NULL AUTO_INCREMENT,
  `Invento_idInvento` INT NOT NULL,
  `Inventor_idInventor` INT NOT NULL,
  `Pais_idPais` INT NOT NULL,
  PRIMARY KEY (`idPatente`),
  CONSTRAINT `fk_Patente_Invento1`
    FOREIGN KEY (`Invento_idInvento`)
    REFERENCES `CPM`.`Invento` (`idInvento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patente_Inventor1`
    FOREIGN KEY (`Inventor_idInventor`)
    REFERENCES `CPM`.`Inventor` (`idInventor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patente_Pais1`
    FOREIGN KEY (`Pais_idPais`)
    REFERENCES `CPM`.`Pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Patente_Invento1_idx` ON `CPM`.`Patente` (`Invento_idInvento` ASC) VISIBLE;

CREATE INDEX `fk_Patente_Inventor1_idx` ON `CPM`.`Patente` (`Inventor_idInventor` ASC) VISIBLE;

CREATE INDEX `fk_Patente_Pais1_idx` ON `CPM`.`Patente` (`Pais_idPais` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Encuesta` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Encuesta` (
  `idEncuesta` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  PRIMARY KEY (`idEncuesta`))
ENGINE = InnoDB;


DROP TABLE IF EXISTS `CPM`.`Respuesta` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Respuesta` (
  `idRespuesta` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  PRIMARY KEY (`idRespuesta`))
ENGINE = InnoDB;


DROP TABLE IF EXISTS `CPM`.`Pregunta` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Pregunta` (
  `idPregunta` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `Respuesta_idRespuestaCorrecta` INT NULL,
  PRIMARY KEY (`idPregunta`),
  CONSTRAINT `fk_Pregunta_Respuesta1`
    FOREIGN KEY (`Respuesta_idRespuestaCorrecta`)
    REFERENCES `CPM`.`Respuesta` (`idRespuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Pregunta_Respuesta1_idx` ON `CPM`.`Pregunta` (`Respuesta_idRespuestaCorrecta` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`EncuestaPregunta` ;
CREATE TABLE IF NOT EXISTS `CPM`.`EncuestaPregunta` (
  `Encuesta_idEncuesta` INT NOT NULL,
  `Pregunta_idPregunta` INT NOT NULL,
  `Respuesta_idRespuestaPais` INT NULL,
  `Pais_idPais` INT NOT NULL,
  CONSTRAINT `fk_EncuestaPregunta_Encuesta1`
    FOREIGN KEY (`Encuesta_idEncuesta`)
    REFERENCES `CPM`.`Encuesta` (`idEncuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EncuestaPregunta_Pregunta1`
    FOREIGN KEY (`Pregunta_idPregunta`)
    REFERENCES `CPM`.`Pregunta` (`idPregunta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EncuestaPregunta_Respuesta1`
    FOREIGN KEY (`Respuesta_idRespuestaPais`)
    REFERENCES `CPM`.`Respuesta` (`idRespuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EncuestaPregunta_Pais1`
    FOREIGN KEY (`Pais_idPais`)
    REFERENCES `CPM`.`Pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_EncuestaPregunta_Encuesta1_idx` ON `CPM`.`EncuestaPregunta` (`Encuesta_idEncuesta` ASC) VISIBLE;

CREATE INDEX `fk_EncuestaPregunta_Pregunta1_idx` ON `CPM`.`EncuestaPregunta` (`Pregunta_idPregunta` ASC) VISIBLE;

CREATE INDEX `fk_EncuestaPregunta_Respuesta1_idx` ON `CPM`.`EncuestaPregunta` (`Respuesta_idRespuestaPais` ASC) VISIBLE;

CREATE INDEX `fk_EncuestaPregunta_Pais1_idx` ON `CPM`.`EncuestaPregunta` (`Pais_idPais` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`PreguntaRespuesta` ;
CREATE TABLE IF NOT EXISTS `CPM`.`PreguntaRespuesta` (
  `Respuesta_idRespuesta` INT NULL,
  `Pregunta_idPregunta` INT NULL,
  CONSTRAINT `fk_PreguntaRespuesta_Respuesta1`
    FOREIGN KEY (`Respuesta_idRespuesta`)
    REFERENCES `CPM`.`Respuesta` (`idRespuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PreguntaRespuesta_Pregunta1`
    FOREIGN KEY (`Pregunta_idPregunta`)
    REFERENCES `CPM`.`Pregunta` (`idPregunta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_PreguntaRespuesta_Respuesta1_idx` ON `CPM`.`PreguntaRespuesta` (`Respuesta_idRespuesta` ASC) VISIBLE;

CREATE INDEX `fk_PreguntaRespuesta_Pregunta1_idx` ON `CPM`.`PreguntaRespuesta` (`Pregunta_idPregunta` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`AreaInvestigacion` ;
CREATE TABLE IF NOT EXISTS `CPM`.`AreaInvestigacion` (
  `idAreaInvestigacion` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NULL,
  `ranking` INT NULL,
  `Profesional_idProfesionalJefe` INT NULL,
  `Profesional_idProfesionalJefeJefe` INT NULL,
  PRIMARY KEY (`idAreaInvestigacion`),
  CONSTRAINT `fk_AreaInvestigacion_Profesional1`
    FOREIGN KEY (`Profesional_idProfesionalJefe`)
    REFERENCES `CPM`.`Profesional` (`idProfesional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreaInvestigacion_Profesional2`
    FOREIGN KEY (`Profesional_idProfesionalJefeJefe`)
    REFERENCES `CPM`.`Profesional` (`idProfesional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_AreaInvestigacion_Profesional1_idx` ON `CPM`.`AreaInvestigacion` (`Profesional_idProfesionalJefe` ASC) VISIBLE;

CREATE INDEX `fk_AreaInvestigacion_Profesional2_idx` ON `CPM`.`AreaInvestigacion` (`Profesional_idProfesionalJefeJefe` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`ProfesionalAreaInvestigacion` ;
CREATE TABLE IF NOT EXISTS `CPM`.`ProfesionalAreaInvestigacion` (
  `AreaInvestigacion_idAreaInvestigacion` INT NULL,
  `Profesional_idProfesional` INT NULL,
  CONSTRAINT `fk_ProfesionalAreaInvestigacion_AreaInvestigacion1`
    FOREIGN KEY (`AreaInvestigacion_idAreaInvestigacion`)
    REFERENCES `CPM`.`AreaInvestigacion` (`idAreaInvestigacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProfesionalAreaInvestigacion_Profesional1`
    FOREIGN KEY (`Profesional_idProfesional`)
    REFERENCES `CPM`.`Profesional` (`idProfesional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_ProfesionalAreaInvestigacion_AreaInvestigacion1_idx` ON `CPM`.`ProfesionalAreaInvestigacion` (`AreaInvestigacion_idAreaInvestigacion` ASC) VISIBLE;

CREATE INDEX `fk_ProfesionalAreaInvestigacion_Profesional1_idx` ON `CPM`.`ProfesionalAreaInvestigacion` (`Profesional_idProfesional` ASC) VISIBLE;


DROP TABLE IF EXISTS `CPM`.`Frontera` ;
CREATE TABLE IF NOT EXISTS `CPM`.`Frontera` (
  `idFrontera` INT NOT NULL AUTO_INCREMENT,
  `Pais_idPaisPrincipal` INT NULL,
  `Pais_idPaisSecundario` INT NULL,
  `norte` CHAR(1) NULL,
  `sur` CHAR(1) NULL,
  `este` CHAR(1) NULL,
  `oeste` CHAR(1) NULL,
  PRIMARY KEY (`idFrontera`),
  CONSTRAINT `fk_Frontera_Pais1`
    FOREIGN KEY (`Pais_idPaisPrincipal`)
    REFERENCES `CPM`.`Pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Frontera_Pais2`
    FOREIGN KEY (`Pais_idPaisSecundario`)
    REFERENCES `CPM`.`Pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Frontera_Pais1_idx` ON `CPM`.`Frontera` (`Pais_idPaisPrincipal` ASC) VISIBLE;

CREATE INDEX `fk_Frontera_Pais2_idx` ON `CPM`.`Frontera` (`Pais_idPaisSecundario` ASC) VISIBLE;
