import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'cadastro_barraca_widget.dart' show CadastroBarracaWidget;
import 'package:flutter/material.dart';

class CadastroBarracaModel extends FlutterFlowModel<CadastroBarracaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadData3yb = false;
  FFUploadedFile uploadedLocalFile_uploadData3yb =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for nomeProd widget.
  FocusNode? nomeProdFocusNode;
  TextEditingController? nomeProdTextController;
  String? Function(BuildContext, String?)? nomeProdTextControllerValidator;
  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // State field(s) for hora widget.
  FocusNode? horaFocusNode;
  TextEditingController? horaTextController;
  String? Function(BuildContext, String?)? horaTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeProdFocusNode?.dispose();
    nomeProdTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    horaFocusNode?.dispose();
    horaTextController?.dispose();
  }
}
