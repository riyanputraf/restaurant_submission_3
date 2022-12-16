
import 'package:flutter/material.dart';
import 'package:restaurant/data/db/db_helper.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/result_state.dart';


class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _fetchFavorit();
  }

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorit = [];
  List<Restaurant> get favorit => _favorit;

  void _fetchFavorit() async {
    _favorit = await databaseHelper.getFavoritResto();
    if (_favorit.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tambahkan Resto Favorit Anda';
    }
    notifyListeners();
  }

  void addFavoritRestaurant(Restaurant restaurant) async {
    try {
      await databaseHelper.addFavoritResto(restaurant);
      _fetchFavorit();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load data';
      notifyListeners();
    }
  }

  Future<bool> isFavoriteRestaurant(String id) async {
    final favoritedResto = await databaseHelper.getFavoritFromId(id);
    return favoritedResto.isNotEmpty;
  }

  void removeFavoritRestaurant(String id) async {
    try {
      await databaseHelper.removeFavoritResto(id);
      _fetchFavorit();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to remove data';
      notifyListeners();
    }
  }
}