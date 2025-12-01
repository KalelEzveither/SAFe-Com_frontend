import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'barracas_hortifruti_widget.dart' show BarracasHortifrutiWidget;
import 'package:flutter/material.dart';

class BarracasHortifrutiModel
    extends FlutterFlowModel<BarracasHortifrutiWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
