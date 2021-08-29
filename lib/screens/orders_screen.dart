import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    //Future.delayed(Duration.zero).then((_) async {
    // _isLoading = true;

    // Provider.of<Orders>(
    //   context,
    //   listen: false,
    // ).fetchAndSetOrders().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders!'),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(
            context,
            listen: false,
          ).fetchAndSetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                //do error handling stuff here
                return Center(
                  child: Text('an error occured'),
                );
              } else {
                return Consumer<Orders>(builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) => OrderItem(
                      orderData.orders[index],
                    ),
                    itemCount: orderData.orders.length,
                  );
                });
              }
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
