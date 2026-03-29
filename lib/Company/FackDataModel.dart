import 'FakeModel.dart';

List<Company> companies = [
  Company(
    name: "Toyota",
    logo: "assets/1.JPG",
    cars: [
      Car(name: "Corolla", models: ["2019", "2020", "2021"]),
      Car(name: "Camry", models: ["2018", "2019", "2020"]),
    ],
  ),
  Company(
    name: "BMW",
    logo: "assets/1.JPG",
    cars: [
      Car(name: "M3", models: ["2017", "2018", "2019"]),
      Car(name: "X5", models: ["2019", "2020"]),
    ],
  ),
  Company(
    name: "Mercedes",
    logo: "assets/1.JPG",
    cars: [
      Car(name: "C-Class", models: ["2018", "2019"]),
      Car(name: "E-Class", models: ["2019", "2020"]),
    ],
  ),
];

List<String> fakeParts = [
  "Engine",
  "Brakes",
  "Tires",
  "Gearbox",
  "Radiator",
  "Battery",
];
