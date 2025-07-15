import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/const.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_cubit.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart';

class AddProductionSettingsPage extends StatelessWidget {
  const AddProductionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' إضافة اعدادات الانتاج '),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<AddProductionSettingsCubit>(
          create: (context) => AddProductionSettingsCubit(
            repository: productionSettingsRepo,
          ),
          child: const AddProductionSettingsForm(),
        ),
      ),
    );
  }
}

class AddProductionSettingsForm extends StatefulWidget {
  const AddProductionSettingsForm({super.key});

  @override
  State<AddProductionSettingsForm> createState() =>
      _AddProductionSettingsFormState();
}

class _AddProductionSettingsFormState extends State<AddProductionSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _totalProductionController = TextEditingController();
  final _profitRatioController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'estimated';
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void dispose() {
    _totalProductionController.dispose();
    _profitRatioController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductionSettingsCubit, AddProductionSettingsState>(
      listener: (context, state) {
        if (state is AddProductionSettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AddProductionSettingsCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
          );
          // يمكنك إضافة أي إجراء إضافي بعد الحفظ
        }
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل إجمالي الإنتاج
              TextFormField(
                controller: _totalProductionController,
                decoration: const InputDecoration(
                  labelText: 'إجمالي الإنتاج',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال إجمالي الإنتاج';
                  }
                  if (double.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // حقل نسبة الربح
              TextFormField(
                controller: _profitRatioController,
                decoration: const InputDecoration(
                  labelText: 'نسبة الربح (من 0 إلى 1)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نسبة الربح';
                  }
                  final ratio = double.tryParse(value);
                  if (ratio == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  if (ratio < 0 || ratio > 1) {
                    return 'يجب أن تكون النسبة بين 0 و 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // نوع الإعدادات (تقديري/فعلي)
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع الإعدادات',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'estimated',
                    child: Text('تقديري'),
                  ),
                  DropdownMenuItem(
                    value: 'real',
                    child: Text('فعلي'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // الشهر والسنة
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(
                        labelText: 'الشهر',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'السنة',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(5, (index) {
                        final year = DateTime.now().year + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ملاحظات
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              BlocBuilder<AddProductionSettingsCubit,
                  AddProductionSettingsState>(
                builder: (context, state) {
                  if (state is AddProductionSettingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AddProductionSettingsCubit>()
                              .createProductionSettings(
                                totalProduction: double.parse(
                                    _totalProductionController.text),
                                profitRatio:
                                    double.parse(_profitRatioController.text),
                                type: _selectedType,
                                month: _selectedMonth,
                                year: _selectedYear,
                                notes: _notesController.text.isNotEmpty
                                    ? _notesController.text
                                    : null,
                              );
                        }
                      },
                      child: const Text('حفظ الإعدادات'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
