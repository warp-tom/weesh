import 'package:flutter/material.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({super.key});

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  String _amount = "0";

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'C') {
        _amount = "0";
      } else if (value == '<') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = "0";
        }
      } else {
        if (_amount == "0") {
          _amount = value;
        } else if (_amount.length < 5) {
           _amount += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('Enter Amount', style: TextStyle(color: AppColors.warmGrey)),
                  const Gap(8),
                  Text(
                    '₱ $_amount.00',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
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
                    onPressed: _amount == "0" ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cash In Success!')),
                      );
                      context.pop();
                    },
                    child: const Text('Confirm Cash In'),
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
                  color: key == 'C' || key == '<' ? AppColors.warmGrey : AppColors.textBody,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
