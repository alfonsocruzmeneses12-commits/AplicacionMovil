import 'package:flutter/material.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  List _misPedidos = [];
  int idCliente = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idCliente = args['id_cliente'] ?? 1;
    }
    _cargarMisPedidos();
  }

  Future<void> _cargarMisPedidos() async {
    final db = await SqLiteHandler().getDb();
    final pedidos = await db.rawQuery(
      '''
      SELECT V.id_venta, V.fecha, V.total, V.estado, Vend.nombre_local 
      FROM Ventas V
      JOIN Vendedor Vend ON V.id_vendedor = Vend.id_vendedor
      WHERE V.id_cliente = ?
      ORDER BY V.id_venta DESC
    ''',
      [idCliente],
    );

    setState(() {
      _misPedidos = pedidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos y Notificaciones')),
      body: _misPedidos.isEmpty
          ? const Center(child: Text('Aún no has realizado ningún pedido.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _misPedidos.length,
              itemBuilder: (context, index) {
                final pedido = _misPedidos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.receipt)),
                    title: Text('Tienda: ${pedido['nombre_local']}'),
                    subtitle: Text(
                      'Fecha: ${pedido['fecha']}\nTotal: \$${pedido['total']} MXN\nEstado: ${pedido['estado']}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
