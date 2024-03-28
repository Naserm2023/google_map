
import 'package:dio/dio.dart';

import '../../constants/strings.dart';

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices(){
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 20 * 1000),
      receiveTimeout: const Duration(milliseconds: 20 * 1000),
      receiveDataWhenStatusError: true,
    );
    
    dio = Dio(options);
  }
  
  Future<List<dynamic>> fetchSuggestions (String place , String sessionToken) async {
    
    try{
      Response response = await dio.get(suggestionsBaseUrl,queryParameters:{
        'input' : place,
        'types' : 'address',
        'coponents' : 'country:uae',
        'key' : googleApiKey,
        'sessiontoken' : sessionToken
      }
      );
      print(response.data['predictions']);
      print(response.statusCode);
      return response.data['predictions'];
    }
    catch(error){
      print(error.toString());
      return [];
    }
  }
}