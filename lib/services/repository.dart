import 'package:chalege_accept/models/product_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Repository {
  
  Future<String> create(ProductData product) async {
    try {
      await Firestore.instance.collection('products').add({
        'titulo': product.titulo,
        'descricao': product.descricao,
        'preco': product.preco,
        'feito': product.feito,
        'data': product.data,
        'excluido': product.excluido,
      });
      return 'Produto criado com sucesso';
    } catch (e) {
      return 'Falha ao criar produto';
    }
  }

  /* List<ProductData> buscarDados() {
     Stream<QuerySnapshot> snapshot = Firestore.instance
        .collection('products')
        .where('excluido', isEqualTo: false)
        .orderBy('data')
        .snapshots();
    return snapshot;
  }
 */
  
}



/* import 'package:chalege_accept/models/product_models.dart';
import 'package:chalege_accept/services/repository.dart';
import 'package:chalege_accept/widgets/currency_input_formatter.dart';
import 'package:flutter/services.dart';
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
  Repository repository;

  @observable
  ProductData productData;

  @observable
  String titulo;
  @observable
  String descricao;
  @observable
  String preco;
  @observable
  bool excluido;

  @observable
  bool feito;
  @observable
  DateTime data;



  @computed
  bool get formValid => tituloValid && descricaoValid;

  @computed
  bool get tituloValid => titulo != null && titulo.length >= 3;
  String get tituloError {
    if (titulo == null || tituloValid)
      return null;
    else if (titulo.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Titulo muito curto';
  }

  @computed
  bool get descricaoValid => descricao != null && descricao.length > 6;
  String get descricaoError {
    if (descricao == null || descricaoValid)
      return null;
    else if (descricao.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Descrição muito curta';
  }

  @computed
  bool get precoValid => preco != null && preco.length != 6;

  String get precoError {
    if (preco == null || precoValid)
      return null;
    else if (null)
      return 'Campo obrigatório';
    else
      return 'Número inválido';
  }
  @action
  void setTitulo(String value) => titulo = value;

  @action
  void setDescricao(String value) => descricao = value;

  @action
  void setPreco(String value) => preco = value;

  @action
  void setExcluido(bool value) => excluido = value;

  @action
  void setFeito(bool value) => feito = value;

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Novo Produto')),
          content: SingleChildScrollView(
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
                  height: 10,
                ),
                Text('Título'),
                Observer(
                  builder: (BuildContext context) {
                    return TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ex.: Pão Françês',
                        errorText: tituloError,
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
                        errorText: descricaoError,
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
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            Observer(
              builder: (BuildContext context) {
                return FlatButton(
                  onPressed: () async {
                    if (formValid) {
                      productData.titulo = titulo;
                      productData.descricao = descricao;
                      productData.preco = preco;

                      await repository.create(productData).then((r) {
                        print(r);
                      });
                    }
                    Navigator.of(context).pop();
                  },
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
 */