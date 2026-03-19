import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.phone,
  });
  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController(text: '1234');

  @override
  void dispose() {
    // pin_code_fields automatically disposes the controller when unmounted
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Verification',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppPadding.section),
              Text(
                'Enter the 6-digit code sent to ${widget.phone}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: AppRadius.inputRadius,
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: AppColors.surface,
                  inactiveFillColor: AppColors.surface,
                  selectedFillColor: AppColors.surface,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.neutral200,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                              try {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .signInWithPhone(widget.phone);
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Code resent!')),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                  child: const Text('Resend Code'),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.horizontal),
                child: FilledButton(
                  onPressed: authState.isLoading || _otpController.text.length < 6
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final messenger = ScaffoldMessenger.of(context);

                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .verifyOtp(widget.phone, _otpController.text);

                            if (!context.mounted) return;
                            context.go('/profile_setup');
                          } catch (e) {
                            if (!context.mounted) return;
                            messenger.showSnackBar(
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
                      : const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
