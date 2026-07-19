import 'package:flutter/material.dart';

class miniCardTile extends StatelessWidget {

  final String name;
  final String tagline;
  final String price;
  final String imageUrl;
  final VoidCallback? onRemove;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;


  const miniCardTile({
    super.key,
    required this.name,
    required this.tagline,
    required this.price,
    required this.imageUrl,
    this.onRemove,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsetsGeometry.symmetric(vertical:10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5D8),
                borderRadius: BorderRadius.circular(10),
                image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.contain) : null,
              ),
              child: imageUrl.isEmpty
                ? const Icon(Icons.image, color: Color(0xFFB08968),) 
                : null,
            ),
            const SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B4226),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onFavoriteTap,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: const Color(0xFFB08968),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  Text(
                    tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF9C6B4F),
                    ),
                  ),

                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFF6B4226), fontSize: 14,
                    ),
                  )
                ],
              )
            ),

            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline),
              color: const Color(0xFFB08968),
            )
          ],
        ),
      )
    );
  }
}