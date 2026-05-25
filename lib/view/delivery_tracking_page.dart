import 'dart:async';
import 'package:chalege_accept/services/directions_service.dart';
import 'package:chalege_accept/services/location_service.dart';
import 'package:chalege_accept/services/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryTrackingPage extends StatefulWidget {
  const DeliveryTrackingPage({
    super.key,
    required this.orderId,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
  });

  final String? orderId;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String destinationAddress;

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  final _repository = Repository();
  final _locationService = LocationService();
  final _directionsService = DirectionsService();

  final _statusOptions = const [
    'novo',
    'aceito',
    'em_preparo',
    'saiu_para_entrega',
    'entregue',
    'cancelado'
  ];

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _liveLocationSubscription;
  String? _selectedOrderId;
  RouteInfo? _activeRoute;
  String? _routeKey;

  bool _loadingRoute = false;
  bool _updatingStatus = false;
  bool _updatingDriverLocation = false;
  bool _sharingLiveLocation = false;

  String _userRole = 'cliente';
  bool _isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    _selectedOrderId = widget.orderId;
    _loadUserRole();
  }

  @override
  void dispose() {
    _liveLocationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  bool get _isCliente => _userRole == 'cliente';
  bool get _isAdmin => !_isCliente;

  Future<void> _loadUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists)
          setState(() => _userRole =
              doc.data()!['role']?.toString().toLowerCase() ?? 'cliente');
      }
    } catch (e) {
      print("Erro role: $e");
    } finally {
      if (mounted) setState(() => _isLoadingRole = false);
    }
  }

  // --- MÉTODOS DE SERVIÇO ---
  Future<void> _updateStatus(String orderId, String status) async {
    setState(() => _updatingStatus = true);
    await _repository.updateOrderStatus(orderId, status);
    if (mounted) setState(() => _updatingStatus = false);
  }

  Future<void> _updateDriverLocationNow(String orderId) async {
    setState(() => _updatingDriverLocation = true);
    final pos = await _locationService.determinePosition();
    final addr = await _locationService.reverseGeocode(
        latitude: pos.latitude, longitude: pos.longitude);
    await _repository.updateDriverLocation(orderId,
        latitude: pos.latitude, longitude: pos.longitude, address: addr);
    if (mounted) setState(() => _updatingDriverLocation = false);
  }

  Future<void> _toggleLiveTracking(String orderId) async {
    if (_sharingLiveLocation) {
      await _liveLocationSubscription?.cancel();
      setState(() => _sharingLiveLocation = false);
    } else {
      _liveLocationSubscription =
          _locationService.positionStream().listen((pos) {
        _repository.updateDriverLocation(orderId,
            latitude: pos.latitude, longitude: pos.longitude, address: '');
      });
      setState(() => _sharingLiveLocation = true);
    }
  }

  // --- MÉTODOS DE UI E MAPA ---
  Widget _buildOrderQueueHeader() {
    if (_isCliente) return const SizedBox.shrink();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _repository.watchRecentOrders(limit: 25),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final docs = snapshot.data!.docs;
        return SizedBox(
            height: 60,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: docs
                    .map((doc) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: ChoiceChip(
                            label: Text(
                              '${doc.id.substring(0, 6)} · ${_formatStatusLabel((doc.data()['status'] ?? 'novo').toString())}',
                            ),
                            selected: doc.id == _selectedOrderId,
                            onSelected: (_) =>
                                setState(() => _selectedOrderId = doc.id))))
                    .toList()));
      },
    );
  }

  Widget _buildAdminOrdersList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _repository.watchRecentOrders(limit: 50),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('Nenhum pedido encontrado.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final doc = docs[index];
            final data = doc.data();
            final status = (data['status'] as String?) ?? 'novo';
            final cliente = (data['cliente'] as String?) ?? 'Cliente';
            final subtotal = (data['subtotal'] as num?)?.toDouble() ?? 0;

            return Card(
              child: ListTile(
                onTap: () => setState(() => _selectedOrderId = doc.id),
                title: Text(cliente),
                subtitle:
                    Text('Pedido ${doc.id.substring(0, 8).toUpperCase()}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrencyBRL(subtotal),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatStatusLabel(status),
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatStatusLabel(String status) =>
      status.toUpperCase().replaceAll('_', ' ');

  Color _getStatusColor(String status) {
    switch (status) {
      case 'entregue':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatCurrencyBRL(double value) {
    final clean = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $clean';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) return const Center(child: CircularProgressIndicator());
    final orderId = _selectedOrderId ?? widget.orderId;
    if (orderId == null) {
      if (_isAdmin) {
        return Column(
          children: [
            _buildOrderQueueHeader(),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Todos os pedidos',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(child: _buildAdminOrdersList()),
          ],
        );
      }
      return const Center(child: Text('Nenhum pedido selecionado.'));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _repository.watchOrder(orderId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!.data() ?? <String, dynamic>{};
        final status = data['status'] as String? ?? 'novo';
        final subtotal = (data['subtotal'] as num?)?.toDouble() ?? 0;
        final cliente = (data['cliente'] as String?) ?? 'Cliente';

        return Column(
          children: [
            _buildOrderQueueHeader(),
            if (_isAdmin)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cliente,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(_formatCurrencyBRL(subtotal)),
                  ],
                ),
              ),
            Expanded(
                child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(-14.7936, -39.0400), zoom: 14),
              onMapCreated: (c) => _mapController = c,
            )),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedido: ${orderId.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // AQUI ENTRA A LÓGICA DE CARGOS:
                  if (!_isCliente) ...[
                    DropdownButtonFormField<String>(
                      value: _statusOptions.contains(status) ? status : 'novo',
                      items: _statusOptions
                          .map((s) => DropdownMenuItem(
                              value: s, child: Text(_formatStatusLabel(s))))
                          .toList(),
                      onChanged: (v) => _updateStatus(orderId, v!),
                      decoration:
                          const InputDecoration(labelText: 'Status do Pedido'),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () =>
                                  _updateDriverLocationNow(orderId),
                              child: const Text('Atualizar Posição'))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: FilledButton(
                              onPressed: () => _toggleLiveTracking(orderId),
                              child: Text(_sharingLiveLocation
                                  ? 'Pausar Live'
                                  : 'Iniciar Live'))),
                    ]),
                  ] else ...[
                    Text('Status atual: ${_formatStatusLabel(status)}',
                        style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold)),
                  ]
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
