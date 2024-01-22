// lib/services/thingspeak_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


Future<int> obtenerRitmoCardiacoDeThingSpeak(String readApiKey) async {
  final url = Uri.parse('https://api.thingspeak.com/channels/2354876/fields/1.json?api_key=2Z9QX5SYU33HVCHZ&results=2');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final int ritmoCardiaco = int.parse(data['feeds'].last['field1']);
      return ritmoCardiaco;
    } else {
      throw Exception('Error al obtener datos de ThingSpeak: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al realizar la solicitud: $e');
  }
}
