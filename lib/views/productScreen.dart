import 'package:minicatalog/components/productTile.dart';
import 'package:minicatalog/services/apiService.dart';
import 'package:minicatalog/models/productModel.dart';
import 'package:minicatalog/views/cart.dart';
import 'package:minicatalog/views/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:minicatalog/views/profile.dart';

class productScreen extends StatefulWidget {
  const productScreen({super.key});

  @override
  State<productScreen> createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {

  final ApiService apiService = ApiService();
  List<Data> allProducts = [];
  bool isLoading = false;
  String errorMessage = '';

  Set<int> cartIds = {};
  Set<int> favoriteIds = {};

  Future<void> loadProducts() async {
    

    try {
       setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final productData = await apiService.fetchProducts();

    setState((){
      allProducts = productData.data ?? [];
      isLoading = false;
    });

    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA), // sıcak krem zemin
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Discover", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B4226),),),
                    
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B4226).withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                          
                          child: IconButton(
                            onPressed: (){
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context)=> profile(products: allProducts, favIds: favoriteIds,)
                                )
                              );
                            },
                            icon: const Icon(Icons.person_2_outlined),
                            iconSize: 26, color: const Color(0xFF6B4226),),
                        ),

                        SizedBox(width: 4,),

                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B4226).withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                          child: IconButton(
                            onPressed: (){
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context)=> cart(products: allProducts, cartIds: cartIds)
                                )
                              );
                            }, icon: const Icon(Icons.shopping_bag_outlined),
                            iconSize: 26, color: const Color(0xFF6B4226),),
                        ),
                      
                      
                      ],
                    ),
                ]),


              SizedBox(height: 8,),
              Text("Find your perfect device", style: TextStyle(fontSize: 16, color: const Color(0xFF9C6B4F)),),
              SizedBox(height: 16,),
              
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4226).withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFB08968)),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  onChanged: (value) {
                    // Handle search logic here
                  },
                ),
              ),

              SizedBox(height: 20,),

              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  'https://wantapi.com/assets/banner.png',
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 20,),

              if(isLoading == true)
                const Center(child: CircularProgressIndicator(color: Color(0xFFB08968)),)
              else if(errorMessage.isNotEmpty)
                Center(child: Text(errorMessage, style: const TextStyle(color: Color(0xFF6B4226))),)
              else
                Expanded(child: GridView.builder(
                  itemCount: allProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //HER SATİRDA İKİ ÜRÜN
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = allProducts [index];
                    return GestureDetector(
                      onTap:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => productDetails(product: product,cartIds: cartIds, favoriteIds: favoriteIds,),),);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B4226).withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: productTile(product: product),
                      ),
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}