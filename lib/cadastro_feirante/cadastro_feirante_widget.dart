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

    _model.cpfTextController ??= TextEditingController();
    _model.cpfFocusNode ??= FocusNode();

    _model.celularTextController ??= TextEditingController();
    _model.celularFocusNode ??= FocusNode();

    _model.eMailTextController ??= TextEditingController();
    _model.eMailFocusNode ??= FocusNode();

    _model.senhaTextController ??= TextEditingController();
    _model.senhaFocusNode ??= FocusNode();

    _model.confirmarSenhaTextController ??= TextEditingController();
    _model.confirmarSenhaFocusNode ??= FocusNode();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // --- CABEÇALHO (Mantido o visual da sua amiga) ---
                Stack(
                  children: [
                    Container(
                      width: 441.83,
                      height: 404.3,
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
                                width: 256.0,
                                height: 335.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.91),
                            child: Container(
                              width: 373.5,
                              height: 26.8,
                              decoration: BoxDecoration(
                                color: Color(0x00FFFFFF),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'É um prazer tê-lo conosco! Crie sua conta',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          // Botão de Voltar (Importante para navegação)
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // --- FORMULÁRIO (Campos Novos + Lógica Corrigida) ---
                Container(
                  width: 407.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // 1. NOME
                      _buildInputContainer(
                        context,
                        controller: _model.nomeTextController,
                        focusNode: _model.nomeFocusNode,
                        label: 'Digite seu nome',
                      ),

                      // 2. CPF (Visual Novo da Amiga + Sua Lógica)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: _buildInputContainer(
                          context,
                          controller: _model.cpfTextController,
                          focusNode: _model.cpfFocusNode,
                          label: 'CPF',
                        ),
                      ),

                      // 3. CELULAR (Visual Novo da Amiga + Sua Lógica)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: _buildInputContainer(
                          context,
                          controller: _model.celularTextController,
                          focusNode: _model.celularFocusNode,
                          label: 'Celular',
                        ),
                      ),

                      // 4. EMAIL
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: _buildInputContainer(
                          context,
                          controller: _model.eMailTextController,
                          focusNode: _model.eMailFocusNode,
                          label: 'E-mail',
                        ),
                      ),

                      // 5. SENHA
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: _buildPasswordContainer(
                          context,
                          controller: _model.senhaTextController,
                          focusNode: _model.senhaFocusNode,
                          label: 'Senha',
                          isVisible: _model.senhaVisibility,
                          onVisibilityChanged: () => safeSetState(
                              () => _model.senhaVisibility = !_model.senhaVisibility),
                        ),
                      ),

                      // 6. CONFIRMAR SENHA (CORRIGIDO: Controller Certo!)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: _buildPasswordContainer(
                          context,
                          controller: _model.confirmarSenhaTextController, // <--- AQUI ESTAVA O ERRO
                          focusNode: _model.confirmarSenhaFocusNode,
                          label: 'Confirme sua senha',
                          isVisible: _model.confirmarSenhaVisibility, // Variável correta do model
                          onVisibilityChanged: () => safeSetState(() =>
                              _model.confirmarSenhaVisibility = !_model.confirmarSenhaVisibility),
                        ),
                      ),

                      // --- BOTÃO DE AÇÃO (CORRIGIDO PARA "PRÓXIMO") ---
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              // 1. Validação dos Campos (Mantém a segurança)
                              if (_model.nomeTextController.text.isEmpty ||
                                  _model.cpfTextController.text.isEmpty ||
                                  _model.celularTextController.text.isEmpty ||
                                  _model.eMailTextController.text.isEmpty ||
                                  _model.senhaTextController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Preencha todos os campos!')),
                                );
                                return;
                              }

                              // 2. Validação de Senha
                              if (_model.senhaTextController.text != _model.confirmarSenhaTextController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('As senhas não coincidem!')),
                                );
                                return;
                              }

                              // 3. Validação dos Termos
                              if (_model.checkboxValue == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Você deve aceitar os Termos de Uso.')),
                                );
                                return;
                              }

                              // 4. PREPARAR O PACOTE DE DADOS
                              // Aqui criamos um mapa simples com tudo que o usuário digitou
                              final Map<String, dynamic> dadosParaProximaTela = {
                                'nome': _model.nomeTextController.text.trim(),
                                'cpfCnpj': _model.cpfTextController.text.trim(),
                                'telefone': _model.celularTextController.text.trim(),
                                'email': _model.eMailTextController.text.trim(),
                                'senha': _model.senhaTextController.text, // A senha vai junto para criar a conta no final
                                'role': 'FEIRANTE' // Importante: Marcar que é feirante
                              };

                              print("Dados empacotados: $dadosParaProximaTela");

                              // 5. NAVEGAR PARA A TELA DE BARRACA
                              // Verifique se o nome 'CadastroBarraca' é EXATAMENTE o que está no 'static String routeName' da outra tela
                              context.pushNamed(
                                'CadastroBarraca', // Nome da rota da tela da sua amiga
                                extra: dadosParaProximaTela, // Passamos o pacote aqui
                              );
                            },
                            text: 'Próximo',
                            options: FFButtonOptions(
                              width: 200.0,
                              height: 46.2,
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

                      // --- RODAPÉ (JÁ TEM CONTA) ---
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Já tem uma conta? ',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('Login'); // Ajuste se sua rota for 'login' minusculo
                              },
                              text: 'Login',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: Color(0x004B39EF),
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontSize: 15.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers para limpar o código repetitivo ---

  Widget _buildInputContainer(BuildContext context,
      {required TextEditingController? controller,
      required FocusNode? focusNode,
      required String label}) {
    return Container(
      width: 349.5,
      height: 52.0,
      decoration: BoxDecoration(
        color: Color(0x00262D34),
        borderRadius: BorderRadius.circular(250.0), // Arredondamento visual da amiga
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: label,
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
        ),
      ),
    );
  }

  Widget _buildPasswordContainer(BuildContext context,
      {required TextEditingController? controller,
      required FocusNode? focusNode,
      required String label,
      required bool isVisible,
      required VoidCallback onVisibilityChanged}) {
    return Container(
      width: 349.5,
      height: 52.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 20.0, 0.0),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: !isVisible,
          decoration: InputDecoration(
            labelText: label,
            hintText: label,
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
              onTap: onVisibilityChanged,
              child: Icon(
                isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 22,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      ),
    );
  }
}