import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // AVISO! Voce deve trocar este IP pelo IPv4 do teu computador!
  // Não uses 'localhost'. Usa o IP da rede (ex: 192.168.0.15)
  // Mantém a porta 8080 e o caminho /api/auth
  static const String _baseUrl = 'http://192.168.0.118:8080/api/auth';

  // --- LOGIN ---
  Future<Map<String, dynamic>?> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/login');
    
    try {
      print('Tentando login em: $url'); // Log para ajudar a debugar
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      print('Status Code: ${response.statusCode}'); // Ver se deu 200 ou 401

      if (response.statusCode == 200) {
        // Sucesso! Retorna os dados do utilizador
        return jsonDecode(response.body);
      } else {
        print('Erro no Login: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de Conexão (Verifica o IP e se o Backend está a correr): $e');
      return null;
    }
  }

  // --- CADASTRO ---
  // Este método aceita um Map com todos os dados (nome, email, cpf, etc)
  Future<bool> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Erro no Cadastro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de Conexão: $e');
      return false;
    }
  }
}