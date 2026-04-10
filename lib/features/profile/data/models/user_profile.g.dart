// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserProfile(
      nombres: fields[0] as String,
      apellidos: fields[1] as String,
      dni: fields[2] as String,
      telefono: fields[3] as String,
      domicilio: fields[4] as String,
      correo: fields[5] as String,
      tipo: fields[6] as UserType,
      facultad: fields[7] as String,
      escuelaProfesional: fields[8] as String,
      firmaBytes: fields[9] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.nombres)
      ..writeByte(1)
      ..write(obj.apellidos)
      ..writeByte(2)
      ..write(obj.dni)
      ..writeByte(3)
      ..write(obj.telefono)
      ..writeByte(4)
      ..write(obj.domicilio)
      ..writeByte(5)
      ..write(obj.correo)
      ..writeByte(6)
      ..write(obj.tipo)
      ..writeByte(7)
      ..write(obj.facultad)
      ..writeByte(8)
      ..write(obj.escuelaProfesional)
      ..writeByte(9)
      ..write(obj.firmaBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 1;

  @override
  UserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserType.alumno;
      case 1:
        return UserType.docente;
      case 2:
        return UserType.administrativo;
      case 3:
        return UserType.exAlumno;
      case 4:
        return UserType.otro;
      default:
        return UserType.alumno;
    }
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    switch (obj) {
      case UserType.alumno:
        writer.writeByte(0);
        break;
      case UserType.docente:
        writer.writeByte(1);
        break;
      case UserType.administrativo:
        writer.writeByte(2);
        break;
      case UserType.exAlumno:
        writer.writeByte(3);
        break;
      case UserType.otro:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
