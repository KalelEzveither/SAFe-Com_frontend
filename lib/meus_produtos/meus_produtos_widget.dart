import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'meus_produtos_model.dart';

import '../services/barraca_service.dart';
import '../services/session_service.dart';
import '../model/barraca_model.dart';
import '../model/produto_model.dart';
import '../criar_produto/criar_produto_widget.dart';
import '../gestao_reservas/gestao_reservas_widget.dart';

export 'meus_produtos_model.dart';

class MeusProdutosWidget extends StatefulWidget {
  const MeusProdutosWidget({super.key});

  static String routeName = 'meus_Produtos';
  static String routePath = '/meusProdutos';

  @override
  State<MeusProdutosWidget> createState() => _MeusProdutosWidgetState();
}

class _MeusProdutosWidgetState extends State<MeusProdutosWidget> {
  late MeusProdutosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  Barraca? _minhaBarraca;
  List<Produto> _meusProdutos = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeusProdutosModel());
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    
    final user = await SessionService.getUser();
    if (user != null) {
      // 1. Busca a barraca do vendedor
      final barraca = await BarracaService().getBarracaPeloUsuario(user['id']);
      
      if (barraca != null) {
        // 2. Busca os produtos dessa barraca
        final produtos = await BarracaService().getProdutosPorBarraca(barraca.id);
        
        if (mounted) {
          setState(() {
            _minhaBarraca = barraca;
            _meusProdutos = produtos;
            _isLoading = false;
          });
        }
      } else {
        setState(() => _isLoading = false); // Não tem barraca ainda
      }
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
        
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (_minhaBarraca != null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CriarProdutoWidget(barracaId: _minhaBarraca!.id), 
                ),
              );
              _carregarDados(); // Recarrega a lista ao voltar
            } else {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Crie sua barraca primeiro!")));
            }
          },
          backgroundColor: Color(0xFF156F00),
          icon: Icon(Icons.add),
          label: Text("Novo Produto"),
        ),

        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 61.5,
              icon: Icon(Icons.arrow_back, color: Color(0xFF156F00), size: 24.0),
              onPressed: () { context.safePop(); },
            ),
          ),
          title: Text(
            _minhaBarraca?.nome ?? 'Minha Barraca',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                  fontSize: 22,
                ),
          ),
          actions: [
            // Atalho para Ver Pedidos (Opcional, mas útil)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.list_alt, color: Color(0xFF156F00)),
                tooltip: "Ver Reservas",
                onPressed: () {
                  context.pushNamed(GestaoReservasWidget.routeName);
                },
              ),
            )
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: _isLoading 
            ? Center(child: CircularProgressIndicator(color: Color(0xFF156F00)))
            : _minhaBarraca == null
                ? Center(child: Text("Você ainda não tem uma barraca cadastrada."))
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Descrição da Barraca
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  _minhaBarraca!.descricao.isNotEmpty 
                                      ? _minhaBarraca!.descricao 
                                      : 'Sem descrição cadastrada.',
                                  style: FlutterFlowTheme.of(context).labelMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Lista de Produtos
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 80.0), // Padding bottom pro FAB não cobrir
                          child: _meusProdutos.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Nenhum produto cadastrado."),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: _meusProdutos.length,
                                  itemBuilder: (context, index) {
                                    final produto = _meusProdutos[index];

                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3.0,
                                              color: Color(0x411D2429),
                                              offset: Offset(0.0, 1.0),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // Imagem
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 1.0, 1.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  child: Image.network(
                                                    (produto.imagemUrl.isNotEmpty)
                                                        ? produto.imagemUrl
                                                        : 'https://via.placeholder.com/80',
                                                    width: 80.0,
                                                    height: 80.0,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (ctx, err, stack) => Icon(Icons.fastfood, size: 40, color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                              
                                              // Textos
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 4.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        produto.nome,
                                                        style: FlutterFlowTheme.of(context).headlineSmall,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 0.0),
                                                        child: AutoSizeText(
                                                          produto.descricao,
                                                          textAlign: TextAlign.start,
                                                          style: FlutterFlowTheme.of(context).labelMedium,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Estoque: ${produto.quantidadeEstoque}',
                                                        style: TextStyle(
                                                          color: produto.quantidadeEstoque > 0 ? Colors.green : Colors.red,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              
                                              // Botão Editar
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Vai para Editar passando o produto
                                                        /*
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => EditarProdutoWidget(produto: produto),
                                                          ),
                                                        );
                                                        _carregarDados(); // Atualiza ao voltar
                                                        */
                                                        print("Clicou em editar: ${produto.nome}");
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Color(0xFF156F00),
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}