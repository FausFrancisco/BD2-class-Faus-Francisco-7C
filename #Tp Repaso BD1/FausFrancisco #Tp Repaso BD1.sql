DROP DATABASE IF EXISTS Cabfly;

CREATE DATABASE IF NOT EXISTS Cabfly;

USE Cabfly;

CREATE TABLE Pasajero (
    IDPasajero INT PRIMARY KEY,
    Nombre VARCHAR(255),
    Apellido VARCHAR(255),
    NroDocum VARCHAR(255),
    Telef VARCHAR(255),
    Email VARCHAR(255)
);

CREATE TABLE EstadoReserva (
    Nombre VARCHAR(255) PRIMARY KEY,
    Descripcion VARCHAR(255)
);

CREATE TABLE Asiento (
    Nro VARCHAR(255) PRIMARY KEY,
    Estado VARCHAR(255)
);

CREATE TABLE EstadoAsiento (
    Nombre VARCHAR(255) PRIMARY KEY,
    Descripcion VARCHAR(255)
);

CREATE TABLE Aerolinea (
    Nombre VARCHAR(255) PRIMARY KEY,
    Descripcion VARCHAR(255)
);

CREATE TABLE Vuelo (
    NroVuelo INT PRIMARY KEY,
    Empresa VARCHAR(255),
    Aerolinea VARCHAR(255),
    Origen VARCHAR(255),
    Destino VARCHAR(255),
    Puerta VARCHAR(255),
    FechaEmision DATE,
    Hora INT,
    Asiento VARCHAR(255),
    FOREIGN KEY (Aerolinea) REFERENCES Aerolinea(Nombre)
);

CREATE TABLE Reserva (
    Codigo VARCHAR(255) PRIMARY KEY,
    Pasajero INT,
    NroVuelo INT,
    Fecha DATE,
    Hora INT,
    Estado VARCHAR(255),
    Monto DECIMAL,
    Asiento VARCHAR(255),
    FOREIGN KEY (Pasajero) REFERENCES Pasajero(IDPasajero),
    FOREIGN KEY (NroVuelo) REFERENCES Vuelo(NroVuelo),
    FOREIGN KEY (Estado) REFERENCES EstadoReserva(Nombre),
    FOREIGN KEY (Asiento) REFERENCES Asiento(Nro)
);