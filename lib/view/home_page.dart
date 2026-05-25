import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:chalege_accept/controllers/home_controller.dart';
import 'package:chalege_accept/controllers/product_controller.dart';
import 'package:chalege_accept/models/product_models.dart';
import 'package:chalege_accept/services/location_service.dart';
import 'package:chalege_accept/view/delivery_tracking_page.dart';
import 'package:chalege_accept/view/product_page.dart';
import 'package:chalege_accept/view/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class _HomeTab {
  const _HomeTab({
    required this.title,
    required this.destination,
    required this.page,
  });

  final String title;
  final NavigationDestination destination;
  final Widget page;
}

class HomePage extends StatefulWidget {
  static String tag = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I<HomeController>();
  final productController = GetIt.I<ProductController>();
  final locationService = LocationService();

  final _clienteController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final Map<String, int> _cart = <String, int>{};

  late PageController _pageController;

  bool _isFinishingOrder = false;
  bool _isLocatingAddress = false;
  double? _deliveryLatitude;
  double? _deliveryLongitude;
  String? _activeOrderId;

  bool _isAdmin = false;
  bool _loadingRole = true;

  bool _isAdminRole(String? role) {
    final normalized = role?.trim().toLowerCase();
    return normalized == 'admin' || normalized == 'administrador';
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: controller.page);
    productController.readProducts();
    _loadUserRole();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _enderecoController.dispose();
    _observacaoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _isAdmin = false;
            _loadingRole = false;
          });
        }
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = snapshot.data()?['role'] as String?;
      final tokenResult = await user.getIdTokenResult(true);
      final claimAdmin = tokenResult.claims?['admin'] == true ||
          tokenResult.claims?['role']?.toString().toLowerCase() == 'admin';

      if (mounted) {
        setState(() {
          _isAdmin = _isAdminRole(role) || claimAdmin;
          _loadingRole = false;
        });
        _ensurePageInRange();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isAdmin = false;
          _loadingRole = false;
        });
        _ensurePageInRange();
      }
    }
  }

  List<_HomeTab> _buildTabs() {
    final tabs = <_HomeTab>[
      _HomeTab(
        title: 'Painel D. Juan',
        destination: const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Vitrine',
        ),
        page: _ShowcaseTab(
          productsFuture: productController.products,
          onRefresh: _refreshCatalog,
          onAddToCart: _addToCart,
          cartCount: _cart.values.fold<int>(0, (a, b) => a + b),
          onOpenCheckout: () {
            controller.setPage(1);
            _pageController.animateToPage(
              1,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 280),
            );
          },
          parsePrice: _parsePrice,
          formatCurrency: _formatCurrency,
        ),
      ),
      _HomeTab(
        title: 'Checkout',
        destination: const NavigationDestination(
          icon: Icon(Icons.point_of_sale_outlined),
          selectedIcon: Icon(Icons.point_of_sale),
          label: 'Checkout',
        ),
        page: _CheckoutTab(
          productsFuture: productController.products,
          cart: _cart,
          clienteController: _clienteController,
          enderecoController: _enderecoController,
          observacaoController: _observacaoController,
          isFinishingOrder: _isFinishingOrder,
          isLocatingAddress: _isLocatingAddress,
          onRefreshCatalog: _refreshCatalog,
          onChangeQuantity: _changeQuantity,
          onFinish: _finishOrder,
          onUseCurrentLocation: _useCurrentLocationForCheckout,
          hasResolvedLocation:
              _deliveryLatitude != null && _deliveryLongitude != null,
          parsePrice: _parsePrice,
          formatCurrency: _formatCurrency,
        ),
      ),
      _HomeTab(
        title: 'Rastreamento',
        destination: const NavigationDestination(
          icon: Icon(Icons.alt_route_outlined),
          selectedIcon: Icon(Icons.alt_route),
          label: 'Rastreio',
        ),
        page: DeliveryTrackingPage(
          orderId: _activeOrderId,
          destinationLatitude: _deliveryLatitude,
          destinationLongitude: _deliveryLongitude,
          destinationAddress: _enderecoController.text.trim(),
        ),
      ),
    ];

    if (_isAdmin) {
      tabs.add(
        _HomeTab(
          title: 'Estoque',
          destination: const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Estoque',
          ),
          page: ProductPage(),
        ),
      );
    }

    tabs.add(
      _HomeTab(
        title: 'Meu Perfil',
        destination: const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
        page: ProfilePage(),
      ),
    );

    return tabs;
  }

  void _ensurePageInRange() {
    final tabsLength = _buildTabs().length;
    if (controller.page >= tabsLength) {
      final safeIndex = tabsLength - 1;
      controller.setPage(safeIndex);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(safeIndex);
      }
    }
  }

  Future<void> _refreshCatalog() async {
    productController.readProducts();
    await productController.products;
  }

  double _parsePrice(String raw) {
    final normalized = raw
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(normalized) ?? 0;
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  void _addToCart(ProductData product) {
    if (!product.disponivel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto indisponivel no momento.')),
      );
      return;
    }

    setState(() {
      _cart.update(product.id, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void _changeQuantity(String productId, int delta) {
    setState(() {
      final current = _cart[productId] ?? 0;
      final next = current + delta;
      if (next <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = next;
      }
    });
  }

  Future<void> _useCurrentLocationForCheckout() async {
    setState(() => _isLocatingAddress = true);
    try {
      final position = await locationService.determinePosition();
      String address;
      try {
        address = await locationService.reverseGeocode(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (_) {
        address =
            'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
      }

      if (mounted) {
        setState(() {
          _deliveryLatitude = position.latitude;
          _deliveryLongitude = position.longitude;
          _enderecoController.text = address;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao obter localizacao: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLocatingAddress = false);
      }
    }
  }

  Future<void> _resolveDestinationFromAddress() async {
    if (_deliveryLatitude != null && _deliveryLongitude != null) {
      return;
    }

    final result = await locationService.geocodeAddress(
      _enderecoController.text.trim(),
    );
    if (result == null) {
      return;
    }

    _deliveryLatitude = result.latitude;
    _deliveryLongitude = result.longitude;
  }

  Future<void> _finishOrder(List<ProductData> catalog) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Adicione produtos ao carrinho primeiro.')),
      );
      return;
    }

    if (_clienteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do cliente.')),
      );
      return;
    }

    setState(() => _isFinishingOrder = true);

    try {
      await _resolveDestinationFromAddress();

      double subtotal = 0;
      for (final entry in _cart.entries) {
        final product = catalog.where((item) => item.id == entry.key).first;
        subtotal += _parsePrice(product.preco) * entry.value;
      }

      if (subtotal <= 9.99) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido minimo: R\$ 10,00.')),
        );
        setState(() => _isFinishingOrder = false);
        return;
      }

      await _startAdyenCheckoutFlow(catalog, subtotal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
      setState(() => _isFinishingOrder = false);
    }
  }

  Future<void> _startAdyenCheckoutFlow(
    List<ProductData> catalog,
    double subtotal,
  ) async {
    bool paymentApproved = false;

    // Keeping import/use ready for future real Adyen backend integration.
    final _ = Environment.test;

    paymentApproved = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _buildSimulatedAdyenDropIn(subtotal),
        ) ??
        false;

    if (paymentApproved) {
      await _saveOrderToFirestore(catalog, subtotal);
    } else {
      setState(() => _isFinishingOrder = false);
    }
  }

  Future<void> _saveOrderToFirestore(
    List<ProductData> catalog,
    double subtotal,
  ) async {
    final items = <Map<String, dynamic>>[];
    for (final entry in _cart.entries) {
      final product = catalog.where((item) => item.id == entry.key).first;
      final qty = entry.value;
      final unitPrice = _parsePrice(product.preco);
      items.add({
        'productId': product.id,
        'nome': product.nome,
        'quantidade': qty,
        'precoUnitario': unitPrice,
        'totalItem': unitPrice * qty,
      });
    }

    final payload = {
      'cliente': _clienteController.text.trim(),
      'endereco': _enderecoController.text.trim(),
      'observacao': _observacaoController.text.trim(),
      'itens': items,
      'subtotal': subtotal,
      'status': 'novo',
      'origem': 'painel_admin',
      'localizacaoEntrega': {
        'latitude': _deliveryLatitude,
        'longitude': _deliveryLongitude,
        'endereco': _enderecoController.text.trim(),
      },
      'createdAt': FieldValue.serverTimestamp(),
    };

    final orderId =
        await productController.repository.createOrderAndReturnId(payload);

    if (orderId != null) {
      setState(() {
        _activeOrderId = orderId;
        _cart.clear();
        _clienteController.clear();
        _enderecoController.clear();
        _observacaoController.clear();
        _deliveryLatitude = null;
        _deliveryLongitude = null;
      });

      controller.setPage(2);
      _pageController.animateToPage(
        2,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 280),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento aprovado e pedido criado!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() => _isFinishingOrder = false);
  }

  Widget _buildSimulatedAdyenDropIn(double amount) {
    bool processing = false;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Checkout Seguro',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Valor: ${_formatCurrency(amount)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Cartao de credito'),
                subtitle: Text('Simulacao Adyen Drop-in'),
              ),
              const ListTile(
                leading: Icon(Icons.qr_code_2),
                title: Text('PIX'),
                subtitle: Text('Pagamento instantaneo'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: processing
                    ? null
                    : () async {
                        setModalState(() => processing = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                icon: processing
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock_outline),
                label: Text(processing ? 'Processando...' : 'Pagar agora'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed:
                    processing ? null : () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabs = _buildTabs();
    _ensurePageInRange();

    if (_loadingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Observer(
          builder: (_) {
            final idx = controller.page.clamp(0, tabs.length - 1);
            return Text(tabs[idx].title);
          },
        ),
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: controller.setPage,
          children: tabs.map((tab) => tab.page).toList(),
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) {
          return NavigationBar(
            selectedIndex: controller.page,
            onDestinationSelected: (index) {
              controller.setPage(index);
              _pageController.animateToPage(
                index,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 280),
              );
            },
            backgroundColor: Colors.white,
            indicatorColor: colorScheme.primary.withValues(alpha: 0.2),
            destinations: tabs.map((tab) => tab.destination).toList(),
          );
        },
      ),
    );
  }
}

