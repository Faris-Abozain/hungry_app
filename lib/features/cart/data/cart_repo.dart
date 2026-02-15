import 'package:hungry_app/core/network/api_service.dart';

import '../../../core/network/api_error.dart';
import 'cart_model.dart';

class CartRepo {
  ApiService apiService = ApiService();

  Future<void> addToCart(CartRequestModel cartData) async {
    try {
      final response = await apiService.post('cart/add', cartData.toJson());
      throw ApiError(message: response['message']);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<GetCartResponse?> getCartData() async {
    try {
      final response = await apiService.get("/cart");
      return GetCartResponse.fromJson(response);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      final response = await apiService.delete("cart/remove/$id", {},);

      if (response['code'] == 200 && response['data'] == null) {
        throw ApiError(message: response['message']);
      }
    } catch (e) {
      throw ApiError(message: 'remove item from cart: ${e.toString()}');
    }
  }
}