import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/root.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/data/auth_repo.dart';
import 'features/auth/views/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  // AuthRepo authRepo = AuthRepo();
  // Future <void> _checkLogin () async {
  //   try {
  //     final user = await authRepo.autoLogin();
  //     if (!mounted) return;
  //
  //     if(authRepo.isGuest) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
  //     } else if (authRepo.isLoggedIn) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
  //     } else {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginView()));
  //     }
  //   } catch (e) {
  //     debugPrint('Auto login failed: $e');
  //     if (mounted) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
  //     }
  //   }
  // }

  AuthRepo authRepo = AuthRepo();

  Future<void> _checkLogin() async {
    try {
      final user = await authRepo.autoLogin();
      if (!mounted) return;
      if (authRepo.isGuest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      } else if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => LoginView()),
        );
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 200),
          () => setState(() => _opacity = 1.0),
    );
    Future.delayed(const Duration(seconds: 1), _checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.9),
              AppColors.primary.withOpacity(0.7),
              AppColors.primary.withOpacity(0.5),
              AppColors.primary.withOpacity(0.3),
              AppColors.primary.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: SvgPicture.asset('assets/logo/logo.svg'),
                ),
                const Gap(30),
                Image.asset('assets/splash/splash.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

}