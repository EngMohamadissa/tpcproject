// lib/features/production_settings/data/repositories/production_settings_repo.dart
import 'package:dio/dio.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/error/error_handling.dart';
import 'package:tcp/feutaure/ProductionSettings/data/model/add_production_setting_model.dart';
import 'package:tcp/feutaure/ProductionSettings/data/model/entities/production_setting.dart';
import 'package:tcp/feutaure/ProductionSettings/data/model/production_setting_model.dart';

class ProductionSettingsRepo {
  final ApiService apiService;

  ProductionSettingsRepo(this.apiService);

  Future<List<ProductionSetting>> getProductionSettings() async {
    try {
      final response = await apiService.get('production-settings');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<ProductionSetting> settings =
            data.map((json) => ProductionSettingModel.fromJson(json)).toList();
        return settings;
      } else {
        throw ServerException(
            'Failed to load production settings: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'A network error occurred.');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ProductionSettings> createProductionSettings(
      ProductionSettings settings) async {
    try {
      final response = await apiService.post(
        'production-settings',
        settings.toJson(),
      );
      return ProductionSettings.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

// Define custom exceptions to be thrown by the repository
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}
// lib/features/production_settings/data/model/production_setting_model.dart
// (ملاحظة: المسار في الكود الذي أرسلته كان 'feutaure/ProductionSettings/data/model/production_setting_model.dart'
//  لكنني سأفترض أنه يجب أن يكون 'features/production_settings/data/model/production_setting_model.dart' ليتوافق مع باقي بنية المشروع.)
