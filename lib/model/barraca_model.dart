class Barraca {
  final int id;
  final String nome;
  final String descricao;
  final String? imagemUrl; // Pode vir nulo ou vazio
  final String? horarioFuncionamento;
  final bool isAberta;
  // Adicione outros campos se precisar

  Barraca({
    required this.id,
    required this.nome,
    required this.descricao,
    this.imagemUrl,
    this.horarioFuncionamento,
    required this.isAberta,
  });

  // Fábrica para criar uma Barraca a partir do JSON da API
  factory Barraca.fromJson(Map<String, dynamic> json) {
    return Barraca(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      descricao: json['descricao'] ?? '',
      imagemUrl: json['imagemUrl'],
      horarioFuncionamento: json['horarioFuncionamento'],
      isAberta: json['isAberta'] ?? true,
    );
  }
}