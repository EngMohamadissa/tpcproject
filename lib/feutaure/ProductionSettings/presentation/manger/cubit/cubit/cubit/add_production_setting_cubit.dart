import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/error/error_handling.dart';
import 'package:tcp/feutaure/ProductionSettings/data/model/add_production_setting_model.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/manger/cubit/cubit/cubit/add_production_setting_state.dart';
import 'package:tcp/feutaure/ProductionSettings/repo/production_settings_repo.dart';

class AddProductionSettingsCubit extends Cubit<AddProductionSettingsState> {
  final ProductionSettingsRepo repository;

  AddProductionSettingsCubit({required this.repository})
      : super(AddProductionSettingState());

  Future<void> createProductionSettings({
    required double totalProduction,
    required String type,
    required double profitRatio,
    required int month,
    required int year,
    String? notes,
  }) async {
    emit(AddProductionSettingsLoading());
    try {
      final settings = ProductionSettings(
        totalProduction: totalProduction,
        type: type,
        profitRatio: profitRatio,
        month: month,
        year: year,
        notes: notes,
      );

      final createdSettings =
          await repository.createProductionSettings(settings);
      emit(AddProductionSettingsCreated(createdSettings));
    } on DioException catch (e) {
      String errorMessage = ErrorHandler.handleDioError(e);
      emit(AddProductionSettingsError(errorMessage));
    } catch (error) {
      emit(AddProductionSettingsError(error.toString()));
    }
  }
}
