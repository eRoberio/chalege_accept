import 'package:chalege_accept/screens/products_screens.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 240),

      child: Slidable(
        closeOnScroll: true,
        actionExtentRatio: 0.2,
        direction: Axis.horizontal,
        actionPane: SlidableBehindActionPane(),
        child: ListTile(
          trailing: Wrap(
            spacing: 12,
            children: [
              IconButton(
                icon: Icon(Icons.visibility_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {},
              ),
            ],
          ),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              widget.snapshot.data["icon"],
            ),
          ),
          title: Text(
            widget.snapshot.data['title'],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryScreen(widget.snapshot),
              ),
            );
          },
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Editar',
              icon: Icons.edit,
              color: Colors.black,
              onTap: () {}),
          IconSlideAction(
              caption: 'Excluir',
              icon: Icons.block,
              color: Colors.red[400],
              onTap: () {})
        ],
      ),
    );
  }
}
