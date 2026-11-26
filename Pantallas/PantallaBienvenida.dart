import 'package:flutter/material.dart';
import 'package:pideylisto/Componentes/roles.dart';
import 'package:pideylisto/Core/AppColor.dart';
import 'package:pideylisto/Core/AppRutas.dart';

class Pantallabienvenida extends StatelessWidget {
  const Pantallabienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset("assets/imagenes/logo.png", height: 80, width: 80),
              const SizedBox(height: 12),
              const Text(
                'PideYListo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pide lo que se te antoje \n Nosotros te lo llevamos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '¿Cómo deseas continuar?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Roles(
                titulo: 'Cliente',
                subtitulo: "Pide tu comida favorita",
                icon: Icons.person,
                fondo: AppColor.clientefondo,
                borde: AppColor.clienteBorde,
                onTap: () => Navigator.pushNamed(
                  context,
                  Apprutas.inicioS,
                  arguments: 'Cliente',
                ),
              ),
              const SizedBox(height: 12),
              Roles(
                titulo: 'Vendedor',
                subtitulo: "Ofrece tus productos",
                icon: Icons.store,
                fondo: AppColor.vendedorFondo,
                borde: AppColor.clienteBorde,
                onTap: () => Navigator.pushNamed(
                  context,
                  Apprutas.inicioS,
                  arguments: 'Vendedor',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
