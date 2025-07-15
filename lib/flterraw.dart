// lib/features/raw_material/data/models/raw_material_search_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/const.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/core/widget/custom_field.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_state.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/widget/raw_materials_list_body.dart';

class RawMaterialSearchPage extends StatefulWidget {
  const RawMaterialSearchPage({super.key});

  @override
  State<RawMaterialSearchPage> createState() => _RawMaterialSearchPageState();
}

class _RawMaterialSearchPageState extends State<RawMaterialSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _status;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _minStockAlertController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minStockAlertController.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح
      context.read<RawMaterialSearchCubit>().searchRawMaterials(
            name: _nameController.text.isNotEmpty ? _nameController.text : null,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
            status: _status,
            minPrice: _minPriceController.text.isNotEmpty
                ? double.parse(_minPriceController.text)
                : null,
            maxPrice: _maxPriceController.text.isNotEmpty
                ? double.parse(_maxPriceController.text)
                : null,
            minStockAlert: _minStockAlertController.text.isNotEmpty
                ? double.parse(_minStockAlertController.text)
                : null,
          );
    }
  }

  void _clearFilters() {
    _formKey.currentState!.reset();
    _status = null;

    _nameController.clear();
    _descriptionController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _minStockAlertController.clear();

    setState(() {});
    context
        .read<RawMaterialSearchCubit>()
        .searchRawMaterials(); // بحث بدون فلاتر
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'بحث المواد الخام',
        ),
      ),
      body: Column(
        children: [
          // شريط الفلاتر القابل للطي
          ExpansionTile(
            title: const Text('فلاتر البحث',
                style: TextStyle(fontWeight: FontWeight.bold)),
            initiallyExpanded: false,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        label: Text('اسم المادة'),
                        prefixIcon: const Icon(Icons.label),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _descriptionController,
                        label: Text('الوصف'),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        focusColor: Colors.white,
                        iconEnabledColor: Palette.primary,
                        iconDisabledColor: Palette.primary,
                        value: _status,
                        decoration: InputDecoration(
                            labelText: 'الحالة',
                            prefixIcon: const Icon(
                              Icons.start,
                              color: Palette.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        items: const [
                          DropdownMenuItem(
                              value: null,
                              child: Text('الكل',
                                  style: TextStyle(color: Palette.primary))),
                          DropdownMenuItem(
                              value: 'used',
                              child: Text(
                                'مستخدمة',
                                style: TextStyle(color: Palette.primary),
                              )),
                          DropdownMenuItem(
                              value: 'unused',
                              child: Text('غير مستخدمة',
                                  style: TextStyle(color: Palette.primary))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _status = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _minPriceController,
                              keyboardType: TextInputType.number,
                              label: Text('أقل سعر'),
                              prefixIcon: const Icon(Icons.attach_money),
                              validator: (value) {
                                if (value!.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'أدخل رقم صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              label: Text('أعلى سعر'),
                              prefixIcon: const Icon(Icons.attach_money),
                              validator: (value) {
                                if (value!.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'أدخل رقم صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _minStockAlertController,
                        keyboardType: TextInputType.number,
                        label: Text('الحد الأدنى للتنبيه'),
                        prefixIcon: const Icon(Icons.notifications_active),
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              double.tryParse(value) == null) {
                            return 'أدخل رقم صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.search),
                              label: const Text('بحث'),
                              onPressed: _search,
                              style: FilledButton.styleFrom(
                                backgroundColor: Palette.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(
                                Icons.clear,
                                color: Palette.primary,
                              ),
                              label: const Text(
                                'مسح الفلاتر',
                                style: TextStyle(color: Palette.primary),
                              ),
                              onPressed: _clearFilters,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          // نتائج البحث
          Expanded(
            child: BlocBuilder<RawMaterialSearchCubit, RawMaterialSearchState>(
              builder: (context, state) {
                if (state is RawMaterialSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RawMaterialSearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _search,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is RawMaterialSearchSuccess) {
                  if (state.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد نتائج',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'حاول تغيير معايير البحث',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final rowmateria = state.results[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardShapeRawmaterial(
                          rawMaterial: rowmateria,
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'استخدم فلاتر البحث للبدء',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
