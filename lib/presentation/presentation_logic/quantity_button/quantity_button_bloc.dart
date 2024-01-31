import 'package:bloc/bloc.dart';
part 'quantity_button_event.dart';
part 'quantity_button_state.dart';

class QuantityButtonBloc
    extends Bloc<QuantityButtonEvent, QuantityButtonState> {
  QuantityButtonBloc() : super(QuantityInitialState(quantity: 3)) {
    on<IncreaseQuantity>((event, emit) {
      emit(QuantityButtonState(quantity: state.quantity + 1));
    });
    on<DecreaseQuantity>((event, emit) {
      if (state.quantity >= 3) {
        emit(QuantityButtonState(quantity: state.quantity - 1));
      } else {
        emit(QuantityButtonState(quantity: state.quantity));
      }
    });
  }
}
