import 'dart:convert';
//import 'dart:io';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //static const String baseUrl = '';

  static const String baseUrl =
      'https://mecanismenationaldesuivi.alwaysdata.net';
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

  //Liste locataires avec condition
  static Future<Map<String, dynamic>> getLocatairesCond() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listelocatairescond'),
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

  //Delete locataire
  static Future<Map<String, dynamic>> deleteLocataire(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/deletelocataire/${data['id']}'),
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

  //Récupérer les notifications de loyers impayés
  static Future<Map<String, dynamic>> getUnpaidNotifications() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) throw Exception('Token non trouvé');

      final response = await http.get(
        Uri.parse('$baseUrl/api/unpaid-notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Notifications loyers impayés: $data");
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ??
            'Erreur lors de la récupération des notifications';
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
  //Ajouter un paiement
  static Future<Map<String, dynamic>> addPaiementLocataire(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/createpaiement'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
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
  //Delete paiement 
  static Future<Map<String, dynamic>> deletePaiement(
   Map<String, dynamic> data,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/deletepaiement/${data['id']}'),
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

  //recuperation logement avec condition
  static Future<Map<String, dynamic>> getLogementsCond() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listebienscond'),
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

  //Ajouter un logement
  static Future<Map<String, dynamic>> addLogement(
    Map<String, dynamic> data,
  ) async {
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
      if (response.statusCode == 201) {
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

  //Supprimer un logement
  static Future<Map<String, dynamic>> deleteLogement(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/deletebien/${data['id']}'),
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

  //CRUD contrat
  static Future<Map<String, dynamic>> getContrats() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listecontrats'),
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

  //Recuperer les contrats d'un locataire conditionner
  static Future<Map<String, dynamic>> getContratsCond() async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/listecontratscond'),
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

  //Add Contrat logement
  static Future<Map<String, dynamic>> addContratLocataire(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await recupererData(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/createcontrat'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
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

  //Logout de l'application
  static Future<void> logout() async {
    try {
      // Supprimer le token d'authentification
      await supprimerData(_tokenKey);

      // Supprimer les données utilisateur
      await supprimerData(_userkey);

      print("Déconnexion réussie - données effacées");
    } catch (e) {
      print("Erreur lors de la déconnexion: ${e.toString()}");
      throw Exception('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }

  // Méthode pour supprimer n'importe quelle donnée
  static Future<void> supprimerData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print("Erreur lors de la suppression des données: ${e.toString()}");
    }
  }
}
