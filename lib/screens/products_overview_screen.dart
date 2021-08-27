import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';


class ProductsOverviewScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('My Shop'),
        backgroundColor: Colors.purple[300],
      ),
      body: ProductsGrid(),
    );
  }
}

