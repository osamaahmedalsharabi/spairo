enum ShippingMethod { cashOnDelivery, buyNowPayLater }

class CheckoutData {
  ShippingMethod? shippingMethod;
  String fullName;
  String email;
  String address;
  String city;
  String apartment;
  bool saveAddress;
  String? paymentMethod;
  String cardHolderName;
  String cardNumber;
  String cvv;
  bool defaultCard;

  CheckoutData({
    this.shippingMethod,
    this.fullName = '',
    this.email = '',
    this.address = '',
    this.city = '',
    this.apartment = '',
    this.saveAddress = false,
    this.paymentMethod,
    this.cardHolderName = '',
    this.cardNumber = '',
    this.cvv = '',
    this.defaultCard = false,
  });

  double get shippingCost =>
      shippingMethod == ShippingMethod.cashOnDelivery
          ? 500.0
          : 0.0;

  String get shippingLabel =>
      shippingMethod == ShippingMethod.cashOnDelivery
          ? 'الدفع عند الاستلام'
          : 'اشتري الآن وادفع لاحقاً';

  String get fullAddress =>
      '$address, $city${apartment.isNotEmpty ? ', $apartment' : ''}';
}
