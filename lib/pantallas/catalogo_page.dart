import 'package:flutter/material.dart';

import '../datos/catalogo_inicial.dart';
import '../datos/filtrar_catalogo.dart';
import '../modelos/componente.dart';
import '../rutas.dart';
import '../widgets/formulario_componente.dart';
import '../widgets/presentacion_componente.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final _componentes = List<Componente>.of(catalogoInicial);
  final _busqueda = TextEditingController();
  final _desplazamiento = ScrollController();
  Categoria? _categoria;
  bool _mostrarBusqueda = false;

  @override
  void dispose() {
    _busqueda.dispose();
    _desplazamiento.dispose();
    super.dispose();
  }

  Future<void> _registrarComponente() async {
    // El modal devuelve un Componente validado. Al cancelar, devuelve null.
    final componente = await showDialog<Componente>(
      context: context,
      builder: (_) => const FormularioComponente(),
    );
    if (!mounted || componente == null) return;

    setState(() {
      _componentes.insert(0, componente);
      _categoria = null;
      _busqueda.clear();
    });
    // La lista vuelve al inicio y muestra la ficha recién guardada.
    if (_desplazamiento.hasClients) _desplazamiento.jumpTo(0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Componente guardado en el catálogo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    // setState vuelve a ejecutar el filtro al escribir, elegir un chip o guardar.
    final visibles = filtrarCatalogo(_componentes, _categoria, _busqueda.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo SENATI'),
        actions: [
          IconButton(
            tooltip: _mostrarBusqueda ? 'Cerrar búsqueda' : 'Buscar',
            icon: Icon(_mostrarBusqueda ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _mostrarBusqueda = !_mostrarBusqueda;
              if (!_mostrarBusqueda) _busqueda.clear();
            }),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registrarComponente,
        backgroundColor: tema.colorScheme.primary,
        foregroundColor: tema.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Componente'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventario de laboratorio',
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (_mostrarBusqueda) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _busqueda,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            labelText: 'Buscar por nombre o categoría',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      for (final categoria in [null, ...Categoria.values])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(categoria?.etiqueta ?? 'Todos'),
                            selected: _categoria == categoria,
                            onSelected: (_) => setState(
                              () => _categoria = _categoria == categoria
                                  ? null
                                  : categoria,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    visibles.length == 1
                        ? '1 componente'
                        : '${visibles.length} componentes',
                    style: tema.textTheme.labelLarge?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: visibles.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(24, 0, 24, 72),
                            child: Text(
                              'No se encontraron componentes. Prueba otra '
                              'búsqueda o selecciona otra categoría.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: _desplazamiento,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                          itemCount: visibles.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, indice) =>
                              _TarjetaComponente(componente: visibles[indice]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TarjetaComponente extends StatelessWidget {
  const _TarjetaComponente({required this.componente});

  final Componente componente;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final precio = Text(
      componente.precioFormateado,
      style: tema.textTheme.labelLarge?.copyWith(
        color: const Color(0xFF176044),
        fontWeight: FontWeight.w700,
      ),
    );
    return LayoutBuilder(
      builder: (context, medidas) {
        final compacto = medidas.maxWidth < 480;
        return Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: tema.colorScheme.outlineVariant),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: tema.colorScheme.primaryContainer,
              foregroundColor: tema.colorScheme.onPrimaryContainer,
              child: Icon(iconoDe(componente.categoria)),
            ),
            title: Text(
              componente.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  EtiquetaCategoria(componente.categoria),
                  if (compacto) precio,
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!compacto) ...[precio, const SizedBox(width: 8)],
                const Icon(Icons.chevron_right),
              ],
            ),
            // La ficha recibe este objeto en arguments desde el Navigator.
            onTap: () => Navigator.pushNamed<void>(
              context,
              rutaDetalle,
              arguments: componente,
            ),
          ),
        );
      },
    );
  }
}
