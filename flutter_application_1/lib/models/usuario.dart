class Usuario {
  final String uid;
  final String nombre;
  final String correoElectronico;
  final String? telefono;
  final String? fotoPerfil;
  final DateTime? fechaCreacion;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.correoElectronico,
    this.telefono,
    this.fotoPerfil,
    this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correoElectronico': correoElectronico,
      'telefono': telefono,
      'fotoPerfil': fotoPerfil,
      'fechaCreacion': fechaCreacion,
    };
  }

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'] ?? '',
      correoElectronico: map['correoElectronico'] ?? '',
      telefono: map['telefono'],
      fotoPerfil: map['fotoPerfil'],
      fechaCreacion: map['fechaCreacion']?.toDate(),
    );
  }

  Usuario copyWith({
    String? uid,
    String? nombre,
    String? correoElectronico,
    String? telefono,
    String? fotoPerfil,
    DateTime? fechaCreacion,
  }) {
    return Usuario(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      telefono: telefono ?? this.telefono,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
