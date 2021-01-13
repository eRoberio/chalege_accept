import 'package:chalege_accept/models/product_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  static final Firestore _db = Firestore.instance;
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

  Future<List<ProductData>> buscarDados() async {
    List<ProductData> products = [];

    QuerySnapshot snapshot = await Firestore.instance
        .collection('products')
        .where('excluido', isEqualTo: false)
        .orderBy('data')
        .getDocuments();

    snapshot.documents.forEach((product) {
      products.add(ProductData(
          id: product.documentID,
          titulo: product['titulo'],
          descricao: product['descricao'],
          preco: product['preco'],
          data: product['data'],
          excluido: product['excluido'],
          feito: product['feito']));
    });

    return products;
  }

  Future<String> delete(String id) async {
    await _db.collection('products').document(id).delete().catchError((e) {
      print(e);
      return 'Falha ao excluir produto';
    });
    return 'Produto excluído com sucesso';
  }

  Future<String> delete2(String id) async {
    await _db
        .collection('products')
        .document(id)
        .updateData({'excluido': true}).catchError((e) {
      print(e);
      return 'Falha ao excluir produto';
    });
    return 'Produto excluir com sucesso';
  }

  Future<String> update(String id, Map<String, dynamic> data) async {
    await _db
        .collection('products')
        .document(id)
        .updateData(data)
        .catchError((e) {
      print(e);
      return 'Falha ao atualizar produto';
    });
    return 'Produto atualizado com sucesso';
  }
}
