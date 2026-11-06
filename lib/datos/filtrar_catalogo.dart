import '../modelos/componente.dart';

List<Componente> filtrarCatalogo(
  List<Componente> componentes,
  Categoria? categoria,
  String busqueda,
) {
  final termino = _normalizar(busqueda.trim());
  // El resultado se deriva de la colección original en cada cambio de filtro.
  return componentes.where((componente) {
    final coincideCategoria =
        categoria == null || componente.categoria == categoria;
    return coincideCategoria &&
        (_normalizar(componente.nombre).contains(termino) ||
            _normalizar(componente.categoria.etiqueta).contains(termino));
  }).toList();
}

String _normalizar(String texto) => texto
    .toLowerCase()
    .replaceAll('á', 'a')
    .replaceAll('é', 'e')
    .replaceAll('í', 'i')
    .replaceAll('ó', 'o')
    .replaceAll('ú', 'u')
    .replaceAll('ü', 'u');
