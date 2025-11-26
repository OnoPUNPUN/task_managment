import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_bottom_button.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Lottie.asset(
                'assets/animations/auth animations/account_created.json',
                height: 250,
                repeat: false,
              ),
              const SizedBox(height: 30),
              Text(
                'Account Created!',
                style: GoogleFonts.lexendDeca(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your account has been successfully created.\nYou can now start managing your tasks.',
                style: GoogleFonts.lexendDeca(
                  fontSize: 16,
                  color: const Color(0xFF6E6E6E),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppBottomButton(
                text: 'Let\'s Start',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                hasArrow: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
