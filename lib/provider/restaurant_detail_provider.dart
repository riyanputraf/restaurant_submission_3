import 'dart:io';

import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant_detail.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/provider/result_state.dart';



class RestaurantDetailProvider extends ChangeNotifier {
  late final ApiService apiService;
  final String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _fetchDetailResto();
  }

  late RestaurantDetailModels _restaurantModelDetail;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantDetailModels get result => _restaurantModelDetail;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailResto() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.detailRestaurant(id);
      if (restaurantDetail.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Restaurant Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantModelDetail = restaurantDetail;
      }
    } on SocketException catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No internet connection';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}