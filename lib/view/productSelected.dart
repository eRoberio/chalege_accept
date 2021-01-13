import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductSelected extends StatefulWidget {
  @override
  _ProductSelectedState createState() => _ProductSelectedState();
}

class _ProductSelectedState extends State<ProductSelected> {
  final productController = GetIt.I<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productController.productData.titulo),),
    );
  }
}
