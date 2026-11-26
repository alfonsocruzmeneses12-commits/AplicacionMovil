import 'package:flutter/material.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class PantallaGestionProductos extends StatefulWidget {
  final Map<String, dynamic>? datosVendedor;
  const PantallaGestionProductos({super.key, this.datosVendedor});

  @override
  State<PantallaGestionProductos> createState() =>
      _PantallaGestionProductosState();
}

class _PantallaGestionProductosState extends State<PantallaGestionProductos>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List _productos = [];
  List _pedidosRecibidos = [];
  int idVendedor = 1;
  String nombreLocal = 'Mi Tienda';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idVendedor = args['id_vendedor'] ?? 1;
      nombreLocal = args['nombre_local'] ?? 'Mi Tienda';
    }
    _cargarDatosVendedor();
  }

  Future<void> _cargarDatosVendedor() async {
    final db = await SqLiteHandler().getDb();

    // Cargar productos exclusivos de ESTE vendedor
    final productos = await db.query(
      'Producto',
      where: 'id_vendedor = ?',
      whereArgs: [idVendedor],
    );

    // Cargar pedidos hechos a este vendedor
    final pedidos = await db.rawQuery(
      '''
      SELECT V.id_venta, V.fecha, V.total, V.estado, C.nombre_completo as cliente 
      FROM Ventas V
      JOIN Cliente C ON V.id_cliente = C.id_cliente
      WHERE V.id_vendedor = ?
      ORDER BY V.id_venta DESC
    ''',
      [idVendedor],
    );

    setState(() {
      _productos = productos;
      _pedidosRecibidos = pedidos;
    });
  }

  Future<void> _eliminarProducto(int id) async {
    final db = await SqLiteHandler().getDb();
    await db.delete('Producto', where: 'id_producto = ?', whereArgs: [id]);
    _cargarDatosVendedor();
  }

  Future<void> _marcarComoFinalizado(int idVenta) async {
    final db = await SqLiteHandler().getDb();
    await db.update(
      'Ventas',
      {'estado': 'finalizado'},
      where: 'id_venta = ?',
      whereArgs: [idVenta],
    );
    _cargarDatosVendedor();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido marcado como finalizado y guardado.'),
      ),
    );
  }

  void _mostrarFormularioProducto({Map<String, dynamic>? productoEditando}) {
    final codigoController = TextEditingController(
      text: productoEditando?['codigo_barras'] ?? '',
    );
    final descController = TextEditingController(
      text: productoEditando?['descripcion'] ?? '',
    );
    final precioController = TextEditingController(
      text: productoEditando?['precio_venta']?.toString() ?? '',
    );
    final stockController = TextEditingController(
      text: productoEditando?['stock_actual']?.toString() ?? '',
    );
    final imagenController = TextEditingController(
      text: productoEditando?['imagen'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          productoEditando == null
              ? 'Nuevo Producto en $nombreLocal'
              : 'Editar Producto',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de Barras',
                ),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Producto',
                ),
              ),
              TextField(
                controller: precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio Venta'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock Actual'),
              ),
              TextField(
                controller: imagenController,
                decoration: const InputDecoration(
                  labelText: 'URL o Ruta de Imagen',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = await SqLiteHandler().getDb();
              final data = {
                'id_vendedor': idVendedor,
                'codigo_barras': codigoController.text,
                'descripcion': descController.text,
                'precio_venta': double.tryParse(precioController.text) ?? 0.0,
                'stock_actual': int.tryParse(stockController.text) ?? 0,
                'imagen': imagenController.text,
              };

              if (productoEditando == null) {
                await db.insert('Producto', data);
              } else {
                await db.update(
                  'Producto',
                  data,
                  where: 'id_producto = ?',
                  whereArgs: [productoEditando['id_producto']],
                );
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              _cargarDatosVendedor();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local: $nombreLocal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Mis Productos', icon: Icon(Icons.fastfood)),
            Tab(
              text: 'Notificaciones / Pedidos',
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestana 1: Productos de la tienda
          ListView.builder(
            itemCount: _productos.length,
            itemBuilder: (context, index) {
              final p = _productos[index];
              return ListTile(
                leading:
                    p['imagen'] != null && p['imagen'].toString().isNotEmpty
                    ? Image.network(
                        p['imagen'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood),
                      )
                    : const Icon(Icons.fastfood, size: 40),
                title: Text(p['descripcion']),
                subtitle: Text(
                  'Precio: \$${p['precio_venta']} | Stock: ${p['stock_actual']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _mostrarFormularioProducto(productoEditando: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarProducto(p['id_producto']),
                    ),
                  ],
                ),
              );
            },
          ),
          // Pestana 2: Pedidos de los clientes
          ListView.builder(
            itemCount: _pedidosRecibidos.length,
            itemBuilder: (context, index) {
              final pedido = _pedidosRecibidos[index];
              bool esFinalizado = pedido['estado'] == 'finalizado';
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    'Pedido #${pedido['id_venta']} - Cliente: ${pedido['cliente']}',
                  ),
                  subtitle: Text(
                    'Total: \$${pedido['total']} | Estado: ${pedido['estado']}',
                  ),
                  trailing: esFinalizado
                      ? const Chip(
                          label: Text(
                            'Finalizado',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        )
                      : ElevatedButton(
                          onPressed: () =>
                              _marcarComoFinalizado(pedido['id_venta']),
                          child: const Text('Finalizar'),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioProducto(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
