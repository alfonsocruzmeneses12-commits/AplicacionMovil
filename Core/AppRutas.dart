import 'package:flutter/material.dart';
import 'package:pideylisto/Componentes/Gestion_productos.dart';
import 'package:pideylisto/Componentes/Notificacion.dart';
import 'package:pideylisto/Pantallas/PantallaBienvenida.dart';
import 'package:pideylisto/Pantallas/PantallaDetalleTienda.dart';
import 'package:pideylisto/Pantallas/PantallaInicioS.dart';
import 'package:pideylisto/Pantallas/PantallaRegistro.dart';
import 'package:pideylisto/Pantallas/Principal_cliente.dart';

class Apprutas {
  static const String bienvenido = '/bienvenido';
  static const String inicioS = '/inicioS';
  static const String registro = '/registro';
  static const String principalCliente = '/principalCliente';
  static const String gestionProductos = '/gestionProductos';
  static const String notificaciones = '/notificaciones';
  static const String detalleTienda = '/detalleTienda';

  static Map<String, WidgetBuilder> get rutas => {
    bienvenido: (context) => const Pantallabienvenida(),
    inicioS: (context) => const Pantallainicios(),
    registro: (context) => const Registrar(),
    principalCliente: (context) => const PrincipalCliente(),
    gestionProductos: (context) => const PantallaGestionProductos(),
    notificaciones: (context) => const PantallaNotificaciones(),
    detalleTienda: (context) => const PantallaDetalleTienda(),
  };
}
