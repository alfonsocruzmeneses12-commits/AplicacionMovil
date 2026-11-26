import 'package:flutter/material.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/Core/AppRutas.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class Pantallainicios extends StatefulWidget {
  const Pantallainicios({super.key});

  @override
  State<Pantallainicios> createState() => _PantallainiciosState();
}

class _PantallainiciosState extends State<Pantallainicios> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  Future<void> _iniciarSesion() async {
    String username = _userController.text.trim();
    String password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final db = await SqLiteHandler().getDb();

      // 1. Buscar en la tabla Vendedor
      final vendedorRes = await db.query(
        'Vendedor',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (vendedorRes.isNotEmpty) {
        if (!mounted) return;
        final vendedor = vendedorRes.first;
        // Redirige al panel del vendedor enviando su ID y Nombre de Local
        Navigator.pushReplacementNamed(
          context,
          Apprutas.gestionProductos,
          arguments: {
            'id_vendedor': vendedor['id_vendedor'],
            'nombre_local': vendedor['nombre_local'],
          },
        );
        return;
      }

      // 2. Si no es vendedor, buscar en la tabla Cliente
      final clienteRes = await db.query(
        'Cliente',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (clienteRes.isNotEmpty) {
        if (!mounted) return;
        final cliente = clienteRes.first;
        // Redirige al panel del cliente enviando su ID
        Navigator.pushReplacementNamed(
          context,
          Apprutas.principalCliente,
          arguments: {'id_cliente': cliente['id_cliente']},
        );
        return;
      }

      // Si no existe en ninguna tabla
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _iniciarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, Apprutas.registro),
                    child: Text(
                      'Registrate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
