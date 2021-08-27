import 'package:flutter/material.dart';
import 'package:my_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Products(),
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
    
          '/':(ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName:(ctx) =>ProductDetailScreen(),
    
        },
      ),
    );
  }
}
