import 'dart:convert';
import 'package:restaurant/data/model/restaurant_detail.dart';
import 'package:restaurant/data/model/restaurant_search.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/model/restaurant.dart';



class ApiService {

  Future<RestaurantModel> listRestaurant(http.Client client) async {
    final response = await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      return RestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<RestaurantDetailModels> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailModels.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<RestaurantSearchModel> searchRestaurant(String query) async {
    final response = await http
        .get(Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
