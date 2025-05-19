// screens/main_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_buttom.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String username = args?['username'] ?? 'Usuário';
    final double saldo = 200.50;
    return Scaffold(
      appBar: AppBar(title: const Text('Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Olá, $username!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Saldo: R\$ ${saldo.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            const Text('Ações:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onPressed: () => Navigator.pushNamed(context, '/cotacao'),
                  text: 'Cotação',
                ),
                CustomButton(
                  onPressed: () => Navigator.pushNamed(context, '/transferencia'),
                  text: 'Transferir',
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}