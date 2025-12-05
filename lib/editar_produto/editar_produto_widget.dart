import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // Import necessário para TextCapitalization

import 'editar_produto_model.dart';
export 'editar_produto_model.dart';

import '../model/produto_model.dart'; 
import '../services/produto_service.dart';

class EditarProdutoWidget extends StatefulWidget {
  final Produto produto; // Recebe o produto para editar

  const EditarProdutoWidget({
    super.key,
    required this.produto,
  });

  static String routeName = 'editar_Produto';
  static String routePath = '/editarProduto';

  @override
  State<EditarProdutoWidget> createState() => _EditarProdutoWidgetState();
}

class _EditarProdutoWidgetState extends State<EditarProdutoWidget> {
  late EditarProdutoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  // Variáveis para corresponder ao estilo do CadastroBarracaWidget
  late TextEditingController _nomeController;
  late FocusNode _nomeFocusNode;
  late TextEditingController _precoController;
  late FocusNode _precoFocusNode;
  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocusNode;
  late FormFieldController<List<String>> _choiceChipsController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditarProdutoModel());

    // Inicialização dos TextControllers e FocusNodes
    _nomeController = TextEditingController(text: widget.produto.nome);
    _nomeFocusNode = FocusNode();
    
    // Inicialização do campo Preço
    _precoController = TextEditingController(
        text: widget.produto.preco.toStringAsFixed(2).replaceAll('.', ','));
    _precoFocusNode = FocusNode();

    // Inicialização do campo Descrição
    _descriptionController = TextEditingController(text: widget.produto.descricao);
    _descriptionFocusNode = FocusNode();

    // Inicialização do ChoiceChipsController com a categoria atual
    _choiceChipsController = FormFieldController<List<String>>(
      [widget.produto.categoria], // Adicionado fallback para categoria
    );
    _model.choiceChipsValue = widget.produto.categoria;
  }

  @override
  void dispose() {
    _model.dispose();
    _nomeController.dispose();
    _nomeFocusNode.dispose();
    _precoController.dispose();
    _precoFocusNode.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  // Lógica de Atualizar Inalterada
  Future<void> _atualizarProduto() async {
    setState(() => _isSaving = true);

    if (!_model.formKey.currentState!.validate()) {
        setState(() => _isSaving = false);
        return;
    }

    double preco = double.tryParse(
        _precoController.text.replaceAll(',', '.').trim()) ??
        widget.produto.preco;

    Produto produtoAtualizado = Produto(
      id: widget.produto.id,
      nome: _nomeController.text,
      descricao: _descriptionController.text,
      preco: preco,
      imagemUrl: widget.produto.imagemUrl,
      categoria: _choiceChipsController.value?.firstOrNull ?? widget.produto.categoria,
      quantidadeEstoque: widget.produto.quantidadeEstoque,
      barracaId: widget.produto.barracaId,
    );

    // Simulação do Serviço (mantenha a sua lógica real aqui)
    bool sucesso = await ProdutoService().atualizarProduto(produtoAtualizado);

    if (mounted) {
      setState(() => _isSaving = false);
      if (sucesso) {
        // Usa o FlutterFlowTheme para cores
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Atualizado com sucesso!"),
          backgroundColor: FlutterFlowTheme.of(context).primary, // Cor verde/primária
        ));
        context.safePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao atualizar."),
          backgroundColor: FlutterFlowTheme.of(context).error, // Cor de erro
        ));
      }
    }
  }

  // Lógica de Deletar Inalterada
  Future<void> _deletarProduto() async {
    var confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Excluir Produto"),
        content: Text("Tem certeza que deseja remover este item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar", style: TextStyle(color: FlutterFlowTheme.of(context).primaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir", style: TextStyle(color: FlutterFlowTheme.of(context).error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Simulação do Serviço (mantenha a sua lógica real aqui)
      bool sucesso = await ProdutoService().deletarProduto(widget.produto.id);
      if (sucesso && mounted) {
        context.safePop();
      } else if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao excluir."),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Decodifica imagem se tiver
    ImageProvider? imagemProvider;
    if (widget.produto.imagemUrl.isNotEmpty) {
      try {
        imagemProvider = MemoryImage(base64Decode(widget.produto.imagemUrl));
      } catch (e) {
        // Fallback
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        // Cor de fundo copiada do CadastroBarracaWidget
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground, 
        appBar: AppBar(
          // Cor de fundo copiada do CadastroBarracaWidget
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Produto', // Título alterado
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              Text(
                'Altere as informações do seu produto', // Subtítulo alterado
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ].divide(SizedBox(height: 4)),
          ),
          actions: [
            // Botão de Excluir (Mantido com Ícone e Ação original)
            IconButton(
              icon: Icon(Icons.delete_outline, color: FlutterFlowTheme.of(context).secondaryText, size: 24),
              onPressed: _deletarProduto,
              tooltip: 'Excluir Produto',
            ),
            // Botão de Fechar/Voltar (Adicionado para seguir o padrão do CadastroBarraca)
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
                  color: Color(0xFF156F00),
                  size: 24,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
            ),
          ],
          centerTitle: false, // Alterado para false para alinhar o título
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Align(
              alignment: AlignmentDirectional(0, -1),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 770, // Mantido para dispositivos maiores
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- VISUALIZAÇÃO DA IMAGEM ---
                      // Adaptação da área de upload de imagem para visualização
                      Container(
                        width: double.infinity,
                        height: 330, // Aumentado para corresponder ao estilo do CadastroBarraca
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                          image: imagemProvider != null 
                              ? DecorationImage(image: imagemProvider, fit: BoxFit.cover) 
                              : null,
                        ),
                        child: imagemProvider == null 
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 64, color: FlutterFlowTheme.of(context).secondaryText),
                                    Text('Imagem do Produto', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: FlutterFlowTheme.of(context).secondaryText)),
                                    // Adicione um botão para "Alterar Imagem" aqui se quiser
                                  ],
                                ),
                              ) 
                            : null,
                      ),
                      
                      SizedBox(height: 12),
                      
                      // --- FORMULÁRIO ---
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // 1. Campo Nome
                            TextFormField(
                              controller: _nomeController,
                              focusNode: _nomeFocusNode,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Nome do Produto',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                              ),
                              style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                letterSpacing: 0.0,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'O nome é obrigatório';
                                }
                                return null;
                              },
                              inputFormatters: [
                                // Adiciona o filtro de capitalização
                                if (!isAndroid && !isiOS)
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      return TextEditingValue(
                                        selection: newValue.selection,
                                        text: newValue.text.toCapitalization(TextCapitalization.words),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            
                            SizedBox(height: 12),

                            // 2. Campo Preço
                            TextFormField(
                              controller: _precoController,
                              focusNode: _precoFocusNode,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Preço (R\$)',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                hintText: 'Ex: 10,50',
                                hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                              ),
                              style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                letterSpacing: 0.0,
                              ),
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

                            SizedBox(height: 12),
                            
                            // 3. Choice Chips para Categoria
                            Text(
                              'Categoria do Produto',
                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 8),

                            FlutterFlowChoiceChips(
                              options: [
                                ChipData('Hortifruti'), 
                                ChipData('Doces'), 
                                ChipData('Temperos'), 
                                ChipData('Artesanato'), 
                                ChipData('Salgados')
                              ],
                              onChanged: (val) => safeSetState(() => _model.choiceChipsValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                iconColor: Colors.white,
                                elevation: 0,
                                borderColor: FlutterFlowTheme.of(context).primary,
                                borderWidth: 2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                iconColor: FlutterFlowTheme.of(context).secondaryText,
                                elevation: 0,
                                borderColor: FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              controller: _choiceChipsController,
                              chipSpacing: 8,
                              rowSpacing: 8,
                              multiselect: false, // Mantido como single-select
                              alignment: WrapAlignment.start,
                              wrapped: true,
                            ),

                            SizedBox(height: 12),

                            // 4. Campo Descrição
                            TextFormField(
                              controller: _descriptionController,
                              focusNode: _descriptionFocusNode,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Descrição do Produto...',
                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                              ),
                              style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                letterSpacing: 0.0,
                              ),
                              maxLines: 5, // Ajustado para corresponder ao layout
                              minLines: 3,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'A descrição é obrigatória';
                                }
                                return null;
                              },
                              inputFormatters: [
                                // Adiciona o filtro de capitalização
                                if (!isAndroid && !isiOS)
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      return TextEditingValue(
                                        selection: newValue.selection,
                                        text: newValue.text.toCapitalization(TextCapitalization.words),
                                      );
                                    },
                                  ),
                              ],
                            ),

                            SizedBox(height: 32),

                            // 5. Botão Salvar Alterações
                            FFButtonWidget(
                              onPressed: _isSaving ? null : () async {
                                if (_model.formKey.currentState!.validate()) {
                                  await _atualizarProduto();
                                }
                              },
                              text: _isSaving ? 'Salvando...' : 'Salvar Alterações',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48, // Altura ajustada
                                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                // Cor copiada do botão Cadastrar Barraca (Laranja)
                                color: Color(0xF3FD8E2B), 
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      font: GoogleFonts.interTight(),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(32), // Borda ajustada
                              ),
                            ),
                          ].divide(SizedBox(height: 12)),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)), // Espaçamento entre os blocos
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