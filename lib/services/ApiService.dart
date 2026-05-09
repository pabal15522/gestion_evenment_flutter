import 'dart:convert';

import 'package:gestion_evement/models/Evenement.dart';
import 'package:http/http.dart' as http;

class ApiService{


Future<List<Evenement>> eventList() async {

  var url = Uri.http('192.168.11.102:8000','/api/events');
  var response = await http.get(url);
  final data =jsonDecode( response.body);
  if (data is List) {
    return data.map((item) => Evenement.fromJson(item)).toList();
  } else {
    throw Exception('Les données reçues ne sont pas une liste');
  }

  }
}