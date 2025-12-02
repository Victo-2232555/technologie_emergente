import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../modeles/meteo_modele.dart';

/// Service responsable de :
/// 1) Vérifier les permissions de localisation
/// 2) Récupérer la position GPS de l’utilisateur
/// 3) Appeler l’API OpenWeatherMap
class ServiceMeteo {
  /// Ma clé API OpenWeatherMap
  static const String _cleApi = '4cc0383c44141354714b0fa2a3e3ecdf';

  static const String _urlBase =
      'https://api.openweathermap.org/data/2.5/weather';

  /// Méthode publique : obtient la météo actuelle pour la position de l’utilisateur.
  Future<ModeleMeteo> obtenirMeteoActuelle() async {
    final position = await _obtenirPosition();
    final uri = Uri.parse(
      '$_urlBase?lat=${position.latitude}&lon=${position.longitude}'
      '&appid=$_cleApi&units=metric&lang=fr',
    );

    final reponse = await http.get(uri);

    if (reponse.statusCode == 200) {
      final Map<String, dynamic> donnees = jsonDecode(reponse.body);
      return ModeleMeteo.depuisJson(donnees);
    } else {
      throw Exception('Erreur API (${reponse.statusCode}) : ${reponse.body}');
    }
  }

  /// Vérifie que la localisation est activée et que l’utilisateur a donné
  /// la permission à l’application.
  Future<Position> _obtenirPosition() async {
    bool serviceActif = await Geolocator.isLocationServiceEnabled();

    if (!serviceActif) {
      // On propose à l’utilisateur d’activer la localisation dans les paramètres
      await Geolocator.openLocationSettings();
      throw Exception('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('La permission de localisation a été refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'La permission de localisation est refusée de façon permanente.',
      );
    }

    // À ce stade, on a la permission : on peut obtenir la position
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
