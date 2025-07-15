// lib/features/production_settings/presentation/pages/production_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/const.dart';
import 'package:tcp/core/util/func/show.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/core/widget/error_widget_view.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_cubit.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/manger/cubit/get_product_setting_state.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/add_production_page.dart';
import 'package:tcp/feutaure/ProductionSettings/presentation/view/widget/production_setting_card.dart';
import 'package:tcp/feutaure/ProductionSettings/repo/production_settings_repo.dart';

import '../../../../core/util/func/float_action_botton.dart';

class ProductionSettingsPage extends StatelessWidget {
  const ProductionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductionSettingsCubit(
        repository: ProductionSettingsRepo(
          ApiService(),
        ),
      )..fetchProductionSettings(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            title: '  عرض   الإنتاج',
            automaticallyImplyLeading: true,
          ),
        ),
        body: BlocConsumer<ProductionSettingsCubit, ProductionSettingsState>(
          listener: (context, state) {
            if (state is ProductionSettingsLoaded) {
              showCustomSnackBar(
                context,
                'get Production Setting Success',
                color: Palette.primarySuccess,
              );
            } else if (state is ProductionSettingsError) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.primaryError,
              );
            }
          },
          builder: (context, state) {
            if (state is ProductionSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductionSettingsLoaded) {
              if (state.settings.isEmpty) {
                return const Center(
                  child: Text('No production data available.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: state.settings.length,
                itemBuilder: (context, index) {
                  return ProductionSettingCard(
                    setting: state.settings[index],
                    onDelete: () {},
                    onEdit: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => UpdateProductionSettingDialog(
                      //             currentSetting: null,
                      //           )),
                      // );
                    },
                  );
                },
              );
            } else if (state is ProductionSettingsError) {
              return ErrorWidetView(
                message: state.message,
                onPressed: () {
                  context
                      .read<ProductionSettingsCubit>()
                      .fetchProductionSettings();
                },
              );
            }
            return const Center(
                child: Text('Press the button to load production settings.'));
          },
        ),
        floatingActionButton: buildFloatactionBouttonW(context, onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddProductionSettingsPage()),
          );
        }),
      ),
    );
  }
}
