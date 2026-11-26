import 'package:flutter/material.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/Core/AppRutas.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class PrincipalCliente extends StatefulWidget {
  const PrincipalCliente({super.key});

  @override
  State<PrincipalCliente> createState() => _PrincipalClienteState();
}

class _PrincipalClienteState extends State<PrincipalCliente> {
  bool _isLoading = true;
  List _tiendas = [];
  int idCliente = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idCliente = args['id_cliente'] ?? 1;
    }
    _verificarTiendasYProductos();
  }

  Future<void> _verificarTiendasYProductos() async {
    try {
      final db = await SqLiteHandler().getDb();
      // Consultamos los vendedores/tiendas disponibles
      final tiendas = await db.query('Vendedor');

      setState(() {
        _tiendas = tiendas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColor.fondo,
      appBar: AppBar(
        title: const Text('Tiendas Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(
              context,
              Apprutas.notificaciones,
              arguments: {'id_cliente': idCliente},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _tiendas.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.store_mall_directory_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No existen tiendas para realizar un pedido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _tiendas.length,
                itemBuilder: (context, index) {
                  final tienda = _tiendas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.store, color: Colors.white),
                      ),
                      title: Text(
                        tienda['nombre_local'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Vendedor: ${tienda['nombre_completo']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Al hacer clic, puedes llevarlo a ver los productos de esta tienda específica
                        Navigator.pushNamed(
                          context,
                          Apprutas.detalleTienda,
                          arguments: {
                            'id_vendedor': tienda['id_vendedor'],
                            'nombre_local': tienda['nombre_local'],
                            'id_cliente': idCliente,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
