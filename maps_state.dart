import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_google_map/data/models/PlaceSuggestion.dart';


abstract class MapsState {

}

class MapsInitial extends MapsState{}

class PlacesLoaded extends MapsState{
  final List<PlaceSuggestion> places;

  PlacesLoaded(this.places);
}