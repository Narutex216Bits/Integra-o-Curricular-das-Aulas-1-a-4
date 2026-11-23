import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/produto.dart';

void main() {
  runApp(const CatalogoApp());
}

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ProdutoDetalhePage(),
    );
  }
}

class ProdutoDetalhePage extends StatefulWidget {
  const ProdutoDetalhePage({super.key});

  @override
  State<ProdutoDetalhePage> createState() => _ProdutoDetalhePageState();
}

class _ProdutoDetalhePageState extends State<ProdutoDetalhePage> {
  static const String _jsonSimulado = '''
  {
    "nome_produto": "Smartphone Galaxy S24",
    "categoria": "Mobile",
    "preco": 4599.90,
    "quantidade_estoque": 12,
    "disponivel": true,
    "tags": ["android", "5g", "snapdragon"]
  }
  ''';

  late Produto _produto;
  bool _simularEstoqueBaixo = false;

  @override
  void initState() {
    super.initState();
    _carregarProduto();
  }

  void _carregarProduto({bool estoqueBaixo = false}) {
    final decoded = jsonDecode(_jsonSimulado) as Map<String, dynamic>;
    if (estoqueBaixo) {
      decoded['quantidade_estoque'] = 3;
    }
    setState(() {
      _simularEstoqueBaixo = estoqueBaixo;
      _produto = Produto.fromJson(decoded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar dados',
            onPressed: () => _carregarProduto(estoqueBaixo: false),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _produto.categoria.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _produto.nomeProduto,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${_produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _produto.disponivel
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _produto.disponivel ? 'Disponível' : 'Indisponível',
                    ),
                    const Spacer(),
                    Text('Estoque: ${_produto.quantidadeEstoque} un.'),
                  ],
                ),
                if (_produto.temEstoqueCritico) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Estoque crítico: menos de 5 unidades disponíveis.',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _produto.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _carregarProduto(estoqueBaixo: !_simularEstoqueBaixo),
        tooltip: 'Alternar simulação de estoque crítico',
        child: const Icon(Icons.inventory_2_outlined),
      ),
    );
  }
}