import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUser = 'user_data';

  // Salva o usuário completo (JSON) no celular
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user);
    await prefs.setString(_keyUser, userJson);
    print("Sessão salva para: ${user['nome']}");
  }

  // Recupera o usuário salvo (para usar na Home, Perfil, etc)
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Verifica se tem alguém logado (para decidir se vai pra Login ou Home)
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  // Deslogar (Apaga tudo)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados
    print("Usuário deslogado.");
  }
}