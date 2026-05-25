import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String nome;
  String descricao;
  String preco;
  bool disponivel;
  Timestamp dataCadastro;
  String? imagemUrl;

  ProductData({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.disponivel,
    required this.dataCadastro,
    this.imagemUrl,
  });
}
