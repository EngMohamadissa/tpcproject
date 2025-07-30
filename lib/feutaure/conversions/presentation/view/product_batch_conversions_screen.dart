import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/core/widget/empty_widget_view.dart';
import 'package:tcp/core/widget/error_widget_view.dart';
import 'package:tcp/feutaure/conversions/presentation/manger/cubit/conversions_cubit.dart';
import 'package:tcp/feutaure/conversions/presentation/manger/cubit/conversions_state.dart';
import 'package:tcp/feutaure/conversions/repo/conversion_repo.dart';

class ProductBatchConversionsScreen extends StatelessWidget {
  final int productBatchId;

  const ProductBatchConversionsScreen(
      {super.key, required this.productBatchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversionsCubit(
        repository: ConversionsRepoImpl(ApiService()),
      )..getConversionsByProductBatch(productBatchId),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'تحويلات دفعة المنتج #$productBatchId',
          ),
        ),
        body: BlocBuilder<ConversionsCubit, ConversionsState>(
          builder: (context, state) {
            if (state is ConversionBatchLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ));
            } else if (state is ConversionBatchLoaded) {
              if (state.conversions.isEmpty) {
                return EmptyWigetView(
                    message: 'لا توجد تحويلات لهذه الدفعة.', icon: Icons.error);
              }
              return ListView.builder(
                itemCount: state.conversions.length,
                itemBuilder: (context, index) {
                  final conversion = state.conversions[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'الكمية: ${conversion.cost} ${conversion.quantityUsed}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('معرف المنتج: ${conversion.conversionId}'),
                          Text('تاريخ التحويل: ${conversion.createdAt}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ConversionBatchError) {
              return ErrorWidetView(message: 'حدث خطأ: ${state.message}');
            }
            return const Center(
                child: Text('اضغط لجلب التحويلات.')); // حالة افتراضية
          },
        ),
      ),
    );
  }
}
