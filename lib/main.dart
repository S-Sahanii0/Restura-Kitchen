import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/services/order_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert'; //deserialize
import 'dart:developer';

import 'models/Order.dart';

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
  @override
  final OrderService _orderService = OrderService(Dio());
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
              future: _orderService.getOrders(),
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
                                          onPressed: () {
                                             _orderService.postData(snapshot.data[index].id
                                                .toString());
                                            setState(() {});
                                          },
                                        ),
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
