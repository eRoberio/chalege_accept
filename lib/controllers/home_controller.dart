import 'package:chalege_accept/models/product_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  
  @observable
  late ProductData productData;

  @observable
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
      .collection('products')
      .where('excluido', isEqualTo: false)
      .orderBy('data')
      .snapshots();

  @observable
  int page = 0;

//ACTIONS

  @action
  void setPage(int value) => page = value;

  @action
  void setProductData(ProductData value) => productData = value;


  @action
  void setSnapshot(Stream<QuerySnapshot> value) => snapshot = value;
}
