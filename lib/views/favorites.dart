import 'package:minicatalog/models/productModel.dart';
import 'package:minicatalog/components/miniCardTile.dart';
import 'package:flutter/material.dart';

class favorites extends StatefulWidget {
  

  final List<Data> products;
  final Set <int> favIds; 


  const favorites({super.key, required this.products, required this.favIds});

  @override
  State<favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<favorites> {

  @override
  Widget build(BuildContext context) {

    final favProducts = widget.products.where((element) => widget.favIds.contains(element.id)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Favorites"),
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
              child: favProducts.isEmpty ?

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_outlined,
                      size: 64,
                      color: const Color(0xFFB08968),
                    ),

                    SizedBox(height: 20,),
                    Text(
                      "This section is empty.",
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
                itemCount: favProducts.length,
                itemBuilder: (context, index) {
                  final product = favProducts [index];
                  final bool isFavorite = widget.favIds.contains(product.id);

                  return miniCardTile(
                    name: product.name ?? "", 
                    tagline: product.tagline ?? "", 
                    price: product.price ?? "" , 
                    imageUrl: product.image ?? "",
                    isFavorite: isFavorite,
                    onFavoriteTap: () {
                      setState(() {
                        widget.favIds.remove(product.id);
                      });
                    },
                    onRemove: () {
                      setState(() {
                        widget.favIds.remove(product.id);
                      });
                    }, );
                },
              )
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    
    
    );
  }
}