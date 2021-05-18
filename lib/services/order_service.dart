import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_app/models/Order.dart';

class OrderService{

  final Dio dio;

  OrderService(this.dio);

  void postData(String id) async {
    await dio
        .post("https://restura-backend.herokuapp.com/api/bomb_order/" + id);
  }

  Future<List<Order>> getOrders() async {
    print('hare');
    final _authority = "restura-backend.herokuapp.com";
    final _path = "/api/list_order";
    var data = await http.get(Uri.https(_authority, _path));
    print(data.headers);
    var jsonData = json.decode(data.body) as List;
    List<Order> orders = [];
    print(jsonData.first['item'] as String);
    print(jsonData.first['customer'] as String);
    print(jsonData.first['quantity'] as int);
    print(jsonData.first['status'] as bool);
    print(DateTime.parse(jsonData.first['time']));
    // List.from(json)

    for (var o in jsonData) {
      print(o);
      Order order = Order(o['id'], o['customer'], o['item'], o['quantity'],
          DateTime.parse(o['time']), o['status']);
      print(order);

      orders.add(order);
    }

    return orders;
  }
}

