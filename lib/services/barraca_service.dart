import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/barraca_model.dart'; 
import '../model/produto_model.dart';

class BarracaService {
  static const String _baseUrl = 'http://192.168.0.118:8080/api/barracas';

  // Buscar todas as barracas
  Future<List<Barraca>> getBarracas() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // O backend retorna uma Lista de JSONs: [{}, {}, {}]
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes)); // utf8 para acentos
        List<Barraca> barracas = body.map((dynamic item) => Barraca.fromJson(item)).toList();
        return barracas;
      } else {
        throw Exception('Falha ao carregar barracas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no BarracaService: $e');
      return []; // Retorna lista vazia em caso de erro para não travar o app
    }
  }

  Future<List<Produto>> getProdutosPorBarraca(int barracaId) async {
    try {
      final url = Uri.parse('$_baseUrl/produtos/barraca/$barracaId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Produto.fromJson(item)).toList();
      } else if (response.statusCode == 204) {
        return []; // Barraca sem produtos
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no BarracaService: $e');
      return [];
    }
  }
}