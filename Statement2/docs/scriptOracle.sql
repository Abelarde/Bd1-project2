-- Generado por Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   en:        2021-01-03 14:37:22 CST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE areainvestigacion (
    idareainvestigacion         INTEGER NOT NULL,
    descripcion                 VARCHAR2(255 CHAR),
    ranking                     INTEGER,
    profesional_idprofesional   INTEGER,
    profesional_idprofesional1  INTEGER
);

CREATE UNIQUE INDEX areainvestigacion__idx ON
    areainvestigacion (
        profesional_idprofesional
    ASC );

CREATE UNIQUE INDEX areainvestigacion__idxv1 ON
    areainvestigacion (
        profesional_idprofesional1
    ASC );

ALTER TABLE areainvestigacion ADD CONSTRAINT areainvestigacion_pk PRIMARY KEY ( idareainvestigacion );

CREATE TABLE encuesta (
    idencuesta INTEGER NOT NULL
);

ALTER TABLE encuesta ADD CONSTRAINT encuesta_pk PRIMARY KEY ( idencuesta );

CREATE TABLE encuestapregunta (
    encuesta_idencuesta  INTEGER NOT NULL,
    pregunta_idpregunta  INTEGER NOT NULL
);

CREATE TABLE frontera (
    idfrontera  INTEGER NOT NULL,
    nombre      VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE frontera ADD CONSTRAINT frontera_pk PRIMARY KEY ( idfrontera );

CREATE TABLE invento (
    idinvento                  INTEGER NOT NULL,
    nombre                     VARCHAR2(255 CHAR) NOT NULL,
    profesional_idprofesional  INTEGER NOT NULL
);

ALTER TABLE invento ADD CONSTRAINT invento_pk PRIMARY KEY ( idinvento );

CREATE TABLE inventor (
    idinventor   INTEGER,
    nombre       VARCHAR2(255 CHAR) NOT NULL,
    pais_idpais  INTEGER NOT NULL,
    inventor_id  NUMBER NOT NULL
);

ALTER TABLE inventor ADD CONSTRAINT inventor_pk PRIMARY KEY ( inventor_id );

CREATE TABLE pais (
    idpais                INTEGER NOT NULL,
    nombre                VARCHAR2(255 CHAR) NOT NULL,
    area                  INTEGER,
    poblacion             INTEGER,
    region_idregion       INTEGER NOT NULL,
    region_nombre         VARCHAR2(255 CHAR) NOT NULL,
    inventor_inventor_id  NUMBER NOT NULL
);

CREATE UNIQUE INDEX pais__idx ON
    pais (
        inventor_inventor_id
    ASC );

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( idpais );

CREATE TABLE paisencuesta (
    encuesta_idencuesta  INTEGER NOT NULL,
    pais_idpais          INTEGER NOT NULL
);

CREATE TABLE paisfrontera (
    pais_idpais          INTEGER NOT NULL,
    frontera_idfrontera  INTEGER NOT NULL
);

CREATE TABLE patente (
    idpatente             INTEGER NOT NULL,
    invento_idinvento     INTEGER NOT NULL,
    pais_idpais           INTEGER NOT NULL,
    inventor_inventor_id  NUMBER NOT NULL
);

ALTER TABLE patente ADD CONSTRAINT patente_pk PRIMARY KEY ( idpatente );

CREATE TABLE pregunta (
    idpregunta  INTEGER NOT NULL,
    nombre      VARCHAR2(255 CHAR)
);

ALTER TABLE pregunta ADD CONSTRAINT pregunta_pk PRIMARY KEY ( idpregunta );

CREATE TABLE preguntarespuesta (
    pregunta_idpregunta    INTEGER NOT NULL,
    respuesta_idrespuesta  INTEGER NOT NULL
);

CREATE TABLE profesional (
    idprofesional                           INTEGER NOT NULL,
    salario                                 INTEGER,
    comision                                INTEGER,
    fechainiciofunciones                    DATE, 
--  ERROR: Column name length exceeds maximum allowed length(30) 
         areainvestigacion_idareainvestigacion   INTEGER, 
--  ERROR: Column name length exceeds maximum allowed length(30) 
         areainvestigacion_idareainvestigacion1  INTEGER
);

CREATE UNIQUE INDEX profesional__idx ON
    profesional (
        areainvestigacion_idareainvestigacion
    ASC );

CREATE UNIQUE INDEX profesional__idxv1 ON
    profesional (
        areainvestigacion_idareainvestigacion1
    ASC );

ALTER TABLE profesional ADD CONSTRAINT profesional_pk PRIMARY KEY ( idprofesional );

CREATE TABLE profesionalareainvestigacion (
    profesional_idprofesional              INTEGER NOT NULL, 
--  ERROR: Column name length exceeds maximum allowed length(30) 
         areainvestigacion_idareainvestigacion  INTEGER NOT NULL
);

CREATE TABLE region (
    idregion         INTEGER NOT NULL,
    nombre           VARCHAR2(255 CHAR) NOT NULL,
    region_idregion  INTEGER NOT NULL,
    region_nombre    VARCHAR2(255 CHAR) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( idregion,
                                                          nombre );

CREATE TABLE respuesta (
    idrespuesta  INTEGER NOT NULL,
    nombre       VARCHAR2(255 CHAR)
);

ALTER TABLE respuesta ADD CONSTRAINT respuesta_pk PRIMARY KEY ( idrespuesta );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE areainvestigacion
    ADD CONSTRAINT areainvestigacion_profesional_fk FOREIGN KEY ( profesional_idprofesional )
        REFERENCES profesional ( idprofesional );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE areainvestigacion
    ADD CONSTRAINT areainvestigacion_profesional_fkv2 FOREIGN KEY ( profesional_idprofesional1 )
        REFERENCES profesional ( idprofesional );

ALTER TABLE encuestapregunta
    ADD CONSTRAINT encuestapregunta_encuesta_fk FOREIGN KEY ( encuesta_idencuesta )
        REFERENCES encuesta ( idencuesta );

ALTER TABLE encuestapregunta
    ADD CONSTRAINT encuestapregunta_pregunta_fk FOREIGN KEY ( pregunta_idpregunta )
        REFERENCES pregunta ( idpregunta );

ALTER TABLE invento
    ADD CONSTRAINT invento_profesional_fk FOREIGN KEY ( profesional_idprofesional )
        REFERENCES profesional ( idprofesional );

ALTER TABLE inventor
    ADD CONSTRAINT inventor_pais_fk FOREIGN KEY ( pais_idpais )
        REFERENCES pais ( idpais );

ALTER TABLE pais
    ADD CONSTRAINT pais_inventor_fk FOREIGN KEY ( inventor_inventor_id )
        REFERENCES inventor ( inventor_id );

ALTER TABLE pais
    ADD CONSTRAINT pais_region_fk FOREIGN KEY ( region_idregion,
                                                region_nombre )
        REFERENCES region ( idregion,
                            nombre );

ALTER TABLE paisencuesta
    ADD CONSTRAINT paisencuesta_encuesta_fk FOREIGN KEY ( encuesta_idencuesta )
        REFERENCES encuesta ( idencuesta );

ALTER TABLE paisencuesta
    ADD CONSTRAINT paisencuesta_pais_fk FOREIGN KEY ( pais_idpais )
        REFERENCES pais ( idpais );

ALTER TABLE paisfrontera
    ADD CONSTRAINT paisfrontera_frontera_fk FOREIGN KEY ( frontera_idfrontera )
        REFERENCES frontera ( idfrontera );

ALTER TABLE paisfrontera
    ADD CONSTRAINT paisfrontera_pais_fk FOREIGN KEY ( pais_idpais )
        REFERENCES pais ( idpais );

ALTER TABLE patente
    ADD CONSTRAINT patente_invento_fk FOREIGN KEY ( invento_idinvento )
        REFERENCES invento ( idinvento );

ALTER TABLE patente
    ADD CONSTRAINT patente_inventor_fk FOREIGN KEY ( inventor_inventor_id )
        REFERENCES inventor ( inventor_id );

ALTER TABLE patente
    ADD CONSTRAINT patente_pais_fk FOREIGN KEY ( pais_idpais )
        REFERENCES pais ( idpais );

ALTER TABLE preguntarespuesta
    ADD CONSTRAINT preguntarespuesta_pregunta_fk FOREIGN KEY ( pregunta_idpregunta )
        REFERENCES pregunta ( idpregunta );

ALTER TABLE preguntarespuesta
    ADD CONSTRAINT preguntarespuesta_respuesta_fk FOREIGN KEY ( respuesta_idrespuesta )
        REFERENCES respuesta ( idrespuesta );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE profesional
    ADD CONSTRAINT profesional_areainvestigacion_fk FOREIGN KEY ( areainvestigacion_idareainvestigacion )
        REFERENCES areainvestigacion ( idareainvestigacion );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE profesional
    ADD CONSTRAINT profesional_areainvestigacion_fkv2 FOREIGN KEY ( areainvestigacion_idareainvestigacion1 )
        REFERENCES areainvestigacion ( idareainvestigacion );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE profesionalareainvestigacion
    ADD CONSTRAINT profesionalareainvestigacion_areainvestigacion_fk FOREIGN KEY ( areainvestigacion_idareainvestigacion )
        REFERENCES areainvestigacion ( idareainvestigacion );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE profesionalareainvestigacion
    ADD CONSTRAINT profesionalareainvestigacion_profesional_fk FOREIGN KEY ( profesional_idprofesional )
        REFERENCES profesional ( idprofesional );

ALTER TABLE region
    ADD CONSTRAINT region_region_fk FOREIGN KEY ( region_idregion,
                                                  region_nombre )
        REFERENCES region ( idregion,
                            nombre );

CREATE SEQUENCE inventor_inventor_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER inventor_inventor_id_trg BEFORE
    INSERT ON inventor
    FOR EACH ROW
    WHEN ( new.inventor_id IS NULL )
BEGIN
    :new.inventor_id := inventor_inventor_id_seq.nextval;
END;
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            16
-- CREATE INDEX                             5
-- ALTER TABLE                             33
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          1
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   9
-- WARNINGS                                 0
