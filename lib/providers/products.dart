import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String? _authToken;
  String? _userId;

  void update(authToken, List<Product>? items, String userId) {
    if (items == null) {
      _items = [];
    } else {
      _items = items;
    }
    _authToken = authToken;
    _userId = userId;
    notifyListeners();
  }

// var _showFavoritesOnly = false;
  List<Product> get items {
    // if(_showFavoritesOnly){
    // return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }

    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> addProduct(Product product) async {
    final url =
        'https://my-shop-9e159-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'userId':_userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);

      //_items.insert(0, newProduct)

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://my-shop-9e159-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('the item does not exist');
    }
  }

  Future<void> fetchAndSetProducts([bool  filterByUser=false]) async {
    final filterString = filterByUser ? '&orderBy="userId"&equalTo="$_userId"' : '';
    var url =
        'https://my-shop-9e159-default-rtdb.firebaseio.com/products.json?auth=$_authToken$filterString';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
 url =
        'https://my-shop-9e159-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';

      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData= json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: favoriteData==null? false: favoriteData[prodId]?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      print(favoriteResponse.body);
    } catch (error) {
      throw error;
      
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-shop-9e159-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
    print(response.statusCode);
  }
}
