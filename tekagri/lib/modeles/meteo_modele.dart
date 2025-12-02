/// Modèle de données représentant les informations météo principales.
class ModeleMeteo {
  final String nomVille;
  final double temperature;
  final int humidite;
  final double vitesseVent;
  final String description;
  final double precipitation;

  ModeleMeteo({
    required this.nomVille,
    required this.temperature,
    required this.humidite,
    required this.vitesseVent,
    required this.description,
    required this.precipitation,
  });

  /// Fabrique un objet ModeleMeteo à partir d’un JSON renvoyé par l’API.
  factory ModeleMeteo.depuisJson(Map<String, dynamic> json) {
    // Certaines clés peuvent être absentes (par exemple la pluie)
    double pluie = 0.0;
    if (json['rain'] != null && json['rain']['1h'] != null) {
      pluie = (json['rain']['1h'] as num).toDouble();
    }

    return ModeleMeteo(
      nomVille: json['name'] ?? 'Inconnue',
      temperature: (json['main']['temp'] as num).toDouble(),
      humidite: (json['main']['humidity'] as num).toInt(),
      vitesseVent: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      precipitation: pluie,
    );
  }
}
