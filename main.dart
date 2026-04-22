import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProductPage(product: Product(name: 'Example Product', price: 100)),
  ));
}
class Product {
  String name;
  int price;

  Product({required this.name, required this.price});
}

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [
    Product(name: 'Kopi', price: 50000),
    Product(name: 'Chicken', price: 20000),
  ];
  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }
  void removeProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }
  void updateProduct(int index, Product product) {
    setState(() {
      products[index] = product;
    });
  }
  void showForm({Product? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name);
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString()
      );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name product'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price product'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                int price = int.parse(priceController.text);
                if (product == null) {
                  addProduct(Product(name: name, price: price));
                } else {
                  updateProduct(index!, Product(name: name, price: price));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // huruf diawali kecil namanya parameter, huruf besar widget
        title: Text('CRUD Product'),
        backgroundColor: const Color.fromARGB(255, 21, 143, 112),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text('Price: ${products[index].price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showForm(product: products[index], index: index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    removeProduct(products[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}