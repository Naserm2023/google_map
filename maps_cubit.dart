import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_google_map/business_logic/cubit/maps/maps_state.dart';
import 'package:fresh_google_map/data/models/PlaceSuggestion.dart';
import 'package:fresh_google_map/data/repository/maps_repo.dart';
import 'package:meta/meta.dart';

class MapsCubit extends Cubit<MapsState> {

  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void emitPlaceSuggestions(String place , String sessionToken){
    mapsRepository.fetchSuggestions(place, sessionToken).then((suggestions) {
      emit(PlacesLoaded(suggestions));
    });
  }
}