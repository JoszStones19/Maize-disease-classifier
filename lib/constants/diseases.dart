import '../models/disease.dart';

class DiseaseConstants {
  DiseaseConstants._();

  static const Map<String, Disease> diseases = {
    'northern_leaf_blight': Disease(
      key: 'northern_leaf_blight',
      name: 'Northern Leaf Blight',
      scientificName: 'Exserohilum turcicum',
      type: 'fungal',
      severity: 'high',
      description:
          'Causes large, elongated grey-green or tan lesions on leaves. Spreads in cool, moist conditions.',
      treatment:
          'Apply fungicide (mancozeb or propiconazole). Remove heavily infected leaves. Improve air circulation.',
      prevention:
          'Use resistant varieties, practice crop rotation, avoid overhead irrigation.',
    ),
    'gray_leaf_spot': Disease(
      key: 'gray_leaf_spot',
      name: 'Gray Leaf Spot',
      scientificName: 'Cercospora zeae-maydis',
      type: 'fungal',
      severity: 'high',
      description:
          'Produces rectangular gray to tan lesions parallel to leaf veins. Thrives in warm, humid weather.',
      treatment:
          'Apply strobilurin fungicides early. Remove crop debris after harvest.',
      prevention:
          'Rotate with non-host crops, use tolerant hybrids.',
    ),
    'common_rust': Disease(
      key: 'common_rust',
      name: 'Common Rust',
      scientificName: 'Puccinia sorghi',
      type: 'fungal',
      severity: 'medium',
      description:
          'Brick-red to brown pustules scattered on both leaf surfaces.',
      treatment:
          'Foliar fungicides (azoxystrobin) effective if applied early.',
      prevention: 'Plant resistant hybrids. Scout fields regularly.',
    ),
    'healthy': Disease(
      key: 'healthy',
      name: 'Healthy',
      scientificName: 'No pathogen detected',
      type: 'low risk',
      severity: 'low',
      description: 'No disease detected. The leaf appears healthy.',
      treatment: 'No treatment needed. Continue good agronomic practices.',
      prevention: 'Keep monitoring plants and maintain strong field hygiene.',
    ),
  };
}
