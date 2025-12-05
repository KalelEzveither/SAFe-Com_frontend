import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

class OrderService {
  // Ajuste o IP se necessário
  static const String _apiBaseUrl = 'http://192.168.0.118:8080/api/pedidos';

  // Envia o pedido para o Java
  Future<Map<String, dynamic>> finalizarPedido(String metodo, String entrega, {double? troco}) async {
    final user = await SessionService.getUser();
    if (user == null) return {'success': false, 'message': 'Usuário não logado'};

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/finalizar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': user['id'],
          'metodoPagamento': metodo,
          'tipoEntrega': entrega,
          'trocoPara': troco
        }),
      );

      // O Java retorna texto puro ou JSON. Vamos tratar:
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Reserva realizada com sucesso!'};
      } else {
        // Tenta ler o erro do corpo
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
  
  // Busca pedidos do cliente logado
  Future<List<dynamic>> getMeusPedidos() async {
    final user = await SessionService.getUser();
    if (user == null) return [];
    
    final response = await http.get(Uri.parse('$_apiBaseUrl/usuario/${user['id']}'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    return [];
  }

  // Busca pedidos da barraca (Se for vendedor)
  Future<List<dynamic>> getPedidosDaMinhaBarraca(int barracaId) async {
    final response = await http.get(Uri.parse('$_apiBaseUrl/barraca/$barracaId'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    return [];
  }

  // Atualiza status
  Future<bool> atualizarStatus(int pedidoId, String novoStatus) async {
    final response = await http.put(Uri.parse('$_apiBaseUrl/$pedidoId/status?status=$novoStatus'));
    return response.statusCode == 200;
  }
}