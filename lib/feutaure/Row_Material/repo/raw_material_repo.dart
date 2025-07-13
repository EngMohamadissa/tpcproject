import 'package:dio/dio.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/error/error_handling.dart';
import 'package:tcp/feutaure/Row_Material/data/add_raw_material_model.dart';
import 'package:tcp/feutaure/Row_Material/data/get_raw_material_model.dart';

class RawMaterialRepository {
  final ApiService apiService;

  RawMaterialRepository({required this.apiService});

  Future<String> addRawMaterial(RawMaterial rawMaterial) async {
    try {
      final response = await apiService.post(
        'raw-materials/',
        rawMaterial.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('message')) {
          return response.data['message'].toString();
        } else {
          return 'تمت إضافة المادة الخام بنجاح!';
        }
      } else {
        throw Exception('فشل في الإضافة: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? e.message ?? 'فشل الاتصال بالخادم';
      throw Exception('فشل إضافة المادة الخام: $message');
    } catch (e) {
      // ✅ هنا نتحقق إن كان الخطأ نفسه Exception فيه رسالة، نستخدمها كما هي
      if (e is Exception) {
        rethrow; // نعيد نفس الاستثناء بدون أي إضافات
      } else {
        throw Exception('حدث خطأ غير متوقع');
      }
    }
  }

  Future<List<GetRawMaterial>> getRawMaterials() async {
    try {
      final response = await apiService.get(
        'raw-materials/', // افترض أن هذا هو endpoint لجلب القائمة
      );

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('data')) {
          final List<dynamic> rawMaterialsJson = response.data['data'];
          // تحويل كل عنصر JSON إلى كائن RawMaterial
          return rawMaterialsJson
              .map((json) =>
                  GetRawMaterial.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('هيكل استجابة API غير صالح: لا يوجد حقل "data"');
        }
      } else {
        throw Exception('فشل في جلب المواد الخام: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = ErrorHandler.handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(
          'حدث خطأ غير متوقع أثناء جلب المواد الخام: ${e.toString()}');
    }
  }
}
