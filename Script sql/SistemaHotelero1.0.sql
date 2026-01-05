CREATE DATABASE SistemaHotelero
GO

/*
    Tabla tipos de hoteles (hotel,hostal,casa,departamente,etc)
*/

CREATE TABLE TiposHoteles(
    TipoHotelID INT IDENTITY,
    Nombre VARCHAR (128) NOT NULL,
    -- Restriciones
    CONSTRAINT PK_TipoHotelID PRIMARY KEY (TipoHotelID)
);

/*
    Tabla de tipos de redes sociales (X,FB,IG,etc)
*/
CREATE TABLE RedesSociales (
    RedSocialID INT NOT NULL IDENTITY,
    Nombre VARCHAR(64),

    --Restricciones
    CONSTRAINT PK_RedSocialID PRIMARY KEY (RedSocialID) 
);

/*
    Tabla de tipos de servicios (Wifi,piscina,parqueo,restaurante,etc)
*/

CREATE TABLE Servicios (
    ServicioID INT NOT NULL IDENTITY,
    Nombre VARCHAR(64),

    --Restricciones
    CONSTRAINT PK_ServicioID PRIMARY KEY (ServicioID) 
);



CREATE TABLE EmpresasHoteleras (
    EmpresaID INT IDENTITY,
    CedulaJuridica VARCHAR(64) NOT NULL UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Tipo INT NOT NULL,
    CorreoElectronico VARCHAR(256) UNIQUE,
    -- Dirección (Atributo Compuesto Expandido)
    Provincia VARCHAR(64),
    Canton VARCHAR(64),
    Distrito VARCHAR(64),
    Barrio VARCHAR(64),
    OtrasSenas VARCHAR(MAX),
    -- Restriciones
    CONSTRAINT PK_Empresa PRIMARY KEY (EmpresaID),
    CONSTRAINT FK_Tipo FOREIGN KEY (Tipo) REFERENCES TiposHoteles(TipoHotelID)
);
--AQUI FALTAN LOS ATRIBUTOS MULTIVALORADOS Y TIPO,
--UNA OPCION ES HACER OTRAS TABLAS PERO YA VEREMOS


--TABLAS DE ATRIBUTOS MULTIVALORADOS

