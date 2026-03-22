import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Login',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lottie animation for phone authentication
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  'assets/lottie/login.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: AppPadding.section),
              Text(
                'Enter your mobile number to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+63 ',
                  prefixStyle: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
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
