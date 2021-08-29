import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String? id;
  final String imageUrl;
  UserProductsItem(
    this.title,
    this.imageUrl,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: const EdgeInsets.symmetric(
        // horizontal: 1,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        //Colors.yellow[100],
        //Colors.deepPurple[50],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: id,
                  );
                },
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(
                      context,
                      listen: false,
                    ).deleteProduct(id.toString());
                  } catch (error) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Deleting failed!', textAlign: TextAlign.center,),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
