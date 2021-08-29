import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var hasProducts = true;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   });

  //   super.initState();
  // }

  var _isInit = true;
  var _showOnlyFavorites = false;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    try {
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });

        await Provider.of<Products>(context).fetchAndSetProducts().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    } catch (error) {
       if (error.toString() ==
           'type \'Null\' is not a subtype of type \'Map<String, dynamic>\' in type cast') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('No Products to show!'),
          content: Text('Please try again later or add products'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  hasProducts = false;
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Ok!'),
            )
          ],
        ),
      );
      }
      print(error);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('My Shop'),
        backgroundColor: Colors.purple[300],
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cartData.itemCount.toString(),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              child: ProductsGrid(_showOnlyFavorites, this.hasProducts),
              onRefresh: () => _refreshProducts(context),
            ),
    );
  }
}
