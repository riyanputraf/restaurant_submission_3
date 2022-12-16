import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/data/model/restaurant_search.dart';
import 'package:restaurant/provider/restaurant_search_provider.dart';
import 'package:restaurant/provider/result_state.dart';
import 'package:restaurant/ui/restaurant_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/resto_search';

  final String query;

  const RestaurantSearchPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantSearchProvider>(
      create: (_) =>
          RestaurantSearchProvider(apiService: ApiService(), query: query),
      child: Consumer<RestaurantSearchProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF5B00),
                  ),
                ));
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                foregroundColor: Colors.black,
                title: const Text(
                  'Pencarian Restaurant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Total restaurant ditemukan: ${state.result.founded.toString()}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        return _buildResultSearch(
                            context, state.result.restaurants[index]);
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Scaffold(
                  body: Center(
                    child: Text(state.message),
                  ),
                ),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Material(
                child: Scaffold(
                  body: Center(
                    child: Text(state.message),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _buildResultSearch(
    BuildContext context, RestaurantSearch restaurant) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: Restaurant(
              id: restaurant.id,
              city: restaurant.city,
              description: restaurant.id,
              name: restaurant.name,
              rating: restaurant.rating,
              pictureId: restaurant.pictureId));
    },
    child: Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(bottom: 20.0, top: 15.0),
      child: Row(
        children: [
          Hero(
            tag: 'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId!}',
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              width: 150,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId!}',
                width: 100,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      restaurant.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                      Text(
                        restaurant.city,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
