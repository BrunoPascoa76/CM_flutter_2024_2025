import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomCubit extends Cubit<double> {
  ZoomCubit() : super(5.0);

  void zoomIn() => emit(state + 1);
  void zoomOut() => emit(state - 1);
}
