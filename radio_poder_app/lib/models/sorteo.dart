class Sorteo {
  final int id;
  final String titulo;
  final String texto;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String foto;
  final bool estado;

  Sorteo({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.fechaInicio,
    required this.fechaFin,
    required this.foto,
    required this.estado,
  });
}
