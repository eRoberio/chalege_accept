import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Servico de localizacao desativado.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Permissao de localizacao negada.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Stream<Position> positionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 8,
      ),
    );
  }

  Future<String> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) {
      return 'Endereco nao encontrado';
    }

    final place = placemarks.first;
    final street = place.street ?? '';
    final number = place.subThoroughfare ?? '';
    final neighborhood = place.subLocality ?? '';
    final city = place.locality ?? '';
    final state = place.administrativeArea ?? '';

    return [street, number, neighborhood, city, state]
        .where((item) => item.trim().isNotEmpty)
        .join(', ');
  }

  Future<({double latitude, double longitude})?> geocodeAddress(
      String address) async {
    if (address.trim().isEmpty) {
      return null;
    }

    final locations = await locationFromAddress(address);
    if (locations.isEmpty) {
      return null;
    }

    final first = locations.first;
    return (latitude: first.latitude, longitude: first.longitude);
  }
}
