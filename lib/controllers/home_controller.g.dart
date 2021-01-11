// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on HomeControllerBase, Store {
  final _$productDataAtom = Atom(name: 'HomeControllerBase.productData');

  @override
  ProductData get productData {
    _$productDataAtom.reportRead();
    return super.productData;
  }

  @override
  set productData(ProductData value) {
    _$productDataAtom.reportWrite(value, super.productData, () {
      super.productData = value;
    });
  }

  final _$snapshotAtom = Atom(name: 'HomeControllerBase.snapshot');

  @override
  Stream<QuerySnapshot> get snapshot {
    _$snapshotAtom.reportRead();
    return super.snapshot;
  }

  @override
  set snapshot(Stream<QuerySnapshot> value) {
    _$snapshotAtom.reportWrite(value, super.snapshot, () {
      super.snapshot = value;
    });
  }

  final _$pageAtom = Atom(name: 'HomeControllerBase.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$HomeControllerBaseActionController =
      ActionController(name: 'HomeControllerBase');

  @override
  void setPage(int value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProductData(ProductData value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setProductData');
    try {
      return super.setProductData(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSnapshot(Stream<QuerySnapshot> value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setSnapshot');
    try {
      return super.setSnapshot(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
productData: ${productData},
snapshot: ${snapshot},
page: ${page}
    ''';
  }
}
