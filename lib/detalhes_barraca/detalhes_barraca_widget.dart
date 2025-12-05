import 'dart:convert';

import '../model/barraca_model.dart';
import '../model/produto_model.dart';
import '../services/barraca_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detalhes_barraca_model.dart';
export 'detalhes_barraca_model.dart';

class DetalhesBarracaWidget extends StatefulWidget {
  final Barraca barraca;

  const DetalhesBarracaWidget({
    super.key,
    required this.barraca,
  });

  static String routeName = 'detalhes_Barraca';
  static String routePath = '/detalhesBarraca';

  @override
  State<DetalhesBarracaWidget> createState() => _DetalhesBarracaWidgetState();
}

class _DetalhesBarracaWidgetState extends State<DetalhesBarracaWidget> {
  late DetalhesBarracaModel _model;
  
  // Variável para armazenar o estado da busca
  late Future<List<Produto>> _produtosFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesBarracaModel());
    
    // Inicia a busca dos produtos apenas uma vez quando a tela abre
    _produtosFuture = BarracaService().getProdutosPorBarraca(widget.barraca.id);
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
          title: Text(
            widget.barraca.nome,
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FlutterFlowTheme.of(context).displaySmall.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 44.0,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF156F00),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed(CarrinhoWidget.routeName);
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF156F00),
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.safePop();
                  },
                ),
              ),
              // Exibe a descrição da barraca se houver (substituí o texto fixo)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  widget.barraca.descricao.isNotEmpty 
                      ? widget.barraca.descricao 
                      : 'Confira os produtos desta barraca abaixo:',
                  style: FlutterFlowTheme.of(context).labelMedium,
                ),
              ),

              // LISTA DINÂMICA (FUTURE BUILDER)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: FutureBuilder<List<Produto>>(
                  future: _produtosFuture,
                  builder: (context, snapshot) {
                    // 1. Carregando
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF156F00),
                          ),
                        ),
                      );
                    }
                    // 2. Erro
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar produtos. Tente novamente.',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      );
                    }
                    // 3. Vazio
                    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Nenhum produto disponível nesta barraca.',
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      );
                    }

                    // 4. Sucesso: Lista de Produtos
                    final produtos = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];

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
                                  // Imagem do Produto
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 1.0, 1.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: produto.imagemUrl != null && produto.imagemUrl!.isNotEmpty
                                          ? Image.memory( // <-- MUDANÇA AQUI: Usando Image.memory
                                              base64Decode(produto.imagemUrl!), // <-- Decodifica o Base64 para Bytes
                                              width: 80.0,
                                              height: 80.0,
                                              fit: BoxFit.cover,
                                              errorBuilder: (ctx, err, stack) => Icon(Icons.fastfood, size: 40, color: Colors.grey),
                                            )
                                          : Container( // <-- Bloco para imagem placeholder se a URL estiver vazia
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6.0),
                                                color: FlutterFlowTheme.of(context).alternate,
                                              ),
                                              child: Icon(Icons.fastfood, size: 40, color: FlutterFlowTheme.of(context).secondaryText),
                                            ),
                                    ),
                                  ),
                                  // Detalhes (Nome e Descrição)
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Preço e Botão
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
                                            // Navegação para Detalhes do Produto (passando o objeto se necessário)
                                            context.pushNamed(
                                              DetalhesProdutoWidget.routeName,
                                              extra: {'produto': produto} // Opcional: passar o produto
                                            );
                                          },
                                          child: Icon(
                                            Icons.chevron_right_rounded,
                                            color: Color(0xFF156F00),
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 4.0, 8.0),
                                        child: Text(
                                          'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                          textAlign: TextAlign.end,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF156F00),
                                                ),
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