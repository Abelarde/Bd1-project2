
CREATE TABLE categoriaproducto (
    idcategoriaproducto  INTEGER NOT NULL,
    nombre               VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE categoriaproducto ADD CONSTRAINT categoriaproducto_pk PRIMARY KEY ( idcategoriaproducto );

CREATE TABLE ciudad (
    idciudad         INTEGER NOT NULL,
    nombre           VARCHAR2(255 CHAR) NOT NULL,
    region_idregion  INTEGER NOT NULL
);

ALTER TABLE ciudad ADD CONSTRAINT ciudad_pk PRIMARY KEY ( idciudad );

CREATE TABLE codigopostal (
    idcodigopostal         INTEGER NOT NULL,
    codigo                 INTEGER NOT NULL,
    ciudad_idciudad        INTEGER NOT NULL,
    direccion_iddireccion  INTEGER NOT NULL
);

CREATE UNIQUE INDEX codigopostal__idx ON
    codigopostal (
        direccion_iddireccion
    ASC );

ALTER TABLE codigopostal ADD CONSTRAINT codigopostal_pk PRIMARY KEY ( idcodigopostal );

CREATE TABLE compania (
    idcompania  INTEGER NOT NULL,
    nombre      VARCHAR2(255 CHAR) NOT NULL,
    contacto    VARCHAR2(255 CHAR),
    correo      VARCHAR2(255 CHAR),
    telefono    VARCHAR2(255 CHAR)
);

ALTER TABLE compania ADD CONSTRAINT compania_pk PRIMARY KEY ( idcompania );

CREATE TABLE detalletransaccion (
    cantidad                   INTEGER NOT NULL,
    producto_idproducto        INTEGER NOT NULL,
    transaccion_idtransaccion  INTEGER NOT NULL
);

CREATE TABLE direccion (
    iddireccion  INTEGER NOT NULL,
    nombre       VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE direccion ADD CONSTRAINT direccion_pk PRIMARY KEY ( iddireccion );

CREATE TABLE persona (
    idpersona              INTEGER NOT NULL,
    nombre                 VARCHAR2(255 CHAR) NOT NULL,
    correo                 VARCHAR2(255 CHAR),
    telefono               VARCHAR2(255 CHAR),
    fecharegistro          DATE,
    tipo                   CHAR(1 CHAR) NOT NULL,
    direccion_iddireccion  INTEGER NOT NULL
);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( idpersona );

CREATE TABLE producto (
    idproducto                             INTEGER NOT NULL,
    nombre                                 VARCHAR2(255 CHAR) NOT NULL,
    precio                                 NUMBER(10, 2) NOT NULL, 
--  ERROR: Column name length exceeds maximum allowed length(30) 
         categoriaproducto_idcategoriaproducto  INTEGER NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( idproducto );

CREATE TABLE region (
    idregion  INTEGER NOT NULL,
    nombre    VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( idregion );

CREATE TABLE transaccion (
    idtransaccion        INTEGER NOT NULL,
    compania_idcompania  INTEGER NOT NULL,
    persona_idpersona    INTEGER NOT NULL
);

ALTER TABLE transaccion ADD CONSTRAINT transaccion_pk PRIMARY KEY ( idtransaccion );

ALTER TABLE ciudad
    ADD CONSTRAINT ciudad_region_fk FOREIGN KEY ( region_idregion )
        REFERENCES region ( idregion );

ALTER TABLE codigopostal
    ADD CONSTRAINT codigopostal_ciudad_fk FOREIGN KEY ( ciudad_idciudad )
        REFERENCES ciudad ( idciudad );

ALTER TABLE codigopostal
    ADD CONSTRAINT codigopostal_direccion_fk FOREIGN KEY ( direccion_iddireccion )
        REFERENCES direccion ( iddireccion );

ALTER TABLE detalletransaccion
    ADD CONSTRAINT detalletransaccion_producto_fk FOREIGN KEY ( producto_idproducto )
        REFERENCES producto ( idproducto );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE detalletransaccion
    ADD CONSTRAINT detalletransaccion_transaccion_fk FOREIGN KEY ( transaccion_idtransaccion )
        REFERENCES transaccion ( idtransaccion );

ALTER TABLE persona
    ADD CONSTRAINT persona_direccion_fk FOREIGN KEY ( direccion_iddireccion )
        REFERENCES direccion ( iddireccion );

ALTER TABLE producto
    ADD CONSTRAINT producto_categoriaproducto_fk FOREIGN KEY ( categoriaproducto_idcategoriaproducto )
        REFERENCES categoriaproducto ( idcategoriaproducto );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_compania_fk FOREIGN KEY ( compania_idcompania )
        REFERENCES compania ( idcompania );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_persona_fk FOREIGN KEY ( persona_idpersona )
        REFERENCES persona ( idpersona );



