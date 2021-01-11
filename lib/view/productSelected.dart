import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ProductSelected extends StatefulWidget {

   ProductSelected(this.snapshot);
 final DocumentSnapshot snapshot;

  @override
  _ProductSelectedState createState() => _ProductSelectedState();
}

class _ProductSelectedState extends State<ProductSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}