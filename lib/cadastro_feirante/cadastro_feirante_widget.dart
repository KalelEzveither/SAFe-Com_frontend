import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cadastro_feirante_model.dart';
export 'cadastro_feirante_model.dart';

class CadastroFeiranteWidget extends StatefulWidget {
  const CadastroFeiranteWidget({super.key});

  static String routeName = 'CadastroFeirante';
  static String routePath = '/cadastroFeirante';

  @override
  State<CadastroFeiranteWidget> createState() => _CadastroFeiranteWidgetState();
}

class _CadastroFeiranteWidgetState extends State<CadastroFeiranteWidget> {
  late CadastroFeiranteModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroFeiranteModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.eMailTextController ??= TextEditingController();
    _model.eMailFocusNode ??= FocusNode();

    _model.senhaTextController1 ??= TextEditingController();
    _model.senhaFocusNode1 ??= FocusNode();

    _model.senhaTextController2 ??= TextEditingController();
    _model.senhaFocusNode2 ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // --- CABEÇALHO COM IMAGEM (Mantido igual) ---
              Stack(
                children: [
                  Container(
                    width: 427.4,
                    height: 292.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/imagempragica.png',
                        ).image,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/icone_(8).png',
                              width: 192.2,
                              height: 225.79,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).info,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.safePop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // --- FORMULÁRIO ---
              Container(
                width: 407.0,
                // Removi a altura fixa ou ajustei para caber o conteúdo sem as categorias
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Campo NOME
                        Container(
                          width: 349.6,
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: Color(0x00262D34),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              controller: _model.nomeTextController,
                              focusNode: _model.nomeFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Digite seu nome',
                                hintText: 'Digite seu nome',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                filled: true,
                                fillColor: Color(0x2D767E7E),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.nomeTextControllerValidator.asValidator(context),
                            ),
                          ),
                        ),
                        
                        // Campo EMAIL
                        Container(
                          width: 349.6,
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: Color(0x00262D34),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              controller: _model.eMailTextController,
                              focusNode: _model.eMailFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'E-mail',
                                hintText: 'Digite seu e-mail',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                filled: true,
                                fillColor: Color(0x2D767E7E),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.eMailTextControllerValidator.asValidator(context),
                            ),
                          ),
                        ),

                        // Campo SENHA 1
                        Container(
                          width: 349.5,
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              controller: _model.senhaTextController1,
                              focusNode: _model.senhaFocusNode1,
                              autofocus: false,
                              obscureText: !_model.senhaVisibility1,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Senha',
                                hintText: 'Insira sua Senha',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                filled: true,
                                fillColor: Color(0x2D767E7E),
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(() => _model.senhaVisibility1 = !_model.senhaVisibility1),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.senhaVisibility1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    size: 22,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.senhaTextController1Validator.asValidator(context),
                            ),
                          ),
                        ),

                        // Campo SENHA 2 (Confirmar)
                        Container(
                          width: 353.1,
                          height: 56.15,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              controller: _model.senhaTextController2,
                              focusNode: _model.senhaFocusNode2,
                              autofocus: false,
                              obscureText: !_model.senhaVisibility2,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Confirmar Senha',
                                hintText: 'Confirme sua Senha',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                                  borderRadius: BorderRadius.circular(250.0),
                                ),
                                filled: true,
                                fillColor: Color(0x2D767E7E),
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(() => _model.senhaVisibility2 = !_model.senhaVisibility2),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.senhaVisibility2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    size: 22,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.senhaTextController2Validator.asValidator(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0), // Espaçamento extra
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            // 1. Validação Básica
                            if (_model.nomeTextController.text.isEmpty || 
                                _model.eMailTextController.text.isEmpty || 
                                _model.senhaTextController1.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Preencha todos os campos obrigatórios!')),
                              );
                              return;
                            }

                            if (_model.senhaTextController1.text != _model.senhaTextController2.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('As senhas não conferem!')),
                              );
                              return;
                            }

                            // 2. Criação do Pacote de Dados (Map)
                            final dadosDoFeirante = {
                              'nome': _model.nomeTextController.text,
                              'email': _model.eMailTextController.text,
                              'senha': _model.senhaTextController1.text,
                              // Placeholders solicitados
                              'cpfCnpj': '00000000002', 
                              'telefone': '77999999991',    
                              'tipo': 'VENDEDOR'            
                            };

                            // 3. Navegação para a Tela de Barraca (Passando os dados)
                            context.pushNamed(
                              'CadastroBarraca', // Confirme se o nome da rota no seu main.dart é este ou 'CadastroBarracaWidget'
                              extra: dadosDoFeirante, 
                            );
                          },
                          text: 'Próximo',
                          options: FFButtonOptions(
                            width: 200, 
                            height: 41.6,
                            color: Color(0xF3FD8E2B),
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  color: Color(0xFFFFFCFC),
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}