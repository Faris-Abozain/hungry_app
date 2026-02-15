import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_model.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/views/login_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_user_text_field.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;
  bool isLoadingLogout = false;
  String? selectedImage;
  bool isLoadingUpdate = false;

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

  Future<void> logout() async {
    try {
      setState(() => isLoadingLogout = true);
      await authRepo.logOut();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => LoginView()),
      );
      setState(() => isLoadingLogout = false);
    } catch (e) {
      setState(() => isLoadingLogout = false);
      print(e.toString());
    }
  }

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }
  Future<void> updateProfileData() async {
    try {
      setState(() => isLoadingUpdate = true);

      final user = await authRepo.updateProfileData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        imagePath: selectedImage,
        visa: _visa.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack('Profile updated successfully'),
      );

      setState(() {
        isLoadingUpdate = false;
        userModel = user;
      });
    } on ApiError catch (e) {
      if (!mounted) return;

      if (e.statusCode == 200 || e.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack('Profile updated successfully'),
        );

        setState(() => isLoadingUpdate = false);
        await getProfileData();
        return;
      }

      setState(() => isLoadingUpdate = false);

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack("Profile updated successfully"),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoadingUpdate = false);

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack('Failed to update profile'),
      );
    }
  }



  @override
  void initState() {
    getProfileData().then((value) {
      _name.text = userModel?.name ?? 'Faris';
      _email.text = userModel?.email ?? 'faris@gmail.com';
      _address.text = userModel?.address ?? 'Shebien Elkom';
      _visa.text = userModel?.visa ?? 'Add Visa Card';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getProfileData();
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.primary,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: SvgPicture.asset('assets/icon/settings.svg', width: 20),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Skeletonizer(
              enabled: userModel == null,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.grey.shade300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: AppColors.primary,
                              ),
                              color: Colors.grey.shade100,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: selectedImage != null
                                ? Image.file(
                              File(selectedImage!),
                              fit: BoxFit.cover,
                            )
                                : (userModel?.image != null &&
                                userModel!.image!.isNotEmpty)
                                ? Image.network(
                              userModel!.image!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, err, builder) =>
                                  Icon(Icons.person),
                            )
                                : Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Card(
                          elevation: 0.0,
                          color: const Color.fromARGB(255, 6, 78, 13),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  text: 'Upload',
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                Gap(10),
                                Icon(
                                  CupertinoIcons.camera,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 0.0,
                          color: const Color.fromARGB(255, 111, 2, 40),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  text: 'Remove',
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                Gap(10),
                                Icon(
                                  CupertinoIcons.trash,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(30),
                  CustomUserTextField(controller: _name, label: 'Name'),
                  Gap(25),
                  CustomUserTextField(controller: _email, label: 'Email'),
                  Gap(25),
                  CustomUserTextField(
                    controller: _address,
                    label: 'Delivery Address',
                  ),
                  Gap(36),
                  userModel?.visa == null
                      ? CustomUserTextField(controller: _visa, label: 'Visa')
                      : ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                    tileColor: Color(0xffF3F4F6),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    leading: Image.asset(
                      'assets/icon/profileVisa.png',
                      width: 50,
                    ),
                    title: CustomText(
                      text: 'Debit card',
                      color: Colors.black,
                    ),
                    subtitle: CustomText(
                      text: userModel?.visa ?? '**** **** **** 2342',
                      color: Colors.black,
                    ),
                    trailing: CustomText(
                      text: 'Default',
                      color: Colors.black,
                    ),
                  ),
                  Gap(36),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade800, blurRadius: 20)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: updateProfileData,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        isLoadingUpdate
                            ? CircularProgressIndicator(color: Colors.white)
                            : CustomText(
                            text: 'Edit Profile', color: Colors.white),
                        Gap(5),
                        Icon(CupertinoIcons.pencil, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: logout,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        isLoadingLogout
                            ? CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                            : CustomText(
                          text: 'Log Out',
                          color: AppColors.primary,
                        ),
                        Icon(Icons.logout, color: AppColors.primary),
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
