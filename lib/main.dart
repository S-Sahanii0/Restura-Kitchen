import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert'; //deserialize
import 'dart:developer';

void main() => runApp(new Home()); //like a wrapper for rest of our app

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new OrderView(title: 'Restura'),
    );
  }
}

class OrderView extends StatefulWidget {
  OrderView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OrderViewState createState() => new _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  Dio dio = new Dio();


  void postData(String id) async {
    await dio
        .post("https://restura-backend.herokuapp.com/api/bomb_order/" + id);
    setState(() {});
  }

  Future<List<Order>> _getOrders() async {
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
    print(orders);
    print("hi");
    print(orders.length);
    debugPrint(data.toString());
    int i = orders.length;
    log("the : $i");
    // log
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restura'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Center(
        child: SizedBox(
          width: 380,
          child: FutureBuilder(
              future: _getOrders(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                return (snapshot.data != null)
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data);
                          return Card(
                            elevation: 8,
                            margin: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16), //todo make this 16
                              child: ListTile(
                                leading: Icon(
                                  Icons.fastfood_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            (snapshot.data[index].item),
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize:
                                                    16), //todo make the heading bigger and other small
                                          ),
                                          Text(
                                            (snapshot.data[index].customer),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "Quantity: " +
                                                (snapshot.data[index].quantity
                                                    .toString()),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "Status: " +
                                                (snapshot.data[index].status
                                                    .toString()),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: OutlinedButton(
                                            child: Text(
                                              (snapshot.data[index].status)
                                                  ? 'Complete'
                                                  : 'Pending',
                                              style: TextStyle(
                                                  color: Colors.lightBlue),
                                            ),
                                            onPressed: () => postData(snapshot
                                                .data[index].id
                                                .toString())),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                    : Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
              }),
        ),
      ),
    );
  }
}

class Order {
  final int id;
  final String customer;
  final String item;
  final int quantity;
  final DateTime time;
  final bool status;

  Order(
      this.id, this.customer, this.item, this.quantity, this.time, this.status);

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "customer": this.customer,
      "item": this.item,
      "quantity": this.quantity,
      "time": this.time.toIso8601String(),
      "status": this.status,
    };
  }

  // factory Order.fromJson(Map<String, dynamic> json) {
  //   return Order(
  //     customer: json["customer"],
  //     item: json["item"],
  //     quantity: int.parse(json["quantity"]),
  //     time: DateTime.parse(json["time"]),
  //     status: json["status"].toLowerCase() == 'true',
  //   );
  // }
//
}
