import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final darkMode =
      await StorageService.carregarTema();

  runApp(
    AbastecimentosApp(
      initialDarkMode: darkMode,
    ),
  );
}

class AbastecimentosApp extends StatefulWidget {
  final bool initialDarkMode;

  const AbastecimentosApp({
    super.key,
    required this.initialDarkMode,
  });

  @override
  State<AbastecimentosApp> createState() =>
      _AbastecimentosAppState();
}

class _AbastecimentosAppState
    extends State<AbastecimentosApp> {

  late bool darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = widget.initialDarkMode;
  }

  Future<void> alterarTema(bool valor) async {
    await StorageService.salvarTema(valor);

    setState(() {
      darkMode = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Abastecimentos',

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      themeMode: darkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      home: SplashScreen(
        darkMode: darkMode,
        onThemeChanged: alterarTema,
      ),
    );
  }
}