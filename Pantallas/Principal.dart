import 'package:flutter/material.dart';
import 'package:pideylisto/Componentes/ItemsCard.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/handlers/base_datos.dart'; // Importa tu manejador de SQLite

class Principal extends StatelessWidget {
  const Principal({super.key});

  // GURADAR EN SQL
  Future<void> _finalizarPedido(BuildContext context) async {
    try {
      final db = await SqLiteHandler().getDb();

      int idClienteEjemplo = 1;
      int idUsuarioEjemplo = 1;
      double totalVenta = 185.00;

      int idVentaCreada = await db.insert('Ventas', {
        'id_cliente': idClienteEjemplo,
        'id_usuario': idUsuarioEjemplo,
        'total': totalVenta,
      });

      await db.insert('Detalles_Ventas', {
        'id_venta': idVentaCreada,
        'id_producto': 1,
        'cantidad': 1,
        'precio_unitario': 140.00,
        'subtotal': 140.00,
      });

      await db.insert('Detalles_Ventas', {
        'id_venta': idVentaCreada,
        'id_producto': 3,
        'cantidad': 1,
        'precio_unitario': 45.00,
        'subtotal': 45.00,
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pedido finalizado y guardado con éxito en SQLite!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el pedido: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ENTREGAR EN',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColor.primary,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Av. Principal #123, Centro',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 20),
                  hintText: 'Buscar platillos, tacos, hamburguesas...',
                  hintStyle: const TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CATEGORÍAS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryChip('Todas', isSelected: true),
                    _categoryChip('Rápida'),
                    _categoryChip('Mexicana'),
                    _categoryChip('Postres'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Tu Carrito de Compras',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Limpiar',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),

              Itemscard(
                title: 'Hamburgesa con Papas',
                precio: '+ 140.00 MXN',
                cuenta: '1',
                cuentaIni: 1,
                imagePath: "assets/imagenes/Hamburgesa_papas.jpeg",
              ),
              const SizedBox(height: 8),
              Itemscard(
                title: 'Alitas con papas',
                precio: '+ 120.00 MXN',
                cuenta: '1',
                cuentaIni: 1,
                imagePath: "assets/imagenes/alitas_papas.jpeg",
              ),
              const SizedBox(height: 16),
              Itemscard(
                title: 'Platanos Machos',
                precio: '+ 45.00 MXN',
                cuenta: '1',
                cuentaIni: 1,
                imagePath: "assets/imagenes/platanos.jpeg",
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _finalizarPedido(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Terminar y Guardar Pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'DIRECCIÓN DE ENTREGA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBE6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.home, color: AppColor.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Casa (Principal)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Av. Principal #123, Col. Centro. CP 42600\nAnotaciones: Timbre color blanco',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle, color: AppColor.primary, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
