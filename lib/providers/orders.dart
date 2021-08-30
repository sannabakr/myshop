import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? _authToken;
  List<OrderItem> get orders {
    return [..._orders];
  }

  void update(authToken, List<OrderItem>? orders) {
    if(orders == null){
      _orders=[];
    }else {
      _orders=orders;
    }
    _authToken = authToken;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://my-shop-9e159-default-rtdb.firebaseio.com/orders.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://my-shop-9e159-default-rtdb.firebaseio.com/orders.json?auth=$_authToken';
    final response = await http.get(
      Uri.parse(url),
    );
    final List<OrderItem> loadedOrders = [];

    Map<String?, dynamic>? extractedData =
        json.decode(response.body);
    if (extractedData == null) {
      return;
    } else{
      extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId!,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList()),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    }
    
  }
}
