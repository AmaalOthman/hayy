import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';

/// One box per digit, backed by a single invisible TextField so paste,
/// backspace and iOS SMS autofill all behave natively.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
    this.hasError = false,
    this.enabled = true,
    this.length = AppConstants.otpLength,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onCompleted;
  final bool hasError;
  final bool enabled;
  final int length;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_rebuild);
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_rebuild);
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  /// The controller also notifies on cursor moves; fire once per full code.
  String? _lastCompleted;

  void _onChanged() {
    setState(() {});
    final code = widget.controller.text;
    if (code.length < widget.length) {
      _lastCompleted = null;
    } else if (code != _lastCompleted) {
      _lastCompleted = code;
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text;
    final focused = widget.focusNode.hasFocus;
    final text = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < widget.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: AppRadius.mdAll,
                      border: Border.all(
                        width: _isActive(i, code, focused) ? 1.8 : 1,
                        color: _borderColor(i, code, focused),
                      ),
                      boxShadow: _isActive(i, code, focused)
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.duskBlue.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      i < code.length ? code[i] : '',
                      style: text.headlineMedium?.copyWith(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                autofocus: true,
                showCursor: false,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isActive(int i, String code, bool focused) =>
      focused &&
      (i == code.length || (i == widget.length - 1 && code.length == widget.length));

  Color _borderColor(int i, String code, bool focused) {
    if (widget.hasError) return AppColors.error;
    if (_isActive(i, code, focused)) return AppColors.duskBlue;
    if (i < code.length) return AppColors.mutedCopper;
    return AppColors.warmTravertine;
  }
}
