import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/widget/empty_widget_view.dart';
import 'package:tcp/core/widget/error_widget_view.dart';
import 'package:tcp/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_cubit.dart';
import 'package:tcp/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_state.dart';
import 'package:tcp/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart'; // لتنسيق الأرقام والعملة

class ProductSummaryReportScreen extends StatelessWidget {
  const ProductSummaryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductSummaryReportCubit(
        ProductSummaryRepositoryImp(
            ApiService()), // توفير ApiService و Repository
      )..fetchProductSummaryReports(), // جلب البيانات عند تحميل الشاشة
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ملخص أداء المنتجات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.indigo, // لون مميز لهذه الميزة
          elevation: 0,
        ),
        body: BlocBuilder<ProductSummaryReportCubit, ProductSummaryReportState>(
          builder: (context, state) {
            if (state is ProductSummaryReportLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.indigo));
            } else if (state is ProductSummaryReportLoaded) {
              if (state.reports.isEmpty) {
                return EmptyWigetView(
                  message: 'message',
                  icon: Icons.assignment,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.reports.length,
                itemBuilder: (context, index) {
                  final report = state.reports[index];
                  final productName = report.product?.name ?? 'منتج غير معروف';
                  final profitColor = report.netProfit >= 0
                      ? Colors.green[700]
                      : Colors.red[700];

                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo[800],
                                      ),
                                  overflow: TextOverflow
                                      .ellipsis, // لقطع النص إذا كان طويلاً
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                report.netProfit >= 0
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                color: profitColor,
                                size: 36,
                              ),
                            ],
                          ),
                          const Divider(
                              height: 25, thickness: 1, color: Colors.grey),
                          _buildInfoRow(context, 'النوع:', report.type),
                          _buildInfoRow(context, 'الكمية المنتجة:',
                              '${report.quantityProduced}'),
                          _buildInfoRow(context, 'الكمية المباعة:',
                              '${report.quantitySold}'),
                          _buildInfoRow(
                            context,
                            'إجمالي التكاليف:',
                            NumberFormat.currency(locale: 'ar', symbol: 'د.ك')
                                .format(report.totalCosts),
                          ),
                          _buildInfoRow(
                            context,
                            'إجمالي الدخل:',
                            NumberFormat.currency(locale: 'ar', symbol: 'د.ك')
                                .format(report.totalIncome),
                            valueColor: Colors.blue[700],
                          ),
                          _buildInfoRow(
                            context,
                            'الربح الصافي:',
                            NumberFormat.currency(locale: 'ar', symbol: 'د.ك')
                                .format(report.netProfit),
                            valueColor: profitColor,
                          ),
                          if (report.notes != null &&
                              report.notes!.isNotEmpty) ...[
                            const SizedBox(height: 15),
                            Text(
                              'ملاحظات:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              report.notes!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'تاريخ التقرير: ${_formatDate(report.createdAt)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductSummaryReportError) {
              return ErrorWidetView(message: state.message);
            }
            return const SizedBox
                .shrink(); // في حالة ProductSummaryReportInitial
          },
        ),
      ),
    );
  }

  // دالة مساعدة لبناء صف معلومات
  Widget _buildInfoRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: valueColor ?? Colors.black87,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لتنسيق التاريخ
  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }
}
