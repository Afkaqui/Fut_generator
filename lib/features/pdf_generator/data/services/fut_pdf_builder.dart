import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../profile/data/models/user_profile.dart';

class FutPdfBuilder {
  // Ruled line Y positions for FUNDAMENTO (from PDF)
  static const _fundLines = [558.4, 577.9, 597.4, 616.8, 636.3, 655.8];
  // SOLICITO box: between lines y=124.8 and y=147.3, x=250 to x=555
  // Label rects from PDF analysis:
  // Field 2 AUTORIDAD label: y0=217.7, y1=233.0
  // Field 3 DATOS label: y0=268.6, y1=283.9
  // Field 4 DOCENTE label: y0=318.9, y1=334.2
  // Field 5 DNI label: y0=369.1, y1=384.4 (x0=29.3)
  // Field 6 TELEF label: y0=369.1, y1=384.4 (x0=311.3)
  // Field 7 DOMICILIO label: y0=419.7, y1=435.0
  // Field 8 CORREO label: y0=469.3, y1=484.6
  // Field 9 FUNDAMENTO label: y0=520.9, y1=536.2
  // Field 10 DOCS label: y0=692.3, y1=707.6
  // Field 11 FECHA label: y0=692.3, y1=707.6 (x0=311.1)
  // Field 12 FIRMA label: y0=737.2, y1=752.5 (x0=311.1)

  static Future<List<int>> generate({
    required UserProfile profile,
    required String solicito,
    required String autoridad,
    required String fundamentoPedido,
    required List<String> documentos,
    bool incluirFirma = true,
    DateTime? fecha,
  }) async {
    await initializeDateFormatting('es', null);

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final templateData =
        await rootBundle.load('assets/images/fut_template.png');
    final templateImage = pw.MemoryImage(templateData.buffer.asUint8List());

    final pdf = pw.Document();
    final now = fecha ?? DateTime.now();
    final fechaStr =
        'Huánuco, ${DateFormat("d 'de' MMMM 'de' yyyy", 'es').format(now)}';

    final valueStyle = pw.TextStyle(font: fontRegular, fontSize: 9);
    final valueBold = pw.TextStyle(font: fontBold, fontSize: 9);
    final smallStyle = pw.TextStyle(font: fontRegular, fontSize: 8);

    // Line spacing for fundamento: lines at 558.4, 577.9, 597.4...
    // Gap between lines: ~19.5 pts. Font size 8 -> lineHeight ~19.5/8 = 2.44
    const fundLineSpacing = 19.5;

    // Firma widget
    pw.Widget? firmaWidget;
    if (incluirFirma &&
        profile.firmaBytes != null &&
        profile.firmaBytes!.isNotEmpty) {
      firmaWidget = pw.Image(
        pw.MemoryImage(profile.firmaBytes!),
        width: 80,
        height: 35,
        fit: pw.BoxFit.contain,
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(
            children: [
              // Background: original FUT template
              pw.Positioned.fill(
                child: pw.Image(templateImage, fit: pw.BoxFit.fill),
              ),

              // === FIELD 1: SOLICITO ===
              // Between horizontal lines at y=124.8 and y=147.3, x=250 to x=555
              pw.Positioned(
                left: 255,
                top: 127,
                child: pw.SizedBox(
                  width: 295,
                  child: pw.Text(solicito, style: valueStyle, maxLines: 2),
                ),
              ),

              // === FIELD 2: AUTORIDAD ===
              // Below label rect y1=233.0
              pw.Positioned(
                left: 37,
                top: 236,
                child: pw.SizedBox(
                  width: 520,
                  child: pw.Text(autoridad, style: valueStyle),
                ),
              ),

              // === FIELD 3: DATOS DEL USUARIO ===
              // Below label rect y1=283.9
              pw.Positioned(
                left: 37,
                top: 287,
                child: pw.SizedBox(
                  width: 520,
                  child: pw.Text(
                    '${profile.nombres} ${profile.apellidos}',
                    style: valueBold,
                  ),
                ),
              ),

              // === FIELD 4: TIPO ===
              // Below label rect y1=334.2
              pw.Positioned(
                left: 37,
                top: 337,
                child: pw.Text(
                  profile.tipoLabel.toUpperCase(),
                  style: valueBold,
                ),
              ),

              // === FIELD 5: DNI ===
              // Below label rect y1=384.4
              pw.Positioned(
                left: 37,
                top: 388,
                child: pw.Text(profile.dni, style: valueBold),
              ),

              // === FIELD 6: TELEF/CELULAR ===
              // Below label rect y1=384.4 at x=311
              pw.Positioned(
                left: 315,
                top: 388,
                child: pw.Text(profile.telefono, style: valueBold),
              ),

              // === FIELD 7: DOMICILIO ===
              // Below label rect y1=435.0
              pw.Positioned(
                left: 37,
                top: 438,
                child: pw.SizedBox(
                  width: 520,
                  child: pw.Text(profile.domicilio, style: valueStyle),
                ),
              ),

              // === FIELD 8: CORREO ELECTRÓNICO ===
              // Below label rect y1=484.6
              pw.Positioned(
                left: 37,
                top: 488,
                child: pw.Text(profile.correo, style: valueStyle),
              ),

              // === FIELD 9: FUNDAMENTO DEL PEDIDO ===
              // Single text block that wraps naturally across ruled lines
              // First line at y=558.4, text sits above it -> top = 558.4 - 10 = ~548
              // Lines spaced 19.5pts apart
              pw.Positioned(
                left: 42,
                top: _fundLines[0] - 11,
                child: pw.SizedBox(
                  width: 508,
                  child: pw.Text(
                    fundamentoPedido,
                    style: pw.TextStyle(
                      font: fontRegular,
                      fontSize: 8,
                      lineSpacing: fundLineSpacing - 8, // 19.5 - fontSize = gap between lines
                    ),
                    maxLines: 6,
                  ),
                ),
              ),

              // === FIELD 10: DOCUMENTOS QUE SE ADJUNTAN ===
              // Below label rect y1=707.6
              pw.Positioned(
                left: 37,
                top: 710,
                child: pw.SizedBox(
                  width: 268,
                  child: pw.Text(
                    documentos.isNotEmpty
                        ? documentos
                            .asMap()
                            .entries
                            .map((e) => '${e.key + 1}. ${e.value}')
                            .join('\n')
                        : '',
                    style: smallStyle,
                    maxLines: 5,
                  ),
                ),
              ),

              // === FIELD 11: LUGAR Y FECHA ===
              // Below label rect y1=707.6 at x=311
              pw.Positioned(
                left: 315,
                top: 710,
                child: pw.SizedBox(
                  width: 235,
                  child: pw.Text(fechaStr, style: smallStyle),
                ),
              ),

              // === FIELD 12: FIRMA DEL USUARIO ===
              // If signature exists: firma + name + DNI right after label
              // If no signature: name + DNI at bottom, leaving space to sign manually
              pw.Positioned(
                left: 315,
                top: firmaWidget != null ? 755 : 800,
                child: pw.SizedBox(
                  width: 230,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (firmaWidget != null) ...[
                        firmaWidget,
                        pw.SizedBox(height: 2),
                      ],
                      pw.Container(
                        width: 130,
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        profile.nombreCompleto,
                        style: smallStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        'DNI: ${profile.dni}',
                        style: smallStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

}
