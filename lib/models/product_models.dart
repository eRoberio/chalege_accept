import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String titulo;
  String descricao = '';
  String preco;
  bool excluido;
  bool feito;
  Timestamp data;

  ProductData({
    this.id,
    this.titulo,
    this.descricao,
    this.excluido,
    this.feito,
    this.data,
    this.preco,
  });
}
