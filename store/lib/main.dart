import 'package:flutter/material.dart';
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
void main() {
  runApp(OrderApp());
}


class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chocolate Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Define variables to hold product data and order details
  // List
  List<Product> products = [
    Product(name: 'DairyMilk', variants: [
      Variant(name: '10g - Regular', price: 10),
      Variant(name: '35g - Regular', price: 30),
      Variant(name: '110g - Regular', price: 80),
      Variant(name: '110g - Silk', price: 95),
    ]),
    Product(name: 'Perk', variants: [
      Variant(name: '10g - Regular', price: 10),
    ]),
    Product(name: 'KitKat', variants: [
      Variant(name: '10g - Regular', price: 10),
      Variant(name: '35g - Regular', price: 25),
      Variant(name: '75g - Regular', price: 25),
    ]),
     Product(name: 'FiveStar', variants: [
      Variant(name: '10g - Regular', price: 5),
     
    ]),
    // Define other products similarly
  ];

  List<OrderItem> orderItems = [];

  // Function to add an order item
  void addOrderItem(Product product, Variant variant, int quantity) {
    setState(() {
      orderItems.add(OrderItem(product: product, variant: variant, quantity: quantity));
    });
  }

  // Function to calculate total price
  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in orderItems) {
      totalPrice += item.variant.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  product.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: product.variants.length,
                itemBuilder: (context, variantIndex) {
                  Variant variant = product.variants[variantIndex];
                  return ListTile(
                    title: Text(variant.name),
                    trailing: SizedBox(
                      width: 100,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // Convert value to integer and add order item
                          int quantity = int.tryParse(value) ?? 0;
                          if (quantity > 0) {
                            addOrderItem(product, variant, quantity);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle order placement
          double totalPrice = calculateTotalPrice();
          // Show order summary
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Order Summary'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var item in orderItems)
                      Text('${item.product.name} - ${item.variant.name}: ${item.quantity}'),
                    SizedBox(height: 10),
                    Text('Total Price: ₹$totalPrice'),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Clear order items
                      setState(() {
                        orderItems.clear();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                    
                  ),
                ],
              );
            },
          );
        },
        label: Text('Place Order'),
        icon: Icon(Icons.shopping_cart),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
       bottomNavigationBar: SizedBox(height: 20),
    );
  }
}

class Product {
  final String name;
  final List<Variant> variants;

  Product({required this.name, required this.variants});
}

class Variant {
  final String name;
  final double price;

  Variant({required this.name, required this.price});
}

class OrderItem {
  final Product product;
  final Variant variant;
  final int quantity;

  OrderItem({required this.product, required this.variant, required this.quantity});
}
