import 'package:flutter_bloc/flutter_bloc.dart';

class MapZoomCubit extends Cubit<double> {
  MapZoomCubit() : super(10.0);

  void zoomIn() => emit(state + 1);
  void zoomOut() => emit(state - 1);
  void setZoom(double zoom) => emit(zoom);
}
