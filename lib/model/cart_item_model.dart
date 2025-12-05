class CartItem {
  final int id; // ID do item no carrinho
  final int produtoId;
  final String nomeProduto;
  final double precoUnitario;
  final int quantidade;
  final String? imagemUrl;
  final int barracaId;
  final String nomeBarraca;

  CartItem({
    required this.id,
    required this.produtoId,
    required this.nomeProduto,
    required this.precoUnitario,
    required this.quantidade,
    this.imagemUrl,
    required this.barracaId,
    required this.nomeBarraca,
  });

  // Calcula o subtotal deste item
  double get subtotal => precoUnitario * quantidade;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      produtoId: json['produtoId'],
      nomeProduto: json['nomeProduto'],
      precoUnitario: (json['precoUnitario'] as num).toDouble(),
      quantidade: json['quantidade'],
      imagemUrl: json['imagemUrl'],
      barracaId: json['barracaId'],
      nomeBarraca: json['nomeBarraca'] ?? 'Barraca',
    );
  }
}