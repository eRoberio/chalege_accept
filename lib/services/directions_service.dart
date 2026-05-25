import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteInfo {
  RouteInfo({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> points;
  final int distanceMeters;
  final int durationSeconds;
}

class DirectionsService {
  static final Map<String, RouteInfo> _cache = <String, RouteInfo>{};

  static const _endpoint =
      'https://maps.googleapis.com/maps/api/directions/json';

  Future<RouteInfo?> getDrivingRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final cacheKey = _buildCacheKey(origin, destination);
    final cached = _cache[cacheKey];
    if (cached != null) {
      return cached;
    }

    const apiKey = String.fromEnvironment('AIzaSyBeq6d7GOUC2Mne6aGgh0XNq0qeYFR7yUM');
    if (apiKey.isEmpty) {
      return null;
    }

    final uri = Uri.parse(
      '$_endpoint?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=driving&language=pt-BR&key=$apiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String?;
    if (status != 'OK') {
      return null;
    }

    final routes = decoded['routes'] as List<dynamic>;
    if (routes.isEmpty) {
      return null;
    }

    final route = routes.first as Map<String, dynamic>;
    final legs = (route['legs'] as List<dynamic>?) ?? const [];
    final firstLeg = legs.isNotEmpty
        ? legs.first as Map<String, dynamic>
        : <String, dynamic>{};

    final distanceMeters =
        ((firstLeg['distance'] as Map<String, dynamic>?)?['value'] as num?)
                ?.toInt() ??
            0;
    final durationSeconds =
        ((firstLeg['duration'] as Map<String, dynamic>?)?['value'] as num?)
                ?.toInt() ??
            0;

    final overviewPolyline = ((route['overview_polyline']
            as Map<String, dynamic>?)?['points'] as String?) ??
        '';
    if (overviewPolyline.isEmpty) {
      return null;
    }

    final points = _decodePolyline(overviewPolyline);
    final result = RouteInfo(
      points: points,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );

    _cache[cacheKey] = result;
    return result;
  }

  String _buildCacheKey(LatLng origin, LatLng destination) {
    String f(double v) => v.toStringAsFixed(5);
    return '${f(origin.latitude)},${f(origin.longitude)}|${f(destination.latitude)},${f(destination.longitude)}';
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
