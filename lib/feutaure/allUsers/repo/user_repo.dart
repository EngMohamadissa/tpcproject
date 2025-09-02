import 'package:dio/dio.dart';
import 'package:tcp/core/util/apiservice.dart';
import 'package:tcp/core/util/error/error_handling.dart';
import 'package:tcp/feutaure/allUsers/data/model/user_model.dart';

class UserRepoImpl {
  final ApiService _apiService;

  UserRepoImpl(this._apiService);

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.get('showAllUsers');
      if (response.data != null && response.data['users'] is List) {
        return (response.data['users'] as List)
            .map((item) => UserModel.fromJson(item))
            .toList();
      } else {
        return []; // إرجاع قائمة فارغة إذا لم تكن هناك بيانات أو كانت غير صحيحة
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to fetch all users: $e');
    }
  }

  Future<Map<String, dynamic>> changeUserActivationStatus(int userId) async {
    try {
      final response = await _apiService
          .update('admin/change-user-activation/$userId', data: {});
      return response.data as Map<String, dynamic>; // ارجع الرد كاملاً
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to change user activation status: $e');
    }
  }

  Future<UserModel> updateUser(
      int userId, Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.update(
        'user/update/$userId', // المسار مع الـ ID
        data: userData,
      );
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format for user update');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<UserModel> getUserById(int userId) async {
    try {
      final response =
          await _apiService.get('user/show/$userId'); // استخدام المسار الجديد
      // تحقق من أن بيانات المستخدم موجودة تحت مفتاح 'user' في الـ response
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Invalid response format: User data not found.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب بيانات المستخدم: $e');
    }
  }

  Future<UserModel> updateProfile(
      int userId, Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.update(
        'user/update/$userId', // المسار مع الـ ID
        data:
            userData, // البيانات التي تم تمريرها (بما في ذلك كلمة المرور إذا وجدت)
      );
      if (response.data != null && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('تنسيق استجابة غير صالح لتحديث المستخدم');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في تحديث المستخدم: $e');
    }
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    // <--- تطبيق الدالة
    try {
      final response = await _apiService
          .delete('user/delete/$userId'); // استخدام دالة delete
      return response.data
          as Map<String, dynamic>; // عادةً ما تعود رسالة وstatus
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في حذف المستخدم: $e');
    }
  }
}
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tcp/core/util/apiservice.dart';
// import 'package:tcp/core/util/injection_container.dart' as di;
// import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
// import 'package:tcp/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
// import 'package:tcp/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';
// import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
// import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
// import 'package:tcp/feutaure/Row_Material/repo/raw_material_repo.dart';
// import 'package:tcp/feutaure/simi_products/presentation/manger/semi_finished_products_cubit.dart';
// import 'package:tcp/firebase_notifications.dart';
// import 'package:tcp/firebase_options.dart';
// import 'package:tcp/screens/spash_view.dart';
// import 'package:tcp/view_models/auth_cubit/auth_cubit.dart';

// void main() async {
//   di.init(); // Initialize dependency injection

//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//   // await setupFirebaseNotifications();

//   final SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();

//   runApp(
//     MyApp(sharedPreferences: sharedPreferences),
//   );
// }

// class MyApp extends StatelessWidget {
//   final SharedPreferences sharedPreferences;

//   const MyApp({super.key, required this.sharedPreferences});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => di.sl<SemiFinishedProductsCubit>(),
//         ),
//         // BlocProvider(
//         //   create: (context) => RawMaterialBatchesListCubit(
//         //     RawMaterialBatchRepository(
//         //       ApiService(), // إنشاء ApiService
//         //     ),
//         //   ),
//         // ),
//         BlocProvider(
//           create: (context) => UpdateBatchRawMaterialCubit(
//             RawMaterialBatchRepository(
//                 ApiService()), // Provide ApiService to the repo
//           ),
//         ),

//         BlocProvider(
//             create: (context) => AddRawMaterialBatchCubit(
//                   RawMaterialBatchRepository(
//                     ApiService(), // إنشاء ApiService، يمكنك استخدام Injection هنا إذا كان لديك
//                   ),
//                 )),
//         BlocProvider(
//             create: (context) => UpdateRawMaterialCubit(
//                   rawMaterialRepository: RawMaterialRepository(
//                     apiService: ApiService(),
//                   ),
//                 )),
//         BlocProvider(
//             create: (context) => RawMaterialSearchCubit(
//                   repository: RawMaterialRepository(
//                     apiService: ApiService(),
//                   ),
//                 )),
//         BlocProvider<AuthCubit>(
//           create: (context) => AuthCubit(sharedPreferences),
//         ),
//       ],
//       child: ScreenUtilInit(
//         designSize: const Size(360, 690),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               fontFamily: 'Inter',
//             ),
//             home: const SplashSreen(),
//           );
//         },
//       ),
//     );
//   }
// }
