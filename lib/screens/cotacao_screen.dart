// screens/cotacao_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  State<CotacaoScreen> createState() => _CotacaoScreenState();
}

class _CotacaoScreenState extends State<CotacaoScreen> {
  Map<String, double> _cotacoes = {};
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _getCotacoes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiUrl = 'https://api.hgbrasil.com/finance?format=json-cors&key=1a582a9f';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results']['currencies'] != null) {
          final currencies = data['results']['currencies'];
          setState(() {
            _cotacoes = {
              'USD': currencies['USD']['buy'] as double? ?? 0.0,
              'EUR': currencies['EUR']['buy'] as double? ?? 0.0,
            };
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Estrutura da API inválida.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Erro ao carregar as cotações: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erro de conexão: $error';
        _isLoading = false;
      });
    }
  }

  void _compartilharCotacoes() {
    if (_cotacoes.isNotEmpty) {
      String textToShare = 'Cotações (em relação ao BRL):\n';
      _cotacoes.forEach((key, value) {
        textToShare += '$key: ${value.toStringAsFixed(2)}\n';
      });
      Share.share(textToShare);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As cotações ainda não foram carregadas.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banco Digital - Cotação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Cotações (em relação ao BRL):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Dólar Americano (USD): ${_cotacoes['USD']?.toStringAsFixed(2) ?? 'Carregando...'}'),
            Text('Euro (EUR): ${_cotacoes['EUR']?.toStringAsFixed(2) ?? 'Carregando...'}'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _getCotacoes, child: const Text('Atualizar Cotações')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _compartilharCotacoes, child: const Text('Compartilhar Cotações')),
          ],
        ),
      ),
    );
  }
}