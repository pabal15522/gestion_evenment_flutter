import 'dart:convert';

import 'package:gestion_evement/models/Evenement.dart';
import 'package:gestion_evement/models/Inscription.dart';
import 'package:http/http.dart' as http;

import '../config/Config.dart';

class ApiService{


Future<List<Evenement>> eventList(String? search,String? date) async {
  final Map<String, String> params = {};
  if (search != null && search.isNotEmpty) params['search'] = search;
  if (date != null && date.isNotEmpty) params['date'] = date;

  var url = Uri.http(Config.apiUrl,'/api/events',params);
  var response = await http.get(url);
  final data =jsonDecode( response.body);
  if (data is List) {
    return data.map((item) => Evenement.fromJson(item)).toList();
  } else {
    throw Exception('Les données reçues ne sont pas une liste');
  }

  }

  Future<Evenement> eventDetail(int eventId) async {
    var url = Uri.http(Config.apiUrl,'/api/events/$eventId');
    var response = await http.get(url);
    final data =jsonDecode( response.body);
    if (data) {
      return Evenement.fromJson(data);
    }
    else {
      throw Exception('Les données reçues ne sont pas une liste');
    }
  }

Future<Map<String, dynamic>> register(int eventId, Inscription inscription) async {
  var url = Uri.http(Config.apiUrl, '/api/events/$eventId/register');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'firstName': inscription.firstName,
      'lastName': inscription.lastName,
      'email': inscription.email,
    }),
  );
  if (response.statusCode == 201) {
    return {'success': true, 'message': "Inscription effectuée avec succès"};
  } else if (response.statusCode == 409) {
    return {'success': false, 'message': "Cette adresse email est déjà enregistrée pour cet évènement"};
  } else if (response.statusCode == 400) {
    return {'success': false, 'message': "Format d'email invalide"};
  } else {
    throw Exception('Une erreur s\'est produite lors de l\'enregistrement');
  }
}
}