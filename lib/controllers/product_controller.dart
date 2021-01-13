import 'package:chalege_accept/controllers/home_controller.dart';
import 'package:chalege_accept/models/product_models.dart';
import 'package:chalege_accept/services/repository.dart';
import 'package:chalege_accept/widgets/currency_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'product_controller.g.dart';

class ProductController = _ProductControllerBase with _$ProductController;

abstract class _ProductControllerBase with Store {
  Repository repository = Repository();

  @observable
  ProductData productData;

  @action
  void setProductData(ProductData value) => productData = value;

  @observable
  String titulo;

  @observable
  Future<List<ProductData>> products;

  @action
  void setTitulo(String value) => titulo = value;

  @observable
  String mensagem;

  @action
  void setMensagem(String value) => mensagem = value;

  @observable
  String descricao;

  @action
  void setDescricao(String value) => descricao = value;

  @observable
  String preco;

  @action
  void setPreco(String value) => preco = value;

  @observable
  bool excluido;

  @action
  void setExcluido(bool value) => excluido = value;

  @observable
  bool feito;

  @action
  void setFeito(bool value) => feito = value;

  @observable
  Timestamp data;
  @action
  void setData(Timestamp value) => data = value;
  @observable
  @observable
  Stream<QuerySnapshot> snapshot = Firestore.instance
      .collection('products')
      .where('excluido', isEqualTo: false)
      .orderBy('data')
      .snapshots();

  @action
  void setSnapshot(Stream<QuerySnapshot> value) => snapshot = value;

  void imageSelected(File image) async {
    Function(File) onImageSelected;
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
      );
      onImageSelected(croppedImage);
    }
  }

  Future _abrirGaleria() async {
    FlatButton(
      child: Text("Galeria"),
      onPressed: () async {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        imageSelected(image);
      },
    );
  }

  _abrirCamera(BuildContext context) {
    FlatButton(
      child: Text("Câmera"),
      onPressed: () async {
        File image = await ImagePicker.pickImage(source: ImageSource.camera);
        imageSelected(image);
      },
    );
  }

  @computed
  bool get formValid => tituloValid && precoValid;

  @computed
  bool get tituloValid => titulo != null && titulo.length >= 3;
  String get tituloError {
    if (titulo == null || tituloValid)
      return null;
    else if (titulo.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Nome muito curto';
  }

  @computed
  bool get precoValid => preco != null && preco != "R\$ 0,00";
  String get precoError {
    if (preco == null || precoValid)
      return null;
    else
      return 'Campo obrigatório';
  }

  _verDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Inserir Imagem"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Abir Galeria"),
                  onTap: () {
                    _abrirGaleria();
                  },
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                GestureDetector(
                  child: Text("Abrir Camera"),
                  onTap: () {
                    _abrirCamera(context);
                  },
                ),
              ],
            )),
          );
        });
  }

  @action
  Future<void> createProduct(BuildContext context) async {
    showFormCreate(context: context);
  }

  @action
  showDialogExcluir(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Você tem certeza que deseja excluir ?"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    "Sim",
                    style: TextStyle(color: Colors.red[400]),
                  ),
                  onTap: () {
                    this.deleteProduct(id);
                    this.readProducts();
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                GestureDetector(
                  child: Text("Não"),
                  onTap: Navigator.of(context).pop,
                ),
              ],
            )),
          );
        });
  }

  @action
  readProducts() {
    products = repository.buscarDados();
  }

  @action
  Future<void> deleteProduct(String id) {
    return repository.delete2(id).then((value) {
      setMensagem(value);
      print('Mensagem Delete: $mensagem');
    });
  }

  @action
  void updateProduct(BuildContext context, ProductData product) {
    showFormUpdate(context: context, product: product);
  }

  @action
  showFormUpdate({BuildContext context, ProductData product}) {
    var form = GlobalKey<FormState>();

    setTitulo(product.titulo);
    setDescricao(product.descricao);
    setPreco(product.preco);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Atualizar Produto')),
          content: Form(
            key: form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          'Inserir Imagem',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.photo_camera,
                        ),
                      ],
                    ),
                    onTap: () {
                      _verDialog(context);
                    },
                  ),
                  Text('Id'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: product.id,
                        enabled: false,
                        onChanged: setTitulo,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Título'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex.: Pão Françês',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: product.titulo,
                        onChanged: setTitulo,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Descrição'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex.: Esse pão com manteiga é muito bom. ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: product.descricao,
                        onChanged: setDescricao,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Preço'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyPtBrInputFormatter(maxDigits: 8),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ex.: 3,00 ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: product.preco,
                        onChanged: setPreco,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            Observer(
              builder: (BuildContext context) {
                return FlatButton(
                  onPressed: this.formValid
                      ? () async {
                          Map<String, dynamic> data = {
                            'titulo': titulo,
                            'descricao': descricao,
                            'preco': preco,
                            'feito': false,
                            'data': Timestamp.now(),
                            'excluido': false,
                          };

                          await repository
                              .update(product.id, data)
                              .then((value) {
                            setMensagem(value);
                            print('Mensagem atualizaçao: $mensagem');
                          });

                          zerarVariaveis();

                          this.readProducts();
                          Navigator.of(context).pop();
                        }
                      : null,
                  disabledColor: Colors.grey[500],
                  color: Colors.green,
                  child: Text('Atualizar'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @action
  showFormCreate({BuildContext context}) {
    var form = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Novo Produto')),
          content: Form(
            key: form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          'Inserir Imagem',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.photo_camera,
                        ),
                      ],
                    ),
                    onTap: () {
                      _verDialog(context);
                    },
                  ),
                  Text('Título'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          errorText: tituloError,
                          hintText: 'Ex.: Pão Françês',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: setTitulo,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Descrição'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex.: Esse pão com manteiga é muito bom. ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: setDescricao,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Preço'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyPtBrInputFormatter(maxDigits: 8),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText: precoError,
                          hintText: 'Ex.: 3,00 ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: setPreco,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            Observer(
              builder: (BuildContext context) {
                return FlatButton(
                  onPressed: this.formValid
                      ? () async {
                          if (form.currentState.validate()) {
                            await repository
                                .create(ProductData(
                              titulo: titulo,
                              descricao: descricao,
                              preco: preco,
                              feito: false,
                              data: Timestamp.now(),
                              excluido: false,
                            ))
                                .then((value) {
                              setMensagem(value);
                              print('Mensagem de criação: $mensagem');
                            });
                          }
                          this.readProducts();
                          zerarVariaveis();

                          Navigator.of(context).pop();
                        }
                      : null,
                  disabledColor: Colors.grey[500],
                  color: Colors.green,
                  child: Text('Salvar'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @action
  zerarVariaveis() {
    setDescricao('');
    setTitulo('');
    setPreco('');
  }
}