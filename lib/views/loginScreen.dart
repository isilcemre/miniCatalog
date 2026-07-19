import 'package:flutter/material.dart';
import 'package:minicatalog/services/localStorageService.dart';
import 'package:minicatalog/views/productScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final LocalStorageService localStorageService = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFFAF3EA),
      body: SafeArea(
        
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B4226).withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.wechat_outlined,
                        size: 40,
                        color: Color(0xFF6B4226),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey welcome back!!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6B4226),
                          ),
                        ),

                        Text("Plase enter your pasword and name to login", style: TextStyle(fontSize: 14, color: Color(0xFF9C6B4F)),)
                      ],
                    ),
                  ],
                ),
               
               
                SizedBox(height: 40,),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: Icon(Icons.person_outline, color: Color(0xFF6B4226),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none,),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 16,),
            
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF6B4226),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none,),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
            
            
                SizedBox(height: 24,),
                
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child:const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.white
                    ),
                  ), 
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      String username = nameController.text.trim();
                      localStorageService.saveData(username);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => productScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}