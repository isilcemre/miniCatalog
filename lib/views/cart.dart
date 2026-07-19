import 'package:minicatalog/models/productModel.dart';
import 'package:minicatalog/components/miniCardTile.dart';
import 'package:flutter/material.dart';
import 'package:minicatalog/views/checkout.dart';


class cart extends StatefulWidget {


  final List<Data> products;
  final Set <int> cartIds; 

  const cart({super.key, required this.products, required this.cartIds});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  @override
  Widget build(BuildContext context) {

    final cartProducts = widget.products.where((element) => widget.cartIds.contains(element.id)).toList();



    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: cartProducts.isEmpty ?

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: const Color(0xFFB08968),
                    ),

                    SizedBox(height: 20,),
                    Text(
                      "Your cart is empty.",
                      style: TextStyle(color: const Color(0xFF6B4226)),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Add items now.",
                      style: TextStyle(color: const Color(0xFF9C6B4F)),
                    ),
                  ],
                ),
              )
              :ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts [index];

                  return miniCardTile(
                    name: product.name ?? "", 
                    tagline: product.tagline ?? "", 
                    price: product.price ?? "" , 
                    imageUrl: product.image ?? "",
                    onRemove: () {
                      setState(() {
                        widget.cartIds.remove(product.id);
                      });
                    }, );
                },
              )
            ),
            SizedBox(height: 20,),


            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF6B4226).withOpacity(0.15)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B4226).withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: const Color(0xFFB08968)),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tempus, lorem sed volutpat eleifend, ligula est convallis odio, non mollis urna velit vehicula lectus.",
                    style: TextStyle(color: const Color(0xFF6B4226),
                    fontSize: 13),),
                  ),
                ],
              ),
            ),


            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                if (cartProducts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your cart is empty.")),
                );
                return;
              }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => checkout(cartProducts: cartProducts),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4226),
                minimumSize: Size(double.infinity, 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(14)
                )
              ),
              child: Text(
                "Buy Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    
    
    );
  }
}