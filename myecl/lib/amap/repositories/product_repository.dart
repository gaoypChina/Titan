import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myecl/amap/class/product.dart';
import 'package:myecl/tools/repository.dart';

class ProductListRepository extends Repository {
  final ext = "amap/products";

  Future<List<Product>> getProductList() async {
    final response = await http.get(Uri.parse(host + ext), headers: headers);
    if (response.statusCode == 200) {
      String resp = utf8.decode(response.body.runes.toList());
      return List<Product>.from(
          json.decode(resp).map((x) => Product.fromJson(x)));
    } else {
      throw Exception("Failed to load product list");
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(Uri.parse(host + ext),
        headers: headers, body: json.encode(product.toJson()));
    if (response.statusCode == 201) {
      String resp = utf8.decode(response.body.runes.toList());
      return Product.fromJson(json.decode(resp));
    } else {
      throw Exception("Failed to create product");
    }
  }

  Future<bool> updateProduct(Product product) async {
    final response = await http.patch(
        Uri.parse(host + ext + "/" + product.id.toString()),
        headers: headers,
        body: json.encode(product.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update product");
    }
  }

  Future<bool> deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse(host + ext + "/" + productId),
        headers: headers);
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Failed to delete product");
    }
  }
}
