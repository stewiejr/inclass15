import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  final CollectionReference _itemsCollection = FirebaseFirestore.instance
      .collection('items');

  // Add a new item
  Future<void> addItem(Item item) async {
    await _itemsCollection.add(item.toMap());
  }

  // Get stream of items
  Stream<List<Item>> getItemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update an existing item
  Future<void> updateItem(Item item) async {
    if (item.id != null) {
      await _itemsCollection.doc(item.id).update(item.toMap());
    }
  }

  // Delete an item
  Future<void> deleteItem(String itemId) async {
    await _itemsCollection.doc(itemId).delete();
  }
}
