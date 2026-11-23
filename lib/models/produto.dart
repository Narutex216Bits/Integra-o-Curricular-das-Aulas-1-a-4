class Produto {
  final String nomeProduto;
  final String categoria;
  final double preco;
  final int quantidadeEstoque;
  final bool disponivel;
  final List<String> tags;

  const Produto({
    required this.nomeProduto,
    required this.categoria,
    required this.preco,
    required this.quantidadeEstoque,
    required this.disponivel,
    required this.tags,
  });

  bool get temEstoqueCritico => quantidadeEstoque < 5;

  factory Produto.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>? ?? const [];

    return Produto(
      nomeProduto: json['nome_produto'] as String? ?? '',
      categoria: json['categoria'] as String? ?? '',
      preco: ((json['preco'] as num?) ?? 0).toDouble(),
      quantidadeEstoque: ((json['quantidade_estoque'] as num?) ?? 0).toInt(),
      disponivel: json['disponivel'] as bool? ?? false,
      tags: rawTags.map((e) => e.toString()).toList(),
    );
  }
}