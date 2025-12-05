import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/barraca_model.dart'; 
import '../model/produto_model.dart';

class BarracaService {
  // 1. A Base para no /api
  static const String _apiBaseUrl = 'http://192.168.0.118:8080/api';

  Future<List<Barraca>> getBarracas() async {
    try {
      // 2. Adiciona /barracas aqui
      final response = await http.get(Uri.parse('$_apiBaseUrl/barracas'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((dynamic item) => Barraca.fromJson(item)).toList();
      } else {
        throw Exception('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro BarracaService: $e');
      return [];
    }
  }

  Future<List<Produto>> getProdutosPorBarraca(int barracaId) async {
    try {
      // 3. Adiciona /produtos aqui (SEM /barracas antes)
      final url = Uri.parse('$_apiBaseUrl/produtos/barraca/$barracaId');
      
      print("Chamando URL: $url"); // Vai imprimir a URL certa agora

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Produto.fromJson(item)).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro BarracaService: $e');
      return [];
    }
  }
}