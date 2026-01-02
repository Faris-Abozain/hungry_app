import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/views/signup_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textField.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(200),
                SvgPicture.asset(
                  "assets/logo/logo.svg",
                  color: AppColors.primary,
                ),
                Gap(10),
                CustomText(
                  text: "Welcome Back Discover The Best Fast Food",
                  color: AppColors.primary,
                  size: 13,
                  weight: FontWeight.w500,
                ),
                Gap(60),
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
                    child: Column(
                      children: [
                        Gap(30),
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
                          text: "Login",
                          onTap: () {
                            if (_formKey.currentState!.validate())
                              print("success register");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Root(),));
                          },
                        ),
                        Gap(15),
                        CustomAuthBtn(
                          textColor: AppColors.primary,
                          color: Colors.white,
                          text: "Create Account ?",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (c) => SignupView()),
                            );
                          },
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (c) => Root()),
                            );
                          },
                          child: CustomText(
                            text: 'Continue As a Guest?',
                            color: Colors.white,
                            weight: FontWeight.bold,
                            size: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
