import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCEPService {
  //busca o endereco pelo Cep na API do ViaCep
  static Future<Map<String, dynamic>?> buscarEndereco(String cep) async {
    final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('erro')) return null;
      return data;
    }
    return null;
  }
}
