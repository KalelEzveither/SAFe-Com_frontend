import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/barraca_model.dart'; // Importe o modelo que criamos acima

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
}