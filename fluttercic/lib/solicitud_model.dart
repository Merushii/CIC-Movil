class SolicitudModel {
  final int? folioSolicitud; // Añadido para manejar el folio de la solicitud en el historial
  final String? description; // Cambiado de final a nullable
  final String? type; // Cambiado de final a nullable
  final String? telefono; // Cambiado de final a nullable
  final int? idEdificio; // Cambiado de final a nullable
  final String? ubicacionFisica; // Cambiado de final a nullable
  final String? equipo; // Cambiado de final a nullable
  final String? fecha; // Añadido para manejar la fecha en el historial
  final String? estado; // Añadido para manejar el estado en el historial

  SolicitudModel({
    this.folioSolicitud, // Añadido para manejar el folio de la solicitud en el historial
    this.description,
    this.type,
    this.telefono,
    this.idEdificio,
    this.ubicacionFisica,
    this.equipo,
    this.fecha, // Añadido para manejar la fecha en el historial
    this.estado, // Añadido para manejar el estado en el historial
  });

  // Constructor para crear instancias de SolicitudModel desde JSON
  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      folioSolicitud: json['FolioSolicitud'], // Añadido para manejar el folio de la solicitud en el historial
      description: json['Descripcion'],
      type: json['type'],
      telefono: json['telefono'],
      idEdificio: json['idEdificio'],
      ubicacionFisica: json['ubicacionFisica'],
      equipo: json['Equipo'],
      fecha: json['Fecha'], // Añadido para manejar la fecha en el historial
      estado: json['Estado'], // Añadido para manejar el estado en el historial
    );
  }

  // Método toJson para convertir la instancia de SolicitudModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'type': type,
      'telefono': telefono,
      'idEdificio': idEdificio,
      'ubicacionFisica': ubicacionFisica,
      'equipo': equipo,
    };
  }
}
