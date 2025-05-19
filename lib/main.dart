import 'package:flutter/material.dart';
import 'package:appbancario/screens/cotacao_screen.dart';
import 'package:appbancario/screens/login_screen.dart';
import 'package:appbancario/screens/main_screen.dart';
import 'package:appbancario/screens/transferencia_screen.dart';

void main() async {
  runApp(const BancoDigitalApp());
}
class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Digital',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/cotacao': (context) => const CotacaoScreen(),
        '/transferencia': (context) => const TransferenciaScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/transferencia_args') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => TransferenciaScreen(transferData: args),
          );
        }
        return null;
      },
    );
  }
}







