class CartModel {

  final int productId;
  final int qty;
  final double spicy;
  final List<int> toppings;
  final List<int> options;

  CartModel({
    required this.productId,
    required this.qty,
    required this.spicy,
    required this.toppings,
    required this.options
  });


  Map<String,dynamic>toJson()=>{
    "product_id": productId,
    "quantity": qty,
    "spicy":spicy,
    "toppings":toppings,
    "side_options":options
  };

}

class CartRequestModel{

  final List<CartModel> items;
  CartRequestModel({
    required this.items

  });
  Map<String,dynamic> toJson()=>{
    "items":items.map((e)=>e.toJson()).toList()
  };
}


class GetCartResponse{

  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse({

    required this.code,
    required this.message,
    required this.cartData
  });

  factory GetCartResponse.fromJson(Map<String,dynamic>json){
    return GetCartResponse(
        code: json['code']??200,
        message: json['message']?.toString()??'',
        cartData: CartData.fromJson(json['data'])
    );
  }

}

class CartData{

  final int id;
  final String totalPrice;
  final List<CartItemModel> items;

  CartData({
    required this.id,
    required this.totalPrice,
    required this.items
  });

  factory CartData.fromJson(Map<String,dynamic>json){

    return CartData(
      id: json['id']??0,
      totalPrice: json['total_price']?.toString()??'0',
      items: (json['items'] as List).map((e)=>CartItemModel.fromJson(e)).toList(),
    );

  }

}


class CartItemModel {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final double spicy;

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
  });
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json['item_id']??0,
      productId: json['product_id']??0,
      name: json['name']?.toString()??'',
      image: json['image']?.toString()??'',
      quantity: json['quantity']??0,
      price: json['price']?.toString()??'0',
      spicy: double.tryParse(json['spicy']?.toString()??'0') ?? 0.0,
    );
  }

}