import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_item_model.dart';
import 'session_service.dart'; // Importante para pegar o ID do utilizador

class CartService {
  // Use o mesmo IP do AuthService
  static const String _apiBaseUrl = 'http://192.168.0.118:8080/api/carrinho';

  // Buscar itens do carrinho do utilizador logado
  Future<List<CartItem>> getCartItems() async {
    try {
      // Recupera o utilizador da sessão local
      final user = await SessionService.getUser();
      if (user == null) return []; // Se não houver login, retorna vazio

      final int userId = user['id']; // Certifique-se que o JSON salvo tem o campo 'id'

      final response = await http.get(Uri.parse('$_apiBaseUrl/usuario/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => CartItem.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao carregar carrinho: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no CartService: $e');
      return [];
    }
  }

  // Adicionar item (Lógica chamada na tela de detalhes, mas bom ter aqui)
  Future<int> addItem(int produtoId, int quantidade) async {
    final user = await SessionService.getUser();
    if (user == null) return 401; 
    
    print("Enviando para o Java -> Produto: $produtoId | Quantidade: $quantidade");

    final response = await http.post(
      Uri.parse(_apiBaseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuarioId': user['id'],
        'produtoId': produtoId,
        'quantidade': quantidade
      }),
    );
    return response.statusCode; // 200 OK, 409 Conflito, etc.
  }

  // Remover item do carrinho
  Future<bool> removeItem(int cartItemId) async {
    try {
      final response = await http.delete(Uri.parse('$_apiBaseUrl/$cartItemId'));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Erro ao remover item: $e');
      return false;
    }
  }
  
  // Limpar carrinho (útil se houver conflito de barracas)
  Future<bool> clearCart() async {
    final user = await SessionService.getUser();
    if (user == null) return false;
    
    final response = await http.delete(Uri.parse('$_apiBaseUrl/usuario/${user['id']}'));
    return response.statusCode == 204 || response.statusCode == 200;
  }
}