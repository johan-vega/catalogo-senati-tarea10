import 'package:flutter/material.dart';

import '../modelos/componente.dart';
import '../widgets/presentacion_componente.dart';

class DetallePage extends StatelessWidget {
  const DetallePage({super.key, required this.componente});

  // Este objeto llega desde el ListTile a través de la ruta /details.
  final Componente componente;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    const verdeOscuro = Color(0xFF14553A);
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha técnica')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: tema.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: tema.colorScheme.primaryContainer,
                          foregroundColor: tema.colorScheme.onPrimaryContainer,
                          child: Icon(iconoDe(componente.categoria), size: 26),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          componente.nombre,
                          style: tema.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        EtiquetaCategoria(componente.categoria),
                        const Divider(height: 32),
                        Text(
                          'Descripción técnica',
                          style: tema.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          componente.descripcion,
                          style: tema.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4EA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFB5DDC7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Precio estimado',
                        style: TextStyle(color: verdeOscuro),
                      ),
                      Text(
                        componente.precioFormateado,
                        style: tema.textTheme.headlineSmall?.copyWith(
                          color: verdeOscuro,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            componente.disponible
                                ? Icons.check_circle_outline
                                : Icons.inventory_2_outlined,
                            color: verdeOscuro,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              componente.disponible
                                  ? 'Stock disponible en almacén'
                                  : 'Sin stock en almacén',
                              style: const TextStyle(color: verdeOscuro),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  // pop conserva la pantalla anterior con sus filtros y datos.
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver al Catálogo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
