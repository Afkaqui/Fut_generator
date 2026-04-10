class FacultadesData {
  FacultadesData._();

  // Fuente: https://webs.unheval.edu.pe/ y https://admision.unheval.edu.pe/escuelas-profesionales/
  static const Map<String, List<String>> facultadesEscuelas = {
    'Ciencias Administrativas y Turismo': [
      'Ciencias Administrativas',
      'Turismo y Hotelería',
    ],
    'Ciencias Agrarias': [
      'Ingeniería Agronómica',
      'Ingeniería Agroindustrial',
    ],
    'Ciencias Contables y Financieras': [
      'Ciencias Contables y Financieras',
    ],
    'Ciencias de la Educación': [
      'Educación Física',
      'Educación Inicial',
      'Educación Primaria',
      'Biología, Química y Ciencias del Ambiente',
      'Ciencias Histórico Sociales y Geográficas',
      'Filosofía, Psicología y Ciencias Sociales',
      'Lengua y Literatura',
      'Matemática y Física',
    ],
    'Ciencias Sociales': [
      'Ciencias de la Comunicación Social',
      'Sociología',
    ],
    'Derecho y Ciencias Políticas': [
      'Derecho y Ciencias Políticas',
    ],
    'Economía': [
      'Economía',
    ],
    'Enfermería': [
      'Enfermería',
    ],
    'Ingeniería Civil y Arquitectura': [
      'Arquitectura',
      'Ingeniería Civil',
    ],
    'Ingeniería Industrial, de Sistemas y Mecatrónica': [
      'Ingeniería Industrial',
      'Ingeniería de Sistemas',
      'Ingeniería Mecatrónica',
    ],
    'Medicina': [
      'Medicina Humana',
      'Odontología',
    ],
    'Medicina Veterinaria y Zootecnia': [
      'Medicina Veterinaria',
    ],
    'Obstetricia': [
      'Obstetricia',
    ],
    'Psicología': [
      'Psicología',
    ],
  };

  static List<String> get facultades => facultadesEscuelas.keys.toList();

  static List<String> escuelasDe(String facultad) =>
      facultadesEscuelas[facultad] ?? [];
}
