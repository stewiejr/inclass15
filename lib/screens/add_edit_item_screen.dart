import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;

  const AddEditItemScreen({Key? key, this.item}) : super(key: key);

  @override
  _AddEditItemScreenState createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _quantityController = TextEditingController(
      text: widget.item?.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.item?.price.toString(),
    );
    _categoryController = TextEditingController(text: widget.item?.category);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        id: widget.item?.id,
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        category: _categoryController.text,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
      );

      if (widget.item == null) {
        await _firestoreService.addItem(item);
      } else {
        await _firestoreService.updateItem(item);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _deleteItem() async {
    if (widget.item?.id != null) {
      await _firestoreService.deleteItem(widget.item!.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
        actions: [
          if (widget.item != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _deleteItem),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
