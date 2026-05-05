import 'package:leafscan_app/models/treatment_model.dart';
import 'package:leafscan_app/models/plant_simple_model.dart';

class DiseaseModel {
  final int id;
  final String name;
  final String description;
  final String symptoms;
  final String? image;            // може null ако болеста нема слика
  final String? imageDescription; // може null
  final String severity;          // "LOW", "MEDIUM", "HIGH"
  final String category;          // "FUNGAL", "BACTERIAL" итн.
  final List<TreatmentModel> treatments;
  final List<PlantSimpleModel> topPlants;

  const DiseaseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    this.image,
    this.imageDescription,
    required this.severity,
    required this.category,
    required this.treatments,
    required this.topPlants,
  });

  // Се користи кога backend врати JSON → го претвора во DiseaseModel објект
  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id:               json['id'] as int,
      name:             json['name'] as String,
      description:      json['description'] as String,
      symptoms:         json['symptoms'] as String,
      image:            json['image'] as String?,
      imageDescription: json['image_description'] as String?,
      severity:         json['severity'] as String,
      category:         json['category'] as String,
      treatments: (json['treatments'] as List<dynamic>)
          .map((t) => TreatmentModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      topPlants: (json['top_plants'] as List<dynamic>)
          .map((p) => PlantSimpleModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  // Лажни податоци
  static DiseaseModel get mock => DiseaseModel(
    id:               4,
    name:             'Early Blight',
    description:      'Early blight is a common fungal disease caused by Alternaria solani. '
                      'It primarily affects tomatoes and potatoes, causing significant yield loss '
                      'if left untreated.',
    symptoms:         'Dark brown spots with concentric rings appearing on older leaves first. '
                      'Yellowing around the spots, followed by leaf drop. '
                      'Stems may show dark lesions near soil level.',
    image:            null,
    imageDescription: 'Leaf with dark brown circular spots surrounded by yellow halos',
    severity:         'MEDIUM',
    category:         'FUNGAL',
    treatments:       TreatmentModel.mockList,
    topPlants:        PlantSimpleModel.mockList,
  );
}
