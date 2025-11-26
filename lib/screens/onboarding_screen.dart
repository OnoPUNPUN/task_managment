import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment/widgets/app_bottom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF0F1115), Color(0xFF1C1F26)]
        : const [Color(0xFFF3F8FF), Color(0xFFFFFBF3)];
    final titleColor = theme.textTheme.titleLarge?.color ?? const Color(0xFF222222);
    final subtitleColor =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFF6E6E6E);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 80,
            child: Image.asset(
              "assets/onBorading/Blue_stopwatch_with_pink_arrow.png",
              width: 60,
            ),
          ),
          Positioned(
            top: 200,
            left: 310,
            child: Image.asset(
              "assets/onBorading/Blue_desk_calendar.png",
              width: 50,
            ),
          ),

          Positioned(
            top: 280,
            left: 60,
            child: Image.asset("assets/onBorading/pie_chart.png", width: 50),
          ),

          Stack(
            children: [
              Positioned(
                bottom: 490,
                left: 30,
                child: Image.asset(
                  "assets/onBorading/vase_with_tulips_glasses_and_pencil.png",
                  width: 70,
                ),
              ),
              Positioned(
                bottom: 480,
                left: 10,
                child: Image.asset(
                  "assets/onBorading/close_up_of_pink_coffee_cup.png",
                  width: 70,
                ),
              ),
            ],
          ),

          Positioned(
            top: 380,
            left: 305,
            child: Image.asset(
              "assets/onBorading/multicolored_smartphone_notifications.png",
              width: 60,
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                Image.asset(
                  "assets/onBorading/female.png",
                  height: 300,
                  fit: BoxFit.contain,
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Task Management &\nTo-Do List",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "This productive tool is designed to help\nyou better manage your task\nproject-wise conveniently!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 15,
                      color: subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(),

                AppBottomButton(
                  text: 'Let’s Start',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('user_data');
                    await prefs.setBool("first_time", false);
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, "/login");
                    }
                  },
                  hasArrow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
