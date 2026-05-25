// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerBase, Store {
  late final _$productDataAtom =
      Atom(name: 'HomeControllerBase.productData', context: context);

  @override
  ProductData get productData {
    _$productDataAtom.reportRead();
    return super.productData;
  }

  bool _productDataIsInitialized = false;

  @override
  set productData(ProductData value) {
    _$productDataAtom.reportWrite(
        value, _productDataIsInitialized ? super.productData : null, () {
      super.productData = value;
      _productDataIsInitialized = true;
    });
  }

  late final _$snapshotAtom =
      Atom(name: 'HomeControllerBase.snapshot', context: context);

  @override
  Stream<QuerySnapshot<Object?>> get snapshot {
    _$snapshotAtom.reportRead();
    return super.snapshot;
  }

  @override
  set snapshot(Stream<QuerySnapshot<Object?>> value) {
    _$snapshotAtom.reportWrite(value, super.snapshot, () {
      super.snapshot = value;
    });
  }

  late final _$pageAtom =
      Atom(name: 'HomeControllerBase.page', context: context);

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

  late final _$HomeControllerBaseActionController =
      ActionController(name: 'HomeControllerBase', context: context);

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
  void setSnapshot(Stream<QuerySnapshot<Object?>> value) {
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
