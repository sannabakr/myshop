import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';

import 'screens/orders_screen.dart';
import 'screens/products_overview_screen.dart';
import 'providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          backgroundColor: Colors.amber[100],
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'RobotoCondensed',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx)=>OrdersScreen(),

        },
      ),
    );
  }
}
