import 'package:minicatalog/models/productModel.dart';
import 'package:flutter/material.dart';

class productTile extends StatelessWidget {
  final Data product;


  const productTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4226).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: product.id ?? 0,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(16)),
                child: Image.network(product.image ?? "")
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),),
                SizedBox(height: 1,),
                Text(product.tagline ?? "", style: const TextStyle(fontSize: 12, color: Color(0xFF9C6B4F)),), 
                SizedBox(height: 1,),
                Text(product.price ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6B4226)),), 
              ],
            ),
          )

        ],
      ),
    );
  }
}