import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/auth/data/auth_model.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/repos/product_repo.dart';
import 'package:hungry_app/features/home/widgets/card_item.dart';
import 'package:hungry_app/features/home/widgets/search_field.dart';
import 'package:hungry_app/features/home/widgets/user_header.dart';
import 'package:hungry_app/features/product/views/product_details_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/network/api_error.dart';
import '../../../shared/custom_snack_bar.dart';
import '../widgets/food_category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ['All', 'Combo', 'Sliders', 'Classic'];
  int selectedIndex = 0;
  ProductRepo productRepo = ProductRepo();
  AuthRepo authRepo=AuthRepo();
  List<ProductModel>? products = [];
  List<ProductModel>? allProducts = [];
   UserModel? userModel;
   //UserModel? userModel;
  TextEditingController? controller;


  Future<void> getProducts() async {
    final response = await productRepo.getProducts();
    setState(() {
      allProducts=response;
      products = response;
    });
  }
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = "Error in Profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  @override
  void initState() {
    getProfileData();
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Skeletonizer(
        enabled: products==null,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 180,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 70, right: 20),
                  child: Column(children: [UserHeader(
                     userName: userModel?.name??"user",
                    userImage: userModel?.image,
                  ),
                    Gap(20),
                    SearchField(
                  controller: controller,
                    onChanged: (value) {
                      final query =value.toLowerCase();
                      setState(() {
                        products= allProducts?.where((p) =>p.name.toLowerCase().contains(query)).toList();
                      });
                    },

                  )]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FoodCategory(
                    selectedIndex: selectedIndex,
                    category: category,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: products!.length,
                    (context, index) {
                      final product = products![index];
                      if(products==null){
                        return CupertinoActivityIndicator();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) {
                                return ProductDetailsView(productImage: product.image,productId: product.id,productPrice: product.price,);
                              },
                            ),
                          );
                        },
                        child: CardItem(
                          image: product.image,
                          text: product.name,
                          desc: product.desc,
                          rate: product.rating,
                        ),
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
