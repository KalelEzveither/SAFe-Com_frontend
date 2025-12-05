import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'carrinho_model.dart';
// Imports manuais
import '../services/cart_service.dart';
import '../model/cart_item_model.dart';

export 'carrinho_model.dart';

class CarrinhoWidget extends StatefulWidget {
  const CarrinhoWidget({super.key});

  static String routeName = 'carrinho';
  static String routePath = '/carrinho';

  @override
  State<CarrinhoWidget> createState() => _CarrinhoWidgetState();
}

class _CarrinhoWidgetState extends State<CarrinhoWidget> {
  late CarrinhoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estado local
  bool _isLoading = true;
  List<CartItem> _itens = [];
  double _valorTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarrinhoModel());
    _carregarCarrinho(); // Busca dados ao iniciar
  }

  Future<void> _carregarCarrinho() async {
    setState(() => _isLoading = true);
    final itens = await CartService().getCartItems();
    
    // Calcula o total
    double total = 0;
    for (var item in itens) {
      total += item.subtotal;
    }

    if (mounted) {
      setState(() {
        _itens = itens;
        _valorTotal = total;
        _isLoading = false;
      });
    }
  }

  Future<void> _removerItem(int id) async {
    bool sucesso = await CartService().removeItem(id);
    if (sucesso) {
      await _carregarCarrinho(); // Recarrega a lista atualizada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item removido"), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao remover item")),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF156F00),
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Carrinho',
            style: FlutterFlowTheme.of(context).displaySmall,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFF156F00)))
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Se a lista estiver vazia
                          if (_itens.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Center(
                                child: Text(
                                  "O seu carrinho está vazio.",
                                  style: FlutterFlowTheme.of(context).bodyLarge,
                                ),
                              ),
                            ),

                          // Lista de Itens Dinâmica
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _itens.length,
                              itemBuilder: (context, index) {
                                final item = _itens[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x320E151B),
                                          offset: Offset(0.0, 1.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 8.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Imagem do Produto
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: Image.network(
                                              (item.imagemUrl != null && item.imagemUrl!.isNotEmpty)
                                                  ? item.imagemUrl!
                                                  : 'https://via.placeholder.com/80',
                                              width: 80.0,
                                              height: 80.0,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Icon(Icons.fastfood, size: 40, color: Colors.grey),
                                            ),
                                          ),
                                          // Detalhes
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${item.quantidade}x ${item.nomeProduto}",
                                                    style: FlutterFlowTheme.of(context).titleSmall,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          font: GoogleFonts.inter(),
                                                          color: Color(0xFF156F00),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  // Nome da barraca (opcional)
                                                  Text(
                                                    item.nomeBarraca,
                                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Botão Remover
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            icon: Icon(
                                              Icons.delete_outline_rounded,
                                              color: Color(0xFFE86969),
                                              size: 24.0,
                                            ),
                                            onPressed: () {
                                              _removerItem(item.id); // Remove usando o ID do item
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Resumo do Total
                          if (_itens.isNotEmpty)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: FlutterFlowTheme.of(context).labelLarge,
                                  ),
                                  Text(
                                    'R\$ ${_valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                    style: FlutterFlowTheme.of(context).displaySmall.override(
                                          font: GoogleFonts.interTight(),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Botão Pagar
                  if (_itens.isNotEmpty)
                    InkWell(
                      onTap: () async {
                        // Passa o valor total para a tela de Pagamento
                        context.pushNamed(
                          PagamentoPixWidget.routeName,
                          extra: {'valorTotal': _valorTotal, 'itens': _itens},
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF156F00), // Cor verde do seu tema
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Finalizar Compra',
                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                    font: GoogleFonts.interTight(),
                                    color: Colors.white,
                                  ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.payment, color: Colors.white, size: 28),
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