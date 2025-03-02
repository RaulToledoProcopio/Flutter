import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _usuarioPredeterminado = 'UsuarioPrueba';
  final String _contrasenaPredeterminada = '12345';

  void _validarLogin() {
    String usuario = _usuarioController.text;
    String contrasena = _passwordController.text;

    if (usuario == _usuarioPredeterminado &&
        contrasena == _contrasenaPredeterminada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario Logeado'),
          backgroundColor: Colors.green,
        ),
      );
      // Reemplazamos LoginScreen con MainScreen
      Navigator.pushReplacementNamed(context, '/mainScreen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Quitamos el AppBar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Texto "Login" en la parte superior, en blanco
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                    fontSize: 40, // Tamaño del texto
                    fontWeight: FontWeight.bold, // Estilo en negrita
                    letterSpacing: 2.0, // Espaciado entre letras
                  ),
                ),
              ),
              const SizedBox(
                  height: 100), // Para separar el texto de los campos
              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validarLogin,
                child: const Text('Acceder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
