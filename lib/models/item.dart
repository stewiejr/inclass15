import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final DateTime createdAt;

  Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      id: id,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
