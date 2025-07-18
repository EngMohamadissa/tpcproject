import 'package:dio/dio.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/feutaure/ProductSaleReports/data/model/monthly_profit_model.dart';
import '../../../../core/util/error/error_handling.dart';

class ProductSummaryRepositoryImp {
  final ApiService _apiService;

  ProductSummaryRepositoryImp(this._apiService);

  Future<MonthlyProfitModel> getMonthlyProfit() async {
    try {
      final response =
          await _apiService.get('product-summary-reports/monthlyProfit');
      if (response.data != null) {
        return MonthlyProfitModel.fromJson(response.data);
      } else {
        throw Exception('الاستجابة لا تحتوي على بيانات لتقرير الربح الشهري.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب الربح الشهري: $e');
    }
  }
}
