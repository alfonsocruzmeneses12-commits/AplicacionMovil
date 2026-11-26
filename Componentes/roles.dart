import 'package:flutter/material.dart';

class Roles extends StatefulWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final Color fondo;
  final Color borde;
  final VoidCallback onTap;
  const Roles({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.fondo,
    required this.borde,
    required this.onTap,
  });

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.fondo,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(widget.icon, color: Colors.black87),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.subtitulo,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16,color: Colors.black45,)
          ],
        ),
      ),
    );
  }
}
