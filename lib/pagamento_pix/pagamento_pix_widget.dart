import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pagamento_pix_model.dart';

// Imports da Lógica
import '../model/cart_item_model.dart';
import '../services/order_service.dart';

export 'pagamento_pix_model.dart';

class PagamentoPixWidget extends StatefulWidget {
  // Recebe os dados do Carrinho
  final double valorTotal;
  final List<CartItem> itens;

  const PagamentoPixWidget({
    super.key,
    required this.valorTotal,
    required this.itens,
  });

  static String routeName = 'pagamento_Pix';
  static String routePath = '/pagamentoPix';

  @override
  State<PagamentoPixWidget> createState() => _PagamentoPixWidgetState();
}

class _PagamentoPixWidgetState extends State<PagamentoPixWidget> {
  late PagamentoPixModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false; // Para travar o botão enquanto salva

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentoPixModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Lógica de Finalizar Pedido
  Future<void> _confirmarReserva() async {
    setState(() => _isProcessing = true);

    final result = await OrderService().finalizarPedido("PIX", "RETIRADA");

    setState(() => _isProcessing = false);

    if (result['success']) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Sucesso!'),
            content: Text('Sua reserva foi realizada. Aguarde a confirmação.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(alertDialogContext);
                  context.goNamed('Home'); // Volta para o início
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
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
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: Color(0xFFF1F4F8),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20,
            buttonSize: 40,
            icon: Icon(Icons.arrow_back, color: Color(0xFF156F00), size: 24),
            onPressed: () async { context.safePop(); },
          ),
          title: Text(
            'Pagamento via PIX',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  color: Color(0xFF156F00),
                  fontSize: 24,
                ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // --- CARTÃO DO RESUMO (LISTA DINÂMICA) ---
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resumo do Pedido',
                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                        color: Color(0xFF14181B),
                                        fontSize: 20,
                                      ),
                                ),
                                Icon(Icons.shopping_cart, color: Color(0xFF156F00), size: 24),
                              ],
                            ),
                            Divider(height: 1, thickness: 1, color: Color(0xFFE0E3E7)),
                            
                            // LISTA DE ITENS
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: widget.itens.length, // Usa a lista real
                              itemBuilder: (context, index) {
                                final item = widget.itens[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.nomeProduto,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                                                    color: Color(0xFF14181B),
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Text(
                                              'Qty: ${item.quantidade}',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    font: GoogleFonts.readexPro(),
                                                    color: Color(0xFF57636C),
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                                              color: Color(0xFF156F00),
                                              fontSize: 14,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            
                            Divider(height: 1, thickness: 2, color: Color(0xFF156F00)),
                            
                            // TOTAL
                            Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                          font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                                          color: Color(0xFF156F00),
                                        ),
                                  ),
                                  Text(
                                    'R\$ ${widget.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                          font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                                          color: Color(0xFF156F00),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                    ),
                  ),

                  // --- ÁREA DO PIX (QR CODE) ---
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Pagamento via PIX',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    color: Color(0xFF14181B),
                                    fontSize: 20,
                                  ),
                            ),
                            Text(
                              'Escaneie o QR Code abaixo para efetuar o pagamento',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.readexPro(),
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                  ),
                            ),
                            // QR CODE
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F4F8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFFE0E3E7), width: 2),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Image.network(
                                    'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=00020126330014BR.GOV.BCB.PIX0114+557799999999952040000530398654041.005802BR5913SafeCom%20Teste6008Brasilia62070503***6304ABCD', // QR Code Fictício funcional
                                    width: 220,
                                    height: 220,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // COPIA E COLA
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0x77156F00),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'QR Code copia e cola:',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                                                    color: Color(0xFF14181B),
                                                  ),
                                            ),
                                            Text(
                                              '00020126330014BR.GOV.BCB.PIX...',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                                                    color: Color(0xFF14181B),
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      FlutterFlowIconButton(
                                        borderRadius: 8,
                                        buttonSize: 32,
                                        fillColor: Color(0xFF156F00),
                                        icon: Icon(Icons.content_copy, color: Color(0xFFF1F4F8), size: 16),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copiado!")));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16)),
                        ),
                      ),
                    ),
                  ),

                  // --- BOTÕES DE AÇÃO ---
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Adicionei padding para não grudar
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // BOTÃO CONFIRMAR (Substituí o "Compartilhar")
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: _isProcessing 
                                ? null 
                                : () async {
                                    await _confirmarReserva();
                                  },
                            text: _isProcessing ? 'Processando...' : 'Confirmar Pagamento',
                            icon: Icon(Icons.check_circle_outline, size: 20),
                            options: FFButtonOptions(
                              height: 48,
                              color: Color(0xFF156F00),
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                                    color: Colors.white,
                                  ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // BOTÃO CANCELAR
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: () {
                              context.safePop();
                            },
                            text: 'Cancelar',
                            options: FFButtonOptions(
                              height: 48,
                              color: Colors.white,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.readexPro(fontWeight: FontWeight.w500),
                                    color: Color(0xFF57636C),
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(color: Color(0xFFE0E3E7), width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24), // Espaço final
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}