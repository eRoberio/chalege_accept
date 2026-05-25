// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductController on _ProductControllerBase, Store {
  Computed<bool>? _$formValidComputed;

  @override
  bool get formValid =>
      (_$formValidComputed ??= Computed<bool>(() => super.formValid,
              name: '_ProductControllerBase.formValid'))
          .value;
  Computed<bool>? _$nomeValidComputed;

  @override
  bool get nomeValid =>
      (_$nomeValidComputed ??= Computed<bool>(() => super.nomeValid,
              name: '_ProductControllerBase.nomeValid'))
          .value;
  Computed<bool>? _$precoValidComputed;

  @override
  bool get precoValid =>
      (_$precoValidComputed ??= Computed<bool>(() => super.precoValid,
              name: '_ProductControllerBase.precoValid'))
          .value;

  late final _$productDataAtom =
      Atom(name: '_ProductControllerBase.productData', context: context);

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

  late final _$nomeAtom =
      Atom(name: '_ProductControllerBase.nome', context: context);

  @override
  String get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$descricaoAtom =
      Atom(name: '_ProductControllerBase.descricao', context: context);

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

  late final _$precoAtom =
      Atom(name: '_ProductControllerBase.preco', context: context);

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

  late final _$disponivelAtom =
      Atom(name: '_ProductControllerBase.disponivel', context: context);

  @override
  bool get disponivel {
    _$disponivelAtom.reportRead();
    return super.disponivel;
  }

  @override
  set disponivel(bool value) {
    _$disponivelAtom.reportWrite(value, super.disponivel, () {
      super.disponivel = value;
    });
  }

  late final _$imagemUrlAtom =
      Atom(name: '_ProductControllerBase.imagemUrl', context: context);

  @override
  String? get imagemUrl {
    _$imagemUrlAtom.reportRead();
    return super.imagemUrl;
  }

  @override
  set imagemUrl(String? value) {
    _$imagemUrlAtom.reportWrite(value, super.imagemUrl, () {
      super.imagemUrl = value;
    });
  }

  late final _$dataCadastroAtom =
      Atom(name: '_ProductControllerBase.dataCadastro', context: context);

  @override
  Timestamp get dataCadastro {
    _$dataCadastroAtom.reportRead();
    return super.dataCadastro;
  }

  @override
  set dataCadastro(Timestamp value) {
    _$dataCadastroAtom.reportWrite(value, super.dataCadastro, () {
      super.dataCadastro = value;
    });
  }

  late final _$productsAtom =
      Atom(name: '_ProductControllerBase.products', context: context);

  @override
  Future<List<ProductData>> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  bool _productsIsInitialized = false;

  @override
  set products(Future<List<ProductData>> value) {
    _$productsAtom
        .reportWrite(value, _productsIsInitialized ? super.products : null, () {
      super.products = value;
      _productsIsInitialized = true;
    });
  }

  late final _$isUploadingAtom =
      Atom(name: '_ProductControllerBase.isUploading', context: context);

  @override
  bool get isUploading {
    _$isUploadingAtom.reportRead();
    return super.isUploading;
  }

  @override
  set isUploading(bool value) {
    _$isUploadingAtom.reportWrite(value, super.isUploading, () {
      super.isUploading = value;
    });
  }

  late final _$previewImageUrlAtom =
      Atom(name: '_ProductControllerBase.previewImageUrl', context: context);

  @override
  String? get previewImageUrl {
    _$previewImageUrlAtom.reportRead();
    return super.previewImageUrl;
  }

  @override
  set previewImageUrl(String? value) {
    _$previewImageUrlAtom.reportWrite(value, super.previewImageUrl, () {
      super.previewImageUrl = value;
    });
  }

  late final _$imagemLocalMobileAtom =
      Atom(name: '_ProductControllerBase.imagemLocalMobile', context: context);

  @override
  File? get imagemLocalMobile {
    _$imagemLocalMobileAtom.reportRead();
    return super.imagemLocalMobile;
  }

  @override
  set imagemLocalMobile(File? value) {
    _$imagemLocalMobileAtom.reportWrite(value, super.imagemLocalMobile, () {
      super.imagemLocalMobile = value;
    });
  }

  late final _$pickedImageAtom =
      Atom(name: '_ProductControllerBase.pickedImage', context: context);

  @override
  XFile? get pickedImage {
    _$pickedImageAtom.reportRead();
    return super.pickedImage;
  }

  @override
  set pickedImage(XFile? value) {
    _$pickedImageAtom.reportWrite(value, super.pickedImage, () {
      super.pickedImage = value;
    });
  }

  late final _$mensagemAtom =
      Atom(name: '_ProductControllerBase.mensagem', context: context);

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

  late final _$_ProductControllerBaseActionController =
      ActionController(name: '_ProductControllerBase', context: context);

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
  void setNome(String value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setNome');
    try {
      return super.setNome(value);
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
  void setDisponivel(bool value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setDisponivel');
    try {
      return super.setDisponivel(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImagemUrl(String? value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setImagemUrl');
    try {
      return super.setImagemUrl(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPreviewImageUrl(String? value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setPreviewImageUrl');
    try {
      return super.setPreviewImageUrl(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImagemLocalMobile(File? value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setImagemLocalMobile');
    try {
      return super.setImagemLocalMobile(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUploading(bool value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setUploading');
    try {
      return super.setUploading(value);
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
  void setDataCadastro(Timestamp value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setDataCadastro');
    try {
      return super.setDataCadastro(value);
    } finally {
      _$_ProductControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPickedImage(XFile? value) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.setPickedImage');
    try {
      return super.setPickedImage(value);
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
  dynamic createProduct(BuildContext context) {
    final _$actionInfo = _$_ProductControllerBaseActionController.startAction(
        name: '_ProductControllerBase.createProduct');
    try {
      return super.createProduct(context);
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
  String toString() {
    return '''
productData: ${productData},
nome: ${nome},
descricao: ${descricao},
preco: ${preco},
disponivel: ${disponivel},
imagemUrl: ${imagemUrl},
dataCadastro: ${dataCadastro},
products: ${products},
isUploading: ${isUploading},
previewImageUrl: ${previewImageUrl},
imagemLocalMobile: ${imagemLocalMobile},
pickedImage: ${pickedImage},
mensagem: ${mensagem},
formValid: ${formValid},
nomeValid: ${nomeValid},
precoValid: ${precoValid}
    ''';
  }
}
