import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeshSlideToConfirm extends StatefulWidget {
  final String text;
  final Future<void> Function() onConfirm;
  final Color backgroundColor;
  final Color sliderColor;
  final IconData sliderIcon;

  const WeeshSlideToConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
    this.backgroundColor = AppColors.primary,
    this.sliderColor = AppColors.surface,
    this.sliderIcon = Icons.arrow_forward_rounded,
  });

  @override
  State<WeeshSlideToConfirm> createState() => _WeeshSlideToConfirmState();
}

class _WeeshSlideToConfirmState extends State<WeeshSlideToConfirm> with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;
  bool _isLoading = false;
  double _containerWidth = 0.0;

  final double _sliderHeight = 56.0;
  final double _sliderWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        final double maxDrag = _containerWidth - _sliderWidth - 8;

        return Container(
          height: _sliderHeight + 8,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: AppShadows.soft,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background Text
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: _sliderWidth),
                  child: Text(
                    _isConfirmed 
                        ? 'Confirmed' 
                        : (_isLoading ? 'Processing...' : widget.text),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              
              // Shimmer overlay or progress bar could go here
              
              // Draggable Slider
              AnimatedPositioned(
                duration: _isConfirmed ? const Duration(milliseconds: 200) : Duration.zero,
                curve: Curves.easeOutCubic,
                left: _dragPosition + 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: _isConfirmed || _isLoading ? null : (details) {
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxDrag) {
                        _dragPosition = maxDrag;
                      }
                    });
                  },
                  onHorizontalDragEnd: _isConfirmed || _isLoading ? null : (details) async {
                    if (_dragPosition >= maxDrag * 0.9) {
                      // Trigger Success
                      HapticFeedback.heavyImpact();
                      setState(() {
                        _dragPosition = maxDrag;
                        _isConfirmed = true;
                        _isLoading = true;
                      });
                      
                      await widget.onConfirm();
                      
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      // Snap back
                      HapticFeedback.lightImpact();
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },
                  child: Container(
                    height: _sliderHeight,
                    width: _sliderWidth,
                    decoration: BoxDecoration(
                      color: widget.sliderColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                      child: _isLoading 
                        ? Center(
                            child: SizedBox(
                              height: 24, 
                              width: 24, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: widget.backgroundColor)
                            )
                          )
                        : Icon(
                            _isConfirmed ? Icons.check_rounded : widget.sliderIcon,
                            color: widget.backgroundColor,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
