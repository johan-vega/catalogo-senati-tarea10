import 'package:flutter/material.dart';

import '../modelos/componente.dart';

IconData iconoDe(Categoria categoria) => switch (categoria) {
  Categoria.hardware => Icons.developer_board_rounded,
  Categoria.procesadores => Icons.memory_rounded,
  Categoria.almacenamiento => Icons.storage_rounded,
  Categoria.perifericos => Icons.headphones_rounded,
};

class EtiquetaCategoria extends StatelessWidget {
  const EtiquetaCategoria(this.categoria, {super.key});

  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tema.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          categoria.etiqueta,
          style: tema.textTheme.labelMedium?.copyWith(
            color: tema.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
