import 'package:geocoding/geocoding.dart';

Future<Map<String, String>> getCityAndCountry(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String city = place.locality ?? 'Unknown City';
      String country = place.country ?? 'Unknown Country';

      print('City name fetched successfully: $city');
      print('Country name fetched successfully: $country');

      return {
        'city': city,
        'country': country,
      };
    } else {
      print('No placemarks found for coordinates: Lat=$latitude, Lon=$longitude');
      return {
        'city': 'City Not Found',
        'country': 'Country Not Found',
      };
    }
  } catch (e) {
    print('Error during reverse geocoding: $e');
    return {
      'city': 'Error Finding City',
      'country': 'Error Finding Country',
    };
  }
}
