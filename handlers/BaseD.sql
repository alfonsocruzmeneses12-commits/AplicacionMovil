/*CREATE DATABASE tienda;
USE tienda;

-- ===========================
-- TABLA USUARIO
-- ===========================
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
);
GO

-- ===========================
-- TABLA CLIENTE
-- ===========================
CREATE TABLE Cliente (
    id_cliente INT  PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150)
);
GO

-- ===========================
-- TABLA PRODUCTO
-- ===========================
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL
);
GO

-- ===========================
-- TABLA VENTAS
-- ===========================
CREATE TABLE Ventas (
    id_venta INT  PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
GO

-- ===========================
-- TABLA DETALLES_VENTAS
-- ===========================
CREATE TABLE Detalles_Ventas (
    id_detalle INT  PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
*/