import 'package:chalege_accept/screens/products_screens.dart';
import 'package:chalege_accept/services/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoryTile extends StatefulWidget {
 
 CategoryTile(this.snapshot);
 DocumentSnapshot snapshot;


  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  
  final repository = GetIt.I<Repository>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //LOGO
        InkWell(
          child: CircleAvatar(
            radius: 85.0,
            backgroundColor: Colors.transparent,
            backgroundImage:
                NetworkImage(widget.snapshot.data["icon"], scale: 10),
          ),onTap: (){},
        ),
        SizedBox(
          height: 10,
        ),
        //Título
        Text(
          widget.snapshot.data['title'],
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 10,
        ),
        //Localização
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.snapshot.data['local'],
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 300.0,
          padding: EdgeInsets.only(top: 16.0),
          child: RaisedButton(
            child: Text("Adicionar novo produto",
                style: TextStyle(
                  color: Colors.white,
                )),
            colorBrightness: Brightness.dark,
            onPressed: () {},
            color: Colors.redAccent,
          ),
        ),

        Padding(
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
                    builder: (context) => CategoryScreen(),
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
        ),
      ],
    );
  }
}
