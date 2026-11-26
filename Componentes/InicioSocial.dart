import 'package:flutter/material.dart';

class Iniciosocial extends StatefulWidget {
  final String texto;
  final IconData icon;
  final VoidCallback onTap;
  const Iniciosocial({
    super.key,
    required this.texto,
    required this.icon,
    required this.onTap,
  });

  @override
  State<Iniciosocial> createState() => _IniciosocialState();
}

class _IniciosocialState extends State<Iniciosocial> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: widget.onTap,
      icon: Icon(widget.icon, color: Colors.black87),
      label: Text(widget.texto, style: TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: BorderSide(color: Colors.grey),
      ),
    );
  }
}
