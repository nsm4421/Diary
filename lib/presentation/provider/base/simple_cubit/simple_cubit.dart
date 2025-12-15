import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/constant/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'simple_state.dart';

part 'simple_cubit.g.dart';

class SimpleCubit<T extends SimpleState> extends Cubit<T> {
  SimpleCubit(super.initialState);
}
