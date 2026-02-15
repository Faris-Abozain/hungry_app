import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key, required this.value, required this.onChanged,required this.image});
final double value;
final String image;
final ValueChanged<double>onChanged;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(widget.image, height: 150),

        CustomText(
          text:
          'Customize Your Burger\n To Your Tastes.\n Ultimate Experience',
        ),
        Slider(
          value: widget.value,
          max: 1,
          min: 0,
          onChanged: widget.onChanged,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey.shade300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: '🥶'),
            Gap(100),
            CustomText(text: '🌶')
          ],
        ),
      ],
    );
  }
}
