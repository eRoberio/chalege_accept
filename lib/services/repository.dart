import 'package:chalege_accept/models/product_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Repository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> uploadImageToImgbb(File imageFile) async {
    // Sua chave de API confirmada
    const apiKey = '673078b279dbbca24e571f753f434d1e';
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        url,
        body: {'image': base64Image},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url']; // Retorna a URL direta da imagem
      } else {
        throw Exception('Erro no ImgBB: ${response.body}');
      }
    } catch (e) {
      print("Erro no upload: $e");
      rethrow;
    }
  }

  Future<String> create(ProductData product) async {
    try {
      await _db.collection('products').add({
        'nome': product.nome,
        'descricao': product.descricao,
        'preco': product.preco,
        'disponivel': product.disponivel,
        'dataCadastro': product.dataCadastro,
        'imagemUrl': product.imagemUrl, // Agora garantiremos que não vá null
        'excluido': false, // Essencial para o índice funcionar
      });
      return 'Produto criado com sucesso';
    } catch (e) {
      return 'Falha ao criar produto';
    }
  }

  Future<List<ProductData>> buscarDados() async {
    // O filtro 'excluido == false' fará o produto sumir da lista após deletar
    QuerySnapshot snapshot = await _db
        .collection('products')
        .where('excluido', isEqualTo: false)
        .orderBy('dataCadastro', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ProductData(
        id: doc.id,
        nome: data['nome'] ?? '',
        descricao: data['descricao'] ?? '',
        preco: data['preco'] ?? '',
        disponivel: data['disponivel'] ?? true,
        dataCadastro: data['dataCadastro'] ?? Timestamp.now(),
        imagemUrl: data['imagemUrl'], // Mapeamento da URL para a UI
      );
    }).toList();
  }

  Future<String> delete2(String id) async {
    try {
      await _db.collection('products').doc(id).update({'excluido': true});
      return 'Produto excluído com sucesso';
    } catch (e) {
      return 'Falha ao excluir produto';
    }
  }

  Future<String> update(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('products').doc(id).update(data);
      return 'Produto atualizado com sucesso';
    } catch (e) {
      return 'Falha ao atualizar produto';
    }
  }

  Future<String> createOrder(Map<String, dynamic> data) async {
    try {
      await _db.collection('orders').add(data);
      return 'Pedido finalizado com sucesso';
    } catch (e) {
      return 'Falha ao finalizar pedido';
    }
  }

  Future<String?> createOrderAndReturnId(Map<String, dynamic> data) async {
    try {
      final doc = await _db.collection('orders').add(data);
      return doc.id;
    } catch (e) {
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchOrder(String orderId) {
    return _db.collection('orders').doc(orderId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentOrders({
    int limit = 20,
  }) {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDriverLocation(
    String orderId, {
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    await _db.collection('orders').doc(orderId).update({
      'entregadorLocalizacao': {
        'latitude': latitude,
        'longitude': longitude,
        'endereco': address,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Adicione este método dentro da classe Repository no arquivo repository.dart

  /// Faz upload usando uma String Base64 (necessário para Flutter Web)
  Future<String> uploadBase64ImageToImgbb(String base64Image) async {
    const apiKey = '673078b279dbbca24e571f753f434d1e';
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    try {
      final response = await http.post(
        url,
        body: {
          'image': base64Image, // Passa a string base64 direto
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        throw Exception('Falha ImgBB Web: ${response.body}');
      }
    } catch (e) {
      print("Erro upload web: $e");
      rethrow;
    }
  }
}
