import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/catalog/tramites_catalog.dart';
import '../../data/models/tramite.dart';

class TramiteListScreen extends StatefulWidget {
  const TramiteListScreen({super.key});

  @override
  State<TramiteListScreen> createState() => _TramiteListScreenState();
}

class _TramiteListScreenState extends State<TramiteListScreen> {
  String _query = '';
  String? _categoriaSeleccionada;

  List<Tramite> get _filteredTramites {
    var result = TramitesCatalog.todos;

    if (_categoriaSeleccionada != null) {
      result = result
          .where((t) => t.categoria == _categoriaSeleccionada)
          .toList();
    }

    if (_query.isNotEmpty) {
      result = result
          .where((t) =>
              t.nombre.toLowerCase().contains(_query.toLowerCase()) ||
              t.categoria.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final categorias = TramitesCatalog.categorias;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.seleccionarTramite),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.buscar,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),

          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Todos'),
                    selected: _categoriaSeleccionada == null,
                    onSelected: (_) =>
                        setState(() => _categoriaSeleccionada = null),
                  ),
                ),
                ...categorias.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: _categoriaSeleccionada == cat,
                        onSelected: (_) => setState(
                            () => _categoriaSeleccionada = cat),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredTramites.length,
              itemBuilder: (context, index) {
                final tramite = _filteredTramites[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withAlpha(30),
                      child: Icon(
                        _iconForCategoria(tramite.categoria),
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(tramite.nombre),
                    subtitle: Text(
                      tramite.categoria,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/tramite/${tramite.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategoria(String categoria) {
    switch (categoria) {
      case 'Matrícula y Registro':
        return Icons.app_registration;
      case 'Notas y Académico':
        return Icons.grade;
      case 'Matrícula Especial':
        return Icons.swap_horiz;
      case 'Traslados':
        return Icons.transfer_within_a_station;
      case 'Documentos':
        return Icons.folder;
      case 'Grados y Títulos':
        return Icons.school;
      default:
        return Icons.description;
    }
  }
}
