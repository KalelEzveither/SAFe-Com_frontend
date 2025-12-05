class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;
  final String categoria;
  final int quantidadeEstoque;
  final int? barracaId;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    required this.categoria,
    required this.quantidadeEstoque,
    this.barracaId,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] as num).toDouble(),
      imagemUrl: json['imagemUrl'] ?? '',
      categoria: json['categoria'] ?? 'Geral',
      // O Java manda 'quantidadeEstoque' no JSON
      quantidadeEstoque: json['quantidadeEstoque'] ?? 0, // <--- Capture aqui
      barracaId: json['barracaId'],
    );
  }
}