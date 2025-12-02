import 'package:flutter/material.dart';
import '../services/service_meteo.dart';
import '../modeles/meteo_modele.dart';
import '../widgets/carte_alerte.dart';

/// Écran qui affiche les alertes météo en fonction des données actuelles.
class EcranAlertes extends StatefulWidget {
  const EcranAlertes({super.key});

  @override
  State<EcranAlertes> createState() => _EcranAlertesState();
}

class _EcranAlertesState extends State<EcranAlertes> {
  final ServiceMeteo _serviceMeteo = ServiceMeteo();

  List<String> _alertes = [];
  bool _chargement = false;
  String? _messageErreur;

  /// Analyse les données météo pour créer une liste d’alertes.
  List<String> _genererAlertes(ModeleMeteo meteo) {
    final List<String> alertes = [];

    // Exemple de règles simples (niveau débutant, beaucoup de if)
    if (meteo.temperature <= 0) {
      alertes.add('Risque de gel : protéger les cultures sensibles.');
    }

    if (meteo.temperature >= 30) {
      alertes.add(
        'Forte chaleur : risque de stress hydrique pour les plantes.',
      );
    }

    if (meteo.humidite <= 30) {
      alertes.add('Air sec : vérifier l’irrigation.');
    }

    if (meteo.precipitation >= 10) {
      alertes.add(
        'Pluies importantes : surveiller le risque de ruissellement.',
      );
    }

    if (meteo.vitesseVent >= 10) {
      alertes.add('Vent fort : attention aux serres et équipements légers.');
    }

    // Si aucune alerte n’a été ajoutée, on retourne quand même un tableau vide.
    return alertes;
  }

  Future<void> _chargerAlertes() async {
    setState(() {
      _chargement = true;
      _messageErreur = null;
    });

    try {
      final meteo = await _serviceMeteo.obtenirMeteoActuelle();
      setState(() {
        _alertes = _genererAlertes(meteo);
      });
    } catch (e) {
      setState(() {
        _messageErreur = e.toString();
      });
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _chargerAlertes();
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messageErreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Erreur : $_messageErreur', textAlign: TextAlign.center),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CarteAlerte(alertes: _alertes),
          ElevatedButton(
            onPressed: _chargerAlertes,
            child: const Text('Actualiser les alertes'),
          ),
        ],
      ),
    );
  }
}
