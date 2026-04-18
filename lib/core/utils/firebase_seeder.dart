import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sample_data.dart';
import '../network/api_endpoints.dart';

class FirebaseSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedAll() async {
    try {
      debugPrint('Starting Firestore seeding...');
      
      await seedCategories();
      await seedProducts();
      await seedUserAddress();
      await seedCart();
      
      debugPrint('Firestore seeding completed successfully!');
    } catch (e) {
      debugPrint('Error during seeding: $e');
      rethrow;
    }
  }

  static Future<void> seedCategories() async {
    final collection = _firestore.collection(ApiEndpoints.categories);
    final snapshot = await collection.get();
    
    if (snapshot.docs.isNotEmpty) {
      debugPrint('Categories already exist. Skipping category seeding.');
      return;
    }

    debugPrint('Seeding categories...');
    for (var category in SampleData.categories) {
      await collection.doc(category['id']).set(category);
    }
    debugPrint('Categories seeded: ${SampleData.categories.length}');
  }

  static Future<void> seedProducts() async {
    final collection = _firestore.collection(ApiEndpoints.products);
    final snapshot = await collection.get();

    if (snapshot.docs.isNotEmpty) {
      debugPrint('Products already exist. Skipping product seeding.');
      return;
    }

    debugPrint('Seeding products...');
    for (var product in SampleData.products) {
      final id = product['id'] as String?;
      if (id != null) {
        await collection.doc(id).set(product);
      } else {
        await collection.add(product);
      }
    }
    debugPrint('Products seeded: ${SampleData.products.length}');
  }

  static Future<void> seedUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final uid = user.uid;
    final collection = _firestore.collection(ApiEndpoints.users).doc(uid).collection('addresses');
    final snapshot = await collection.get();
    
    if (snapshot.docs.isNotEmpty) {
      debugPrint('User addresses already exist. Skipping.');
      return;
    }

    debugPrint('Seeding default address...');
    await collection.add({
      'label': 'Home',
      'fullName': user.displayName ?? 'Test User',
      'phone': '+1 555 123 4567',
      'street': '123 Developer Way',
      'city': 'San Francisco',
      'state': 'CA',
      'zipCode': '94105',
      'country': 'USA',
      'isDefault': true,
    });
  }

  static Future<void> seedCart() async {
    final prefs = await SharedPreferences.getInstance();
    final existingCart = prefs.getString('CACHED_CART');
    if (existingCart != null && existingCart != '[]') {
       debugPrint('Cart already has items. Skipping cart seeding.');
       return;
    }

    // Default cart with 2 items based on sample data
    debugPrint('Seeding test cart...');
    final defaultCart = [
      {
        "id": "cart_1",
        "product": {
          "id": "prod_audio_1",
          "name": "Sonic Pure Headphones",
          "description": "Noise-canceling wireless headphones with studio-quality audio performance.",
          "price": 299.0,
          "imageUrl": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000",
          "category": "Audio",
          "brand": "Sonic",
          "stock": 24,
          "createdAt": DateTime.now().toIso8601String()
        },
        "quantity": 1,
        "selectedColor": "Black",
        "selectedSize": "Standard"
      },
      {
        "id": "cart_2",
        "product": {
          "id": "prod_tech_1",
          "name": "Horizon Ultra Smartphone",
          "description": "The next generation of mobile computing.",
          "price": 1099.0,
          "imageUrl": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=1000",
          "category": "Tech",
          "brand": "Horizon",
          "stock": 8,
          "createdAt": DateTime.now().toIso8601String()
        },
        "quantity": 2,
        "selectedColor": "Silver",
        "selectedSize": "256GB"
      }
    ];

    await prefs.setString('CACHED_CART', json.encode(defaultCart));
  }

  static Future<void> clearAllData() async {
    try {
      debugPrint('Clearing Firestore data...');
      
      // Clear Products
      final productsCollection = _firestore.collection(ApiEndpoints.products);
      final productsSnapshot = await productsCollection.get();
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear Categories
      final categoriesCollection = _firestore.collection(ApiEndpoints.categories);
      final categoriesSnapshot = await categoriesCollection.get();
      for (var doc in categoriesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear Orders
      final ordersCollection = _firestore.collection('orders');
      final ordersSnapshot = await ordersCollection.get();
      for (var doc in ordersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('CACHED_CART');

      debugPrint('Firestore data cleared successfully!');
    } catch (e) {
      debugPrint('Error during clearing data: $e');
      rethrow;
    }
  }
}
