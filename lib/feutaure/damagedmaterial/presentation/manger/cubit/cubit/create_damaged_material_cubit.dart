import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_damaged_material_state.dart';

class CreateDamagedMaterialCubit extends Cubit<CreateDamagedMaterialState> {
  CreateDamagedMaterialCubit() : super(CreateDamagedMaterialInitial());
}
