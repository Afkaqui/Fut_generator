import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../core/constants/app_strings.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<int> pdfBytes;

  const PdfPreviewScreen({super.key, required this.pdfBytes});

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/FUT_UNHEVAL.pdf');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'FUT UNHEVAL',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al compartir: $e')),
        );
      }
    }
  }

  Future<void> _savePdf(BuildContext context) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/FUT_UNHEVAL_$timestamp.pdf');
      await file.writeAsBytes(pdfBytes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF guardado en: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.vistaPrevia),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePdf(context),
            tooltip: AppStrings.compartir,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _savePdf(context),
            tooltip: AppStrings.descargar,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              Printing.layoutPdf(
                onLayout: (_) => Uint8List.fromList(pdfBytes),
              );
            },
            tooltip: AppStrings.imprimir,
          ),
        ],
      ),
      body: PdfPreview(
        build: (_) => Uint8List.fromList(pdfBytes),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowSharing: false,
        allowPrinting: false,
      ),
    );
  }
}
