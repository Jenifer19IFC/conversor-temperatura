import 'package:flutter/material.dart';

void main() {
  runApp(ConversorTemperaturaApp());
}

// Widget principal da aplicação, configura o MaterialApp e define a tela inicial
class ConversorTemperaturaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Temperatura',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home: SplashScreen(), // Tela inicial é o SplashScreen
    );
  }
}

// Tela de splash, exibida ao iniciar o app
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Animação inicial da tela splash
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isExpanded = true;
      });
    });

    // Navegação automática para a próxima tela após 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ConversorPage(), // PRÓXIMA TELA
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: AnimatedContainer(
          // Animação para aumentar o tamanho do ícone
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          width: _isExpanded ? 150 : 100,
          height: _isExpanded ? 150 : 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.thermostat_outlined,
            size: 80,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

// CONVERSOR DE TEMPERATURA EM SI
class ConversorPage extends StatefulWidget {
  @override
  _ConversorPageState createState() => _ConversorPageState();
}

class _ConversorPageState extends State<ConversorPage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Temperatura'),
        centerTitle: true, // Centraliza título
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              // Campo para o usuário inserir a temperatura em Celsius
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite a temperatura em Celsius',
                labelStyle: TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorText: _errorMessage, // Exibe erro de validação(se necessário)
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.withOpacity(0.7),
                      ),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    ),
                  )
                : ElevatedButton(
                    // Botão para conversão
                    onPressed: () => _navegarParaResultado(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Converter para Fahrenheit',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

 // Valida a entrada do usuário e faz a conversão
  void _navegarParaResultado(BuildContext context) async {
    String input = _controller.text;
    double? celsius = double.tryParse(input);

    if (celsius == null) {
      setState(() {
        _errorMessage = 'Por favor, digite um número válido';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulação de processamento

    double fahrenheit = (celsius * 9 / 5) + 32;
    String mensagem = _avaliarTemperatura(celsius);

    setState(() {
      _isLoading = false;
    });

    // Navegação para a tela de resultado
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ResultadoPage(
                resultado: '$celsius °C = $fahrenheit °F', mensagem: mensagem),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var inicio = Offset(1.0, 0.0);
          var fim = Offset.zero;
          var curva = Curves.ease;

          var tween =
              Tween(begin: inicio, end: fim).chain(CurveTween(curve: curva));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // Avalia a temperatura em Celsius e retorna uma mensagem casual
  String _avaliarTemperatura(double celsius) {
    if (celsius < 10) {
      return "Está frio! Vista um casaco.";
    } else if (celsius >= 10 && celsius <= 25) {
      return "A temperatura está agradável.";
    } else {
      return "Está quente! Lembre-se de se hidratar.";
    }
  }
}

// Tela que exibe o resultado da conversão
class ResultadoPage extends StatelessWidget {
  final String resultado;
  final String mensagem;

  ResultadoPage({required this.resultado, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado da Conversão'),
        centerTitle: true, // Centraliza o título
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exibe o resultado da conversão de temperatura
              Text(
                resultado,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Exibe mensagem casual
              Text(
                mensagem,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                // Botão para volta para a tela anterior
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                ),
                child: Text(
                  'Voltar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
