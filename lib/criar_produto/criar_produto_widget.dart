// ignore_for_file: unnecessary_null_comparison

import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'criar_produto_model.dart';
export 'criar_produto_model.dart';

// IMPORTS DO BACKEND
import '../model/produto_model.dart';
import '../services/produto_service.dart';

class CriarProdutoWidget extends StatefulWidget {
  // Recebe o ID da barraca para saber onde salvar
  final int barracaId;

  const CriarProdutoWidget({
    super.key,
    required this.barracaId,
  });

  static String routeName = 'criar_Produto';
  static String routePath = '/criarProduto';

  @override
  State<CriarProdutoWidget> createState() => _CriarProdutoWidgetState();
}

class _CriarProdutoWidgetState extends State<CriarProdutoWidget> {
  late CriarProdutoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false; // Trava o botão ao salvar

  late TextEditingController _estoqueTextController;
  late FocusNode _estoqueFocusNode;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CriarProdutoModel());

    _model.nomeProdTextController ??= TextEditingController();
    _model.nomeProdFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    _estoqueTextController = TextEditingController(text: '0');
    _estoqueFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    _estoqueTextController.dispose();
    _estoqueFocusNode.dispose();
    super.dispose();
  }

  // --- LÓGICA DE SALVAR PRODUTO ---
  Future<void> _salvarProduto() async {
    if (!_model.formKey.currentState!.validate()) {
      // Usa o Scaffold Messenger para exibir erro de validação
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, preencha todos os campos obrigatórios.")));
      return;
    }
    
    // Mantendo a verificação original:
    if (_model.nomeProdTextController.text.isEmpty || _model.priceTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Preencha nome e preço.")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Converte Imagem para Base64
      String imagemBase64 = '';
      if (_model.uploadedLocalFile_imagemProd != null && _model.uploadedLocalFile_imagemProd.bytes != null) {
        imagemBase64 = base64Encode(_model.uploadedLocalFile_imagemProd.bytes!);
      }

      // 2. Converte Preço
      double preco = double.tryParse(_model.priceTextController.text.replaceAll(',', '.').trim()) ?? 0.0;
      
      int estoque = int.tryParse(_estoqueTextController.text) ?? 0;

      // 3. Cria Objeto
      Produto novo = Produto(
        id: 0,
        nome: _model.nomeProdTextController.text,
        descricao: _model.descriptionTextController.text,
        preco: preco,
        imagemUrl: imagemBase64,
        categoria: _model.choiceChipsValue ?? 'Geral',
        quantidadeEstoque: estoque,
        barracaId: widget.barracaId,
      );

      // 4. Envia
      bool sucesso = await ProdutoService().criarProduto(novo);

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Produto criado!"), 
            backgroundColor: FlutterFlowTheme.of(context).primary));
        context.safePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro ao criar."), 
            backgroundColor: FlutterFlowTheme.of(context).error));
      }
    } catch (e) {
      print("Erro: $e");
    } finally {
      setState(() => _isSaving = false);
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
              Text(
                'Criar Produto',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.interTight(),
                    letterSpacing: 0.0,
                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
              ),
              Text(
                'Insira as informações do produto',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                    fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
              ),
            ].divide(SizedBox(height: 4)),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 8),
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderRadius: 12,
                borderWidth: 1,
                buttonSize: 40,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                icon: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF156F00), // Mantido o verde forte
                  size: 24,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Align(
                alignment: AlignmentDirectional(0, -1),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 770, // Usando 770 para melhor visualização em dispositivos maiores
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- UPLOAD DE IMAGEM ---
                        Container(
                          width: double.infinity,
                          height: 330,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2,
                            ),
                            image: _model.uploadedLocalFile_imagemProd != null && _model.uploadedLocalFile_imagemProd.bytes != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(_model.uploadedLocalFile_imagemProd.bytes!)
                                  )
                                : null,
                          ),
                          child: InkWell(
                            onTap: () async {
                              final selectedMedia = await selectMediaWithSourceBottomSheet(
                                context: context,
                                allowPhoto: true,
                                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                textColor: FlutterFlowTheme.of(context).primaryText,
                              );
                              if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                safeSetState(() => _model.isDataUploading_imagemProd = true);
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
                                  _model.isDataUploading_imagemProd = false;
                                }
                                if (selectedUploadedFiles.length == selectedMedia.length) {
                                  safeSetState(() {
                                    _model.uploadedLocalFile_imagemProd = selectedUploadedFiles.first;
                                  });
                                }
                              }
                            },
                            child: _model.uploadedLocalFile_imagemProd != null && _model.uploadedLocalFile_imagemProd.bytes != null
                                ? Container() // Se tiver imagem, não mostra o placeholder
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(Icons.upload_sharp, color: FlutterFlowTheme.of(context).secondaryText, size: 64)),
                                      Text("Toque para adicionar foto", style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: FlutterFlowTheme.of(context).secondaryText)),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // --- NOME DO PRODUTO (TextFormField Formatado) ---
                        TextFormField(
                          controller: _model.nomeProdTextController,
                          focusNode: _model.nomeProdFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Nome do produto...',
                            labelStyle: FlutterFlowTheme.of(context).headlineMedium.copyWith(color: FlutterFlowTheme.of(context).secondaryText, fontSize: 18),
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                          ),
                          style: FlutterFlowTheme.of(context).headlineMedium,
                          validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório.' : null,
                          inputFormatters: [
                            if (!isAndroid && !isiOS)
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) => TextEditingValue(
                                      selection: newValue.selection,
                                      text: newValue.text.toCapitalization(TextCapitalization.words)),
                              ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // --- DESCRIÇÃO (TextFormField Formatado) ---
                        TextFormField(
                          controller: _model.descriptionTextController,
                          focusNode: _model.descriptionFocusNode,
                          maxLines: 5,
                          minLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Descrição...',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),

                        SizedBox(height: 12),

                        // --- CATEGORIA (ChoiceChips Formatado) ---
                        Text(
                          'Categoria do Produto',
                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(),
                                letterSpacing: 0.0,
                              ),
                        ),
                        SizedBox(height: 8),

                        FlutterFlowChoiceChips(
                          options: [ChipData('Hortifruti'), ChipData('Doces'), ChipData('Salgados'), ChipData('Artesanato'), ChipData('Temperos')],
                          onChanged: (val) => safeSetState(() => _model.choiceChipsValue = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context).accent2,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: FlutterFlowTheme.of(context).primaryText),
                            iconColor: FlutterFlowTheme.of(context).primaryText,
                            elevation: 0,
                            borderColor: FlutterFlowTheme.of(context).secondary,
                            borderWidth: 2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: FlutterFlowTheme.of(context).secondaryText),
                            iconColor: FlutterFlowTheme.of(context).secondaryText,
                            elevation: 0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          chipSpacing: 8,
                          rowSpacing: 8,
                          multiselect: false,
                          alignment: WrapAlignment.start,
                          wrapped: true,
                          controller: _model.choiceChipsValueController ??= FormFieldController<List<String>>([]),
                        ),

                        SizedBox(height: 12),
                        
                        // --- LINHA DE PREÇO E ESTOQUE CORRIGIDA ---
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // PREÇO (MOVIDO PARA DENTRO DA ROW)
                            Expanded(
                              child: TextFormField(
                                controller: _model.priceTextController,
                                focusNode: _model.priceFocusNode,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Preço (R\$)',
                                  hintText: 'Ex: 10,50',
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge,
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                ),
                                style: FlutterFlowTheme.of(context).bodyLarge,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'O preço é obrigatório';
                                  }
                                  if (double.tryParse(val.replaceAll(',', '.')) == null) {
                                    return 'Preço inválido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            // ESTOQUE (PERMANECE DENTRO DA ROW)
                            Expanded(
                              child: TextFormField(
                                controller: _estoqueTextController,
                                focusNode: _estoqueFocusNode,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Estoque Inicial',
                                  hintText: 'Ex: 50',
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge,
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                ),
                                style: FlutterFlowTheme.of(context).bodyLarge,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Estoque é obrigatório';
                                  }
                                  if (int.tryParse(val) == null || int.parse(val) < 0) {
                                    return 'Número inteiro positivo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // --- BOTÃO DE SALVAR ---
                        FFButtonWidget(
                          onPressed: _isSaving ? null : () {
                            if (_model.formKey.currentState!.validate()) {
                              _salvarProduto();
                            }
                          },
                          text: _isSaving ? 'Salvando...' : 'Criar Produto',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 48,
                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            color: Color(0xF3FD8E2B), // Cor Laranja/Primária
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.interTight(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(color: Colors.transparent, width: 1),
                            borderRadius: BorderRadius.circular(32), // Borda arredondada
                          ),
                        ),
                        SizedBox(height: 24), // Espaçamento inferior
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}