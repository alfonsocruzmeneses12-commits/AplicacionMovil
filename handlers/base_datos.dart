import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqLiteHandler {
  Future<Database> getDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'basedatos_sqlite_v3.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabla Cliente independiente
    await db.execute('''
      CREATE TABLE Cliente (
        id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_completo TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        telefono TEXT,
        direccion TEXT
      );
    ''');

    // 2. Tabla Vendedor independiente con nombre de local
    await db.execute('''
      CREATE TABLE Vendedor (
        id_vendedor INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_completo TEXT NOT NULL,
        nombre_local TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        telefono TEXT
      );
    ''');

    // 3. Tabla Producto ligada al Vendedor propietario y su imagen
    await db.execute('''
      CREATE TABLE Producto (
        id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
        id_vendedor INTEGER NOT NULL,
        codigo_barras TEXT UNIQUE NOT NULL,
        descripcion TEXT NOT NULL,
        precio_venta REAL NOT NULL,
        stock_actual INTEGER NOT NULL,
        imagen TEXT,
        FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor) ON DELETE CASCADE
      );
    ''');

    // 4. Tabla Ventas con control de estado (pendiente / finalizado)
    await db.execute('''
      CREATE TABLE Ventas (
        id_venta INTEGER PRIMARY KEY AUTOINCREMENT,
        id_cliente INTEGER NOT NULL,
        id_vendedor INTEGER NOT NULL,
        fecha TEXT DEFAULT CURRENT_TIMESTAMP,
        total REAL NOT NULL,
        estado TEXT DEFAULT 'pendiente', -- 'pendiente' o 'finalizado'
        FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
        FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
      );
    ''');

    // 5. Tabla Detalles de la Venta
    await db.execute('''
      CREATE TABLE Detalles_Ventas (
        id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
        id_venta INTEGER NOT NULL,
        id_producto INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta) ON DELETE CASCADE,
        FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
      );
    ''');

    // Datos iniciales de prueba (Opcional)
    await db.rawInsert(
      'INSERT INTO Cliente(id_cliente, nombre_completo, username, password, direccion) VALUES(1, "Cliente General", "cliente", "123", "Av. Central #10")',
    );
    await db.rawInsert(
      'INSERT INTO Vendedor(id_vendedor, nombre_completo, nombre_local, username, password) VALUES(1, "Carlos Pérez", "Tacos El Rey", "vendedor", "123")',
    );
  }
}
