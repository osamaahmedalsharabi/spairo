class Company {
  final String name;
  final String logo;
  final List<Car> cars;

  Company({required this.name, required this.logo, required this.cars});
}

class Car {
  final String name;
  final List<String> models;

  Car({required this.name, required this.models});
}

class CarModelDetails {
  final String model;
  final List<String> parts;

  CarModelDetails(this.model, this.parts);
}
