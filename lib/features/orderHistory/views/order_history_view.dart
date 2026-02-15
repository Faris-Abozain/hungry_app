import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 120, top: 15),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('assets/test/test.png', width: 100),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Hamburger',
                                weight: FontWeight.bold,
                              ),
                              CustomText(text: 'Qty: X3'),
                              CustomText(text: 'Price : 20\$'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    CustomButton(
                      text: 'Order Again',
                      width: double.infinity,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
