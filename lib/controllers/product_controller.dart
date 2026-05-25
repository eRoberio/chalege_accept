import 'dart:convert';
import 'dart:io';
import 'package:chalege_accept/models/product_models.dart';
import 'package:chalege_accept/services/repository.dart';
import 'package:chalege_accept/widgets/currency_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart'; // Sem image_cropper!
import 'package:mobx/mobx.dart';

part 'product_controller.g.dart';

class ProductController = _ProductControllerBase with _$ProductController;

abstract class _ProductControllerBase with Store {
  Repository repository = Repository();

  @observable
  ProductData productData = ProductData(
    id: '',
    nome: '',
    descricao: '',
    preco: '',
    disponivel: true,
    dataCadastro: Timestamp.now(),
    imagemUrl: '',
  );

  @action
  void setProductData(ProductData value) => productData = value;

  @observable
  String nome = '';
  @observable
  String descricao = "";
  @observable
  String preco = '';
  @observable
  bool disponivel = true;
  @observable
  String? imagemUrl;
  @observable
  Timestamp dataCadastro = Timestamp.now();

  @observable
  late Future<List<ProductData>> products;
  @observable
  bool isUploading = false;
  @observable
  String? previewImageUrl;
  @observable
  File? imagemLocalMobile;
  @observable
  XFile? pickedImage; // Guarda a imagem para subir só na hora de salvar
  @observable
  String mensagem = '';

  @action
  void setNome(String value) => nome = value;
  @action
  void setDescricao(String value) => descricao = value;
  @action
  void setPreco(String value) => preco = value;
  @action
  void setDisponivel(bool value) => disponivel = value;
  @action
  void setImagemUrl(String? value) => imagemUrl = value;
  @action
  void setPreviewImageUrl(String? value) => previewImageUrl = value;
  @action
  void setImagemLocalMobile(File? value) => imagemLocalMobile = value;
  @action
  void setUploading(bool value) => isUploading = value;
  @action
  void setMensagem(String value) => mensagem = value;
  @action
  void setDataCadastro(Timestamp value) => dataCadastro = value;
  @action
  void setPickedImage(XFile? value) => pickedImage = value;

  @action
  zerarVariaveis() {
    setNome('');
    setDescricao('');
    setPreco('');
    setDisponivel(true);
    setImagemUrl(null);
    setPreviewImageUrl(null);
    setImagemLocalMobile(null);
    setPickedImage(null);
    setUploading(false);
  }

  @computed
  bool get formValid => nomeValid && precoValid;
  @computed
  bool get nomeValid => nome.length >= 3;
  @computed
  bool get precoValid => preco.isNotEmpty && preco != "R\$ 0,00";

  // --- NOVA LÓGICA DE IMAGEM: Apenas seleciona e exibe a prévia ---
  void imageSelected(BuildContext context, XFile? image,
      void Function(XFile?) onImageSelected) {
    if (image != null) {
      setPickedImage(image); // Guarda na memória

      // Exibe a prévia imediatamente
      if (kIsWeb) {
        setPreviewImageUrl(image.path);
      } else {
        setImagemLocalMobile(File(image.path));
      }
    }
  }

  Future<void> _abrirGaleria(
      BuildContext context, void Function(XFile?) onImageSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imageSelected(context, image, onImageSelected);
  }

  Future<void> _abrirCamera(
      BuildContext context, void Function(XFile?) onImageSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    imageSelected(context, image, onImageSelected);
  }

  @action
  readProducts() {
    products = repository.buscarDados();
  }

  @action
  Future<void> deleteProduct(String id) {
    return repository.delete2(id).then((value) => setMensagem(value));
  }

