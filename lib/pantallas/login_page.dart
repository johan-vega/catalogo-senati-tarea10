import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onIngresar});

  final VoidCallback onIngresar;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formulario = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  bool _credencialesIncorrectas = false;

  @override
  void dispose() {
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (!_formulario.currentState!.validate()) return;

    // Credenciales de la demostración. La comparación se ejecuta en el
    // navegador y las credenciales forman parte del código compilado.
    if (_usuario.text.trim() == 'senatino' && _contrasena.text == 'guapo') {
      widget.onIngresar();
      return;
    }

    setState(() => _credencialesIncorrectas = true);
  }

  void _limpiarError(String _) {
    if (_credencialesIncorrectas) {
      setState(() => _credencialesIncorrectas = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo SENATI')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: tema.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formulario,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: tema.colorScheme.primaryContainer,
                            foregroundColor:
                                tema.colorScheme.onPrimaryContainer,
                            child: const Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Iniciar sesión',
                          style: tema.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Ingresa tus credenciales para abrir el catálogo.',
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usuario,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          onChanged: _limpiarError,
                          validator: (valor) => (valor ?? '').trim().isEmpty
                              ? 'Escribe el usuario.'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _contrasena,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          onChanged: _limpiarError,
                          onFieldSubmitted: (_) => _ingresar(),
                          validator: (valor) => (valor ?? '').isEmpty
                              ? 'Escribe la contraseña.'
                              : null,
                        ),
                        if (_credencialesIncorrectas) ...[
                          const SizedBox(height: 12),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              'Usuario o contraseña incorrectos.',
                              style: TextStyle(color: tema.colorScheme.error),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _ingresar,
                          child: const Text('Ingresar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
