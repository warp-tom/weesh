import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    // When the soft keyboard is open, viewInsets.bottom > 0.
    // We use this to collapse the Lottie animation and free up space.
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      // resizeToAvoidBottomInset: true (Flutter default) shrinks the body
      // when the keyboard appears. SingleChildScrollView handles the rest.
      resizeToAvoidBottomInset: true,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Login',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // reverse: true anchors content at the bottom of the scroll view,
          // so the Continue button rises naturally above the keyboard.
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lottie animates out when keyboard is open to save space.
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: keyboardOpen ? 0 : 200,
                child: keyboardOpen
                    ? const SizedBox.shrink()
                    : Lottie.asset(
                        'assets/lottie/login.json',
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
              ),
              const Gap(AppPadding.section),
              Text(
                'Enter your mobile number to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: Theme.of(context).textTheme.bodyLarge,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+63 ',
                  prefixStyle: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 16,
                  ),
                ),
              ),
              // Fixed gap replaces Spacer — never causes overflow when keyboard opens.
              const Gap(32),
              Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.horizontal),
                child: FilledButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final phone =
                              '+63${_phoneController.text.trim()}';
                          if (phone.length < 13) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter a valid mobile number'),
                              ),
                            );
                            return;
                          }

                          FocusScope.of(context).unfocus();

                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signInWithPhone(phone);

                            if (!context.mounted) return;
                            context.push('/otp', extra: phone);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
