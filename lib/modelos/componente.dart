enum Categoria {
  hardware('Hardware'),
  procesadores('Procesadores'),
  almacenamiento('Almacenamiento'),
  perifericos('Periféricos');

  const Categoria(this.etiqueta);

  final String etiqueta;
}

class Componente {
  const Componente({
    required this.nombre,
    required this.categoria,
    required this.precioCentimos,
    required this.descripcion,
    this.disponible = true,
  });

  final String nombre;
  final Categoria categoria;
  final int precioCentimos;
  final String descripcion;
  final bool disponible;

  // El precio se guarda en céntimos enteros para evitar redondeos binarios.
  String get precioFormateado {
    final soles = precioCentimos ~/ 100;
    final centimos = (precioCentimos % 100).toString().padLeft(2, '0');
    return 'S/. $soles.$centimos';
  }
}

// Admite punto o coma como separador decimal y rechaza separadores de miles.
int? leerPrecioEnCentimos(String entrada) {
  final partes = RegExp(r'^([0-9]{1,9})(?:[.,]([0-9]{1,2}))?$')
      .firstMatch(entrada.trim());
  if (partes == null) return null;

  final soles = int.parse(partes[1]!);
  final centimos = int.parse((partes[2] ?? '').padRight(2, '0'));
  final total = soles * 100 + centimos;
  return total > 0 ? total : null;
}
