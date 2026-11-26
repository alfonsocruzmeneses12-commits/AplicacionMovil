import 'package:flutter/material.dart';

class Itemscard extends StatefulWidget {
  final String title;
  final String precio;
  final int cuentaIni;
  final String cuenta;
  final String imagePath;
  final ValueChanged<int>? onCountChanged;
  const Itemscard({
    super.key,
    required this.imagePath,
    required this.cuentaIni,
    required this.title,
    required this.precio,
    required this.cuenta,
    this.onCountChanged,
  });

  @override
  State<Itemscard> createState() => _ItemscardState();
}

class _ItemscardState extends State<Itemscard> {
  late int cuenta;
  @override
  void initState() {
    super.initState();
    cuenta = widget.cuentaIni;
  }

  void incrementar() {
    setState(() {
      cuenta++;
    });
    if (widget.onCountChanged != null) {
      widget.onCountChanged!(cuenta);
    }
  }

  void decrementar() {
    setState(() {
      cuenta--;
    });
    if (widget.onCountChanged != null) {
      widget.onCountChanged!(cuenta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              // Por si la imagen llega a fallar o no carga la ruta:
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: Colors.orange.shade50,
                child: const Icon(
                  Icons.fastfood,
                  color: Colors.brown,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  widget.precio,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: decrementar,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: Colors.brown,
                ),
                onPressed: incrementar,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
