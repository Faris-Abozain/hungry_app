import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/models/topping_model.dart';

class ProductRepo{
  ApiService apiService=ApiService();

  //getProducts
  Future<List<ProductModel>> getProducts() async{
    try{
      final response = await apiService.get("/products");
      return (response["data"] as List).map((product) => ProductModel.fromJson(product),).toList();

    }catch(e){
     print(e.toString());
     return [];
    }
  }

  //getToppings
  Future<List<ToppingModel?>> getToppings() async{
  try{
    final response = await apiService.get("/toppings");
    return (response["data"] as List).map((e) => ToppingModel.fromJson(e),).toList();
  }catch(e){
    ApiError(message: e.toString());
  }
  return [];
  }

  //getSideOptions
  Future<List<ToppingModel?>> getSideOptions() async{
    try{
      final response = await apiService.get("/side-options");
      return (response["data"] as List).map((e) => ToppingModel.fromJson(e),).toList();
    }catch(e){
      ApiError(message: e.toString());
    }
    return [];
  }


}