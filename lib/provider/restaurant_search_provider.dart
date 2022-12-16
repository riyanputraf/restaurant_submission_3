import 'dart:io';

import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant_search.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/provider/result_state.dart';



class RestaurantSearchProvider extends ChangeNotifier {
  late final ApiService apiService;
  final String query;

  RestaurantSearchProvider({required this.apiService, required this.query}) {
    _fetchSearchResto();
  }

  late RestaurantSearchModel _restaurantModelSearch;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantSearchModel get result => _restaurantModelSearch;

  ResultState get state => _state;

  Future<dynamic> _fetchSearchResto() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantSearchResult = await apiService.searchRestaurant(query);
      if (restaurantSearchResult.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Restaurant Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantModelSearch = restaurantSearchResult;
      }
    } on SocketException catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No internet connection';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error HALOO --> $e';
    }
  }
}