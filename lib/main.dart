import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'modelos/componente.dart';
import 'pantallas/catalogo_page.dart';
import 'pantallas/detalle_page.dart';
import 'pantallas/login_page.dart';
import 'rutas.dart';

// Punto de entrada en navegador y en los dispositivos móviles compatibles.
void main() => runApp(const CatalogoApp());

class CatalogoApp extends StatefulWidget {
  const CatalogoApp({super.key});

  @override
  State<CatalogoApp> createState() => _CatalogoAppState();
}

class _CatalogoAppState extends State<CatalogoApp> {
  // La autorización se guarda en memoria. Recargar vuelve a pedir el acceso.
  bool _sesionIniciada = false;

  Route<void> _abrirLogin() => MaterialPageRoute<void>(
    settings: const RouteSettings(name: rutaLogin),
    builder: (context) => LoginPage(
      onIngresar: () {
        if (_sesionIniciada) return;
        _sesionIniciada = true;
        // Se limpia el historial interno para retirar el formulario del stack.
        Navigator.of(context)
            .pushNamedAndRemoveUntil<void>(rutaCatalogo, (_) => false);
      },
    ),
  );

  Route<void> _generarRuta(RouteSettings settings) {
    // El navegador puede pedir una ruta directamente desde la barra de URL.
    if (!_sesionIniciada) return _abrirLogin();

    final componente = settings.arguments;
    if (settings.name == rutaDetalle && componente is Componente) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DetallePage(componente: componente),
      );
    }
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: rutaCatalogo),
      builder: (_) => const CatalogoPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colores = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B4D8B),
      primary: const Color(0xFF0B4D8B),
      surface: const Color(0xFFF4F7FC),
    );

    return MaterialApp(
      title: 'Catálogo SENATI',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colores,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF08315B),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: rutaLogin,
      onGenerateInitialRoutes: (_) => [_abrirLogin()],
      onGenerateRoute: _generarRuta,
    );
  }
}
