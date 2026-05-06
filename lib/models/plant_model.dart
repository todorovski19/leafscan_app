import 'package:leafscan_app/models/treatment_model.dart';

class DiseaseSimpleModel {
  final int id;
  final String name;
  final String severity; // "LOW", "MEDIUM", "HIGH"
  final String category; // "FUNGAL", "BACTERIAL" итн.
  final List<TreatmentModel> treatments;

  const DiseaseSimpleModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.category,
    required this.treatments,
  });

  factory DiseaseSimpleModel.fromJson(Map<String, dynamic> json) {
    return DiseaseSimpleModel(
      id:       json['id'] as int,
      name:     json['name'] as String,
      severity: json['severity'] as String,
      category: json['category'] as String,
      treatments: (json['treatments'] as List<dynamic>? ?? [])
          .map((t) => TreatmentModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<DiseaseSimpleModel> get mockList => [
    DiseaseSimpleModel(
      id: 1, name: 'Early Blight', severity: 'MEDIUM', category: 'FUNGAL',
      treatments: TreatmentModel.mockList,
    ),
    DiseaseSimpleModel(
      id: 2, name: 'Powdery Mildew', severity: 'LOW', category: 'FUNGAL',
      treatments: [
        const TreatmentModel(id: 4, name: 'Neem oil spray',
            description: 'Apply neem oil every 7 days.', type: 'ORGANIC'),
        const TreatmentModel(id: 5, name: 'Improve airflow',
            description: 'Prune overcrowded branches.', type: 'MECHANICAL'),
      ],
    ),
    DiseaseSimpleModel(
      id: 3, name: 'Leaf Spot', severity: 'HIGH', category: 'BACTERIAL',
      treatments: [
        const TreatmentModel(id: 6, name: 'Copper fungicide',
            description: 'Apply copper-based spray weekly.', type: 'CHEMICAL'),
      ],
    ),
    DiseaseSimpleModel(
      id: 4, name: 'Root Rot', severity: 'HIGH', category: 'FUNGAL',
      treatments: [
        const TreatmentModel(id: 7, name: 'Reduce watering',
            description: 'Let soil dry between watering.', type: 'MECHANICAL'),
        const TreatmentModel(id: 8, name: 'Repot plant',
            description: 'Remove affected roots and repot in fresh soil.', type: 'MECHANICAL'),
      ],
    ),
    DiseaseSimpleModel(
      id: 5, name: 'Rust Disease', severity: 'MEDIUM', category: 'FUNGAL',
      treatments: [
        const TreatmentModel(id: 9, name: 'Remove infected leaves',
            description: 'Prune and destroy infected foliage.', type: 'MECHANICAL'),
        const TreatmentModel(id: 10, name: 'Fungicide spray',
            description: 'Apply copper-based fungicide every 7 days.', type: 'CHEMICAL'),
      ],
    ),
  ];
}


class PlantModel {
  final int id;
  final String name;
  final String scientificName;
  final String type;
  final String description;
  final String? image;
  final String growingSeason;
  final String growingRegion;
  final List<DiseaseSimpleModel> topDiseases;

  const PlantModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.description,
    this.image,
    required this.growingSeason,
    required this.growingRegion,
    required this.topDiseases,
  });


  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id:             json['id'] as int,
      name:           json['name'] as String,
      scientificName: json['scientific_name'] as String,
      type:           json['type'] as String,
      description:    json['description'] as String,
      image:          json['image'] as String?,
      growingSeason:  json['growing_season'] as String,
      growingRegion:  json['growing_region'] as String,
      topDiseases: (json['top_diseases'] as List<dynamic>? ?? [])
          .map((d) => DiseaseSimpleModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }


  static PlantModel get mock => PlantModel(
    id:             1,
    name:           'Tomato',
    scientificName: 'Solanum lycopersicum',
    type:           'VEGETABLE',
    description:    'Tomato is one of the most widely grown vegetables in the world. '
                    'It thrives in warm climates with plenty of sunlight and well-drained soil. '
                    'Rich in vitamins C and K, potassium, and antioxidants.',
    image:          null,
    growingSeason:  'Spring - Summer',
    growingRegion:  'Mediterranean',
    topDiseases:    DiseaseSimpleModel.mockList,
  );
}
