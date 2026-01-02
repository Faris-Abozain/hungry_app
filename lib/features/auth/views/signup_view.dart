import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/views/login_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';

import '../../../shared/custom_text.dart';
import '../../../shared/custom_textField.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController confirmController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Gap(200),
            SvgPicture.asset("assets/logo/logo.svg", color: AppColors.primary),
            CustomText(
              text: 'Welcome To Our Food App',
              color: AppColors.primary,
            ),
            Gap(100),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(30),
                      CustomTextfield(
                        hint: "Name",
                        isPassword: false,
                        controller: nameController,
                      ),
                      Gap(15),
                      CustomTextfield(
                        hint: "Email Address",
                        isPassword: false,
                        controller: emailController,
                      ),
                      Gap(15),
                      CustomTextfield(
                        hint: "Password",
                        isPassword: true,
                        controller: passController,
                      ),
                      Gap(20),
                      CustomAuthBtn(
                        color: AppColors.primary,
                        textColor: Colors.white,
                        text: "Sign Up",
                        onTap: () {
                          if (formKey.currentState!.validate())
                            print("success register");
                        },
                      ),
                      Gap(10),
                      CustomAuthBtn(
                        textColor: AppColors.primary,
                        color: Colors.white,
                        text: "Go To Login?",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => LoginView()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