  @action
  showDialogExcluir(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir?"),
          content: const Text("Tem certeza?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Não")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                deleteProduct(id);
                readProducts();
                Navigator.pop(context);
              },
              child: const Text("Sim", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  _verDialog(BuildContext context, void Function(XFile?) onImageSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const Text("Selecionar Imagem",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade50,
                  child:
                      Icon(Icons.photo_library, color: Colors.brown.shade700)),
              title: const Text("Galeria"),
              onTap: () {
                Navigator.pop(context);
                _abrirGaleria(context, onImageSelected);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.brown.shade50,
                    child:
                        Icon(Icons.camera_alt, color: Colors.brown.shade700)),
                title: const Text("Câmera"),
                onTap: () {
                  Navigator.pop(context);
                  _abrirCamera(context, onImageSelected);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @action
  createProduct(BuildContext context) {
    zerarVariaveis();
    _showModernForm(context: context, isUpdate: false);
  }

  @action
  void updateProduct(BuildContext context, ProductData product) {
    zerarVariaveis();
    setNome(product.nome);
    setDescricao(product.descricao);
    setPreco(product.preco);
    setDisponivel(product.disponivel);
    setImagemUrl(product.imagemUrl);
    _showModernForm(context: context, isUpdate: true, productId: product.id);
  }

  void _showModernForm(
      {required BuildContext context,
      required bool isUpdate,
      String? productId}) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: 600),
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(isUpdate ? 'Atualizar' : 'Novo Produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary)),
                const SizedBox(height: 24),

                // Prévia da imagem limpa, sem loading (o loading agora fica só no botão salvar)
                Center(
                  child: Observer(builder: (_) {
                    return GestureDetector(
                      onTap: isUploading
                          ? null
                          : () => _verDialog(context, (x) {}),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.brown.shade50,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.brown.shade100)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildImagePreview()),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  initialValue: nome,
                  decoration: _inputStyle('Nome', Icons.shopping_bag_outlined),
                  onChanged: setNome,
                  validator: (v) => nomeValid ? null : 'Inválido',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: descricao,
                  maxLines: 2,
                  decoration:
                      _inputStyle('Descrição', Icons.description_outlined),
                  onChanged: setDescricao,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: preco,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyPtBrInputFormatter(maxDigits: 8)
                        ],
                        decoration:
                            _inputStyle('Preço', Icons.payments_outlined),
                        onChanged: setPreco,
                        validator: (v) => precoValid ? null : 'Obrigatório',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Observer(builder: (_) {
                        return Column(
                          children: [
                            const Text('Disponível',
                                style: TextStyle(fontSize: 12)),
                            Switch(
                              value: disponivel,
                              onChanged: setDisponivel,
                              activeThumbColor: Colors.green,
                              activeTrackColor: Colors.green.shade200,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- BOTÃO DE SALVAR QUE FAZ O UPLOAD E GRAVA NO BANCO ---
                Observer(builder: (_) {
                  final canSave = formValid && !isUploading;
                  return ElevatedButton(
                    onPressed: canSave
                        ? () async {
                            if (formKey.currentState?.validate() ?? false) {
                              setUploading(true); // Ativa o loading no botão

                              try {
                                // 1. Faz upload SE uma imagem nova foi selecionada
                                if (pickedImage != null) {
                                  if (kIsWeb) {
                                    final bytes =
                                        await pickedImage!.readAsBytes();
                                    final base64Image = base64Encode(bytes);
                                    imagemUrl = await repository
                                        .uploadBase64ImageToImgbb(base64Image);
                                  } else {
                                    imagemUrl =
                                        await repository.uploadImageToImgbb(
                                            File(pickedImage!.path));
                                  }
                                }

                                // 2. Monta os dados e salva no Firebase
                                final dataMap = {
                                  'nome': nome,
                                  'descricao': descricao,
                                  'preco': preco,
                                  'disponivel': disponivel,
                                  'dataCadastro': Timestamp.now(),
                                  'imagemUrl': imagemUrl,
                                };

                                if (isUpdate) {
                                  await repository.update(productId!, dataMap);
                                } else {
                                  await repository.create(ProductData(
                                    id: '',
                                    nome: nome,
                                    descricao: descricao,
                                    preco: preco,
                                    disponivel: disponivel,
                                    dataCadastro: Timestamp.now(),
                                    imagemUrl: imagemUrl,
                                  ));
                                }

                                readProducts();
                                Navigator.pop(context);
                              } catch (e) {
                                print("Erro ao salvar: $e");
                              } finally {
                                setUploading(false);
                              }
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: isUploading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(isUpdate ? 'Atualizar' : 'Salvar',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && previewImageUrl != null)
      return Image.network(previewImageUrl!, fit: BoxFit.cover);
    else if (!kIsWeb && imagemLocalMobile != null)
      return Image.file(imagemLocalMobile!, fit: BoxFit.cover);
    if (imagemUrl != null && imagemUrl!.isNotEmpty)
      return Image.network(imagemUrl!, fit: BoxFit.cover);
    return Container(
        color: Colors.brown.shade50,
        child: Icon(Icons.add_a_photo_outlined,
            size: 40, color: Colors.brown.shade300));
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200)),
    );
  }
}
