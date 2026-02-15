import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/home/data/models/topping_model.dart';
import 'package:hungry_app/features/product/widgets/spicy_slider.dart';
import 'package:hungry_app/features/product/widgets/topping_card.dart';
import 'package:hungry_app/shared/custom_button.dart';
import 'package:hungry_app/shared/custom_text.dart';

import '../../home/data/repos/product_repo.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    required this.productImage,
    required this.productId,
    required this.productPrice,
  });

  final String productImage;
  final int productId;
  final String productPrice;
  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = 0.5;
  List<int> selectedToppings = [];
  List<int> selectedOptions = [];
  bool isLoading = false;
  List<ToppingModel?>? toppings;
  List<ToppingModel?>? sideOptions;
  ProductRepo productRepo = ProductRepo();

  Future<void> getToppings() async {
    final response = await productRepo.getToppings();
    setState(() {
      toppings = response;
    });
  }

  Future<void> getOptions() async {
    final response = await productRepo.getSideOptions();
    setState(() {
      sideOptions = response;
    });
  }

  CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    getToppings();
    getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpicySlider(
                image: widget.productImage,
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
              ),
              Gap(50),
              CustomText(text: 'Toppings', size: 20),
              Gap(30),
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(toppings?.length ?? 4, (index) {
                    final topping = toppings?[index];
                    final id = topping?.id;
                    if (topping == null) {
                      return CupertinoActivityIndicator();
                    }
                    final isSelected = selectedToppings.contains(id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ToppingCard(
                        color: isSelected
                            ? Colors.green.withOpacity(0.4)
                            : AppColors.primary.withOpacity(0.1),
                        title: topping.name,
                        imageUrl: topping.image,
                        onAdd: () {
                          final id = topping.id ?? 1;
                          setState(() {
                            if (selectedToppings.contains(id)) {
                              selectedToppings.remove(id);
                            } else {
                              selectedToppings.add(id);
                            }
                          });
                        } ),
                    );
                  }),
                ),
              ),
              Gap(20),
              CustomText(text: 'Side Options', size: 20),
              Gap(30),
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(sideOptions?.length ?? 4, (index) {
                    final options = sideOptions?[index];
                    final id = options?.id ?? 1;
                    if (options == null) {
                      return CupertinoActivityIndicator();
                    }
                    final isSelected = selectedOptions.contains(id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ToppingCard(
                        color: isSelected
                            ? Colors.green.withOpacity(0.4)
                            : AppColors.primary.withOpacity(0.1),
                        imageUrl: options.image,
                        title: options.name,
                        onAdd: () => setState(() {
                          if (isSelected) {
                            selectedOptions.remove(id);
                          } else {
                            selectedOptions.add(id);
                          }
                        }),
                      ),
                    );
                  }),
                ),
              ),
              Gap(100),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: 'Total', size: 20),
                  CustomText(text: '\$ ${widget.productPrice}',size: 27),
                ],
              ),
              CustomButton(
                widget:isLoading? CupertinoActivityIndicator(color: Colors.white,) :Icon(CupertinoIcons.cart_badge_plus,color: Colors.white,),
                gap:10,
                text: 'Add To Cart',
                  onTap: () async {
                    try {
                      setState(() => isLoading = true);

                      final cartItem = CartModel(
                        productId: widget.productId,
                        qty: 1,
                        spicy: value,
                        toppings: selectedToppings,
                        options: selectedOptions,
                      );

                      await cartRepo.addToCart(CartRequestModel(items: [cartItem]));

                      setState(() => isLoading = false);

                      Fluttertoast.showToast(
                        msg: "Added to cart successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16,
                      );

                    } catch (e) {
                      setState(() => isLoading = false);

                      Fluttertoast.showToast(
                        msg: "Something went wrong",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  }

              ),
            ],
          ),
        ),
      ),
    );
  }

}