import '../models/tramite.dart';

class TramitesCatalog {
  TramitesCatalog._();

  static const List<Tramite> todos = [
    // --- Grados y Títulos ---
    Tramite(
      id: 'titulo_profesional',
      nombre: 'Otorgamiento de Título Profesional',
      categoria: 'Grados y Títulos',
      autoridadCargo: 'Decano de la Facultad',
      solicito:
          'Otorgamiento del Título Profesional de Ingeniero ............ (Especificar la Escuela Profesional)',
      fundamentoPedido:
          'Solicito el otorgamiento de mi Título Profesional, habiendo obtenido previamente el grado de Bachiller y aprobado mi tesis, cumpliendo además con la publicación en el Repositorio Institucional, el pago correspondiente y los demás requisitos establecidos en el TUPA de la UNHEVAL, por lo que solicito se continúe con el trámite correspondiente.',
      documentosSugeridos: [
        'Dos (02) fotografías actualizadas de frente, tamaño pasaporte (alto 4.5 cm y ancho 3.5 cm), a colores, en fondo blanco, con terno azul presidente o negro, sin lentes',
        'Declaración jurada simple de antecedentes policiales, penales y judiciales',
        'Dos (02) diplomas',
        'Tres dossier (PDF editable) de la tesis o trabajo de suficiencia profesional',
        'Voucher de pago por derecho de Título Profesional',
      ],
    ),
    Tramite(
      id: 'grado_bachiller',
      nombre: 'Otorgamiento de Grado de Bachiller',
      categoria: 'Grados y Títulos',
      autoridadCargo: 'Decano de la Facultad',
      solicito:
          'Otorgamiento del Grado Académico de Bachiller en Ingeniería ............ (Especificar la Escuela Profesional)',
      fundamentoPedido:
          'Solicito el otorgamiento del Grado Académico de Bachiller, indicando que cumplo con los requisitos establecidos en TUPA institucional, habiendo concluido mi plan de estudios, realizado mis prácticas preprofesionales, acreditado el idioma extranjero de nivel básico y reuniendo los documentos exigidos para el trámite correspondiente.',
      documentosSugeridos: [
        'Certificado de idioma inglés',
        'Voucher de pago por derecho del Grado de Bachiller',
        'Dos (02) fotografías actualizadas de frente, tamaño pasaporte (alto 4.5 cm y ancho 3.5 cm), a colores, en fondo blanco, con terno azul presidente o negro, sin lentes',
      ],
    ),

    // --- Prácticas Preprofesionales ---
    Tramite(
      id: 'aprobacion_practicas',
      nombre: 'Aprobación de Prácticas Preprofesionales',
      categoria: 'Prácticas Preprofesionales',
      autoridadCargo: 'Decano de la Facultad',
      solicito: 'Aprobación de Prácticas Preprofesionales',
      fundamentoPedido:
          'Solicito la aprobación de mis prácticas preprofesionales, realizadas conforme a la normativa vigente y a los lineamientos de la Facultad, habiendo cumplido con las horas establecidas, las actividades formativas asignadas y contando con los documentos de respaldo emitidos por la institución donde desarrollé mis prácticas.',
      documentosSugeridos: [
        'Tres (03) ejemplares del informe de las prácticas pre profesionales impreso ambas caras, excepto carátula e introducción',
        'Hoja de evaluación de la empresa (según el Reglamento de Prácticas Preprofesionales de la Facultad)',
        'Carta de conformidad del asesor',
        'Acta de vista de asesor de práctica pre profesional',
        'Cargo de entrega de informe de práctica pre profesional, en formato facilitado por la CEPP',
      ],
    ),
    Tramite(
      id: 'autorizacion_practicas',
      nombre: 'Autorización para Realizar Prácticas Preprofesionales',
      categoria: 'Prácticas Preprofesionales',
      autoridadCargo: 'Decano de la Facultad',
      solicito:
          'Autorización para Realizar Prácticas Preprofesionales y Designación de asesor académico',
      fundamentoPedido:
          'Solicito la autorización para realizar prácticas preprofesionales, en virtud de haber aprobado los créditos requeridos por mi escuela profesional y contar con la aceptación de la institución donde deseo realizar dichas prácticas, cumpliendo lo establecido en el reglamento de prácticas de la Facultad. Por ello, solicito se emita la autorización correspondiente para iniciar formalmente mis actividades formativas.',
      documentosSugeridos: [
        'Carta de aceptación de la empresa o institución',
        'Plan de prácticas preprofesionales',
      ],
    ),

    // --- Matrícula ---
    Tramite(
      id: 'cuarta_matricula',
      nombre: 'Cuarta Matrícula Pregrado',
      categoria: 'Matrícula',
      autoridadCargo: 'Decano de la Facultad',
      solicito:
          'Cuarta matrícula en el curso ............ (especificar curso, módulo o proyecto formativo)',
      fundamentoPedido:
          'Que, habiendo desaprobado el mismo curso, módulo o proyecto formativo por tres (3) veces consecutivas o alternadas, solicito se me permita la cuarta matrícula conforme al procedimiento establecido en el TUPA institucional, comprometiéndome a cumplir con las exigencias académicas correspondientes.',
      documentosSugeridos: [
        'Voucher de pago por derecho de cuarta matrícula',
      ],
    ),

    // --- Registro Central y Archivo Académico ---
    Tramite(
      id: 'constancia',
      nombre: 'Solicitud de Constancia',
      categoria: 'Registro Central',
      autoridadCargo:
          'Coordinador - Unidad Funcional de Registro Central y Archivo Académico',
      autoridadDependeDeFacultad: false,
      solicito:
          'Constancia de: ............ (INDICAR EL TIPO DE CONSTANCIA SEGÚN SEA EL CASO)',
      fundamentoPedido:
          'Que, necesitando para trámites personales, solicito a Usted, ordene a quien corresponda se me expida la Constancia de (INDICAR EL TIPO DE CONSTANCIA SEGÚN SEA EL CASO), de la Escuela Profesional (INDICAR LA ESCUELA PROFESIONAL AL CUAL PERTENECE).',
      documentosSugeridos: [
        'Recibo de pago por derecho de Constancia',
      ],
    ),
    Tramite(
      id: 'certificado_estudios',
      nombre: 'Certificado de Estudios',
      categoria: 'Registro Central',
      autoridadCargo:
          'Coordinador - Unidad Funcional de Registro Central y Archivo Académico',
      autoridadDependeDeFacultad: false,
      solicito:
          'Certificado de Estudios (INDICAR AÑOS DE ESTUDIO QUE SOLICITA, por ejemplo de 1° a 5°)',
      fundamentoPedido:
          'Que, necesitando para trámites personales, solicito a Usted, ordene a quien corresponda se me expida el Certificado de Estudios (INDICAR AÑOS DE ESTUDIO QUE SOLICITA, por ejemplo de 1° a 5°), de la Escuela Profesional (INDICAR LA ESCUELA PROFESIONAL AL CUAL PERTENECE).',
      documentosSugeridos: [
        'Recibo de pago por derecho de Certificado',
        'Fotografía (OPCIONAL)',
      ],
    ),

    // --- Personalizado ---
    Tramite(
      id: 'personalizado',
      nombre: 'FUT Personalizado',
      categoria: 'Personalizado',
      autoridadCargo: '',
      autoridadDependeDeFacultad: false,
      solicito: '',
      fundamentoPedido: '',
      documentosSugeridos: [],
    ),
  ];

  static List<String> get categorias =>
      todos.map((t) => t.categoria).toSet().toList();

  static List<Tramite> porCategoria(String categoria) =>
      todos.where((t) => t.categoria == categoria).toList();

  static List<Tramite> buscar(String query) {
    final q = query.toLowerCase();
    return todos
        .where((t) =>
            t.nombre.toLowerCase().contains(q) ||
            t.categoria.toLowerCase().contains(q))
        .toList();
  }
}
