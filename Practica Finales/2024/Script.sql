CREATE TABLE CLIENTE (
                         zona char(2)  NOT NULL,
                         nroC int  NOT NULL,
                         apell_nombre varchar(50)  NOT NULL,
                         ciudad varchar(20)  NOT NULL,
                         fecha_alta date  NOT NULL,
                         CONSTRAINT PK_CLIENTE PRIMARY KEY (zona,nroC)
);

CREATE TABLE INSTALACION (
                             Zona char(2)  NOT NULL,
                             NroC int  NOT NULL,
                             idServ int  NOT NULL,
                             fecha_instalacion date  NOT NULL,
                             cantHoras int  NOT NULL,
                             tarea varchar(50)  NOT NULL,
                             CONSTRAINT PK_INSTALACION PRIMARY KEY (Zona,NroC,idServ)
);

CREATE TABLE SERVICIO (
                          idServ int  NOT NULL,
                          nombreServ varchar(50)  NOT NULL,
                          anio_comienzo int  NOT NULL,
                          anio_fin int  NULL,
                          tipoServ char(1)  NOT NULL,
                          CONSTRAINT PK_SERVICIO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_MONITOREO (
                                idServ int  NOT NULL,
                                caracteristica varchar(80)  NOT NULL,
                                CONSTRAINT PK_SERV_MONITOREO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_VIGILANCIA (
                                 idServ int  NOT NULL,
                                 situacion varchar(80)  NOT NULL,
                                 CONSTRAINT PK_SERV_VIGILANCIA PRIMARY KEY (idServ)
);

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_CLIENTE
    FOREIGN KEY (Zona, NroC)
        REFERENCES CLIENTE (zona, nroC)
;

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_SERVICIO
    FOREIGN KEY (idServ)
        REFERENCES SERVICIO (idServ)
;

ALTER TABLE SERV_MONITOREO ADD CONSTRAINT FK_SMONITOREO_SERVICIO
    FOREIGN KEY (idServ)
        REFERENCES SERVICIO (idServ)
;

ALTER TABLE SERV_VIGILANCIA ADD CONSTRAINT FK_SVIGILANCIA_SERVICIO
    FOREIGN KEY (idServ)
        REFERENCES SERVICIO (idServ)
;
