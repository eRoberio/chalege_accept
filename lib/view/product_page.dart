import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:chalege_accept/models/product_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

class ProductPage extends StatefulWidget {
  static String tag = '/product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final controller = GetIt.I<ProductController>();

  @override
  void initState() {
    super.initState();
    controller.readProducts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.createProduct(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text(
              'Gerenciar Estoque',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
            ),
          ),
          Expanded(
            child: Observer(
              builder: (BuildContext context) {
                return FutureBuilder<List<ProductData>>(
                  future: controller.products,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProductData>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum produto cadastrado.',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    final products = snapshot.data!;

                    return ListView.separated(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 80, top: 8),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        var doc = products[i];

                        return Slidable(
                          key: ValueKey(doc.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) =>
                                    controller.updateProduct(context, doc),
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Editar',
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16)),
                              ),
                              SlidableAction(
                                onPressed: (context) => controller
                                    .showDialogExcluir(context, doc.id),
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Excluir',
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(16)),
                              ),
                            ],
                          ),
                          child: _buildListItem(doc, colorScheme),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(ProductData doc, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: doc.disponivel ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: doc.imagemUrl != null && doc.imagemUrl!.isNotEmpty
              ? Image.network(doc.imagemUrl!,
                  width: 60, height: 60, fit: BoxFit.cover)
              : Container(
                  width: 60,
                  height: 60,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.bakery_dining, color: colorScheme.primary),
                ),
        ),
        title: Text(
          doc.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: doc.disponivel ? colorScheme.primary : Colors.grey,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            doc.descricao,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(doc.preco,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 15)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: doc.disponivel
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                doc.disponivel ? 'Disponível' : 'Falta',
                style: TextStyle(
                    color: doc.disponivel
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
