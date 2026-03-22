import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/features/wallet/application/wallet_provider.dart';

/// GCash Cash-In screen.
/// Bug 3 fix: Now actually calls [walletAccountNotifierProvider.topUp] on confirm.
class CashInScreen extends ConsumerStatefulWidget {
  const CashInScreen({super.key});

  @override
  ConsumerState<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends ConsumerState<CashInScreen> {
  String _amount = '0';
  bool _isLoading = false;

  void _onKeypadTap(String value) {
    if (_isLoading) return;
    setState(() {
      if (value == 'C') {
        _amount = '0';
      } else if (value == '<') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else {
        if (_amount == '0') {
          _amount = value;
        } else if (_amount.length < 5) {
          _amount += value;
        }
      }
    });
  }

  Future<void> _onConfirm() async {
    final int phpAmount = int.tryParse(_amount) ?? 0;
    if (phpAmount <= 0) return;

    // Convert PHP → centavos for the Edge Function
    final int centavos = phpAmount * 100;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(walletAccountNotifierProvider.notifier)
          .topUp(centavos, 'GCash');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '₱$phpAmount successfully added to your wallet! 🎉',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canConfirm = _amount != '0' && !_isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Cash In via GCash',
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Amount',
                    style: GoogleFonts.plusJakartaSans(color: AppColors.warmGrey),
                  ),
                  const Gap(8),
                  Text(
                    '₱ $_amount.00',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Min ₱10 · Max ₱50,000',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.warmGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Number Pad
          Container(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 48),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRow(['1', '2', '3']),
                _buildRow(['4', '5', '6']),
                _buildRow(['7', '8', '9']),
                _buildRow(['C', '0', '<']),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canConfirm ? _onConfirm : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Confirm Cash In',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          return InkWell(
            onTap: () => _onKeypadTap(key),
            borderRadius: BorderRadius.circular(36),
            child: Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: key == 'C' || key == '<'
                      ? AppColors.warmGrey
                      : AppColors.textBody,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
