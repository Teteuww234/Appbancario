// screens/login_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    // Simulação de login (sem autenticação real)
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/main',
          arguments: {'username': _emailController.text.split('@').first});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bem-vindo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomInput(controller: _emailController, labelText: 'Email ou Usuário', validator: (value) {
              return null;
              },),
            const SizedBox(height: 10),
            CustomInput(controller: _passwordController, labelText: 'Senha', obscureText: true, validator: (value) {
              return null;
              },),
            const SizedBox(height: 20),
            CustomButton(onPressed: () => _login(context), text: 'Entrar'),
          ],
        ),
      ),
    );
  }
}