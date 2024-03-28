import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_google_map/business_logic/cubit/maps/maps_cubit.dart';
import 'package:fresh_google_map/business_logic/cubit/maps/maps_state.dart';
import 'package:fresh_google_map/data/models/PlaceSuggestion.dart';
import 'package:fresh_google_map/place_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';
import 'location-helper.dart';
import 'my-drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  List<PlaceSuggestion> places = [];

  FloatingSearchBarController controller = FloatingSearchBarController();

  static Position? position;

  final Completer<GoogleMapController> _mapcontroller =Completer();


  static final CameraPosition myCurrentLocationCameraPosition = CameraPosition(
      target: LatLng(position!.latitude, position!.longitude),
      bearing: 0.0,
      zoom: 15,
      tilt: 0.0
  );


  Future<void> getCurrentLocation() async{

    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }


  Widget buildMap(){
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapcontroller.complete(controller);
      },
    );
  }


  Future<void> _goToMyCurrentLocation () async{
    final GoogleMapController controller = await _mapcontroller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myCurrentLocationCameraPosition));
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }


  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    GlobalKey<FormState> floatingSearchBarKey = GlobalKey<FormState>();

    return FloatingSearchBar(borderRadius: BorderRadius.circular(50),
      key: floatingSearchBarKey,
      controller: controller,
      elevation: 6,
      hintStyle:const TextStyle(fontSize: 18),
      queryStyle:const TextStyle(fontSize: 18),
      hint: 'Search here',
      border:const BorderSide(
          style: BorderStyle.none
      ),
      margins:const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding:const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: Colors.blue,
      scrollPadding:const EdgeInsets.only(top: 16,bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
      getPlacesSuggestions(query);
      },
      onFocusChanged: (isFocused) {

      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(icon: Icon(Icons.place,color: Colors.black.withOpacity(0.6),), onPressed: () {

          },),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
            ],
          ),
        );
      },
    );
  }

  void getPlacesSuggestions(String query){
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context).emitPlaceSuggestions(query, sessionToken);
  }

  Widget buildSuggestionsBloc() {
   return  BlocBuilder<MapsCubit,MapsState>(
     builder: (context,state){
       if(state is PlacesLoaded){
         places = (state).places;
         if(places.isNotEmpty){
           return buildPlacesList();
         }else{
           return Container();
         }
       }else{
         return Container();
       }
     },
   );
}

Widget buildPlacesList(){
    return ListView.builder(
      itemBuilder: (ctx,index){
        return InkWell(
          onTap: (){
            controller.close();
          },
          child: PlaceItem(
            suggestion: places[index],
          ),
        );

      },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null ? buildMap() :const Center(child: CircularProgressIndicator(color:Colors.blue,),),

          buildFloatingSearchBar(),
        ],
      ),

      floatingActionButton: Container(
        margin:const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _goToMyCurrentLocation,
          child:const Icon(Icons.place,color: Colors.white,size: 30,),

        ),
      ),
    );
  }
}
