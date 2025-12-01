import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cadastro_widget.dart' show CadastroWidget;
import 'package:flutter/material.dart';

class CadastroModel extends FlutterFlowModel<CadastroWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  // State field(s) for E-mail widget.
  FocusNode? eMailFocusNode;
  TextEditingController? eMailTextController;
  String? Function(BuildContext, String?)? eMailTextControllerValidator;
  // State field(s) for Senha widget.
  FocusNode? senhaFocusNode1;
  TextEditingController? senhaTextController1;
  late bool senhaVisibility1;
  String? Function(BuildContext, String?)? senhaTextController1Validator;
  // State field(s) for Senha widget.
  FocusNode? senhaFocusNode2;
  TextEditingController? senhaTextController2;
  late bool senhaVisibility2;
  String? Function(BuildContext, String?)? senhaTextController2Validator;

  @override
  void initState(BuildContext context) {
    senhaVisibility1 = false;
    senhaVisibility2 = false;
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    eMailFocusNode?.dispose();
    eMailTextController?.dispose();

    senhaFocusNode1?.dispose();
    senhaTextController1?.dispose();

    senhaFocusNode2?.dispose();
    senhaTextController2?.dispose();
  }
}
