class Contacto {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String createdAt;
  final String updatedAt;

  Contacto({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contacto.fromMap(Map<String, dynamic> map) {
    return Contacto(
      id: map['_id'] ?? 'Id no disponible',
      nombre: map['nombre'] ?? 'Nombre no disponible',
      apellido: map['apellido'] ?? 'Apellido no disponible',
      telefono: map['telefono'] ?? "Telefono no disponible",
      createdAt: map['createdAt'] ?? 'Fecha de creacion no disponible',
      updatedAt: map['updatedAt'] ?? 'Fecha de actualizacion no disponible',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toMapForApi() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
    };
  }
}
