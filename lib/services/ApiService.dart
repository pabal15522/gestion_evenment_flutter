import 'dart:convert';

import 'package:gestion_evement/models/Evenement.dart';
import 'package:http/http.dart' as http;

class ApiService{


Future<Evenement> eventList() async {

  var url = Uri.https('127.0.0.1:8000', 'api/event');
  var response = await http.post(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return Evenement.fromJson(jsonDecode(response.body));

  }
}