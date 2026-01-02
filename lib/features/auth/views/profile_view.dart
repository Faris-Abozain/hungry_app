import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_user_text_field.dart';

import '../../../shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
 final TextEditingController _name=TextEditingController();
 final TextEditingController _email=TextEditingController();
 final TextEditingController _address=TextEditingController();
  @override
  void initState() {
    _name.text='Ghanima';
    _email.text='Ghanima@gmail.com';
    _address.text='hay leeby';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/009/734/564/original/default-avatar-profile-icon-of-social-media-user-vector.jpg',
                      ),
                    ),
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Gap(30),
              CustomUserTextField(controller: _name, label: 'Name'),
              Gap(25),
              CustomUserTextField(controller: _email, label: 'Email'),
              Gap(25),
              CustomUserTextField(controller: _address, label: 'Delivery Address'),
              Gap(36),
              Divider(),
              Gap(36),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                tileColor: Color(0xffF3F4F6),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                leading: Image.asset('assets/icon/profileVisa.png', width: 50),
                title: CustomText(text: 'Debit card', color: Colors.black),
                subtitle: CustomText(
                  text: '**** ***** 2342',
                  color: Colors.black,
                ),
                trailing: CustomText(text: 'Default',color: Colors.black,)
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 20
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  children: [
                    CustomText(text: 'Edit Profile',color: Colors.white,),
                    Gap(5),
                    Icon(CupertinoIcons.pencil,color: Colors.white,)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(15)
                ),

                child:Row(
                  children: [
                    CustomText(text: 'Log Out',color:AppColors.primary,),
                    Icon(Icons.logout,color: AppColors.primary,)
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
