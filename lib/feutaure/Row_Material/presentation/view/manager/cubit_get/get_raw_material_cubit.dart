import 'package:bloc/bloc.dart';
import 'package:tcp/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_state.dart';
import 'package:tcp/feutaure/Row_Material/repo/raw_material_repo.dart'; // تأكد من المسار الصحيح للموديل

// class GetRawMaterialsCubit extends Cubit<GetRawMaterialsState> {
//   final RawMaterialRepository rawMaterialRepository;

//   GetRawMaterialsCubit({required this.rawMaterialRepository})
//       : super(GetRawMaterialsInitial());

//   Future<void> fetchRawMaterials() async {
//     emit(GetRawMaterialsLoading());
//     try {
//       final rawMaterials = await rawMaterialRepository.getRawMaterials();
//       emit(GetRawMaterialsSuccess(rawMaterials));
//     } catch (e) {
//       String errorMessage;
//       if (e is Exception) {
//         errorMessage = e.toString().replaceFirst('Exception: ', '');
//       } else {
//         errorMessage = e.toString();
//       }
//       emit(GetRawMaterialsError(errorMessage));
//     }
//   }
// }

class GetRawMaterialsCubit extends Cubit<GetRawMaterialsState> {
  final RawMaterialRepository rawMaterialRepository;
  List<GetRawMaterial> _allRawMaterials = []; // تخزين جميع المواد الخام

  GetRawMaterialsCubit({required this.rawMaterialRepository})
      : super(GetRawMaterialsInitial());

  Future<void> fetchRawMaterials() async {
    emit(GetRawMaterialsLoading());
    try {
      _allRawMaterials = await rawMaterialRepository.getRawMaterials();
      emit(GetRawMaterialsSuccess(_allRawMaterials));
    } catch (e) {
      String errorMessage;
      if (e is Exception) {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        errorMessage = e.toString();
      }
      emit(GetRawMaterialsError(errorMessage));
    }
  }

  void filterRawMaterials(String status) {
    if (_allRawMaterials.isEmpty) return;

    List<GetRawMaterial> filteredList;
    if (status == 'All') {
      filteredList = _allRawMaterials;
    } else {
      if (status == 'Used') {
        status = 'used';
      } else {
        status = 'unused';
      }
      // تحويل التسمية العربية إلى القيمة الفعلية في البيانات
      filteredList = _allRawMaterials
          .where((material) => material.status == status)
          .toList();
    }

    emit(GetRawMaterialsSuccess(filteredList));
  }

// void filterRawMaterials(String filterType) {
//   if (_allRawMaterials.isEmpty) return;

//   List<GetRawMaterial> filteredList;

//   switch (filterType) {
//     case 'مستخدمة':
//       filteredList = _allRawMaterials.where((material) => material.status == 'used').toList();
//       break;
//     case 'غير مستخدمة':
//       filteredList = _allRawMaterials.where((material) => material.status == 'unused').toList();
//       break;
//     default: // حالة 'الكل'
//       filteredList = _allRawMaterials;
//   }

//   emit(GetRawMaterialsSuccess(filteredList));
// }
}
