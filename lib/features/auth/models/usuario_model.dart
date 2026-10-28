class UsuarioModel {
  final int id;
  final String nombre;
  final String username;
  final String rol; // 'Administrador', 'Almacén', 'Entregas', 'Coordinador'
  final String token;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.username,
    required this.rol,
    required this.token,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nombre: json['nombre'],
      username: json['username'],
      rol: json['rol'], // Validado y devuelto por el servidor MySQL
      token: json['token'] ?? '',
    );
  }
}