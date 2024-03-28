import 'package:fresh_google_map/data/models/PlaceSuggestion.dart';
import 'package:fresh_google_map/data/webservices/PlacesWebservices.dart';

class MapsRepository{
  final PlacesWebservices placesWebservices;

  MapsRepository(this.placesWebservices);

  Future<List<PlaceSuggestion>> fetchSuggestions (String place , String sessionToken) async {

  final suggestions = await placesWebservices.fetchSuggestions(place, sessionToken);

  return suggestions.map((suggestion) => PlaceSuggestion.fromJson(suggestion)).toList();
  }

}