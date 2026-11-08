import 'package:flutter/material.dart';

import 'message_composer.dart';

class SendMessageFooter extends StatefulWidget {
  const SendMessageFooter({
    super.key,
    this.controller,
    this.onSend,
    this.onMicrophonePressed,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onSend;
  final VoidCallback? onMicrophonePressed;

  @override
  State<SendMessageFooter> createState() => _SendMessageFooterState();
}

class _SendMessageFooterState extends State<SendMessageFooter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant SendMessageFooter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    final onSend = widget.onSend;
    if (message.isEmpty || onSend == null) return;

    onSend(message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(40),
                clipBehavior: Clip.antiAlias,
                child: MessageComposer(
                  controller: _controller,
                  onSend: widget.onSend == null ? null : _sendMessage,
                  onMicrophonePressed: widget.onMicrophonePressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
