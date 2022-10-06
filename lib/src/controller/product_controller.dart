import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/product.dart';
import '../controller/auth_controller.dart';

class ProductController extends GetxController {
  RxList<Product> cartProduct = <Product>[].obs;
  RxList<Product> favoriteProduct = <Product>[].obs;
  RxList<Product> allProducts = <Product>[].obs;
  final AuthController authController = Get.find();

  Product findById(String id) {
    return allProducts.firstWhere((prod) => prod.id == id);
  }

  Future<void> changeFavoriteStatus(Product product) async {
    final oldStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    update();
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorite/${authController.userId}/${product.id}.json?auth=${authController.token}');
    try {
      final response = await http.put(url,
          body: json.encode(
            product.isFavorite,
          ));
      if (response.statusCode >= 400) {
        product.isFavorite = oldStatus;
        update();
      } else {
        if (product.isFavorite) {
          favoriteProduct.insert(0, product);
        }
        if (!product.isFavorite) {
          favoriteProduct.removeWhere((element) => element == product);
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchDataAndSetProduct([bool filterByUser = false]) async {
    List<Product> products = [];
    final filterString = filterByUser
        ? 'orderBy="creatorId"&equalTo="${authController.userId}"'
        : '';
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=${authController.token}&$filterString');

    final urlFavorite = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorite/${authController.userId}.json?auth=${authController.token}');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      final favoriteResponse = await http.get(urlFavorite);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData?.forEach((prodId, prodData) {
        {
          final bool productIsInList =
              products.any((prod) => prod.id == prodId);
          if (!productIsInList) {
            products.add(
              Product(
                  id: prodId,
                  title: prodData['title'],
                  description: prodData['description'],
                  imageUrl: prodData['imageUrl'],
                  price: prodData['price'],
                  isFavorite: favoriteData == null
                      ? false
                      : favoriteData[prodId] ?? false),
            );
          }

          allProducts.value = products;

          final bool isProductInFavList =
              favoriteProduct.any((prod) => prod.id == prodId);
          if (!isProductInFavList &&
              (favoriteData == null ? false : favoriteData[prodId] ?? false) ==
                  true) {
            favoriteProduct.add(
              Product(
                  id: prodId,
                  title: prodData['title'],
                  description: prodData['description'],
                  imageUrl: prodData['imageUrl'],
                  price: prodData['price'],
                  isFavorite: favoriteData[prodId] ?? false),
            );
          }
        }
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=${authController.token}');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': authController.userId,
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      allProducts.add(newProduct);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIxdex = allProducts.indexWhere((prod) => prod.id == id);

    if (productIxdex >= 0) {
      final url = Uri.parse(
          'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=${authController.token}');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      allProducts[productIxdex] = newProduct;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id,json?auth=${authController.token}');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception();
      }
      allProducts.removeWhere((prod) => prod.id == id);
    } catch (_) {
      rethrow;
    }

    favoriteProduct.removeWhere((prod) => prod.id == id);
  }
}
