import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String title;
  // final String id;
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Product>(context, listen: false,);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments:productData.id,);
          },
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, productData, _)=>
            IconButton(
              icon: Icon(productData.isFavorite ?
                Icons.favorite : Icons.favorite_border,
              ),
              color:Theme.of(context).accentColor,
              onPressed: () {
                productData.toggleFavoriteStatus();
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            color:Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
