import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration
              Expanded(
                flex: 4,
                child: Center(
                  child: ClipRRect(
                    borderRadius: AppRadius.cardRadius,
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      semanticLabel: 'Welcome to Weesh illustration',
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: AppDurations.slow)
                    .scale(begin: const Offset(0.95, 0.95)),
              ),
              const Gap(32),

              // PageView for content
              Expanded(
                flex: 3,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(),
                  ],
                ),
              ),

              // Dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.terracotta
                          : AppColors.warmGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const Gap(AppPadding.section),

              // Bottom Action Area
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _currentPage == 2
                      ? FilledButton(
                          onPressed: () {
                            context.push('/login');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.terracotta,
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2)
                      : WeeshButton.ghost(
                          label: 'Next',
                          onTap: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ).animate().fadeIn(duration: 400.ms),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Komusta! Welcome to',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.warmGrey,
          ),
        ),
        const Gap(4),
        SizedBox(
          height: 48, // Constrain height for animated text
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'the Province.',
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.terracotta,
                  ),
                  speed: const Duration(milliseconds: 70),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'All your needs in one place',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.warmGrey,
          ),
        ),
        const Gap(4),
        Text(
          'Ride. Deliver. Shop.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.terracotta,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          'The ultimate super app designed specifically for the Province.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: AppColors.warmGrey,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPage3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Ready to begin?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.warmGrey,
          ),
        ),
        const Gap(4),
        Text(
          'Experience Seamless Services',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.terracotta,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        const Gap(8),
        Text(
          'Create your account or login to get started.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            color: AppColors.warmGrey,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