/*
    AQUI VA LA TABLA DE URLS
*/
CREATE TABLE DireccionesElectronicasEmpresa (
    URL_ID INT NOT NULL IDENTITY,
    EmpresaID INT NOT NULL,
    URL_Empresa VARCHAR(128) NOT NULL,

    --Restricciones
    CONSTRAINT PK_URL_ID PRIMARY KEY (URL_ID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasHoteleras(EmpresaID),
    CONSTRAINT UQ_URL_EMPRESA UNIQUE (URL_EMPRESA)
);


/*
    TABLA DEl puente de tipos de REDES SOCIALES y dicha empresa
*/
CREATE TABLE RedesSocialesEmpresa (
    EmpresaID INT NOT NULL,
    RedSocialID INT NOT NULL,
    Red_URL VARCHAR(256) NOT NULL,

    --Restricciones
    CONSTRAINT PK_Empresa_Redes_ID PRIMARY KEY (EmpresaID,RedSocialID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasHoteleras(EmpresaID),
    CONSTRAINT FK_RedSocialID FOREIGN KEY (RedSocialID) REFERENCES RedesSociales(RedSocialID)
);



/*
    TABLA DEL PUENTE ENTRE TIPOS DE SERVICIOS Y DICHA EMPRESA
*/

CREATE TABLE ServiciosHotel (
    EmpresaID INT NOT NULL,
    ServicioID INT NOT NULL,

    --Restricciones
    CONSTRAINT PK_Empresa_Servicios_ID PRIMARY KEY (EmpresaID,ServicioID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasHoteleras(EmpresaID),
    CONSTRAINT FK_ServicioID FOREIGN KEY (ServicioID) REFERENCES Servicios(ServicioID)
);


/*
    AQUI VA LA TABLA DE TELEFONOS
*/
CREATE TABLE TelefonoEmpresa (
    TelefonoID INT NOT NULL IDENTITY,
    EmpresaID INT NOT NULL,
    TelefonoNum INT NOT NULL,

    --Restricciones
    CONSTRAINT PK_Telefono PRIMARY KEY (TelefonoID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasHoteleras(EmpresaID),
    CONSTRAINT UQ_Telefono_Num UNIQUE (TelefonoNum)
);



--Comienza entidad Habitacion **

CREATE TABLE TiposHabitaciones(
    TipoHabitacionID INT IDENTITY,
    Nombre VARCHAR (128) NOT NULL,
    -- Restriciones
    CONSTRAINT PK_TipoHabitacionID PRIMARY KEY (TipoHabitacionID)
);


CREATE TABLE TiposCamas(
    TipoCamaID INT IDENTITY,
    Nombre VARCHAR (128) NOT NULL,
    -- Restriciones
    CONSTRAINT PK_TipoCamaID PRIMARY KEY (TipoCamaID)
);

CREATE TABLE TiposComodidades(
    TipoComodidadID INT IDENTITY,
    Nombre VARCHAR (128) NOT NULL,
    -- Restriciones
    CONSTRAINT PK_TipoComodidadID PRIMARY KEY (TipoComodidadID)
);



CREATE TABLE Habitaciones(
    HabitacionID INT IDENTITY,
    EmpresaID INT NOT NULL,
    TipoHabitacionID INT NOT NULL,
    
    NumeroHabitacion INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    Estado VARCHAR(32) DEFAULT 'Activo',
    Nombre VARCHAR(128),
    Descripcion VARCHAR(256),

    -- Restriciones
    CONSTRAINT PK_HabitacionID PRIMARY KEY (HabitacionID),
    CONSTRAINT FK_TipoID FOREIGN KEY (TipoHabitacionID) REFERENCES TiposHabitaciones(TipoHabitacionID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasHoteleras(EmpresaID)
);



/*
    TABLA DE CONEXION HABITACIONES - TIPOS DE CAMAS (Relacion M:N)?? 
    **REVISAR
*/
CREATE TABLE CamasHabitaciones (
    HabitacionID INT NOT NULL,
    CamaID INT NOT NULL,

    --Restricciones
    CONSTRAINT PK_Camas_Habitaciones PRIMARY KEY (HabitacionID,CamaID),
    CONSTRAINT FK_HabitacionID FOREIGN KEY (HabitacionID) REFERENCES Habitaciones(HabitacionID),
    CONSTRAINT FK_CamaID FOREIGN KEY (CamaID) REFERENCES TiposCamas(TipoCamaID)
);


/*
    TABLA DE CONEXION HABITACIONES - TIPOS DE COMODIDADES (Relacion M:N)?? 
    **REVISAR
*/  
    CREATE TABLE Habitacion_Comodidades (
        HabitacionID INT NOT NULL,
        ComodidadID INT NOT NULL,

        --Restricciones
        CONSTRAINT PK_Habitacion_Comodidades PRIMARY KEY (HabitacionID, ComodidadID),
        CONSTRAINT FK_HabitacionID FOREIGN KEY (HabitacionID) REFERENCES Habitaciones(HabitacionID),
        CONSTRAINT FK_ComodidadID FOREIGN KEY (ComodidadID) REFERENCES TiposComodidades(TipoComodidadID)
);


/*
    AQUI VA LA TABLA DE FOTOS
*/
CREATE TABLE FotosHabitacion (
    FotoID INT NOT NULL IDENTITY,
    HabitacionID INT NOT NULL,
    Foto VARCHAR(16) NOT NULL,

    --Restricciones
    CONSTRAINT PK_FotoID PRIMARY KEY (FotoID),
    CONSTRAINT FK_HabitacionID FOREIGN KEY (HabitacionID) REFERENCES Habitaciones(HabitacionID),
    CONSTRAINT UQ_Foto UNIQUE (Foto)
);




--Comienza entidad cliente

CREATE TABLE Cliente (
    ClienteID INT IDENTITY,
    TipoIdentificacion VARCHAR(32) NOT NULL,
    Identificacion VARCHAR(64) NOT NULL ,

    FechaNacimiento DATE, -- formato: YYYY-MM-DD
    PaisResidencia VARCHAR(64),
    CorreoElectronico VARCHAR(164) UNIQUE,

    --Nombre completo
    Nombre VARCHAR(64) NOT NULL,
    PrimerApellido VARCHAR(64) NOT NULL,
    SegundoApellido VARCHAR(64),

    -- Dirección
    Provincia VARCHAR(64),
    Canton VARCHAR(64),
    Distrito VARCHAR(64),

    -- Restriciones
    CONSTRAINT PK_Cliente PRIMARY KEY (ClienteID),
    CONSTRAINT UQ_Cliente_ID UNIQUE (Identificacion)

);

CREATE TABLE Cliente_Telefonos (
    ClienteID INT NOT NULL,
    Telefono VARCHAR(32) NOT NULL,
    -- Restriciones
    CONSTRAINT PK_Cliente_Telefonos PRIMARY KEY (ClienteID, Telefono),
    CONSTRAINT FK_Telefonos_Cliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);



--Comienza entidad Reserva

CREATE TABLE Reserva (
    ReservaID INT IDENTITY,
    ClienteID INT NOT NULL,
    HabitacionID INT NOT NULL,
    --Aqui se podria usar DATETIME, pero lo separe porque asi esta en el diagrama
    FechaEntrada DATE NOT NULL, -- formato: YYYY-MM-DD 
    HoraEntrada TIME NOT NULL,  -- formato: HH:MM:SS
    CantPersonas INT DEFAULT 1,
    PoseeVehiculo BIT DEFAULT 0,
    NumeroDeNoches INT NOT NULL,
    -- Restriciones
    CONSTRAINT PK_Reserva PRIMARY KEY (ReservaID),
    CONSTRAINT FK_Reserva_Cliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    CONSTRAINT FK_Reserva_Habitacion FOREIGN KEY (HabitacionID) REFERENCES Habitaciones(HabitacionID)
);



-- AQUI VA LA FACTURA
CREATE TABLE Factura (
    FacturaID INT IDENTITY,
    ReservaID INT NOT NULL,
    NumeroDeFactura INT NOT NULL,

    FormatoDePago VARCHAR(32) NOT NULL,
    FechaFacturacion DATE NOT NULL, 
    HoraFacturacion TIME NOT NULL,

    --Se deberìa crear una tabla con cada cargo registrado o solo colocar el monto???
    CargosAdicionales INT DEFAULT 0,

    --Restricciones
    CONSTRAINT PK_Factura PRIMARY KEY (FacturaID),
    CONSTRAINT UQ_NumeroDeFactura UNIQUE (NumeroDeFactura),
    CONSTRAINT FK_Facturacion_Reserva FOREIGN KEY (ReservaID) REFERENCES Reserva(ReservaID),
);


/*
    -- AQUI VA LA RECREATIVA
*/

CREATE TABLE TipoActividad (
    ActividadID INT NOT NULL IDENTITY,
    Nombre VARCHAR(64) NOT NULL UNIQUE,
    Descripcion VARCHAR(128) NOT NULL,

    --Restricciones
    CONSTRAINT PK_ActividadID PRIMARY KEY (ActividadID) 
);

CREATE TABLE EmpresasRecreativas (
    EmpresaID INT IDENTITY,
    CedulaJuridica VARCHAR(64) NOT NULL UNIQUE,
    Nombre VARCHAR(100) NOT NULL,

    --Contacto
    CorreoElectronico VARCHAR(256) NOT NULL UNIQUE,
    Telefono INT UNIQUE NOT NULL,
    NombreContacto VARCHAR(64) NOT NULL,

    -- Dirección (Atributo Compuesto Expandido)
    Provincia VARCHAR(64),
    Canton VARCHAR(64),
    Distrito VARCHAR(64),
    OtrasSenas VARCHAR(MAX),

    -- Restriciones
    CONSTRAINT PK_Empresa PRIMARY KEY (EmpresaID)
);


/*
    Tabla de conexion entre Servicios - Empresa Recreativa
*/
CREATE TABLE ServiciosRecreativa (  --Usar la misma tabla que usa la empresa hotelera??? 
    EmpresaID INT NOT NULL,
    ServicioID INT NOT NULL,

    --Restricciones
    CONSTRAINT PK_Empresa_Servicios_ID PRIMARY KEY (EmpresaID,ServicioID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasRecreativas(EmpresaID),
    CONSTRAINT FK_ServicioID FOREIGN KEY (ServicioID) REFERENCES Servicios(ServicioID)
);


/*
    Tabla conexion Actividades - Empresa Recreativa
*/
CREATE TABLE Actividad_Recreativa (
    EmpresaID INT NOT NULL,
    ActividadID INT NOT NULL,

    --Restricciones
    CONSTRAINT PK_Recreativa_Actividades_ID PRIMARY KEY (EmpresaID,ActividadID),
    CONSTRAINT FK_EmpresaID FOREIGN KEY (EmpresaID) REFERENCES EmpresasRecreativas(EmpresaID),
    CONSTRAINT FK_ActividadID FOREIGN KEY (ActividadID) REFERENCES TipoActividad(ActividadID)
);