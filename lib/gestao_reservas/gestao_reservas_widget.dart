import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gestao_reservas_model.dart';

// IMPORTS NECESSÁRIOS
import '../services/order_service.dart';
import '../services/session_service.dart';
import '../services/barraca_service.dart';
import '../model/barraca_model.dart';

export 'gestao_reservas_model.dart';

class GestaoReservasWidget extends StatefulWidget {
  const GestaoReservasWidget({super.key});

  // Definindo as rotas corretamente para o nav.dart não reclamar
  static String routeName = 'gestao_Reservas';
  static String routePath = '/gestaoReservas';

  @override
  State<GestaoReservasWidget> createState() => _GestaoReservasWidgetState();
}

class _GestaoReservasWidgetState extends State<GestaoReservasWidget> {
  late GestaoReservasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Variável para a lista de pedidos
  Future<List<dynamic>>? _pedidosFuture;
  bool _isLoadingBarraca = true;
  Barraca? _minhaBarraca;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GestaoReservasModel());
    _carregarDados();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- LÓGICA "DIREITA" ---
  Future<void> _carregarDados() async {
    setState(() => _isLoadingBarraca = true);

    // 1. Pega o usuário logado
    final user = await SessionService.getUser();
    
    if (user != null && user['id'] != null) {
      // 2. Pergunta pro Backend: "Qual a barraca desse usuário?"
      final barraca = await BarracaService().getBarracaPeloUsuario(user['id']);
      
      if (mounted) {
        setState(() {
          _minhaBarraca = barraca;
          _isLoadingBarraca = false;
        });

        // 3. Se achou a barraca, busca os pedidos dela
        if (barraca != null) {
          _atualizarListaPedidos();
        }
      }
    } else {
      // Não tá logado? Manda pro login ou mostra erro
      setState(() => _isLoadingBarraca = false);
    }
  }

  void _atualizarListaPedidos() {
    if (_minhaBarraca != null) {
      setState(() {
        _pedidosFuture = OrderService().getPedidosDaMinhaBarraca(_minhaBarraca!.id);
      });
    }
  }

  void _mudarStatus(int idPedido, String novoStatus) async {
    bool sucesso = await OrderService().atualizarStatus(idPedido, novoStatus);
    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status atualizado!"), backgroundColor: Color(0xFF156F00)),
      );
      _atualizarListaPedidos(); // Recarrega a lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar status."), backgroundColor: Colors.red),
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
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF156F00), size: 30.0),
            onPressed: () async { context.safePop(); },
          ),
          centerTitle: true,
          title: Text(
            'Pedidos Recebidos',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(),
                  color: Color(0xFF156F00),
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _isLoadingBarraca
              ? Center(child: CircularProgressIndicator(color: Color(0xFF156F00)))
              : _minhaBarraca == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store_outlined, size: 60, color: Colors.grey),
                          Text("Você ainda não possui uma barraca cadastrada."),
                          // Aqui poderia ter um botão "Criar Barraca"
                        ],
                      ),
                    )
                  : FutureBuilder<List<dynamic>>(
                      future: _pedidosFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: Color(0xFF156F00)));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("Nenhum pedido recebido ainda."));
                        }

                        final pedidos = snapshot.data!;

                        return ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: pedidos.length,
                          itemBuilder: (context, index) {
                            final p = pedidos[index];
                            // p['status'], p['nomeOutraParte'] (Nome do Cliente), p['valorTotal']

                            return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Cabeçalho do Card
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Pedido #${p['id']}",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: p['status'] == 'CONCLUIDO' ? Colors.green : Colors.orange,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            p['status'],
                                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    
                                    // Info do Cliente
                                    Text(
                                      "Cliente: ${p['nomeOutraParte']}",
                                      style: TextStyle(fontSize: 14, color: Colors.black87),
                                    ),
                                    SizedBox(height: 4),
                                    
                                    // Itens
                                    Text(
                                      p['resumoItens'], 
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                    SizedBox(height: 8),
                                    
                                    // Total e Ações
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total: R\$ ${p['valorTotal']}",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF156F00), fontSize: 16),
                                        ),
                                        
                                        // Botão de Ação (Só aparece se não estiver concluído)
                                        if (p['status'] != 'CONCLUIDO' && p['status'] != 'CANCELADO')
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF156F00),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            onPressed: () => _mudarStatus(p['id'], 'CONCLUIDO'),
                                            child: Text("Entregar", style: TextStyle(color: Colors.white)),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ),
      ),
    );
  }
}