class ProductData {
  String titulo;
  String descricao;
  String preco;
  bool excluido;
  bool feito;
  DateTime data = DateTime.now();

  ProductData(
      {this.titulo,
      this.descricao,
      this.excluido,
      this.feito,
      this.data,
      this.preco});
}
