class Tramite {
  final String id;
  final String nombre;
  final String categoria;
  final String autoridadCargo;
  final bool autoridadDependeDeFacultad;
  final String solicito;
  final String fundamentoPedido;
  final List<String> documentosSugeridos;

  const Tramite({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.autoridadCargo,
    this.autoridadDependeDeFacultad = true,
    required this.solicito,
    required this.fundamentoPedido,
    this.documentosSugeridos = const [],
  });
}
