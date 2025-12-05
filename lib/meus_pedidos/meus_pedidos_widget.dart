import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meus_pedidos_model.dart';
import '../services/order_service.dart'; // Importe o serviço

export 'meus_pedidos_model.dart';

class MeusPedidosWidget extends StatefulWidget {
  const MeusPedidosWidget({super.key});

  static String routeName = 'meus_Pedidos';
  static String routePath = '/meusPedidos';

  @override
  State<MeusPedidosWidget> createState() => _MeusPedidosWidgetState();
}

class _MeusPedidosWidgetState extends State<MeusPedidosWidget> {
  late MeusPedidosModel _model;
  late Future<List<dynamic>> _pedidosFuture; // Variável para os pedidos

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeusPedidosModel());
    // Inicia a busca dos pedidos ao abrir a tela
    _pedidosFuture = OrderService().getMeusPedidos();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Função auxiliar para cor do status
  Color _getStatusColor(String status) {
    if (status == 'CONCLUIDO') return Color(0xFF156F00); // Verde
    if (status == 'CANCELADO') return Colors.red;
    return Color(0xF3FD8E2B); // Laranja (Pendente/Aguardando)
  }

  String _getStatusText(String status) {
    if (status == 'AGUARDANDO_RETIRADA') return 'Aguardando';
    if (status == 'AGUARDANDO_PAGAMENTO') return 'Pagar';
    return status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
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
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF156F00),
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: Text(
                    'Meus Pedidos',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                          ),
                          color: Color(0xFF14181B), // Cor escura para contraste
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                  child: Text(
                    'Veja abaixo seus pedidos recentes',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).labelMedium,
                  ),
                ),
                
                // AQUI ENTRA A LISTA DINÂMICA
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                  child: FutureBuilder<List<dynamic>>(
                    future: _pedidosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: Color(0xFF156F00)),
                          ),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return Center(child: Text("Erro ao carregar pedidos."));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                                Text("Você ainda não tem pedidos.", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      }

                      final pedidos = snapshot.data!;

                      return Column(
                        children: List.generate(pedidos.length, (index) {
                          final p = pedidos[index];
                          
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 570),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Coluna Esquerda (Info)
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // ID e Data
                                            Row(
                                              children: [
                                                Text(
                                                  'Pedido #${p['id']}',
                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 15,
                                                      ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  // Formata data se quiser (ex: p['dataPedido'])
                                                  '', 
                                                  style: FlutterFlowTheme.of(context).labelSmall,
                                                ),
                                              ],
                                            ),
                                            
                                            // Nome da Barraca
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                              child: Text(
                                                p['nomeOutraParte'], // Nome da Barraca vem aqui
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                                                      color: Color(0xFF156F00),
                                                    ),
                                              ),
                                            ),

                                            // Resumo dos Itens
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                              child: Text(
                                                p['resumoItens'], // "2x Pastel, 1x Coca"
                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                      font: GoogleFonts.inter(),
                                                      fontSize: 13,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Coluna Direita (Valor e Status)
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                          child: Text(
                                            'R\$ ${p['valorTotal'].toString().replaceAll('.', ',')}',
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                  color: Color(0xFF156F00),
                                                  fontSize: 18,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          height: 32,
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(p['status']),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            _getStatusText(p['status']),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}