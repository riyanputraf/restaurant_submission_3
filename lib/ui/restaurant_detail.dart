import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/provider/restaurant_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/result_state.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/article_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), id: restaurant.id),
      child: Consumer<RestaurantDetailProvider>(builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFFF5B00),
            ),
          ));
        } else if (state.state == ResultState.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.result.restaurant.name),
            ),
            body: Consumer<DatabaseProvider>(
              builder: (context, provider, child) {
                return FutureBuilder<bool>(
                  future: provider.isFavoriteRestaurant(restaurant.id),
                    builder: (context, snapshot) {
                      var isFavorited = snapshot.data ?? false;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Hero(
                                    tag: state.result.restaurant.pictureId,
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.network(
                                            'https://restaurant-api.dicoding.dev/images/large/${state.result.restaurant.pictureId}'))),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(state.result.restaurant.name,
                                            style: const TextStyle(
                                                fontSize: 25, fontWeight: FontWeight.bold)),
                                      ),
                                      isFavorited ? IconButton(
                                        onPressed: () => provider.removeFavoritRestaurant(
                                            state.result.restaurant.id),
                                        icon: const Icon(Icons.favorite),
                                        color: Colors.redAccent,
                                      ) : IconButton(
                                        onPressed: () =>
                                            provider.addFavoritRestaurant(restaurant),
                                        icon: const Icon(Icons.favorite_border),
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(

                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        state.result.restaurant.city,
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        state.result.restaurant.rating.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                'Description',
                                style:
                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                state.result.restaurant.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text('Foods',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text(state
                                            .result.restaurant.menus.foods[index].name
                                            .toString())),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 5,
                                  );
                                },
                                itemCount: state.result.restaurant.menus.foods.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text('Drinks',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text(state
                                            .result.restaurant.menus.drinks[index].name
                                            .toString())),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return const Divider();
                                },
                                itemCount: state.result.restaurant.menus.drinks.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text('Review',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.only(left: 30, right: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(state
                                            .result.restaurant.customerReviews[index].name.toString(), style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text(state
                                            .result.restaurant.customerReviews[index].date.toString()
                                        ),
                                        SizedBox(height: 10),
                                        Text(state
                                            .result.restaurant.customerReviews[index].review.toString()
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return const Divider();
                                },
                                itemCount: state.result.restaurant.customerReviews.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                );
              }
            ),
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      }),
    );
  }
}
