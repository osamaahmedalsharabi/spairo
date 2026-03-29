class BrandModel {
  final String id;
  final String name;
  final String image;

  BrandModel({required this.id, required this.name, required this.image});

  factory BrandModel.fromJson(Map<String, dynamic> json, String id) {
    return BrandModel(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
