import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  Map<String, dynamic>? _userData;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // --- BUSCA DADOS DO USUÁRIO E DA PANIFICADORA DE FORMA CONCORRENTE ---
  Future<void> _carregarDados() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Future.wait executa as duas buscas ao mesmo tempo para máxima performance
      final results = await Future.wait([
        FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        FirebaseFirestore.instance
            .collection('bakery_profile')
            .doc('main')
            .get(),
      ]);

      final userDoc = results[0];
      final bakeryDoc = results[1];

      if (userDoc.exists && userDoc.data() != null) {
        _userData = userDoc.data()!;
        _isAdmin = _userData?['role'] == 'admin';
      }

      if (bakeryDoc.exists && bakeryDoc.data() != null) {
        final bakeryData = bakeryDoc.data()!;
        _nomeController.text = bakeryData['nome'] ?? '';
        _enderecoController.text = bakeryData['endereco'] ?? '';
        _descricaoController.text = bakeryData['descricao'] ?? '';
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- SALVA AS ALTERAÇÕES (APENAS PARA ADMIN) ---
  Future<void> _salvarPerfil() async {
    if (!_isAdmin) return;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      try {
        await FirebaseFirestore.instance
            .collection('bakery_profile')
            .doc('main')
            .set({
          'nome': _nomeController.text,
          'endereco': _enderecoController.text,
          'descricao': _descricaoController.text,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Perfil da loja atualizado!'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erro ao salvar: $e'),
              backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _confirmarLogout() async {
    final confirmar = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Icon(Icons.logout_rounded, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text('Sair da conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Deseja realmente sair do aplicativo?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)))),
                const SizedBox(width: 16),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0),
                        child: const Text('Sim, Sair',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            )
          ],
        ),
      ),
    );

    if (confirmar == true) await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String userName = _userData?['nome'] ?? 'Usuário';
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    final String userPhone = _userData?['telefone'] ?? 'Não informado';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER DO PERFIL DO USUÁRIO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary]),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Text(userName,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(userEmail,
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.8))),
                  const SizedBox(height: 12),
                  // Badge indicando a função
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color:
                            _isAdmin ? Colors.amber.shade700 : Colors.white24,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(_isAdmin ? 'ADMINISTRADOR' : 'CLIENTE',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- DADOS PESSOAIS ---
                  const Text('Meus Dados',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200)),
                    child: Column(
                      children: [
                        ListTile(
                            leading: Icon(Icons.phone_outlined,
                                color: colorScheme.primary),
                            title: const Text('Telefone'),
                            subtitle: Text(userPhone)),
                        const Divider(height: 1),
                        ListTile(
                            leading: Icon(Icons.location_on_outlined,
                                color: colorScheme.primary),
                            title: const Text('Endereço Padrão'),
                            subtitle: Text(
                                _userData?['endereco'] ?? 'Não informado')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- FORMULÁRIO DE ADMINISTRAÇÃO (MOSTRA SÓ SE FOR ADMIN) ---
                  if (_isAdmin) ...[
                    const Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.amber),
                        SizedBox(width: 8),
                        Text('Configurações da Loja',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: Colors.amber.shade200, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nomeController,
                                decoration: _inputStyle('Nome da Panificadora',
                                    Icons.badge_outlined),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo obrigatório'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _enderecoController,
                                decoration: _inputStyle('Endereço da Loja',
                                    Icons.storefront_outlined),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo obrigatório'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descricaoController,
                                decoration: _inputStyle(
                                    'Descrição', Icons.description_outlined),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2))
                                      : const Icon(Icons.save),
                                  label: Text(_isSaving
                                      ? 'Salvando...'
                                      : 'Salvar Alterações'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16)),
                                  onPressed: _isSaving ? null : _salvarPerfil,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // --- BOTÃO DE LOGOUT ---
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Sair da Conta',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    onPressed: _confirmarLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)),
    );
  }
}
