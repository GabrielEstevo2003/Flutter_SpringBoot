import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/agenda.dart';

class ApiService {
  //URL da API
  static const String baseUrl = 'http://localhost:8080/agenda'; // Use 10.0.2.2 no Android Emulator

//Método POST enviado à API
static Future<bool> salvarAgenda(Agenda agenda) async {
  final jsonBody = jsonEncode(agenda.toJson());
  print('Enviando JSON: $jsonBody');

  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonBody,
  );

  print('Resposta: ${response.statusCode} - ${response.body}');
  return response.statusCode == 201;
}

//Método GET enviado à API
  static Future<List<Agenda>> listarAgendas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Agenda.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar agendas');
    }
  }

//Método DELETE enviado à API
  static Future<bool> excluirAgenda(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  return response.statusCode == 204;
}

//Método PUT enviado à API
static Future<bool> atualizarAgenda(Agenda agenda) async {
  final response = await http.put(
    Uri.parse('$baseUrl/${agenda.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(agenda.toJson()),
  );
  return response.statusCode == 200;
}
}
