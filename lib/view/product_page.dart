import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:chalege_accept/view/productSelected.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

class ProductPage extends StatefulWidget {
  static String tag = '/home';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final controller = GetIt.I<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Observer(
        builder: (BuildContext context) {
          return StreamBuilder(
            stream: controller.snapshot,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data.documents.length == 0) {
                return Center(
                    child: Text('Lamento, nenhum produto encontrado :( '));
              }

              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int i) {
                  var doc = snapshot.data.documents[i];
                  controller.setDocSnapshot(doc);
                  var item = doc.data;

                  // print('todo/${doc.reference.documentID}');

                  return Column(
                    children: [
                      Slidable(
                        closeOnScroll: true,
                        actionExtentRatio: 0.2,
                        direction: Axis.horizontal,
                        actionPane: SlidableBehindActionPane(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          child: InkWell(
                            child: Container(
                              color: Colors.white,
                              height: 70,
                              width: 340,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check_circle),
                                    ],
                                  ),
                                  Text(item['titulo']),
                                  Text(item['descricao']),
                                  Text(item['preco']),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductSelected(doc),
                                ),
                              );
                            },
                          ),
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
                              onTap: () {
                                controller.showDialogExcluir(context);
                              })
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: DottedBorder(
        color: Colors.redAccent,
        padding: EdgeInsets.only(left: 8, right: 8),
        strokeWidth: 2,
        child: Container(
          width: 300.0,
          child: RaisedButton(
            child: Text(
              "Adicionar novo",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () => controller.createProduct(context),

            
            color: Color.fromARGB(255, 249, 220, 220),
          ),
        ),
      ),
    );
  }
}
