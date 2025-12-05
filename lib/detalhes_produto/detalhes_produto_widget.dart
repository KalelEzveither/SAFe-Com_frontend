import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detalhes_produto_model.dart';
import '../services/cart_service.dart';
import '../model/produto_model.dart'; // Para usar o objeto Produto

class DetalhesProdutoWidget extends StatefulWidget {
  final Produto produto; // Recebe o produto clicado

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
  bool _isLoading = false;

  // Estado local para a quantidade
  int quantidade = 1;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesProdutoModel());
  }
  
  Future<void> _adicionarAoCarrinho() async {
    setState(() => _isLoading = true); // Trava o botão

    final cartService = CartService();
    int status = await cartService.addItem(widget.produto.id, quantidade); 

    setState(() => _isLoading = false); // Destrava

    if (status == 200 || status == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto adicionado ao carrinho!'), backgroundColor: Colors.green),
      );
      context.safePop(); // Volta para a barraca
    } 
    else if (status == 409) {
      // Regra de Negócio: Já tem item de outra barraca
      _mostrarAlertaConflito();
    } 
    else if (status == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faça login para comprar.')),
      );
      // Opcional: Levar para tela de login
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
              await CartService().clearCart(); // Limpa
              _adicionarAoCarrinho(); // Tenta adicionar de novo
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

  void _incrementar() {
    setState(() {
      quantidade++;
    });
  }

  void _decrementar() {
    if (quantidade > 1) {
      setState(() {
        quantidade--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o total parcial
    double valorTotal = widget.produto.preco * quantidade;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Imagem do Produto (Topo Expandido)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 350.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          child: Image.network(
                            (widget.produto.imagemUrl.isNotEmpty)
                                ? widget.produto.imagemUrl
                                : 'https://via.placeholder.com/400x300', // Placeholder padrão
                            width: double.infinity,
                            height: 350.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                Icon(Icons.fastfood, size: 100, color: Colors.grey),
                          ),
                        ),
                        // Botão Voltar
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 44.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            fillColor: Color(0x7F000000), // Fundo semitransparente
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.safePop();
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Informações do Produto
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Text(
                        widget.produto.nome,
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                      child: Text(
                        'R\$ ${widget.produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.interTight(),
                              color: Color(0xFF156F00),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                      child: Text(
                        widget.produto.descricao.isNotEmpty 
                            ? widget.produto.descricao 
                            : 'Sem descrição disponível.',
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Barra Inferior (Contador e Botão Adicionar)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x55000000),
                    offset: Offset(0.0, -2.0),
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Linha do Contador
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantidade',
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          width: 130.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_rounded, color: FlutterFlowTheme.of(context).secondaryText),
                                onPressed: _decrementar,
                              ),
                              Text(
                                '$quantidade',
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                              IconButton(
                                icon: Icon(Icons.add_rounded, color: Color(0xFF156F00)),
                                onPressed: _incrementar,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    
                    // Botão Adicionar ao Carrinho
                    InkWell(
                      // Se estiver carregando (_isAdding true), o onTap fica null (desabilitado)
                      onTap: _isLoading
                          ? null
                          : () async {
                              await _adicionarAoCarrinho();
                            },
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          // Muda a cor para cinza se estiver carregando, senão mantém o verde
                          color: _isLoading ? Colors.grey : Color(0xFF156F00),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          // Muda o texto dependendo do estado
                          _isLoading
                              ? 'Adicionando...'
                              : 'Adicionar • R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.interTight(),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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