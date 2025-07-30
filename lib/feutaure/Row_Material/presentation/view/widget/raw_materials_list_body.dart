import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_state.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_state.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/update_raw_material_view.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/widget/card_raw_material.dart';

class RawMaterialsListBody extends StatefulWidget {
  const RawMaterialsListBody({super.key});

  @override
  State<RawMaterialsListBody> createState() => _RawMaterialsListBodyState();
}

class _RawMaterialsListBodyState extends State<RawMaterialsListBody> {
  String _currentFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<GetRawMaterialsCubit>().fetchRawMaterials();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.teal.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          _buildFilterChip('All', _currentFilter == 'All'),
          _buildFilterChip('Used', _currentFilter == 'Used'),
          _buildFilterChip('Unused', _currentFilter == 'Unused'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _currentFilter = selected ? label : 'All';
        });
        context.read<GetRawMaterialsCubit>().filterRawMaterials(_currentFilter);
      },
      selectedColor: Colors.teal.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.teal.shade800 : Colors.grey.shade800,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.teal.shade600 : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      checkmarkColor: Colors.teal.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: BlocConsumer<GetRawMaterialsCubit, GetRawMaterialsState>(
            listener: (context, state) {
              if (state is GetRawMaterialsError) {
                _showSnackBar(state.message, isError: true);
              }
            },
            builder: (context, state) {
              if (state is GetRawMaterialsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                );
              } else if (state is GetRawMaterialsSuccess) {
                if (state.rawMaterials.isEmpty) {
                  return Center(
                    child: Text(
                      'No raw materials available.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.rawMaterials.length,
                  itemBuilder: (context, index) {
                    final rawMaterial = state.rawMaterials[index];
                    return CardShapeRawmaterial(rawMaterial: rawMaterial);
                  },
                );
              } else if (state is GetRawMaterialsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.teal.shade600, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'Failed to load data: ${state.message}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<GetRawMaterialsCubit>()
                              .fetchRawMaterials();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: Text(
                  'Start fetching raw materials.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
