// lib/cubit/get_raw_materials/get_raw_materials_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:tcp/feutaure/Row_Material/presentation/view/manager/get_raw_material_state.dart';
import 'package:tcp/feutaure/Row_Material/repo/raw_material_repo.dart'; // تأكد من المسار الصحيح للموديل

class GetRawMaterialsCubit extends Cubit<GetRawMaterialsState> {
  final RawMaterialRepository rawMaterialRepository;

  GetRawMaterialsCubit({required this.rawMaterialRepository})
      : super(GetRawMaterialsInitial());

  Future<void> fetchRawMaterials() async {
    emit(GetRawMaterialsLoading());
    try {
      final rawMaterials = await rawMaterialRepository.getRawMaterials();
      emit(GetRawMaterialsSuccess(rawMaterials));
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
}
