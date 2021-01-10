import 'package:chalege_accept/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  final Firestore _db = Firestore.instance;

  Future<ProductData> create(ProductData productData) async {
    Map<String, dynamic> products = {
      "title": productData.title,
      "description": productData.description,
      "price": productData.price,
    };
    await _db
        .collection('products')
        .document()
        .collection("lanches")
        .add(products);
  }
}
