// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductController on _ProductControllerBase, Store {
  final _$productDataAtom = Atom(name: '_ProductControllerBase.productData');

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

  final _$tituloAtom = Atom(name: '_ProductControllerBase.titulo');

  @override
  String get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  final _$productsAtom = Atom(name: '_ProductControllerBase.products');

  @override
  Future<List<ProductData>> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(Future<List<ProductData>> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  final _$mensagemAtom = Atom(name: '_ProductControllerBase.mensagem');

  @override
  String get mensagem {
    _$mensagemAtom.reportRead();
    return super.mensagem;
  }

  @override
  set mensagem(String value) {
    _$mensagemAtom.reportWrite(value, super.mensagem, () {
      super.mensagem = value;
    });
  }

  final _$descricaoAtom = Atom(name: '_ProductControllerBase.descricao');

  @override
  String get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  final _$precoAtom = Atom(name: '_ProductControllerBase.preco');

  @override
  String get preco {
    _$precoAtom.reportRead();
    return super.preco;
  }

  @override
  set preco(String value) {
    _$precoAtom.reportWrite(value, super.preco, () {
      super.preco = value;
    });
  }

  final _$excluidoAtom = Atom(name: '_ProductControllerBase.excluido');

  @override
  bool get excluido {
    _$excluidoAtom.reportRead();
    return super.excluido;
  }

  @override
  set excluido(bool value) {
    _$excluidoAtom.reportWrite(value, super.excluido, () {
      super.excluido = value;
    });
  }

  final _$feitoAtom = Atom(name: '_ProductControllerBase.feito');

  @override
  bool get feito {
    _$feitoAtom.reportRead();
    return super.feito;
  }

  @override
  set feito(bool value) {
    _$feitoAtom.reportWrite(value, super.feito, () {
      super.feito = value;
    });
  }

  final _$dataAtom = Atom(name: '_ProductControllerBase.data');

  @override
  Timestamp get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(Timestamp value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  final _$isUpdateAtom = Atom(name: '_ProductControllerBase.isUpdate');

  @override
  bool get isUpdate {
    _$isUpdateAtom.reportRead();
    return super.isUpdate;
  }

  @override
  set isUpdate(bool value) {
    _$isUpdateAtom.reportWrite(value, super.isUpdate, () {
      super.isUpdate = value;
    });
  }

  final _$snapshotAtom = Atom(name: '_ProductControllerBase.snapshot');

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

  final _$createProductAsyncAction =
      AsyncAction('_ProductControllerBase.createProduct');

  @override
  Future<void> createProduct(BuildContext context) {
    return _$createProductAsyncAction.run(() => super.createProduct(context));
  }

  final _$_ProductControllerBaseActionController =
      ActionController(name: '_ProductControllerBase');

  @override
  void setProductData(ProductData value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setProductData');
    try {
      return super.setProductData(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitulo(String value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setTitulo');
    try {
      return super.setTitulo(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMensagem(String value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setMensagem');
    try {
      return super.setMensagem(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescricao(String value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setDescricao');
    try {
      return super.setDescricao(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPreco(String value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setPreco');
    try {
      return super.setPreco(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setExcluido(bool value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setExcluido');
    try {
      return super.setExcluido(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFeito(bool value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setFeito');
    try {
      return super.setFeito(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setData(Timestamp value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setData');
    try {
      return super.setData(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsUpdate(bool value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setIsUpdate');
    try {
      return super.setIsUpdate(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSnapshot(Stream<QuerySnapshot> value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setSnapshot');
    try {
      return super.setSnapshot(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic showDialogExcluir(BuildContext context, String id) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.showDialogExcluir');
    try {
      return super.showDialogExcluir(context, id);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic readProducts() {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.readProducts');
    try {
      return super.readProducts();
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> deleteProduct(String id) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.deleteProduct');
    try {
      return super.deleteProduct(id);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateProduct(BuildContext context, ProductData product) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.updateProduct');
    try {
      return super.updateProduct(context, product);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic showFormUpdate({BuildContext context, ProductData product}) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.showFormUpdate');
    try {
      return super.showFormUpdate(context: context, product: product);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic showFormCreate({BuildContext context}) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.showFormCreate');
    try {
      return super.showFormCreate(context: context);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic zerarVariaveis() {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.zerarVariaveis');
    try {
      return super.zerarVariaveis();
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
productData: ${productData},
titulo: ${titulo},
products: ${products},
mensagem: ${mensagem},
descricao: ${descricao},
preco: ${preco},
excluido: ${excluido},
feito: ${feito},
data: ${data},
isUpdate: ${isUpdate},
snapshot: ${snapshot}
    ''';
  }
}
