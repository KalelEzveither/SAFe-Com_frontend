class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;
  final String categoria;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    required this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] as num).toDouble(),
      // O Java/Jackson envia 'imagemUrl' (camelCase) por padrão
      imagemUrl: json['imagemUrl'] ?? '', 
      categoria: json['categoria'] ?? 'Geral',
    );
  }
}