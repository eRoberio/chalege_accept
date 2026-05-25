import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Novos controladores para o cadastro
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLogin = true;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        // Fluxo de Login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Validação extra para cadastro
        if (_nameController.text.trim().isEmpty ||
            _phoneController.text.trim().isEmpty) {
          setState(() {
            _error = "Preencha todos os campos obrigatórios.";
            _loading = false;
          });
          return;
        }

        // Fluxo de Cadastro
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Criação do documento do usuário na coleção 'users'
        if (cred.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .set({
            'uid': cred.user!.uid,
            'nome': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'telefone': _phoneController.text.trim(),
            'endereco': _addressController.text.trim(),
            'role': 'cliente', // Por padrão, todo novo cadastro é cliente
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = "Erro inesperado: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showRecuperarSenhaModal() {
    final emailRecoveryController =
        TextEditingController(text: _emailController.text);
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: 600),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final colorScheme = Theme.of(context).colorScheme;

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  Icon(Icons.lock_reset, size: 48, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Recuperar Senha',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary)),
                  const SizedBox(height: 8),
                  const Text(
                      'Digite seu e-mail abaixo. Enviaremos um link para redefinir sua senha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailRecoveryController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail cadastrado',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            final email = emailRecoveryController.text.trim();
                            if (email.isEmpty) return;
                            setModalState(() => isSending = true);
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: const Text('E-mail enviado!'),
                                        backgroundColor:
                                            Colors.green.shade700));
                              }
                            } catch (e) {
                              if (mounted)
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Erro ao enviar e-mail.'),
                                        backgroundColor: Colors.red));
                            } finally {
                              if (mounted)
                                setModalState(() => isSending = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: isSending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Enviar Link',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: Icon(Icons.bakery_dining,
                          size: 80, color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Panificadora\nDon Juan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.primary,
                              height: 1.1)),
                  const SizedBox(height: 8),
                  Text(
                      _isLogin
                          ? 'Que bom ter você de volta!'
                          : 'Crie sua conta para começar.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey.shade600)),
                  const SizedBox(height: 48),

                  // Campos Extras de Cadastro
                  if (!_isLogin) ...[
                    _buildTextField(
                        controller: _nameController,
                        label: 'Nome Completo',
                        icon: Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _phoneController,
                        label: 'Telefone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _addressController,
                        label: 'Endereço Principal (Opcional)',
                        icon: Icons.location_on_outlined),
                    const SizedBox(height: 16),
                  ],

                  // Campos de Credenciais
                  _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      isPassword: true),

                  if (_isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: _showRecuperarSenhaModal,
                          child: Text('Esqueceu a senha?',
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold))),
                    )
                  else
                    const SizedBox(height: 16),

                  if (_error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200)),
                      child: Row(children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_error!,
                                style: TextStyle(
                                    color: Colors.red.shade700, fontSize: 14)))
                      ]),
                    ),

                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(_isLogin ? 'Entrar' : 'Cadastrar',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _error = null;
                            });
                          },
                    child: Text(
                        _isLogin
                            ? 'Ainda não tem conta? Cadastre-se'
                            : 'Já tem conta? Faça Login',
                        style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      bool isPassword = false,
      TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2)),
      ),
    );
  }
}
