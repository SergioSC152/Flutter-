class Bovino {
  final String? id;
  final String numeroAnimal;
  final String tipoAnimal; // Vacas, Novillos, Toros, Terneros/becceros
  final String raza;
  final String? enfermedad;
  final String? disposicion;
  final String? peso;
  final String? reporteVacunas;
  final String? imagenUrl;
  final String? observaciones;
  final DateTime fechaRegistro;
  final String usuarioId; // ID del usuario que registró el animal

  Bovino({
    this.id,
    required this.numeroAnimal,
    required this.tipoAnimal,
    required this.raza,
    this.enfermedad,
    this.disposicion,
    this.peso,
    this.reporteVacunas,
    this.imagenUrl,
    this.observaciones,
    required this.fechaRegistro,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'numeroAnimal': numeroAnimal,
      'tipoAnimal': tipoAnimal,
      'raza': raza,
      'enfermedad': enfermedad,
      'disposicion': disposicion,
      'peso': peso,
      'reporteVacunas': reporteVacunas,
      'imagenUrl': imagenUrl,
      'observaciones': observaciones,
      'fechaRegistro': fechaRegistro,
      'usuarioId': usuarioId,
    };
  }

  factory Bovino.fromMap(String id, Map<String, dynamic> map) {
    return Bovino(
      id: id,
      numeroAnimal: map['numeroAnimal'] ?? '',
      tipoAnimal: map['tipoAnimal'] ?? '',
      raza: map['raza'] ?? '',
      enfermedad: map['enfermedad'],
      disposicion: map['disposicion'],
      peso: map['peso'],
      reporteVacunas: map['reporteVacunas'],
      imagenUrl: map['imagenUrl'],
      observaciones: map['observaciones'],
      fechaRegistro: map['fechaRegistro']?.toDate() ?? DateTime.now(),
      usuarioId: map['usuarioId'] ?? '',
    );
  }

  Bovino copyWith({
    String? id,
    String? numeroAnimal,
    String? tipoAnimal,
    String? raza,
    String? enfermedad,
    String? disposicion,
    String? peso,
    String? reporteVacunas,
    String? imagenUrl,
    String? observaciones,
    DateTime? fechaRegistro,
    String? usuarioId,
  }) {
    return Bovino(
      id: id ?? this.id,
      numeroAnimal: numeroAnimal ?? this.numeroAnimal,
      tipoAnimal: tipoAnimal ?? this.tipoAnimal,
      raza: raza ?? this.raza,
      enfermedad: enfermedad ?? this.enfermedad,
      disposicion: disposicion ?? this.disposicion,
      peso: peso ?? this.peso,
      reporteVacunas: reporteVacunas ?? this.reporteVacunas,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      observaciones: observaciones ?? this.observaciones,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
