class PlantSimpleModel {
  final int id;
  final String name;

  const PlantSimpleModel({
    required this.id,
    required this.name,
  });

  factory PlantSimpleModel.fromJson(Map<String, dynamic> json) {
    return PlantSimpleModel(
      id:   json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Лажни податоци
  static List<PlantSimpleModel> get mockList => [
    const PlantSimpleModel(id: 1, name: 'Tomato'),
    const PlantSimpleModel(id: 2, name: 'Potato'),
    const PlantSimpleModel(id: 3, name: 'Pepper'),
    const PlantSimpleModel(id: 4, name: 'Eggplant'),
    const PlantSimpleModel(id: 5, name: 'Basil'),
  ];
}
