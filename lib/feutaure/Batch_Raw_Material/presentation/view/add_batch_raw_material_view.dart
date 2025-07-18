import 'package:flutter/material.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/widget/body_add_batch_raw_material.dart';

class AddBatchRawMaterialView extends StatelessWidget {
  const AddBatchRawMaterialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'Add Batch RawMaterial',
        ),
      ),
      body: BodyAddBatchRawMaterial(),
    );
  }
}
