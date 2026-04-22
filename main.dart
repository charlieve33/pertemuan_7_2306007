import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductPage(
      product: Product(
        name: 'Wisata',
        price: 100,
        imageUrl: 'https://picsum.photos/id/12/3888/2592',
      ),
    ),
  ));
}

class Product {
  String name;
  int price;
  String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [
    Product(
      name: 'Coffee',
      price: 50000,
      imageUrl: 'https://picsum.photos/id/2/3888/2592',
    ),
    Product(
      name: 'Bunga',
      price: 20000,
      imageUrl: 'https://picsum.photos/id/152/3888/2592',
    ),
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
    TextEditingController nameController =
        TextEditingController(text: product?.name);

    TextEditingController priceController =
        TextEditingController(text: product?.price.toString());

    TextEditingController imageController =
        TextEditingController(text: product?.imageUrl);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(product == null ? 'Add Product' : 'Edit Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PREVIEW GAMBAR
                    imageController.text.isNotEmpty
                        ? Image.network(
                            imageController.text,
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Image tidak valid');
                            },
                          )
                        : const Text('Belum ada gambar'),

                    const SizedBox(height: 10),

                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Name product'),
                    ),

                    TextField(
                      controller: priceController,
                      decoration:
                          const InputDecoration(labelText: 'Price product'),
                      keyboardType: TextInputType.number,
                    ),

                    TextField(
                      controller: imageController,
                      decoration:
                          const InputDecoration(labelText: 'Image URL'),
                      onChanged: (value) {
                        setStateDialog(() {}); // refresh preview
                      },
                    ),
                  ],
                ),
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
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        imageController.text.isEmpty) {
                      return;
                    }

                    String name = nameController.text;
                    int price = int.parse(priceController.text);
                    String imageUrl = imageController.text;

                    if (product == null) {
                      addProduct(Product(
                          name: name, price: price, imageUrl: imageUrl));
                    } else {
                      updateProduct(
                          index!,
                          Product(
                              name: name,
                              price: price,
                              imageUrl: imageUrl));
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Product'),
        backgroundColor: const Color.fromARGB(255, 21, 143, 112),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.network(
                products[index].imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
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