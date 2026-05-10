import 'dart:convert';

import 'package:gestion_evement/models/Evenement.dart';
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

  Future<String> register(int eventId) async {
    var url = Uri.http(Config.apiUrl,'/api/events/$eventId/register');
    var response = await http.post(url);
    if(response.statusCode==201){
      return "Inscription effectuée avec succès";
    }
    if(response.statusCode==409){
      return "Cette adresse email est déjà enregistrée pour cet évènement";
    }
    else {
      throw Exception('Une erreur s\'est produite lors de l\'enregistrement');
    }
  }
}