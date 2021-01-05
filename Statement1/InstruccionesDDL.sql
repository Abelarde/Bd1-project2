
DROP SCHEMA IF EXISTS `CentroDeDatos` ;

CREATE SCHEMA IF NOT EXISTS `CentroDeDatos` ;
USE `CentroDeDatos` ;

-- -----------------------------------------------------

DROP TABLE IF EXISTS `CentroDeDatos`.`CategoriaProducto` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`CategoriaProducto` (
  `idCategoriaProducto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idCategoriaProducto`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`Region` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Region` (
  `idRegion` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idRegion`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`Ciudad` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Ciudad` (
  `idCiudad` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `idRegion` INT NOT NULL,
  PRIMARY KEY (`idCiudad`),
  CONSTRAINT `fk_Ciudad_Region`
    FOREIGN KEY (`idRegion`)
    REFERENCES `CentroDeDatos`.`Region` (`idRegion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE INDEX `fk_Ciudad_Region_idx` ON `CentroDeDatos`.`Ciudad` (`idRegion` ASC) VISIBLE;

DROP TABLE IF EXISTS `CentroDeDatos`.`Direccion` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Direccion` (
  `idDireccion` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idDireccion`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`CodigoPostal` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`CodigoPostal` (
  `idCodigoPostal` INT NOT NULL AUTO_INCREMENT,
  `nombre` INT NOT NULL,
  `idCiudad` INT NOT NULL,
  `idDireccion` INT NOT NULL,
  PRIMARY KEY (`idCodigoPostal`),
  CONSTRAINT `fk_CodigoPostal_Ciudad`
    FOREIGN KEY (`idCiudad`)
    REFERENCES `CentroDeDatos`.`Ciudad` (`idCiudad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CodigoPostal_Direccion`
    FOREIGN KEY (`idDireccion`)
    REFERENCES `CentroDeDatos`.`Direccion` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
CREATE INDEX `fk_CodigoPostal_Ciudad_idx` ON `CentroDeDatos`.`CodigoPostal` (`idCiudad` ASC) VISIBLE;
CREATE INDEX `fk_CodigoPostal_Direccion_idx` ON `CentroDeDatos`.`CodigoPostal` (`idDireccion` ASC) VISIBLE;

DROP TABLE IF EXISTS `CentroDeDatos`.`Compania` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Compania` (
  `idCompania` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `contacto` VARCHAR(255),
  `correo` VARCHAR(255),
  `telefono` VARCHAR(255),
  PRIMARY KEY (`idCompania`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`Producto` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Producto` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `idCategoriaProducto` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `fk_Producto_CategoriaProducto`
    FOREIGN KEY (`idCategoriaProducto`)
    REFERENCES `CentroDeDatos`.`CategoriaProducto` (`idCategoriaProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
    
DROP TABLE IF EXISTS `CentroDeDatos`.`Persona` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Persona` (
  `idPersona` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `correo` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idPersona`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`Tipo`;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Tipo`(
	`idTipo` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`idTipo`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `CentroDeDatos`.`Persona_Tipo`;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Persona_Tipo`(
	`idPersona_Tipo` INT NOT NULL AUTO_INCREMENT,
    `fechaRegistro` DATE,
    `idDireccion` INT NOT NULL,
    `idTipo` INT NOT NULL,
    `idPersona` INT NOT NULL,
    PRIMARY KEY(`idPersona_Tipo`),
  CONSTRAINT `fk_Persona_Tipo_Direccion`
	FOREIGN KEY (`idDireccion`)
    REFERENCES `CentroDeDatos`.`Direccion` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_Tipo_Tipo`
	FOREIGN KEY (`idTipo`)
    REFERENCES `CentroDeDatos`.`Tipo` (`idTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_Tipo_Persona`
	FOREIGN KEY (`idPersona`)
    REFERENCES `CentroDeDatos`.`Persona` (`idPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION       
)
ENGINE = InnoDB;
    
DROP TABLE IF EXISTS `CentroDeDatos`.`Transaccion` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`Transaccion` (
  `idTransaccion` INT NOT NULL AUTO_INCREMENT,
  `idCompania` INT NOT NULL,
  `idPersona_Tipo` INT NOT NULL,
  PRIMARY KEY (`idTransaccion`),
  CONSTRAINT `fk_Transaccion_Compania`
	FOREIGN KEY (`idCompania`)
    REFERENCES `CentroDeDatos`.`Compania` (`idCompania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaccion_Persona_Tipo`
	FOREIGN KEY (`idPersona_Tipo`)
    REFERENCES `CentroDeDatos`.`Persona_Tipo` (`idPersona_Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;    

DROP TABLE IF EXISTS `CentroDeDatos`.`DetalleTransaccion` ;
CREATE TABLE IF NOT EXISTS `CentroDeDatos`.`DetalleTransaccion` (
  `cantidad` INT NOT NULL,
  `idProducto` INT NOT NULL,
  `idTransaccion` INT NOT NULL,
  CONSTRAINT `fk_Transaccion_Producto`
	FOREIGN KEY (`idProducto`)
    REFERENCES `CentroDeDatos`.`Producto` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaccion_Transaccion`
	FOREIGN KEY (`idTransaccion`)
    REFERENCES `CentroDeDatos`.`Transaccion` (`idTransaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB; 



