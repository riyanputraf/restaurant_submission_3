import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';


void main() {
  test('Should return RestaurantModel when the response is successful',
          () async {
        final client = MockClient(
              (request) async {
            final response = {
              "error": false,
              "message": "success",
              "count": 20,
              "restaurants": []
            };
            return Response(json.encode(response), 200);
          },
        );

        expect(await ApiService().listRestaurant(client), isA<RestaurantModel>());
      });
}
