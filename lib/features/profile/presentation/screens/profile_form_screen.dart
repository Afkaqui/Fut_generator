import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/facultades_data.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/user_profile.dart';
import '../providers/profile_provider.dart';

class ProfileFormScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;

  const ProfileFormScreen({super.key, this.isOnboarding = false});

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _domicilioCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  UserType _tipo = UserType.alumno;
  String? _facultad;
  String? _escuela;
  Uint8List? _firmaBytes;
  String? _originalDni;
  bool _loaded = false;

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _dniCtrl.dispose();
    _telefonoCtrl.dispose();
    _domicilioCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  void _loadProfile(UserProfile profile) {
    _nombresCtrl.text = profile.nombres;
    _apellidosCtrl.text = profile.apellidos;
    _dniCtrl.text = profile.dni;
    _telefonoCtrl.text = profile.telefono;
    _domicilioCtrl.text = profile.domicilio;
    _correoCtrl.text = profile.correo;
    _tipo = profile.tipo;
    _facultad = FacultadesData.facultades.contains(profile.facultad)
        ? profile.facultad
        : null;
    _escuela = _facultad != null &&
            FacultadesData.escuelasDe(_facultad!).contains(profile.escuelaProfesional)
        ? profile.escuelaProfesional
        : null;
    _firmaBytes = profile.firmaBytes;
    _originalDni = profile.dni;
  }

  Future<void> _pickSignatureImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 300,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    // Process: remove white/near-white background → transparent
    final processed = await _removeWhiteBackground(bytes);
    if (processed != null) {
      setState(() => _firmaBytes = processed);
    }
  }

  Future<Uint8List?> _removeWhiteBackground(Uint8List imageBytes) async {
    try {
      final decoded = img.decodeImage(imageBytes);
      if (decoded == null) return imageBytes;

      // Convert to RGBA if needed
      final image = decoded.convert(numChannels: 4);

      const threshold = 220; // pixels with R,G,B all > threshold → transparent

      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();

          if (r > threshold && g > threshold && b > threshold) {
            // Make transparent
            pixel.a = 0;
          }
        }
      }

      return Uint8List.fromList(img.encodePng(image));
    } catch (e) {
      // If processing fails, return original
      return imageBytes;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_facultad == null || _escuela == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona facultad y escuela')),
      );
      return;
    }

    final profile = UserProfile(
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      dni: _dniCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      domicilio: _domicilioCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      tipo: _tipo,
      facultad: _facultad!,
      escuelaProfesional: _escuela!,
      firmaBytes: _firmaBytes,
    );

    await ref
        .read(profileProvider.notifier)
        .saveProfile(profile, oldDni: _originalDni);

    if (mounted) {
      if (widget.isOnboarding) {
        context.go('/home');
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    if (!widget.isOnboarding && !_loaded) {
      profileAsync.whenData((profile) {
        if (profile != null && !_loaded) {
          _loaded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _loadProfile(profile));
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isOnboarding ? 'Completa tu Perfil' : AppStrings.profileTitle,
        ),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isOnboarding) ...[
                Text(
                  AppStrings.appSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tus datos una sola vez. Se usarán para generar todos tus trámites.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],

              // Tipo de usuario
              Text(AppStrings.tipoUsuario,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: UserType.values.map((type) {
                  final labels = {
                    UserType.alumno: AppStrings.alumno,
                    UserType.docente: AppStrings.docente,
                    UserType.administrativo: AppStrings.administrativo,
                    UserType.exAlumno: AppStrings.exAlumno,
                    UserType.otro: AppStrings.otro,
                  };
                  return ChoiceChip(
                    label: Text(labels[type]!),
                    selected: _tipo == type,
                    onSelected: (_) => setState(() => _tipo = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Nombres
              TextFormField(
                controller: _nombresCtrl,
                decoration:
                    const InputDecoration(labelText: AppStrings.nombres),
                textCapitalization: TextCapitalization.words,
                validator: (v) => Validators.required(v, 'Nombres'),
              ),
              const SizedBox(height: 12),

              // Apellidos
              TextFormField(
                controller: _apellidosCtrl,
                decoration:
                    const InputDecoration(labelText: AppStrings.apellidos),
                textCapitalization: TextCapitalization.words,
                validator: (v) => Validators.required(v, 'Apellidos'),
              ),
              const SizedBox(height: 12),

              // DNI
              TextFormField(
                controller: _dniCtrl,
                decoration: const InputDecoration(labelText: AppStrings.dni),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: Validators.dni,
              ),
              const SizedBox(height: 12),

              // Teléfono
              TextFormField(
                controller: _telefonoCtrl,
                decoration:
                    const InputDecoration(labelText: AppStrings.telefono),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                validator: Validators.telefono,
              ),
              const SizedBox(height: 12),

              // Correo
              TextFormField(
                controller: _correoCtrl,
                decoration:
                    const InputDecoration(labelText: AppStrings.correo),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 12),

              // Domicilio
              TextFormField(
                controller: _domicilioCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.domicilio,
                  hintText: 'Jr. / Av. / Calle, Distrito',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => Validators.required(v, 'Domicilio'),
              ),
              const SizedBox(height: 16),

              // Facultad
              DropdownButtonFormField<String>(
                value: _facultad,
                decoration:
                    const InputDecoration(labelText: AppStrings.facultad),
                isExpanded: true,
                items: FacultadesData.facultades
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _facultad = value;
                    _escuela = null;
                  });
                },
                validator: (v) => v == null ? 'Selecciona una facultad' : null,
              ),
              const SizedBox(height: 12),

              // Escuela
              DropdownButtonFormField<String>(
                value: _escuela,
                decoration:
                    const InputDecoration(labelText: AppStrings.escuela),
                isExpanded: true,
                items: (_facultad != null
                        ? FacultadesData.escuelasDe(_facultad!)
                        : <String>[])
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _escuela = value),
                validator: (v) => v == null ? 'Selecciona una escuela' : null,
              ),
              const SizedBox(height: 20),

              // Firma
              Text(AppStrings.firma,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: _firmaBytes != null
                    ? Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.memory(_firmaBytes!),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () =>
                                  setState(() => _firmaBytes = null),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final result =
                                    await context.push<Uint8List>('/signature');
                                if (result != null) {
                                  setState(() => _firmaBytes = result);
                                }
                              },
                              icon: const Icon(Icons.draw),
                              label: const Text('Dibujar'),
                            ),
                            const SizedBox(width: 8),
                            const Text('|',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: _pickSignatureImage,
                              icon: const Icon(Icons.image),
                              label: const Text('Subir imagen'),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Save
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    AppStrings.guardar,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
