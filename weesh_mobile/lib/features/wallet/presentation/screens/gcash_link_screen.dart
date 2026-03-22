import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/profile/data/repositories/supabase_profile_repository.dart';
import 'package:weesh_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class GcashLinkScreen extends ConsumerStatefulWidget {
  const GcashLinkScreen({super.key});

  @override
  ConsumerState<GcashLinkScreen> createState() => _GcashLinkScreenState();
}

class _GcashLinkScreenState extends ConsumerState<GcashLinkScreen> {
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isSendingOtp = false;
  bool _isVerifying = false;
  bool _isLinked = false;
  bool _otpSent = false;
  String? _linkedNumber;

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _otpFocusNodes) { f.dispose(); }
    super.dispose();
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid GCash phone number')),
      );
      return;
    }
    setState(() => _isSendingOtp = true);
    // Simulate SMS OTP (replace with real SMS provider in production)
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) setState(() { _isSendingOtp = false; _otpSent = true; });
  }

  Future<void> _verifyAndLink() async {
    if (_otpValue.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
      return;
    }

    // Hardcoded OTP for testing — only '123456' is accepted
    if (_otpValue != '123456') {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect code. Use 123456 to verify.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final user = ref.read(authControllerProvider).value;
    if (user == null) { setState(() => _isVerifying = false); return; }

    try {
      await ref.read(profileRepositoryProvider).linkGcash(
            userId: user.id,
            gcashNumber: _phoneController.text.trim(),
          );
      ref.invalidate(userProfileProvider);
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isLinked = true;
          _linkedNumber = _phoneController.text.trim();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isVerifying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to link GCash: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Link GCash',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.section),
          child: _isLinked
              ? _buildSuccessState()
              : _otpSent
                  ? _buildOtpForm()
                  : _buildPhoneForm(),
        ),
      ),
    );
  }

  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // GCash branding card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF007DFE), Color(0xFF0057B7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF007DFE).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Iconsax.mobile, color: Colors.white, size: 28),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GCash', style: GoogleFonts.plusJakartaSans(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Link for instant payments', style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(32),
        Text('GCash Phone Number', style: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.deepCharcoal)),
        const Gap(8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+63 9XX XXX XXXX',
            prefixIcon: const Icon(Iconsax.call, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Iconsax.info_circle, size: 18, color: AppColors.warmGrey),
            const Gap(8),
            Expanded(child: Text(
              'We\'ll send a 6-digit verification code to your GCash-registered number.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.warmGrey),
            )),
          ]),
        ),
        const Spacer(),
        FilledButton(
          onPressed: _isSendingOtp ? null : _sendOtp,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF007DFE),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSendingOtp
              ? const SizedBox(height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Send Verification Code', style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600, fontSize: 16)),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(8),
        Text('Enter Verification Code', style: GoogleFonts.plusJakartaSans(
          fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
        const Gap(8),
        Text('A 6-digit code was sent to ${_phoneController.text}',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.warmGrey)),
        const Gap(32),
        // 6-digit OTP row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => SizedBox(
            width: 48,
            height: 58,
            child: TextField(
              controller: _otpControllers[i],
              focusNode: _otpFocusNodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              ),
              onChanged: (val) {
                if (val.isNotEmpty && i < 5) {
                  _otpFocusNodes[i + 1].requestFocus();
                } else if (val.isEmpty && i > 0) {
                  _otpFocusNodes[i - 1].requestFocus();
                }
                setState(() {});
              },
            ),
          )),
        ),
        const Gap(24),
        TextButton(
          onPressed: _isSendingOtp ? null : _sendOtp,
          child: Text('Resend Code', style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF007DFE), fontWeight: FontWeight.w600)),
        ),
        const Spacer(),
        FilledButton(
          onPressed: (_isVerifying || _otpValue.length < 6) ? null : _verifyAndLink,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF007DFE),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isVerifying
              ? const SizedBox(height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Verify & Link GCash', style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600, fontSize: 16)),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007DFE), Color(0xFF00C56E)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(
                color: const Color(0xFF007DFE).withValues(alpha: 0.3),
                blurRadius: 24, offset: const Offset(0, 8),
              )],
            ),
            child: const Icon(Iconsax.tick_circle, color: Colors.white, size: 48),
          ),
          const Gap(24),
          Text('GCash Linked!', style: GoogleFonts.plusJakartaSans(
            fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
          const Gap(8),
          Text('${_linkedNumber ?? 'Your GCash account'} is now connected.\nYou can use GCash for all payments.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.warmGrey)),
          const Gap(40),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF007DFE),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
