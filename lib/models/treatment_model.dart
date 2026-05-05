class TreatmentModel {
  final int id;
  final String name;
  final String description;
  final String type; // "CHEMICAL", "MECHANICAL", "ORGANIC"

  const TreatmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  // Се користи кога backend врати JSON → го претвора во TreatmentModel објект
  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id:          json['id'] as int,
      name:        json['name'] as String,
      description: json['description'] as String,
      type:        json['type'] as String,
    );
  }

  // Лажни податоци
  static List<TreatmentModel> get mockList => [
    const TreatmentModel(
      id: 1,
      name: 'Remove infected leaves',
      description: 'Remove affected leaves immediately to prevent spreading to healthy parts of the plant.',
      type: 'MECHANICAL',
    ),
    const TreatmentModel(
      id: 2,
      name: 'Apply organic fungicide',
      description: 'Apply organic fungicide every 7-10 days until symptoms disappear.',
      type: 'ORGANIC',
    ),
    const TreatmentModel(
      id: 3,
      name: 'Copper-based spray',
      description: 'Use copper-based chemical spray as directed. Avoid overuse to prevent soil buildup.',
      type: 'CHEMICAL',
    ),
  ];
}
