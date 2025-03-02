import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Credenciales predeterminadas
  final String _usuarioPredeterminado = 'UsuarioPrueba';
  final String _contrasenaPredeterminada = '12345';

  // Función para validar el login
  void _validarLogin() {
    String usuario = _usuarioController.text;
    String contrasena = _passwordController.text;

    // Comprobar si las credenciales son correctas
    if (usuario == _usuarioPredeterminado &&
        contrasena == _contrasenaPredeterminada) {
      // Mostrar un SnackBar con el mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario Logeado'),
          backgroundColor: Colors.green,
        ),
      );
      // Navegar a MainScreen
      Navigator.pushReplacementNamed(context, '/mainScreen');
    } else {
      // Mostrar un SnackBar con el mensaje de error
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
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
    );
  }
}
