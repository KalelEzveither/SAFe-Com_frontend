import 'dart:convert'; // Para Base64 e JSON
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // ADICIONE http ao pubspec.yaml se não tiver
import 'cadastro_barraca_model.dart';
export 'cadastro_barraca_model.dart';

class CadastroBarracaWidget extends StatefulWidget {
  const CadastroBarracaWidget({super.key});

  static String routeName = 'CadastroBarraca';
  static String routePath = '/cadastroBarraca';

  @override
  State<CadastroBarracaWidget> createState() => _CadastroBarracaWidgetState();
}

class _CadastroBarracaWidgetState extends State<CadastroBarracaWidget> {
  late CadastroBarracaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Mapa para converter os nomes dos chips em IDs do banco
  final Map<String, int> categoriasMap = {
    'Hortifruti': 1,
    'Doces': 2,
    'Temperos': 3,
    'Artesanato': 4,
    'Salgados': 5,
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroBarracaModel());

    _model.nomeProdTextController ??= TextEditingController();
    _model.nomeProdFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.horaTextController ??= TextEditingController();
    _model.horaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Função para enviar tudo para o Backend
  Future<void> _finalizarCadastro() async {
    // 1. Recuperar dados do usuário da tela anterior
    final Map<String, dynamic>? dadosUsuario = 
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (dadosUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: Dados do usuário perdidos.')));
      return;
    }

    // 2. Preparar Imagem em Base64
    String? imagemBase64;
    if (_model.uploadedLocalFile_uploadData3yb.bytes != null && 
        _model.uploadedLocalFile_uploadData3yb.bytes!.isNotEmpty) {
      imagemBase64 = base64Encode(_model.uploadedLocalFile_uploadData3yb.bytes!);
    }

    // 3. Preparar IDs das categorias
    List<int> catIds = [];
    if (_model.choiceChipsValues != null) {
      for (var nome in _model.choiceChipsValues!) {
        if (categoriasMap.containsKey(nome)) {
          catIds.add(categoriasMap[nome]!);
        }
      }
    }

    // 4. Montar o JSON Completo (Request Body)
    final corpoRequisicao = {
      "usuario": dadosUsuario, // O Map que veio da tela 1
      "barraca": {
        "nome": _model.nomeProdTextController.text,
        "descricao": _model.descriptionTextController.text,
        "horarioFuncionamento": _model.horaTextController.text,
        "imagemUrl": imagemBase64, // Pode ser null, backend aceita
        "categoriaIds": catIds
      }
    };

    try {
      // 5. Chamada API 
      final url = Uri.parse('http://192.168.0.118:8080/api/auth/feirante'); 
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(corpoRequisicao),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso!
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Sucesso!'),
              content: Text('Conta de feirante criada com sucesso.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(alertDialogContext);
                    context.goNamed('login'); // Vai para Login
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cadastrar Barraca', style: FlutterFlowTheme.of(context).headlineMedium),
              Text('Insira as informações da sua barraca', style: FlutterFlowTheme.of(context).labelMedium),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 8.0),
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderRadius: 12.0,
                borderWidth: 1.0,
                buttonSize: 40.0,
                icon: Icon(Icons.close_rounded, color: Color(0xFF156F00), size: 24.0),
                onPressed: () async { context.safePop(); },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // --- COMPONENTE DE UPLOAD DE IMAGEM ---
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () async {
                        final selectedMedia = await selectMediaWithSourceBottomSheet(
                          context: context,
                          allowPhoto: true,
                        );
                        if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                          safeSetState(() => _model.isDataUploading_uploadData3yb = true);
                          var selectedUploadedFiles = <FFUploadedFile>[];
                          try {
                            selectedUploadedFiles = selectedMedia.map((m) => FFUploadedFile(
                                  name: m.storagePath.split('/').last,
                                  bytes: m.bytes,
                                  height: m.dimensions?.height,
                                  width: m.dimensions?.width,
                                  blurHash: m.blurHash,
                                  originalFilename: m.originalFilename,
                                )).toList();
                          } finally {
                            _model.isDataUploading_uploadData3yb = false;
                          }
                          if (selectedUploadedFiles.length == selectedMedia.length) {
                            safeSetState(() {
                              _model.uploadedLocalFile_uploadData3yb = selectedUploadedFiles.first;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                        ),
                        child: _model.uploadedLocalFile_uploadData3yb.bytes != null && _model.uploadedLocalFile_uploadData3yb.bytes!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _model.uploadedLocalFile_uploadData3yb.bytes!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_sharp, size: 64.0, color: FlutterFlowTheme.of(context).secondaryText),
                                  Text('Toque para enviar foto', style: FlutterFlowTheme.of(context).bodyMedium),
                                ],
                              ),
                      ),
                    ),
                  ),

                  // --- CAMPOS DE TEXTO ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _model.nomeProdTextController,
                          focusNode: _model.nomeProdFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Nome da barraca',
                            hintText: 'Ex: Barraca da Tia Maria',
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary)),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _model.descriptionTextController,
                          focusNode: _model.descriptionFocusNode,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Descrição',
                            hintText: 'O que você vende de bom?',
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary)),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _model.horaTextController,
                          focusNode: _model.horaFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Horário',
                            hintText: 'Ex: 08:00 às 12:00',
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary)),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  // --- CATEGORIAS ---
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categorias:', style: FlutterFlowTheme.of(context).labelMedium),
                        SizedBox(height: 8),
                        FlutterFlowChoiceChips(
                          options: [
                            ChipData('Hortifruti'),
                            ChipData('Doces'),
                            ChipData('Temperos'),
                            ChipData('Artesanato'),
                            ChipData('Salgados')
                          ],
                          onChanged: (val) => safeSetState(() => _model.choiceChipsValues = val),
                          selectedChipStyle: ChipStyle(
                            backgroundColor: Color(0xF3FD8E2B),
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          chipSpacing: 8.0,
                          multiselect: true,
                          initialized: _model.choiceChipsValues != null,
                          controller: _model.choiceChipsValueController ??= FormFieldController<List<String>>([]),
                          wrapped: true,
                        ),
                      ],
                    ),
                  ),

                  // --- BOTÃO FINALIZAR ---
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        // Validação simples
                        if (_model.nomeProdTextController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dê um nome para sua barraca!')));
                          return;
                        }
                        // CHAMA A FUNÇÃO QUE FAZ TUDO
                        await _finalizarCadastro();
                      },
                      text: 'Finalizar Cadastro',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        color: Color(0xFF156F00),
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(color: Colors.white),
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}