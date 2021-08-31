import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_overview_screen.dart';
import 'providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import '../screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (_, auth, previousProducts) => previousProducts!
            ..update(
              auth.token,
              previousProducts.items,
              auth.userId,
            ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (_, auth, previousOrders) => previousOrders!
            ..update(
              auth.token,
              previousOrders.orders,
              auth.userId,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            backgroundColor: Colors.amber[50],
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'RobotoCondensed',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
