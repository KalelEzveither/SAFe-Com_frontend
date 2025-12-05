import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cadastro_feirante_widget.dart' show CadastroFeiranteWidget;
import 'package:flutter/material.dart';

class CadastroFeiranteModel extends FlutterFlowModel<CadastroFeiranteWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  // State field(s) for CPF widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  // State field(s) for Celular widget.
  FocusNode? celularFocusNode;
  TextEditingController? celularTextController;
  String? Function(BuildContext, String?)? celularTextControllerValidator;
  // State field(s) for E-mail widget.
  FocusNode? eMailFocusNode;
  TextEditingController? eMailTextController;
  String? Function(BuildContext, String?)? eMailTextControllerValidator;
  // State field(s) for senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;
  // State field(s) for ConfirmarSenha widget.
  FocusNode? confirmarSenhaFocusNode;
  TextEditingController? confirmarSenhaTextController;
  late bool confirmarSenhaVisibility;
  String? Function(BuildContext, String?)?
      confirmarSenhaTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    senhaVisibility = false;
    confirmarSenhaVisibility = false;
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    celularFocusNode?.dispose();
    celularTextController?.dispose();

    eMailFocusNode?.dispose();
    eMailTextController?.dispose();

    senhaFocusNode?.dispose();
    senhaTextController?.dispose();

    confirmarSenhaFocusNode?.dispose();
    confirmarSenhaTextController?.dispose();
  }
}
