// raw_material_batches_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/const.dart';
import 'package:tcp/core/util/func/float_action_botton.dart';
import 'package:tcp/core/util/func/show.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/add_batch_raw_material_view.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_state.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_state.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_state.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/update_batch_raw_material.dart'
    show UpdateBatchRawMaterial;
import 'package:tcp/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';

class RawMaterialBatchesListScreen extends StatelessWidget {
  const RawMaterialBatchesListScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'All RawMaterial Batch',
          ),
        ),
        body: BlocListener<AddRawMaterialBatchCubit, AddRawMaterialBatchState>(
          listener: (context, state) {
            if (state is AddRawMaterialBatchSuccess) {
              context
                  .read<RawMaterialBatchesListCubit>()
                  .fetchRawMaterialBatches();
            }
          },
          child: BathcRawMaterialBody(),
        ),
      ),
    );
  }
}

class BathcRawMaterialBody extends StatefulWidget {
  const BathcRawMaterialBody({
    super.key,
  });

  @override
  State<BathcRawMaterialBody> createState() => _BathcRawMaterialBodyState();
}

class _BathcRawMaterialBodyState extends State<BathcRawMaterialBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RawMaterialBatchesListCubit>().fetchRawMaterialBatches();
    });
  }

  Widget _buildInfoRow(String label, String value,
      {IconData? icon, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: iconColor ?? Colors.grey[600]),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateBatchRawMaterialCubit,
        UpdateBatchRawMaterialState>(
      listener: (context, state) {
        if (state is DeleatBatchRawMaterialSuccess ||
            state is UpdateBatchRawMaterialSuccess) {
          context.read<RawMaterialBatchesListCubit>().fetchRawMaterialBatches();
        }
        if (state is DeleatBatchRawMaterialError) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primaryError,
          );
        }
        if (state is DeleatBatchRawMaterialSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            color: Palette.primarySuccess,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<RawMaterialBatchesListCubit>()
                .fetchRawMaterialBatches();
          },
          color: Colors.indigo, // Refresh indicator color
          child: BlocConsumer<RawMaterialBatchesListCubit,
              RawMaterialBatchesListState>(
            listener: (context, state) {
              if (state is RawMaterialBatchesListError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is RawMaterialBatchesListLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.indigo));
              } else if (state is RawMaterialBatchesListLoaded) {
                if (state.batches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers_clear,
                            size: 100, color: Colors.grey[400]),
                        const SizedBox(height: 20),
                        Text(
                          'No raw material batches to display at the moment.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<RawMaterialBatchesListCubit>()
                                .fetchRawMaterialBatches();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.batches.length,
                  itemBuilder: (context, index) {
                    final batch = state.batches[index];
                    final isLowStock = batch.quantityRemaining <=
                        batch.rawMaterial.minimumStockAlert;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 6, // Increased shadow for more prominence
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // More rounded corners
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(20.0), // Increased padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Section: Raw Material Name and Stock Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${batch.rawMaterial.name} (Batch #${batch.rawMaterialBatchId})',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[800],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      size: 24, color: Colors.green[600]),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateBatchRawMaterial(
                                                rawMaterialBatchModel: batch,
                                              )),
                                    );
                                  },
                                  tooltip: 'Edit Batch',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      size: 24, color: Colors.red[600]),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('تأكيد الحذف'),
                                        content: const Text(
                                            'هل أنت متأكد من رغبتك في حذف هذه المادة؟'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('إلغاء'),
                                          ),
                                          BlocConsumer<
                                              UpdateBatchRawMaterialCubit,
                                              UpdateBatchRawMaterialState>(
                                            listener: (context, state) {
                                              if (state
                                                  is DeleatBatchRawMaterialSuccess) {
                                                Navigator.pop(
                                                    context); // إغلاق dialog عند النجاح
                                              }
                                            },
                                            builder: (context, state) {
                                              return TextButton(
                                                onPressed: state
                                                        is DeleatBatchRawMaterialLoading
                                                    ? null
                                                    : () {
                                                        context
                                                            .read<
                                                                UpdateBatchRawMaterialCubit>()
                                                            .deleatBatchRawMaterial(
                                                                batch
                                                                    .rawMaterialId);
                                                      },
                                                child: state
                                                        is DeleatBatchRawMaterialLoading
                                                    ? const CircularProgressIndicator()
                                                    : const Text('حذف',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  tooltip: 'Delete Batch',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isLowStock
                                        ? Colors.red.shade600
                                        : Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isLowStock ? 'Low Stock' : 'In Stock',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15), // Space after title
                            const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Colors.indigo), // Distinct color divider
                            const SizedBox(height: 15),

                            // Essential Batch Details (can be in a 2x2 grid or two rows)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoRow(
                                        'Quantity In',
                                        '${batch.quantityIn}',
                                        icon: Icons.add_circle_outline,
                                        iconColor: Colors.blueAccent[700],
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoRow(
                                        'Quantity Remaining',
                                        '${batch.quantityRemaining}',
                                        icon: Icons.layers,
                                        iconColor: isLowStock
                                            ? Colors.red
                                            : Colors.orange[
                                                700], // Different color for low stock
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoRow(
                                        'Actual Cost',
                                        '${batch.realCost} SAR',
                                        icon: Icons.monetization_on,
                                        iconColor: Colors.purple[700],
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoRow(
                                        'Supplier',
                                        batch.supplier,
                                        icon: Icons.people_alt,
                                        iconColor: Colors.brown[600],
                                      ),
                                    ),
                                  ],
                                ),
                                _buildInfoRow(
                                  'Payment Method',
                                  batch.paymentMethod,
                                  icon: Icons.credit_card,
                                  iconColor: Colors.teal[600],
                                ),
                                _buildInfoRow(
                                  'Notes',
                                  batch.notes.isNotEmpty
                                      ? batch.notes
                                      : 'No notes available', // Better message if notes are empty
                                  icon: Icons.notes,
                                  iconColor: Colors.grey[600],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                            const Divider(
                                height: 1, thickness: 0.8, color: Colors.grey),
                            const SizedBox(height: 15),

                            // Creation and Update Dates
                            Align(
                              alignment:
                                  Alignment.centerLeft, // Align left for LTR
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date Added: ${DateFormat('yyyy-MM-dd HH:mm').format(batch.createdAt.toLocal())}', // More detailed date format
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Date Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(batch.updatedAt.toLocal())}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),
                            const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Colors.blueGrey),
                            const SizedBox(height: 15),

                            // Related Raw Material Details
                            Text(
                              'Raw Material Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                                'Description',
                                batch.rawMaterial.description.isNotEmpty
                                    ? batch.rawMaterial.description
                                    : 'No description available',
                                icon: Icons.description),
                            _buildInfoRow(
                                'Price', '${batch.rawMaterial.price} SAR',
                                icon: Icons.price_change),
                            _buildInfoRow('Status', batch.rawMaterial.status,
                                icon: Icons.info_outline),
                            _buildInfoRow(
                              'Minimum Alert Threshold',
                              '${batch.rawMaterial.minimumStockAlert}',
                              icon: Icons.notification_important,
                              iconColor:
                                  Colors.deepOrange, // Distinct color for alert
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is RawMaterialBatchesListError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 100, color: Colors.red[400]),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<RawMaterialBatchesListCubit>()
                              .fetchRawMaterialBatches();
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text(
                          'Retry',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Default state (might be RawMaterialBatchesListInitial)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        size: 100, color: Colors.blueGrey[300]),
                    const SizedBox(height: 20),
                    Text(
                      'Loading...', // Could be "Tap to refresh" if no auto-fetch
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
