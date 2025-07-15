import 'package:tcp/feutaure/ProductionSettings/data/model/add_production_setting_model.dart';

abstract class AddProductionSettingsState {}

class AddProductionSettingState extends AddProductionSettingsState {}

class AddProductionSettingsLoading extends AddProductionSettingsState {}

class AddProductionSettingsCreated extends AddProductionSettingsState {
  final ProductionSettings settings;

  AddProductionSettingsCreated(this.settings);
}

class AddProductionSettingsError extends AddProductionSettingsState {
  final String message;

  AddProductionSettingsError(this.message);
}
