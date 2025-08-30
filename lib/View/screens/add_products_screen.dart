import 'package:flutter/material.dart';
import '../../Controller/Product/product.dart';
import '../../Controller/Product/productfetch_controller.dart';

class Addproducts extends StatefulWidget {
  const Addproducts({super.key});

  @override
  State<Addproducts> createState() => _AddproductsState();
}

class _AddproductsState extends State<Addproducts> {
  final ProductController controller = ProductController();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();

  bool _loadinglist = false;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    setState(() {
      _loadinglist = true;
    });
    await controller.fetchproducts();
    setState(() {
      _loadinglist = false;
    });
  }

  void createProducts() async {
    if (_titlecontroller.text.isEmpty ||
        _pricecontroller.text.isEmpty ||
        double.tryParse(_pricecontroller.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid title and price")),
      );
      return;
    }

    setState(() {
      _creating = true;
    });

    String defaultDescription = "No description available";
    String defaultImageUrl =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLe5PABj_xK-db2a02ucOAIIy-Yn_JE454gA&s";

    final product = await controller.addProduct(
      _titlecontroller.text.trim(),
      double.parse(_pricecontroller.text.trim()),
      defaultImageUrl,
    );

    _titlecontroller.clear();
    _pricecontroller.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _creating = false;
    });

    if (product != null) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add product")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      appBar: AppBar(
        title: const Text("Add Products",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildProductForm(),
          const Divider(height: 1, color: Colors.black12),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titlecontroller,
              decoration: InputDecoration(
                hintText: "Product title",
                filled: true,
                fillColor: const Color(0xFFF8F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: TextField(
              controller: _pricecontroller,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "Product Price",
                filled: true,
                fillColor: const Color(0xFFF8F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _creating ? null : createProducts,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: _creating
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : const Text("Add"),
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_loadinglist) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.products.isEmpty) {
      return const Center(
        child: Text("No products found.", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: controller.products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final p = controller.products.reversed.toList()[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: (p.image != null && p.image!.isNotEmpty)
                    ? Image.network(
                  p.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
                )
                    : Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title ?? "No title",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.description ?? "No description",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}