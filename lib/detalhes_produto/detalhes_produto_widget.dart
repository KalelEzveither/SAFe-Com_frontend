import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detalhes_produto_model.dart';
import '../model/produto_model.dart';
import '../services/cart_service.dart';

export 'detalhes_produto_model.dart';

class DetalhesProdutoWidget extends StatefulWidget {
  final Produto produto;

  const DetalhesProdutoWidget({
    super.key,
    required this.produto,
  });

  static String routeName = 'DetalhesProduto';
  static String routePath = '/detalhesProduto';

  @override
  State<DetalhesProdutoWidget> createState() => _DetalhesProdutoWidgetState();
}

class _DetalhesProdutoWidgetState extends State<DetalhesProdutoWidget> {
  late DetalhesProdutoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;      // Carregando ao clicar em Adicionar
  bool _verificandoCart = true; // Carregando inicial (checando carrinho)
  
  int quantidade = 1;
  int quantidadeNoCarrinho = 0; // Quantos já tenho guardado

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesProdutoModel());
    
    // Inicia verificando o carrinho
    _verificarCarrinho();
  }

  Future<void> _verificarCarrinho() async {
    try {
      final cartItems = await CartService().getCartItems();
      
      // Procura se este produto já está no carrinho
      int qtdEncontrada = 0;
      try {
        final item = cartItems.firstWhere((i) => i.produtoId == widget.produto.id);
        qtdEncontrada = item.quantidade;
      } catch (e) {
        qtdEncontrada = 0; // Não achou, é zero
      }

      if (mounted) {
        setState(() {
          quantidadeNoCarrinho = qtdEncontrada;
          _verificandoCart = false;

          // Se o estoque disponível (Estoque Total - Carrinho) for menor que 1, trava
          int disponivelReal = widget.produto.quantidadeEstoque - quantidadeNoCarrinho;
          if (disponivelReal <= 0) {
            quantidade = 0;
          } else {
            quantidade = 1;
          }
        });
      }
    } catch (e) {
      print("Erro ao verificar carrinho: $e");
      if (mounted) setState(() => _verificandoCart = false);
    }
  }

  Future<void> _adicionarAoCarrinho() async {
    // Validação extra antes de enviar
    if (quantidade <= 0) return;

    setState(() => _isLoading = true);

    final cartService = CartService();
    // Envia apenas a quantidade NOVA que o usuário selecionou
    int status = await cartService.addItem(widget.produto.id, quantidade);

    setState(() => _isLoading = false);

    if (status == 200 || status == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicionado com sucesso!'), backgroundColor: Color(0xFF156F00)),
      );
      context.safePop();
    } else if (status == 409) {
      _mostrarAlertaConflito();
    } else if (status == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faça login para comprar.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar. Tente novamente.')),
      );
    }
  }

  void _mostrarAlertaConflito() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nova compra?"),
        content: Text("Você tem itens de outra barraca. Deseja limpar o carrinho e adicionar este?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await CartService().clearCart();
              _adicionarAoCarrinho();
            },
            child: Text("Limpar e Adicionar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- LÓGICA INTELIGENTE DO CONTADOR ---
  void _incrementar() {
    // Estoque Real = O que tem na loja MENOS o que eu já peguei
    int estoqueDisponivel = widget.produto.quantidadeEstoque - quantidadeNoCarrinho;

    if (quantidade < estoqueDisponivel) {
      setState(() {
        quantidade++;
      });
    } else {
      String msg = "Limite atingido!";
      if (quantidadeNoCarrinho > 0) {
        msg = "Você já tem $quantidadeNoCarrinho no carrinho.";
      }
      
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _decrementar() {
    if (quantidade > 1) {
      setState(() => quantidade--);
    }
  }

  @override
  Widget build(BuildContext context) {
    double valorTotal = widget.produto.preco * quantidade;
    
    // Cálculo de disponibilidade
    int estoqueTotal = widget.produto.quantidadeEstoque;
    int estoqueRestante = estoqueTotal - quantidadeNoCarrinho;
    bool temEstoque = estoqueRestante > 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: _verificandoCart 
            ? Center(child: CircularProgressIndicator(color: Color(0xFF156F00))) 
            : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem
                    Stack(
                      children: [
                        Container(
                          width: double.infinity, height: 350.0,
                          decoration: BoxDecoration(color: FlutterFlowTheme.of(context).alternate),
                          child: Image.network(
                            widget.produto.imagemUrl.isNotEmpty ? widget.produto.imagemUrl : 'https://via.placeholder.com/400x300',
                            width: double.infinity, height: 350.0, fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Icon(Icons.fastfood, size: 100, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 44.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent, borderRadius: 30.0, borderWidth: 1.0, buttonSize: 40.0, fillColor: Color(0x7F000000),
                            icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.0),
                            onPressed: () async { context.safePop(); },
                          ),
                        ),
                      ],
                    ),
                    
                    // Nome e Avisos
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.produto.nome, style: FlutterFlowTheme.of(context).headlineMedium),
                          
                          // AVISO SE JÁ TIVER NO CARRINHO
                          if (quantidadeNoCarrinho > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.shopping_cart, size: 16, color: Colors.orange[800]),
                                    SizedBox(width: 8),
                                    Text(
                                      "Você já tem $quantidadeNoCarrinho no carrinho",
                                      style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Preço e Estoque
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$ ${widget.produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  font: GoogleFonts.interTight(), color: Color(0xFF156F00), fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: temEstoque ? Color(0xFFE0F2F1) : Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              temEstoque 
                                ? 'Restam $estoqueRestante' 
                                : (estoqueTotal > 0 ? 'Máx. no Carrinho' : 'Esgotado'),
                              style: TextStyle(
                                color: temEstoque ? Color(0xFF156F00) : Colors.red,
                                fontWeight: FontWeight.bold, fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Descrição
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                      child: Text(
                        widget.produto.descricao.isNotEmpty ? widget.produto.descricao : 'Sem descrição.',
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Barra Inferior
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [BoxShadow(blurRadius: 4.0, color: Color(0x55000000), offset: Offset(0.0, -2.0))],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Adicionar:', style: FlutterFlowTheme.of(context).bodyLarge.override(fontWeight: FontWeight.bold)),
                        Container(
                          width: 130.0, height: 44.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_rounded, color: FlutterFlowTheme.of(context).secondaryText),
                                onPressed: (temEstoque && quantidade > 0) ? _decrementar : null,
                              ),
                              Text('$quantidade', style: FlutterFlowTheme.of(context).titleMedium),
                              IconButton(
                                icon: Icon(
                                  Icons.add_rounded, 
                                  color: (temEstoque && quantidade < estoqueRestante) ? Color(0xFF156F00) : Colors.grey
                                ),
                                onPressed: (temEstoque && quantidade < estoqueRestante) ? _incrementar : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    InkWell(
                      onTap: (_isLoading || !temEstoque || quantidade == 0) 
                          ? null 
                          : () async { await _adicionarAoCarrinho(); },
                      child: Container(
                        width: double.infinity, height: 50.0,
                        decoration: BoxDecoration(
                          color: (_isLoading || !temEstoque || quantidade == 0) ? Colors.grey : Color(0xFF156F00),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          !temEstoque 
                              ? (estoqueTotal > 0 ? 'Limite Atingido' : 'Esgotado')
                              : (_isLoading 
                                  ? 'Adicionando...' 
                                  : 'Adicionar • R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}'),
                          style: FlutterFlowTheme.of(context).titleSmall.override(font: GoogleFonts.interTight(), color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}