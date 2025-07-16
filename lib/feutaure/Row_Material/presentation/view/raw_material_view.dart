// lib/presentation/pages/raw_materials_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/func/float_action_botton.dart';
import 'package:tcp/core/widget/appar_widget,.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/add_raw_material_view.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/widget/raw_materials_list_body.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/widget/search_material_view.dart';
import 'package:tcp/feutaure/Row_Material/repo/raw_material_repo.dart';

class RawMaterialsListPage extends StatelessWidget {
  const RawMaterialsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetRawMaterialsCubit>(
      create: (context) => GetRawMaterialsCubit(
        rawMaterialRepository: RawMaterialRepository(
          apiService: ApiService(),
        ),
      ),
      child: Scaffold(
        floatingActionButton: buildFloatactionBouttonW(context, onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRawMaterialPage()),
          );
        }),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppareWidget(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RawMaterialSearchCubit(
                            repository:
                                RawMaterialRepository(apiService: ApiService()),
                          ),
                          child: const RawMaterialSearchPage(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.search))
            ],
            automaticallyImplyLeading: true,
            title: 'قائمة المواد الخام',
          ),
        ),
        body: const RawMaterialsListBody(),
      ),
    );
  }
}
