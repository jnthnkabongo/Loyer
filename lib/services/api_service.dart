import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //static const String baseUrl = '';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://192.168.1.65:8000';
    } else if (Platform.isAndroid) {
      // Utiliser l'IP du réseau pour les téléphones Android physiques
      //return 'http://192.168.1.65:8000';
      //Pour l'émulateur Android, utiliser:
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      return 'http://192.168.1.65:8000';
    } else {
      return 'http://localhost:8000';
    }
  }

  static const String _tokenKey = 'auth_token';
  static const String _userkey = 'user';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  // Sauvegarder n'importe quelle donnée
  static Future<void> sauvegarderData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else {
      await prefs.setString(key, jsonEncode(value));
    }
  }

  // Récupérer n'importe quelle donnée
  static Future<dynamic> recupererData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return null;
    print("Les donnees de l'utilisateur: $data");

    try {
      return jsonDecode(data); // si JSON
    } catch (e) {
      return data; // si simple String
    }
  }

  //CRUD Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //CRUD Locataires
  static Future<Map<String, dynamic>> getLocataires() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listelocataires'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Les locataires: $data");
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Ajout Locataire
  static Future<Map<String, dynamic>> addLocataire(
    Map<String, dynamic> locataireData,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/createlocataire'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(locataireData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Locataire ajouté: $data");
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur lors de l\'ajout du locataire';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //CRUD Paiements
  static Future<Map<String, dynamic>> getPaiements() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listepaiements'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //CRUD Logements
  static Future<Map<String, dynamic>> getLogements() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listebiens'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> addLogement(Map<String, dynamic> data) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/createbien'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }
}

// {
//     "message": "Dashboard du locataire",
//     "liste_utilisateurs": 2,
//     "liste_paiements_mois": "800.00",
//     "liste_paiements_total": "800.00",
//     "liste_appartements": 1,
//     "liste_locataires_insolvables": 0,
//     "liste_appartements_loues": 1,
//     "liste_appartements_disponibles": 0,
//     "liste_locataires": 1
// }
