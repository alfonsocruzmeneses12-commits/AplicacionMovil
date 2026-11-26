import 'package:flutter/material.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/handlers/base_datos.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  bool isVendor = false;
  final _nombreController = TextEditingController();
  final _localController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  Future<void> _registrarUsuario() async {
    if (_nombreController.text.isEmpty ||
        _userController.text.isEmpty ||
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa los campos obligatorios'),
        ),
      );
      return;
    }

    if (isVendor && _localController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre del local es obligatorio para vendedores'),
        ),
      );
      return;
    }

    try {
      final db = await SqLiteHandler().getDb();
      if (isVendor) {
        await db.insert('Vendedor', {
          'nombre_completo': _nombreController.text.trim(),
          'nombre_local': _localController.text.trim(),
          'username': _userController.text.trim(),
          'password': _passController.text.trim(),
        });
      } else {
        await db.insert('Cliente', {
          'nombre_completo': _nombreController.text.trim(),
          'username': _userController.text.trim(),
          'password': _passController.text.trim(),
          'direccion': 'Dirección predeterminada',
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta creada con éxito! Inicia sesión.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar (El usuario ya existe): $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Text(
                'Crear cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _customTextField('Nombre completo', _nombreController),
              const SizedBox(height: 12),
              if (isVendor) ...[
                _customTextField('Nombre del Local / Tienda', _localController),
                const SizedBox(height: 12),
              ],
              _customTextField('Usuario o Correo', _userController),
              const SizedBox(height: 12),
              _customTextField(
                'Contraseña',
                _passController,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: isVendor,
                onChanged: (val) => setState(() => isVendor = val ?? false),
                title: const Text(
                  'Quiero ser vendedor',
                  style: TextStyle(fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Registrarme',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customTextField(
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
