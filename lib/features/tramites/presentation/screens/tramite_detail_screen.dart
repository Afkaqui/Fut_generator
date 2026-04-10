import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../pdf_generator/data/services/fut_pdf_builder.dart';
import '../../data/catalog/tramites_catalog.dart';

class TramiteDetailScreen extends ConsumerStatefulWidget {
  final String tramiteId;

  const TramiteDetailScreen({super.key, required this.tramiteId});

  @override
  ConsumerState<TramiteDetailScreen> createState() =>
      _TramiteDetailScreenState();
}

class _TramiteDetailScreenState extends ConsumerState<TramiteDetailScreen> {
  late TextEditingController _solicitoCtrl;
  late TextEditingController _fundamentoCtrl;
  late TextEditingController _autoridadCtrl;
  late TextEditingController _documentosCtrl;
  bool _generating = false;
  bool _incluirFirma = true;

  @override
  void initState() {
    super.initState();
    final tramite =
        TramitesCatalog.todos.firstWhere((t) => t.id == widget.tramiteId);

    _solicitoCtrl = TextEditingController(text: tramite.solicito);
    _fundamentoCtrl = TextEditingController(text: tramite.fundamentoPedido);
    _autoridadCtrl = TextEditingController(text: tramite.autoridadCargo);
    _documentosCtrl = TextEditingController(
      text: tramite.documentosSugeridos.join('\n'),
    );
  }

  @override
  void dispose() {
    _solicitoCtrl.dispose();
    _fundamentoCtrl.dispose();
    _autoridadCtrl.dispose();
    _documentosCtrl.dispose();
    super.dispose();
  }

  Future<void> _generatePdf() async {
    final profile = ref.read(profileProvider).value;
    if (profile == null) return;

    setState(() => _generating = true);

    try {
      final pdfBytes = await FutPdfBuilder.generate(
        profile: profile,
        solicito: _solicitoCtrl.text,
        autoridad: _autoridadCtrl.text,
        fundamentoPedido: _fundamentoCtrl.text,
        documentos: _documentosCtrl.text
            .split('\n')
            .where((d) => d.trim().isNotEmpty)
            .toList(),
        incluirFirma: _incluirFirma,
      );

      if (mounted) {
        context.push('/preview', extra: pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tramite =
        TramitesCatalog.todos.firstWhere((t) => t.id == widget.tramiteId);

    return Scaffold(
      appBar: AppBar(
        title: Text(tramite.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Solicito
            Text(AppStrings.solicito,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _solicitoCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Qué solicitas...',
              ),
            ),
            const SizedBox(height: 16),

            // Autoridad
            Text(AppStrings.autoridad,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _autoridadCtrl,
              decoration: const InputDecoration(
                hintText: 'Cargo de la autoridad',
              ),
            ),
            const SizedBox(height: 16),

            // Fundamento
            Text(AppStrings.fundamentoPedido,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _fundamentoCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Fundamento de tu solicitud...',
              ),
            ),
            const SizedBox(height: 16),

            // Documentos
            Text(AppStrings.documentosAdjuntos,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _documentosCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Un documento por línea',
              ),
            ),
            const SizedBox(height: 16),

            // Firma checkbox
            CheckboxListTile(
              value: _incluirFirma,
              onChanged: (v) => setState(() => _incluirFirma = v ?? true),
              title: const Text('Incluir firma digital'),
              subtitle: const Text(
                'Desmarcar para dejar espacio y firmar a mano',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // Generate button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _generating ? null : _generatePdf,
                icon: _generating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(
                  _generating ? 'Generando...' : AppStrings.generarPdf,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
