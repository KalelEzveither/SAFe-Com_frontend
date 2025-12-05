import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports do Backend
import '../model/barraca_model.dart';
import '../services/barraca_service.dart';
import '../detalhes_barraca/detalhes_barraca_widget.dart';

class BarracasPorCategoriaWidget extends StatefulWidget {
  final String categoriaNome; // Recebe "Doces", "Salgados", etc.

  const BarracasPorCategoriaWidget({
    super.key,
    required this.categoriaNome,
  });

  @override
  State<BarracasPorCategoriaWidget> createState() => _BarracasPorCategoriaWidgetState();
}

class _BarracasPorCategoriaWidgetState extends State<BarracasPorCategoriaWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<Barraca> _listaBarracas = [];
  bool _isLoading = true;
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    _carregarBarracas();
  }

  Future<void> _carregarBarracas() async {
    // Busca todas e filtra localmente (simulação, pois o back não tem filtro ainda)
    var todas = await BarracaService().getBarracas();
    
    // Aqui você poderia filtrar: todas.where((b) => b.categoria == widget.categoriaNome)
    // Como não temos categoria na BarracaModel ainda, mostramos todas.
    
    if (mounted) {
      setState(() {
        _listaBarracas = todas;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
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
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 20.0,
                borderWidth: 1.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Color(0xFF156F00),
                  size: 24.0,
                ),
                onPressed: () {
                  context.pop(); // Voltar
                },
              ),
              Text(
                widget.categoriaNome, // Título Dinâmico
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      font: GoogleFonts.inter(),
                      color: Color(0xFF14181B),
                      fontSize: 32.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de Busca
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: textController,
                      focusNode: textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Encontre barracas...',
                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.readexPro(),
                              color: Color(0xFF57636C),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF19DB8A), width: 1.0),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF57636C), size: 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            color: Color(0xFF14181B),
                            fontSize: 14.0,
                          ),
                    ),
                  ),
                ),

                // Título "Bancas em destaque" (Estático por enquanto)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bancas em destaque',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.readexPro(),
                              color: Color(0xFF151515),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        'Ver tudo',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(),
                              color: Color(0xFF156F00),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),

                // Carrossel de Destaques (Horizontal) - Se quiser manter
                // ... (Pulei o carrossel horizontal para focar na lista principal, mas você pode manter se quiser)

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Text(
                    'Todas que vendem ${widget.categoriaNome}',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.readexPro(),
                          color: Color(0xFF404040),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),

                // LISTA VERTICAL DINÂMICA
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: _isLoading 
                      ? Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Color(0xFF156F00))))
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // Importante dentro de SingleChildScrollView
                          itemCount: _listaBarracas.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.0),
                          itemBuilder: (context, index) {
                            final barraca = _listaBarracas[index];
                            
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x1A000000),
                                    offset: Offset(0.0, 1.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Imagem da Barraca
                                    Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFA130),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.network(
                                          (barraca.imagemUrl != null && barraca.imagemUrl!.isNotEmpty) 
                                              ? barraca.imagemUrl! 
                                              : 'https://via.placeholder.com/80',
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) => Icon(Icons.store, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              barraca.nome,
                                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                                    font: GoogleFonts.readexPro(),
                                                    color: Color(0xFF131313),
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: Text(
                                                barraca.descricao,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      font: GoogleFonts.readexPro(),
                                                      color: Color(0xFF57636C),
                                                      fontSize: 12.0,
                                                    ),
                                              ),
                                            ),
                                            // Avaliação e Status (Mockado ou Real se tiver dados)
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16.0),
                                                      Text(
                                                        '4.8 (10)', // Mock
                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                              font: GoogleFonts.readexPro(),
                                                              color: Color(0xFF57636C),
                                                              fontSize: 12.0,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    barraca.isAberta ? 'Aberto' : 'Fechado',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          font: GoogleFonts.readexPro(),
                                                          color: barraca.isAberta ? Color(0xFF156F00) : Colors.red,
                                                          fontSize: 12.0,
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
                                    // Botão Ver
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          // Navega para Detalhes passando a barraca real
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetalhesBarracaWidget(barraca: barraca),
                                            ),
                                          );
                                        },
                                        text: 'Ver',
                                        options: FFButtonOptions(
                                          height: 28.0,
                                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                                          color: Color(0xFF156F00),
                                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.readexPro(),
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                          elevation: 0.0,
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 32.0),
              ]
              .divide(SizedBox(height: 16.0))
              .addToStart(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}