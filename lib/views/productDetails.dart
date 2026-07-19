import 'package:minicatalog/models/productModel.dart';
import 'package:flutter/material.dart';

class productDetails extends StatefulWidget {

  final Data product;
  final Set<int> cartIds;
  final Set<int> favoriteIds;

  const productDetails({
    super.key,
    required this.product, 
    required this.cartIds,
    required this.favoriteIds,
  });

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  @override
  Widget build(BuildContext context) {

    final isFavorite = widget.favoriteIds.contains(widget.product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Back"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
    
    body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center( // Resmi yatay ve dikeyde ortalar
              child: Hero(
                tag: widget.product.id ?? 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.product.image ?? "",
                    height: 350,
                    width: 400, // double.infinity yerine ekranın ortasında durması için sabit bir genişlik verdik
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.product.name ?? "",
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {

                          setState(() {
                            if (isFavorite) {
                              widget.favoriteIds.remove(widget.product.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Removed from favorites."),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color.fromARGB(255, 30, 73, 45),)
                              );
                            } else {
                              widget.favoriteIds.add(widget.product.id ?? 0);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Added to favorites."),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color.fromARGB(255, 30, 73, 45),)
                              );
                            }
                          });

                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: const Color(0xFFB08968),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Text(widget.product.tagline ?? "",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF9C6B4F)),
                  ),
                  SizedBox(height: 16,),
                  Text("description",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
                  ),
                  SizedBox(height: 4,),
                  Text(widget.product.description ??"",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10,),
                  Text(widget.product.price ?? "",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
                  ),
        
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        widget.cartIds.add(widget.product.id ?? 0);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to cart."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color.fromARGB(255, 30, 73, 45),)
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
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),

    );
  }
}