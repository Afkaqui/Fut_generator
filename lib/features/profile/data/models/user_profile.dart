import 'dart:typed_data';
import 'package:hive_ce/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String nombres;

  @HiveField(1)
  String apellidos;

  @HiveField(2)
  String dni;

  @HiveField(3)
  String telefono;

  @HiveField(4)
  String domicilio;

  @HiveField(5)
  String correo;

  @HiveField(6)
  UserType tipo;

  @HiveField(7)
  String facultad;

  @HiveField(8)
  String escuelaProfesional;

  @HiveField(9)
  Uint8List? firmaBytes;

  UserProfile({
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.telefono,
    required this.domicilio,
    required this.correo,
    required this.tipo,
    required this.facultad,
    required this.escuelaProfesional,
    this.firmaBytes,
  });

  String get nombreCompleto => '$nombres $apellidos';

  String get tipoLabel {
    switch (tipo) {
      case UserType.alumno:
        return 'Alumno';
      case UserType.docente:
        return 'Docente';
      case UserType.administrativo:
        return 'Administrativo';
      case UserType.exAlumno:
        return 'Ex Alumno';
      case UserType.otro:
        return 'Otro';
    }
  }
}

@HiveType(typeId: 1)
enum UserType {
  @HiveField(0)
  alumno,

  @HiveField(1)
  docente,

  @HiveField(2)
  administrativo,

  @HiveField(3)
  exAlumno,

  @HiveField(4)
  otro,
}
