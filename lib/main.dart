import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';
import 'package:tcp/feutaure/Product/presentation/view/manager/cubit_update/update_product_cubit.dart';
import 'package:tcp/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_cubit.dart';
import 'package:tcp/feutaure/Product/repo/repo_product.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp/feutaure/Row_Material/repo/raw_material_repo.dart';
import 'package:tcp/feutaure/productmaterial/presentation/view/all_product_material_view.dart';
import 'package:tcp/feutaure/productmaterial/repo/repo_product_material.dart';
import 'package:tcp/feutaure/simi_products/presentation/manger/semi_finished_products_cubit.dart';
import 'package:tcp/feutaure/simi_products/repo/semi_finished_products_repository_impl.dart';
import 'package:tcp/screens/spash_view.dart';
import 'package:tcp/view_models/auth_cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await setupFirebaseNotifications();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(
    MyApp(sharedPreferences: sharedPreferences),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SemiFinishedProductsCubit>(
          create: (context) => SemiFinishedProductsCubit(
            SemiFinishedProductsRepositoryImpl(
              ApiService(),
            ),
          )..getSemiFinishedProducts(),
        ),
        BlocProvider<GetRawMaterialsCubit>(
          create: (context) => GetRawMaterialsCubit(
            rawMaterialRepository: RawMaterialRepository(
              apiService: ApiService(),
            ),
          )..fetchRawMaterials(),
        ),
        BlocProvider(
          create: (context) => ProductMaterialsCubit(
            ProductMaterialsRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateProductCubit(
            productRepository: ProductListRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductListCubit(
            ProductListRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateBatchRawMaterialCubit(
            RawMaterialBatchRepository(
                ApiService()), // Provide ApiService to the repo
          ),
        ),
        BlocProvider(
            create: (context) => AddRawMaterialBatchCubit(
                  RawMaterialBatchRepository(
                    ApiService(), // إنشاء ApiService، يمكنك استخدام Injection هنا إذا كان لديك
                  ),
                )),
        BlocProvider(
            create: (context) => UpdateRawMaterialCubit(
                  rawMaterialRepository: RawMaterialRepository(
                    apiService: ApiService(),
                  ),
                )),
        BlocProvider(
            create: (context) => RawMaterialSearchCubit(
                  repository: RawMaterialRepository(
                    apiService: ApiService(),
                  ),
                )),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(sharedPreferences),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Inter',
            ),
            home: const SplashSreen(),
          );
        },
      ),
    );
  }
}
