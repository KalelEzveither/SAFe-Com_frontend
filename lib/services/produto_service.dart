import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produto_model.dart';

class ProdutoService {
  // Ajuste o IP se necessário
  static const String _apiBaseUrl = 'http://192.168.0.118:8080/api/produtos';

  // Criar Produto
  Future<bool> criarProduto(Produto produto) async {
    try {
      final response = await http.post(
        Uri.parse(_apiBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': produto.nome,
          'descricao': produto.descricao,
          'preco': produto.preco,
          'imagemUrl': produto.imagemUrl,
          'categoria': produto.categoria,
          'quantidadeEstoque': produto.quantidadeEstoque,
          'barracaId': produto.barracaId
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Erro ao criar produto: $e");
      return false;
    }
  }

  // Atualizar Produto
  Future<bool> atualizarProduto(Produto produto) async {
    try {
      final response = await http.put(
        Uri.parse('$_apiBaseUrl/${produto.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': produto.nome,
          'descricao': produto.descricao,
          'preco': produto.preco,
          'imagemUrl': produto.imagemUrl,
          'categoria': produto.categoria,
          'quantidadeEstoque': produto.quantidadeEstoque,
          'barracaId': produto.barracaId
        }),
      );
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print("Erro ao atualizar produto: $e");
      return false;
    }
  }

  // Deletar Produto
  Future<bool> deletarProduto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_apiBaseUrl/$id'));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print("Erro ao deletar produto: $e");
      return false;
    }
  }
}