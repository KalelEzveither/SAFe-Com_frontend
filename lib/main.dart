import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'index.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  String getRoute([RouteMatchBase? routeMatch]) {
    final RouteMatchBase lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SAFe-Com',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'FiltroBarracas';
  late Widget? _currentPage;
  
  // Variável para controlar se mostramos a aba do vendedor
  bool _isVendedor = false;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
    
    // Verifica o tipo do usuário ao iniciar
    _checkUserType();
  }

  // Função que busca no SessionService
  Future<void> _checkUserType() async {
    final user = await SessionService.getUser();
    if (user != null && user['tipo'] == 'VENDEDOR') {
      setState(() {
        _isVendedor = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Dicionário de Abas (Comuns a todos)
    final Map<String, Widget> tabs = {
      'FiltroBarracas': FiltroBarracasWidget(),
      'Home': HomeWidget(),
      'Perfil': PerfilWidget(),
    };

    // 2. Lista de Ícones (Comuns a todos)
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: FaIcon(
          FontAwesomeIcons.sistrix,
          size: 24.0,
        ),
        label: 'Busca',
        tooltip: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 24.0,
        ),
        label: 'Home',
        tooltip: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_outline,
          size: 24.0,
        ),
        label: 'Perfil',
        tooltip: '',
      ),
    ];

    // 3. SE FOR VENDEDOR: Adiciona a aba e o ícone extra
    if (_isVendedor) {
      // Adiciona a rota da tela "Meus Produtos" (Dashboard)
      tabs['MeusProdutos'] = MeusProdutosWidget();

      // Adiciona o ícone da lojinha
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.storefront_sharp, // Ícone de loja
            size: 24.0,
          ),
          label: 'Minha Loja',
          tooltip: '',
        ),
      );
    }

    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        // Proteção para não quebrar se o index for -1 (página fora da nav)
        currentIndex: currentIndex != -1 ? currentIndex : 0, 
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: Color(0xFF156F00),
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: items, // Passa a lista dinâmica
      ),
    );
  }
}