// screens/transferencia_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custom_input.dart';
import 'package:flutter/services.dart';

class TransferenciaScreen extends StatefulWidget {
  final Map<String, dynamic>? transferData;
  const TransferenciaScreen({super.key, this.transferData});

  @override
  State<TransferenciaScreen> createState() => _TransferenciaScreenState();
}
class _TransferenciaScreenState extends State<TransferenciaScreen> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _destinatarioController = TextEditingController();
  final TextEditingController _contaController = TextEditingController();
  final double _saldo = 1500.00;

  Future<void> _showTransferConfirmation(BuildContext context, double valor, String destinatario, String conta) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Dinheiro transferido!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Valor: R\$ ${valor.toStringAsFixed(2)}'),
                Text('Para: $destinatario (Celular: $conta)'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  '/transferencia_args',
                  arguments: {
                    'valor': valor,
                    'destinatario': destinatario,
                    'conta': conta,
                  },
                );
                _valorController.clear();
                _destinatarioController.clear();
                _contaController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSaldoInsuficienteAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 60),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Saldo Insuficiente!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('O valor da transferência é maior que o seu saldo disponível.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo de erro
              },
            ),
          ],
        );
      },
    );
  }
  void _transferir(BuildContext context) {
    if (_valorController.text.isNotEmpty &&
        _destinatarioController.text.isNotEmpty &&
        _contaController.text.isNotEmpty) {
      final valor = double.tryParse(_valorController.text);
      final destinatario = _destinatarioController.text;
      final conta = _contaController.text;

      if (valor != null && valor > 0) {
        if (valor > _saldo) {
          _showSaldoInsuficienteAlert(context);
        } else {
          _showTransferConfirmation(context, valor, destinatario, conta);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor,insira um valor válido para a transferência.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor,preencha todos os campos da transferência.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final transferInfo = widget.transferData;

    return Scaffold(
      appBar: AppBar(title: const Text('Transferência')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (transferInfo != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transferência Confirmada:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Valor: R\$ ${transferInfo['valor']?.toStringAsFixed(2)}'),
                  Text('Destinatário: ${transferInfo['destinatario']}'),
                  Text('Celular: ${transferInfo['conta']}'),
                  const SizedBox(height: 20),
                ],
              ),
            const Text('Dados da Transferência:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CustomInput(controller: _valorController, labelText: 'Valor a Transferir (R\$)', keyboardType: TextInputType.number, validator: (value) {  },),
            const SizedBox(height: 10),
            CustomInput(controller: _destinatarioController, labelText: 'Nome do Destinatário', validator: (value) {  },),
            const SizedBox(height: 10),
            CustomInput(
              controller: _contaController,
              labelText: 'Celular do Destinatário',
              keyboardType: TextInputType.phone, // Mantendo o teclado numérico
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Mantendo a restrição de dígitos
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O celular do destinatário é obrigatório.';
                }
                if (value.length < 10 || value.length > 11) {
                  return 'Por favor, insira um número de celular válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomButton(onPressed: () => _transferir(context), text: 'Transferir'),
          ],
        ),
      ),
    );
  }
}