import 'package:flutter/material.dart';

import '../modelos/componente.dart';

class FormularioComponente extends StatefulWidget {
  const FormularioComponente({super.key});

  @override
  State<FormularioComponente> createState() => _FormularioComponenteState();
}

class _FormularioComponenteState extends State<FormularioComponente> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _precio = TextEditingController();
  final _descripcion = TextEditingController();
  Categoria? _categoria;

  @override
  void dispose() {
    // Estos controladores pertenecen al modal y se liberan al cerrarlo.
    _nombre.dispose();
    _precio.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _guardar() {
    // FormState ejecuta cada validator. Solo se devuelve un registro válido.
    if (!_formulario.currentState!.validate()) return;
    Navigator.pop(
      context,
      Componente(
        nombre: _nombre.text.trim(),
        categoria: _categoria!,
        precioCentimos: leerPrecioEnCentimos(_precio.text)!,
        descripcion: _descripcion.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar Nuevo Componente'),
      scrollable: true,
      constraints: const BoxConstraints(maxWidth: 560),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formulario,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Componente',
                  prefixIcon: Icon(Icons.laptop),
                ),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Escribe el nombre del componente.'
                    : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<Categoria>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                items: [
                  for (final categoria in Categoria.values)
                    DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria.etiqueta),
                    ),
                ],
                onChanged: (categoria) => _categoria = categoria,
                validator: (valor) =>
                    valor == null ? 'Selecciona una categoría.' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _precio,
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ej. S/ 450.00',
                  prefixIcon: Icon(Icons.payments_outlined),
                  errorMaxLines: 2,
                ),
                validator: (valor) {
                  final entrada = (valor ?? '').trim();
                  if (entrada.isEmpty) return 'Escribe el precio.';
                  if (leerPrecioEnCentimos(entrada) == null) {
                    return 'Ingresa un precio positivo de hasta 9 dígitos '
                        'enteros y 2 decimales.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descripcion,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descripción Técnica',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Escribe la descripción técnica.'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar Componente'),
        ),
      ],
    );
  }
}
