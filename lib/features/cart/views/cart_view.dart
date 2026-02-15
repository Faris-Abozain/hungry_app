import 'package:flutter/material.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/cart/widgets/cart_item.dart';
import 'package:hungry_app/features/checkout/views/checkout_view.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../data/cart_model.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {

  late List<int> quantities;
  CartRepo cartRepo =CartRepo();
  GetCartResponse? cartResponse;
  bool isLoading = false;
  bool isLoadingRemove = false;


  @override
  void initState() {
    getCartData();
    super.initState();
  }

  void onAdd(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void onMin(int index) {
    setState(() {
      if (quantities[index] > 1) quantities[index]--;
    });
  }

  Future<void> getCartData() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);
      final response = await cartRepo.getCartData();
      if (!mounted) return;
      final count = response?.cartData.items.length ?? 0;
      setState(() {
        cartResponse = response;
        quantities = List.generate(count, (_) => 1);
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }
  Future<void> removeCartItem(int id) async {
    try {
      setState(() {
        isLoadingRemove = true;
      });
      await cartRepo.removeCartItem(id);
      getCartData();
      setState(() {
        isLoadingRemove = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRemove = false;
      });
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getCartData,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 120, top: 15),
            itemCount: cartResponse?.cartData.items.length ?? 0,
            itemBuilder: (context, index) {
              final item = cartResponse!.cartData.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CartItem(
                  image: item.image,
                  text: item.name.split(' ').take(2).join(' '),
                  desc: 'Spicy ${item.spicy}',
                  number: quantities[index],
                  onRemove: (){
                    removeCartItem(item.itemId);
                  },
                  onAdd: () {
                    onAdd(index);
                  },
                  onMin: () {
                    onMin(index);
                  },
                ),
              );
            },
          ),
        ),
        bottomSheet: Container(
          height: 90,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: 'Total', size: 16),
                  CustomText(text :'\$ ${cartResponse?.cartData.totalPrice}' ?? '0.0',size: 16,),
                ],
              ),
              CustomButton(
                text: 'Checkout',
                width: 150,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) {
                        return CheckoutView(totalPrice: cartResponse!.cartData.totalPrice,);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
