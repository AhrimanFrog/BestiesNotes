import 'package:besties_notes/data/markdown_lite.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Renders a note's Markdown-lite body. Checkboxes are tappable when
/// [onToggleCheckbox] is set.
class MarkdownView extends StatelessWidget {
  final String body;
  final ValueChanged<int>? onToggleCheckbox;

  const MarkdownView({super.key, required this.body, this.onToggleCheckbox});

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in MarkdownLite.parse(body))
          switch (block) {
            MdBlank() => const SizedBox(height: AppSpacing.md),
            MdParagraph(:final spans) => Text.rich(_spans(spans), style: style),
            MdBullet(:final spans) => _ListLine(
              marker: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text('•', style: style),
              ),
              child: Text.rich(_spans(spans), style: style),
            ),
            MdCheckbox(:final spans, :final checked, :final line) => _ListLine(
              marker: _Checkbox(
                checked: checked,
                label: block.plainText,
                onTap: onToggleCheckbox != null
                    ? () => onToggleCheckbox!(line)
                    : null,
              ),
              child: Text.rich(
                _spans(spans),
                style: checked
                    ? style.copyWith(
                        color: context.tokens.textMuted,
                        decoration: TextDecoration.lineThrough,
                      )
                    : style,
              ),
            ),
          },
      ],
    );
  }

  static TextSpan _spans(List<MdSpan> spans) => TextSpan(
    children: [
      for (final s in spans)
        TextSpan(
          text: s.text,
          style: TextStyle(
            fontWeight: s.bold ? FontWeight.w800 : null,
            fontStyle: s.italic ? FontStyle.italic : null,
          ),
        ),
    ],
  );
}

class _ListLine extends StatelessWidget {
  final Widget marker;
  final Widget child;

  const _ListLine({required this.marker, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        marker,
        Expanded(
          child: Padding(padding: const EdgeInsets.only(top: 1), child: child),
        ),
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool checked;
  final String label;
  final VoidCallback? onTap;

  const _Checkbox({required this.checked, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      checked: checked,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Padding(
          // Text-height row, but a comfortable tap area around the box.
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            2,
            AppSpacing.sm,
            AppSpacing.xs,
          ),
          child: Icon(
            checked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            size: 22,
            color: checked ? tokens.tone(StatusTone.done).fg : tokens.textMuted,
          ),
        ),
      ),
    );
  }
}