class _ShowcaseTab extends StatelessWidget {
  const _ShowcaseTab({
    required this.productsFuture,
    required this.onRefresh,
    required this.onAddToCart,
    required this.cartCount,
    required this.onOpenCheckout,
    required this.parsePrice,
    required this.formatCurrency,
  });

  final Future<List<ProductData>> productsFuture;
  final Future<void> Function() onRefresh;
  final void Function(ProductData product) onAddToCart;
  final int cartCount;
  final VoidCallback onOpenCheckout;
  final double Function(String raw) parsePrice;
  final String Function(double value) formatCurrency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Panel Delivery D. Juan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Controle produtos, monte pedidos e finalize checkout rapido.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: cartCount > 0 ? onOpenCheckout : null,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: Text('Ir para checkout ($cartCount)'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Produtos da vitrine',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FutureBuilder<List<ProductData>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final products = snapshot.data ?? <ProductData>[];
                if (products.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhum produto disponivel.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (_, constraints) {
                    final crossAxisCount = constraints.maxWidth > 880
                        ? 4
                        : constraints.maxWidth > 600
                            ? 3
                            : 2;

                    return GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (_, index) {
                        final product = products[index];
                        final isAvailable = product.disponivel;
                        final price = formatCurrency(parsePrice(product.preco));

                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: product.imagemUrl != null &&
                                          product.imagemUrl!.isNotEmpty
                                      ? Image.network(
                                          product.imagemUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              _placeholderImage(),
                                        )
                                      : _placeholderImage(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.nome,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.descricao,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            price,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        IconButton.filledTonal(
                                          onPressed: isAvailable
                                              ? () => onAddToCart(product)
                                              : null,
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.brown.shade50,
      child: Icon(
        Icons.bakery_dining,
        color: Colors.brown.shade300,
      ),
    );
  }
}

class _CheckoutTab extends StatelessWidget {
  const _CheckoutTab({
    required this.productsFuture,
    required this.cart,
    required this.clienteController,
    required this.enderecoController,
    required this.observacaoController,
    required this.isFinishingOrder,
    required this.isLocatingAddress,
    required this.onRefreshCatalog,
    required this.onChangeQuantity,
    required this.onFinish,
    required this.onUseCurrentLocation,
    required this.hasResolvedLocation,
    required this.parsePrice,
    required this.formatCurrency,
  });

  final Future<List<ProductData>> productsFuture;
  final Map<String, int> cart;
  final TextEditingController clienteController;
  final TextEditingController enderecoController;
  final TextEditingController observacaoController;
  final bool isFinishingOrder;
  final bool isLocatingAddress;
  final Future<void> Function() onRefreshCatalog;
  final void Function(String productId, int delta) onChangeQuantity;
  final Future<void> Function(List<ProductData> catalog) onFinish;
  final Future<void> Function() onUseCurrentLocation;
  final bool hasResolvedLocation;
  final double Function(String raw) parsePrice;
  final String Function(double value) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefreshCatalog,
      child: FutureBuilder<List<ProductData>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final catalog = snapshot.data ?? <ProductData>[];
          final items = catalog
              .where((product) => cart.containsKey(product.id))
              .map((product) {
            final quantity = cart[product.id] ?? 0;
            final unitPrice = parsePrice(product.preco);
            return _CheckoutRow(
              product: product,
              quantity: quantity,
              unitPrice: unitPrice,
            );
          }).toList();

          final subtotal = items.fold<double>(
            0,
            (value, item) => value + (item.unitPrice * item.quantity),
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dados do cliente',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: clienteController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do cliente',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: enderecoController,
                        decoration: const InputDecoration(
                          labelText: 'Endereco para entrega',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: isLocatingAddress
                                  ? null
                                  : onUseCurrentLocation,
                              icon: isLocatingAddress
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.my_location_outlined),
                              label: const Text('Usar localizacao atual'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasResolvedLocation
                            ? 'Localizacao de entrega pronta para rastreamento.'
                            : 'Sem coordenadas ainda. Use localizacao atual ou um endereco detalhado.',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasResolvedLocation
                              ? Colors.green.shade700
                              : Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: observacaoController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Observacao',
                          prefixIcon: Icon(Icons.edit_note_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Itens do checkout',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                              'Carrinho vazio. Adicione itens na vitrine.'),
                        ),
                      for (final item in items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.product.nome),
                          subtitle: Text(
                            '${formatCurrency(item.unitPrice)} x ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    onChangeQuantity(item.product.id, -1),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () =>
                                    onChangeQuantity(item.product.id, 1),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Subtotal',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            formatCurrency(subtotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              isFinishingOrder ? null : () => onFinish(catalog),
                          icon: isFinishingOrder
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline),
                          label: Text(
                            isFinishingOrder
                                ? 'Finalizando...'
                                : 'Finalizar pedido',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CheckoutRow {
  _CheckoutRow({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  final ProductData product;
  final int quantity;
  final double unitPrice;
}
