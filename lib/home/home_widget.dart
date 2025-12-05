import '../carrinho/carrinho_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_model.dart';
export 'home_model.dart';
import '/model/barraca_model.dart';
import '/services/barraca_service.dart';
import 'dart:convert'; // Para base64Decode

import '/services/session_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  List<Barraca> _listaBarracas = [];
  List<Barraca> _listaFiltrada = [];

  bool _isLoading = true;
  final BarracaService _barracaService = BarracaService();

  String _nomeUsuario = "Visitante";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    _carregarUsuario();
    _carregarBarracas();
  }

  void _carregarUsuario() async {
    // Chama seu serviço existente para pegar o usuário
    final userData = await SessionService.getUser();

    // Verifica se veio dados e se tem o campo 'nome'
    if (userData != null && userData.containsKey('nome')) {
      setState(() {
        _nomeUsuario = userData['nome']; // Atualiza a variável da tela
      });
    }
  }

  void _carregarBarracas() async {
    var barracas = await _barracaService.getBarracas();
    setState(() {
      _listaBarracas = barracas;
      _listaFiltrada = barracas;
      _isLoading = false;
    });
  }

  // --- LÓGICA DE FILTRO ---
  void _filtrarBarracas(String query) {
    if (query.isEmpty) {
      setState(() {
        _listaFiltrada = _listaBarracas;
      });
    } else {
      setState(() {
        _listaFiltrada = _listaBarracas.where((barraca) {
          final nome = barraca.nome.toLowerCase();
          final desc = barraca.descricao.toLowerCase();
          final input = query.toLowerCase();
          
          return nome.contains(input) || desc.contains(input);
        }).toList();
      });
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
          backgroundColor: Color(0xFF156F00),
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $_nomeUsuario',
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelSmall.fontStyle,
                    ),
              ),
              Text(
                'Dashboard',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Color(0xFFEFF1F3),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0), // Ajustei para 12 pois o botão já tem margem interna
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 44.0, // Tamanho da área de toque (bom para UX)
                fillColor: Colors.transparent, // Fundo transparente
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white, // Mantendo sua cor original
                  size: 24.0,
                ),
                onPressed: () async {
                  // Navega para a tela do Carrinho
                  context.pushNamed(CarrinhoWidget.routeName);
                },
              ),
            ),
          ],
          centerTitle: false,
          toolbarHeight: 72.0,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 12.0),
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    autofocus: false,
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    onChanged: (value) => _filtrarBarracas(value), 
                    decoration: InputDecoration(
                      labelText: 'Encontre barracas...',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: (_model.textFieldFocusNode?.hasFocus ?? false)
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: (_model.textFieldFocusNode?.hasFocus ?? false)
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Barracas mais acessadas',
                    style: FlutterFlowTheme.of(context).bodyLarge,
                  ),
                ),

                // Lista Dinâmica de Barracas
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: Color(0xFF156F00)))
                      : _listaFiltrada.isEmpty // Verifica a lista filtrada, não a original
                          ? Center(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Nenhuma barraca encontrada."),
                            ))
                          : ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 44.0),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _listaFiltrada.length, // Usa a lista filtrada
                              itemBuilder: (context, index) {
                                final barraca = _listaFiltrada[index]; // Usa a lista filtrada

                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 12.0),
                                  child: InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                        'detalhes_Barraca', 
                                        extra: { "barraca": barraca },
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // IMAGEM
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                            child: barraca.imagemUrl != null && barraca.imagemUrl!.isNotEmpty
                                                ? Image.memory(
                                                    base64Decode(barraca.imagemUrl!),
                                                    width: double.infinity,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => 
                                                        Container(height: 200, color: Colors.grey[200], child: Icon(Icons.store, size: 50)),
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    height: 200.0,
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                    child: Icon(Icons.store, size: 60, color: FlutterFlowTheme.of(context).secondaryText),
                                                  ),
                                          ),
                                          
                                          // TEXTOS
                                          Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  barraca.isAberta ? 'Aberto' : 'Fechado',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        font: GoogleFonts.inter(),
                                                        color: barraca.isAberta ? Colors.green : Colors.red,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  barraca.nome,
                                                  style: FlutterFlowTheme.of(context).headlineMedium,
                                                ),
                                                Text(
                                                  barraca.descricao,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: FlutterFlowTheme.of(context).labelSmall,
                                                ),
                                              ].divide(SizedBox(height: 4.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ].addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
