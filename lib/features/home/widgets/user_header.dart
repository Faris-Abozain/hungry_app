import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/auth/data/auth_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class UserHeader extends StatelessWidget {
   UserHeader({super.key,required this.userName,required this.userImage});
  final String userName;
  final String? userImage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
                'assets/logo/logo.svg',
                color: AppColors.primary,
                height: 28,
            ),
            Gap(5),
            CustomText(
              text: "Hello,$userName",
              size: 16,
              weight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              userImage ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9IUW9QQRx9V81XVtoatQ-Qq-tKh1yN0ftYA&s",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9IUW9QQRx9V81XVtoatQ-Qq-tKh1yN0ftYA&s",
                  fit: BoxFit.cover,
                );
              },
            )

          ),
        ),      ],
    );
  }
}
