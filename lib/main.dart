import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// HomePage widget from the document [cite: 78]
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers from document [cite: 79-80]
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // --- START: Added for Task #3 (Search/Filter) ---
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // State variables to hold filter values
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;

  // Listener for the search field to update in real-time [cite: 114]
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  // Clean up controllers
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  // Function to apply price filters
  void _applyPriceFilter() {
    setState(() {
      _minPrice = double.tryParse(_minPriceController.text);
      _maxPrice = double.tryParse(_maxPriceController.text);
    });
  }

  // Function to reset all filters [cite: 120]
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _searchQuery = '';
      _minPrice = null;
      _maxPrice = null;
    });
  }
  // --- END: Added for Task #3 ---

  final CollectionReference _products = FirebaseFirestore.instance.collection(
    'products',
  ); // [cite: 80]

  // Create/Update function from document [cite: 81-94]
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(action == 'create' ? 'Create' : 'Update'),
                onPressed: () async {
                  String name = _nameController.text;
                  double? price = double.tryParse(_priceController.text);
                  if (name.isNotEmpty && price != null) {
                    if (action == 'create') {
                      await _products.add({"name": name, "price": price});
                    }
                    if (action == 'update') {
                      await _products.doc(documentSnapshot!.id).update({
                        "name": name,
                        "price": price,
                      });
                    }
                    _nameController.text = '';
                    _priceController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- START: Completed "TO DO" Task  ---
  // Deleting a product by id
  Future<void> _deleteProduct(String productId) async {
    // This is the missing line to delete the document
    await _products.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have successfully deleted a product')),
    );
  }
  // --- END: Completed "TO DO" Task ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD operations'), // [cite: 96]
      ),
      body: Column(
        children: [
          // --- START: UI for Task #3 (Search/Filter) ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar [cite: 113]
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by name',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 10),
                // Price Filter TextFields [cite: 118]
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Filter and Reset Buttons [cite: 119, 120]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _applyPriceFilter,
                      child: const Text('Filter'),
                    ),
                    ElevatedButton(
                      onPressed: _resetFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // --- END: UI for Task #3 ---

          // Using StreamBuilder to display all products [cite: 96]
          Expanded(
            child: StreamBuilder(
              stream: _products.snapshots(), // Fetches all products
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  // --- START: Filtering Logic for Task #3 ---

                  // Get all documents
                  final allDocs = streamSnapshot.data!.docs;

                  // Apply filters on the client side
                  final filteredDocs = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'].toString().toLowerCase();
                    // Use 'num' to handle both int and double from Firestore
                    final price = data['price'] as num;

                    // 1. Search Filter (case-insensitive "contains") [cite: 114, 116]
                    final nameMatches = name.contains(
                      _searchQuery.toLowerCase(),
                    );

                    // 2. Price Filter [cite: 119]
                    final minMatch = (_minPrice == null || price >= _minPrice!);
                    final maxMatch = (_maxPrice == null || price <= _maxPrice!);

                    // Return true only if all filters match
                    return nameMatches && minMatch && maxMatch;
                  }).toList();

                  // "No products found" message [cite: 125]
                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  // --- END: Filtering Logic for Task #3 ---

                  // Use 'filteredDocs' instead of 'streamSnapshot.data!.docs'
                  return ListView.builder(
                    itemCount: filteredDocs.length, // Use filtered list
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          filteredDocs[index]; // Use filtered list
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(documentSnapshot['name']),
                          subtitle: Text(documentSnapshot['price'].toString()),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdate(documentSnapshot),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteProduct(documentSnapshot.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      // Add new product FAB from document [cite: 107]
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
