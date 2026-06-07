import 'package:flutter/material.dart';

class StatusButton extends StatelessWidget {
  const StatusButton({
    super.key,
    required this._label,
    required this._isLoading,
    required this._isError,
    required this._errorText,
    required this._onPressed,
  });

  final String _label;
  final bool _isLoading;
  final bool _isError;
  final String _errorText;
  final VoidCallback? _onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_createButton(), const SizedBox(height: 16), _createError()],
    );
  }

  Widget _createButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA20021),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _isLoading
                ? const SizedBox(
                    key: ValueKey("loading"),
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _label,
                    key: const ValueKey("text"),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _createError() {
    return SizedBox(
      height: 40,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isError
              ? Text(
                  _errorText,
                  key: const ValueKey("error"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                )
              : const SizedBox.shrink(key: ValueKey("empty")),
        ),
      ),
    );
  }
}
