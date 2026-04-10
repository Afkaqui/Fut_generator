class Validators {
  Validators._();

  static String? required(String? value, [String field = 'Este campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$field es requerido';
    }
    return null;
  }

  static String? dni(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El DNI es requerido';
    }
    if (!RegExp(r'^\d{8}$').hasMatch(value.trim())) {
      return 'El DNI debe tener exactamente 8 dígitos';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(value.trim())) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  static String? telefono(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
      return 'El teléfono debe tener 9 dígitos';
    }
    return null;
  }
}
