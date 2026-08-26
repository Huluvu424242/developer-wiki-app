import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

class BoundedTextFormField extends StatefulWidget {
  const BoundedTextFormField({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.decoration,
    this.focusNode,
    this.validator,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final int maxLength;
  final InputDecoration decoration;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? minLines;
  final int? maxLines;

  @override
  State<BoundedTextFormField> createState() => _BoundedTextFormFieldState();
}

class _BoundedTextFormFieldState extends State<BoundedTextFormField> {
  bool _limitAnnounced = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleLength);
  }

  @override
  void didUpdateWidget(covariant BoundedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleLength);
      widget.controller.addListener(_handleLength);
      _limitAnnounced = false;
    }
  }

  void _handleLength() {
    final atLimit = widget.controller.text.characters.length >= widget.maxLength;
    if (atLimit && !_limitAnnounced) {
      _limitAnnounced = true;
      SystemSound.play(SystemSoundType.alert);
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Kein Zeichen mehr möglich',
        Directionality.of(context),
      );
    } else if (!atLimit) {
      _limitAnnounced = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      minLines: widget.obscureText ? 1 : widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: widget.decoration,
      validator: widget.validator,
      buildCounter: (
        context, {
        required currentLength,
        required isFocused,
        maxLength,
      }) {
        final remaining = (maxLength ?? widget.maxLength) - currentLength;
        if (remaining > 10) {
          return null;
        }
        final message =
            remaining == 0 ? 'Kein Zeichen mehr möglich' : 'noch $remaining Zeichen';
        return Semantics(
          liveRegion: remaining == 0,
          label: message,
          child: Text(message),
        );
      },
    );
  }
}
