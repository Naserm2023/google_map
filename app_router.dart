import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_google_map/business_logic/cubit/maps/maps_cubit.dart';
import 'package:fresh_google_map/data/webservices/PlacesWebservices.dart';
import 'package:fresh_google_map/data/repository/maps_repo.dart';
import 'package:fresh_google_map/map-screen.dart';
import '../../constants/strings.dart';

class AppRouter {



  Route? generateRoute(RouteSettings settings){
    switch (settings.name){
      case MapScreen :
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                MapsCubit(MapsRepository(PlacesWebservices())),
            child: const MapScreen(),

          )
        );
    }
    return null;
  }
}