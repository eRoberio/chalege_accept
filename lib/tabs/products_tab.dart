import 'package:chalege_accept/services/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chalege_accept/tiles/category_tile.dart';
import 'package:get_it/get_it.dart';

class ProductsTab extends StatelessWidget {
  final repository = GetIt.I<Repository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _fire(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return CategoryTile(doc);
            }).toList(),
            color: Colors.grey[500],
          ).toList();

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }

  Future<QuerySnapshot> _fire() async {
    List<DocumentSnapshot> list;

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("products").getDocuments();
    list = querySnapshot.documents;

    list.forEach((document) {
      print(document.documentID);
      return document;
    });
  }
}
