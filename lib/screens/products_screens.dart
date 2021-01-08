import 'package:chalege_accept/tabs/products_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProductsTab());
  }
}
