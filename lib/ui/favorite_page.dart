import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/widgets/card_restaurant.dart';

import '../provider/result_state.dart';

class FavoritPage extends StatelessWidget {
  static const routeName = 'Favorit';

  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'Restaurant Favorit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              itemCount: provider.favorit.length,
              itemBuilder: (context, index) {
                return CardRestaurant(restaurant: provider.favorit[index]);
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'Restaurant Favorit No Data Now',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(
              child: Material(
                child: Text(provider.message),
              ),
            ),
          );
        }
      },
    );
  }
}