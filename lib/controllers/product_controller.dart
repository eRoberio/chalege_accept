import 'package:chalege_accept/models/product_models.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'product_controller.g.dart';

class ProductController = _ProductControllerBase with _$ProductController;

abstract class _ProductControllerBase with Store {
  @observable
  ProductData productData;

  @action
  void setProductData(ProductData value) => productData = value;

  @observable
  String titulo;

  @action
  void setTitulo(String value) => titulo = value;

  @observable
  String descricao;

  @action
  void setDescricao(String value) => descricao = value;

  @observable
  bool excluido;

  @action
  void setExcluido(bool value) => excluido = value;

  @observable
  bool feito;

  @action
  void setFeito(bool value) => feito = value;

  @observable
  DateTime data;
  @action
  void setData(DateTime value) => data = value;

  @observable
  Stream<QuerySnapshot> snapshot = Firestore.instance
      .collection('products')
      .where('excluido', isEqualTo: false)
      .orderBy('data')
      .snapshots();

  @observable
  DocumentSnapshot documentSnapshot;

  @action
  void setDocSnapshot(DocumentSnapshot value) => documentSnapshot = value;

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
    var form = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Novo Produto'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
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
                  SizedBox(
                    height: 20,
                  ),
                  Text('Título'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex.: Comprar ração',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo não pode ser vazio';
                          }
                          return null;
                        },
                        onChanged: setTitulo,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Descrição'),
                  Observer(
                    builder: (BuildContext context) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: '(Opcional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: setDescricao,
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
            FlatButton(
              onPressed: () async {
                if (form.currentState.validate()) {
                  await Firestore.instance.collection('products').add({
                    'titulo': titulo,
                    'descricao': descricao,
                    'feito': false,
                    'data': Timestamp.now(),
                    'excluido': false,
                  });

                  Navigator.of(context).pop();
                }
              },
              color: Colors.green,
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @action
  showDialogExcluir(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Você tem certeza que deseja excluir ?"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Sim"),
                  onTap: () {
                    documentSnapshot.reference.updateData(
                      {
                        'excluido': true,
                      },
                    );
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
}
