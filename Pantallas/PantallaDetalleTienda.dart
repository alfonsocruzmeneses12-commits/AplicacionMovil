import 'package:flutter/material.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class PantallaDetalleTienda extends StatefulWidget {
  const PantallaDetalleTienda({super.key});

  @override
  State<PantallaDetalleTienda> createState() => _PantallaDetalleTiendaState();
}

class _PantallaDetalleTiendaState extends State<PantallaDetalleTienda> {
  List _productosTienda = [];
  String nombreLocal = 'Tienda';
  int idVendedor = 0;
  int idCliente = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idVendedor = args['id_vendedor'] ?? 0;
      nombreLocal = args['nombre_local'] ?? 'Tienda';
      idCliente = args['id_cliente'] ?? 0;
      _cargarProductosDeTienda();
    }
  }

  Future<void> _cargarProductosDeTienda() async {
    final db = await SqLiteHandler().getDb();
    final productos = await db.query(
      'Producto',
      where: 'id_vendedor = ?',
      whereArgs: [idVendedor],
    );
    setState(() {
      _productosTienda = productos;
    });
  }

  Future<void> _realizarPedido(Map<String, dynamic> producto) async {
    final db = await SqLiteHandler().getDb();

    // 1. Crear la venta ligada al cliente y al vendedor de esta tienda
    int idVenta = await db.insert('Ventas', {
      'id_cliente': idCliente,
      'id_vendedor': idVendedor,
      'total': producto['precio_venta'],
      'estado': 'pendiente',
    });

    // 2. Insertar el detalle de la venta
    await db.insert('Detalles_Ventas', {
      'id_venta': idVenta,
      'id_producto': producto['id_producto'],
      'cantidad': 1,
      'precio_unitario': producto['precio_venta'],
      'subtotal': producto['precio_venta'],
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '¡Pedido realizado con éxito! Revisa tus notificaciones.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombreLocal)),
      body: _productosTienda.isEmpty
          ? const Center(
              child: Text('Esta tienda aún no tiene productos disponibles.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _productosTienda.length,
              itemBuilder: (context, index) {
                final prod = _productosTienda[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading:
                        prod['imagen'] != null &&
                            prod['imagen'].toString().isNotEmpty
                        ? Image.network(
                            prod['imagen'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.fastfood),
                          )
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(
                      prod['descripcion'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Precio: \$${prod['precio_venta']} MXN\nStock: ${prod['stock_actual']}',
                    ),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () => _realizarPedido(prod),
                      child: const Text('Pedir'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
