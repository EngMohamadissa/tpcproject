import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_state.dart';
import 'package:tcp/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart';

class ProductSummaryReportCubit extends Cubit<ProductSummaryReportState> {
  final ProductSummaryRepositoryImp _productSummaryRepository;

  ProductSummaryReportCubit(this._productSummaryRepository)
      : super(ProductSummaryReportInitial());

  Future<void> fetchProductSummaryReports() async {
    emit(ProductSummaryReportLoading());
    try {
      final reports =
          await _productSummaryRepository.getProductSummaryReports();
      emit(ProductSummaryReportLoaded(reports));
    } catch (e) {
      emit(ProductSummaryReportError(e.toString()));
    }
  }
}
