part of 'checkout_cubit.dart';

abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutStep extends CheckoutState {
  final int step;
  const CheckoutStep(this.step);
}
