import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/views/signup_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textField.dart';

import '../../../shared/custom_snack_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController(text: "faris@gmail.com");
  TextEditingController passController = TextEditingController(text: "12345678");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  AuthRepo authRepo=AuthRepo();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await authRepo.login(
        emailController.text.trim(),
        passController.text.trim(),
      );

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Root()),
        );
      }
    } on ApiError catch (e) {
      if (e.message == 'Email not found' || e.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack('Email does not exist'),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(e.message),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack('Something went wrong'),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Form(
            key: formKey,
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
                        isLoading ? CupertinoActivityIndicator(color: Colors.white,): CustomAuthBtn(
                          color: AppColors.primary,
                          textColor: Colors.white,
                         text:"Login",
                          onTap: login
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
