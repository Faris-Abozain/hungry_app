class ProductModel{
  int id;
  String name;
  String desc;
  String image;
  String rating;
  String price;

  ProductModel({required this.id,required this.name,required this.image,required this.desc,required this.price,required this.rating});

  factory ProductModel.fromJson(Map<String ,dynamic> json){
    return ProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        desc: json["description"],
        price: json["price"],
        rating: json["rating"]
    );
  }
}