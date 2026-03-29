import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/checkout_data.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutData data = CheckoutData();

  CheckoutCubit() : super(const CheckoutStep(0));

  int get currentStep =>
      state is CheckoutStep ? (state as CheckoutStep).step : 0;

  void goToStep(int step) => emit(CheckoutStep(step));

  void nextStep() {
    final step = currentStep;
    if (step < 3) emit(CheckoutStep(step + 1));
  }

  void previousStep() {
    final step = currentStep;
    if (step > 0) emit(CheckoutStep(step - 1));
  }

  void setShipping(ShippingMethod method) {
    data.shippingMethod = method;
    emit(CheckoutStep(currentStep));
  }

  void setPaymentMethod(String method) {
    data.paymentMethod = method;
    emit(CheckoutStep(currentStep));
  }
}
