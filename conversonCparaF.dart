import 'package:flutter/material.dart';

void main() {
  runApp(ConversorTemperaturaApp());// Roda app
}

class ConversorTemperaturaApp extends StatelessWidget { // Estrutura principal
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Temperatura',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConversorPage(), // Primeira página a ser exibida
    );
  }
}

// StatefulWidget pois haverá atualizações em tela
class ConversorPage extends StatefulWidget {
  @override
  _ConversorPageState createState() => _ConversorPageState();
}

class _ConversorPageState extends State<ConversorPage> {

  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  //  'build' é usado dentro de uma classe de widget para definir a interface do usuário do widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversor de Temperatura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite a temperatura em Celsius',
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navegarParaResultado(context),
              child: Text('Converter para Fahrenheit'),
            ),
          ],
        ),
      ),
    );
  }

  void _navegarParaResultado(BuildContext context) {
    String input = _controller.text;
    double? celsius = double.tryParse(input);

    // Valida n° digitado
    if (celsius == null) {
      setState(() {
        _errorMessage = 'Por favor, digite um número válido';
      });
    } else {
      setState(() {
        _errorMessage = null;  // Limpa a mensagem de erro
      });
      
      // Calcula resultado, caso o n° seja válido
      double fahrenheit = (celsius * 9 / 5) + 32;
      String resultado = '$celsius °C = $fahrenheit °F';

      Navigator.push(
        context,
        MaterialPageRoute(
          // Navega para a paǵina se resultado passando o resultado como parâmetro
          builder: (context) => ResultadoPage(resultado: resultado), 
        ),
      );
    }
  }


} // Fim class _ConversorPageState

// StatelessWidget pois sempre permanecerá a mesma
// Página que exibe o resultado
class ResultadoPage extends StatelessWidget {
  final String resultado;

  ResultadoPage({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Conversão')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            resultado,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
