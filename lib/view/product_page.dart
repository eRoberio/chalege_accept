import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:chalege_accept/models/product_models.dart';
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
    setState(() {
      controller.readProducts();
    });
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Observer(
        builder: (BuildContext context) {
          return FutureBuilder<List<ProductData>>(
            future: controller.products,
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductData>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data.length == 0) {
                return Center(
                    child: Text('Lamento, nenhum produto encontrado :( '));
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  var doc = snapshot.data[i];
                  controller.setProductData(doc);

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
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check_circle),
                                    ],
                                  ),
                                  Text('${i + 1}- ${doc.titulo}'),
                                  Text(doc.descricao),
                                  Text(doc.preco),
                                ],
                              ),
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          Observer(builder: (BuildContext context) {
                            return IconSlideAction(
                                caption: 'Editar',
                                icon: Icons.edit,
                                color: Colors.black,
                                onTap: () {
                                  controller.updateProduct(context, doc);
                                });
                          }),
                          IconSlideAction(
                              caption: 'Excluir',
                              icon: Icons.block,
                              color: Colors.red[400],
                              onTap: () {
                                controller.showDialogExcluir(
                                  context,
                                  doc.id,
                                );
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
      floatingActionButton: Observer(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              controller.createProduct(context);
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
