import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// The small Markdown subset notes use, one block per line:
///
///     **bold**, _italic_ (or *italic*)
///     - bullet
///     - [ ] checkbox / - [x] done
///
/// Anything else is plain text, so a stray `*` never breaks a note.
abstract final class MarkdownLite {
  static final _checkbox = RegExp(r'^(\s*)[-*] \[([ xX])\] ?');
  static final _bullet = RegExp(r'^(\s*)[-*] ');
  static final _inline = RegExp(r'\*\*(.+?)\*\*|_(.+?)_|\*(.+?)\*');

  static List<MdBlock> parse(String body) {
    final lines = body.split('\n');
    return [for (final (i, line) in lines.indexed) _block(i, line)];
  }

  static MdBlock _block(int line, String text) {
    // An item with no text yet (Enter just started it) is just a gap.
    if (_stripPrefix(text).trim().isEmpty) return MdBlank(line: line);
    if (_checkbox.firstMatch(text) case final m?) {
      return MdCheckbox(
        line: line,
        checked: m.group(2) != ' ',
        spans: parseInline(text.substring(m.end)),
      );
    }
    if (_bullet.firstMatch(text) case final m?) {
      return MdBullet(line: line, spans: parseInline(text.substring(m.end)));
    }
    return MdParagraph(line: line, spans: parseInline(text));
  }

  static List<MdSpan> parseInline(String text, {bool bold = false}) {
    final spans = <MdSpan>[];
    var last = 0;
    for (final m in _inline.allMatches(text)) {
      if (m.start > last) {
        spans.add(MdSpan(text.substring(last, m.start), bold: bold));
      }
      if (m.group(1) case final inner?) {
        spans.addAll(parseInline(inner, bold: true));
      } else {
        spans.add(MdSpan(m.group(2) ?? m.group(3)!, bold: bold, italic: true));
      }
      last = m.end;
    }
    if (last < text.length) spans.add(MdSpan(text.substring(last), bold: bold));
    return spans;
  }

  /// [body] with the checkbox on [line] ticked or unticked.
  static String toggleCheckbox(String body, int line) {
    final lines = body.split('\n');
    final m = _checkbox.firstMatch(lines[line]);
    if (m == null) return body;
    final mark = m.group(2) == ' ' ? 'x' : ' ';
    final at = m.start + m.group(0)!.indexOf('[') + 1;
    lines[line] = lines[line].replaceRange(at, at + 1, mark);
    return lines.join('\n');
  }

  /// Done/total of the note's checkboxes; total is 0 without any.
  static ({int done, int total}) checklistProgress(String body) {
    final boxes = parse(body).whereType<MdCheckbox>();
    return (done: boxes.where((b) => b.checked).length, total: boxes.length);
  }

  /// The text without formatting marks, on one line, for list previews.
  static String plainText(String body) {
    return [
      for (final block in parse(body))
        if (block is MdTextBlock) block.plainText,
    ].join(' · ');
  }

  // ── Editing ───────────────────────────────────────────────────────────────

  /// Wraps the selection in [marker] (`**`, `_`), or unwraps it if it
  /// already is. With nothing selected, inserts a pair and puts the cursor
  /// between.
  static TextEditingValue toggleWrap(TextEditingValue value, String marker) {
    final text = value.text;
    final sel = value.selection;
    if (!sel.isValid) return value;
    final start = sel.start;
    final end = sel.end;
    final m = marker.length;

    final wrapped =
        start >= m &&
        end + m <= text.length &&
        text.substring(start - m, start) == marker &&
        text.substring(end, end + m) == marker;
    if (wrapped) {
      return TextEditingValue(
        text: text
            .replaceRange(end, end + m, '')
            .replaceRange(start - m, start, ''),
        selection: TextSelection(baseOffset: start - m, extentOffset: end - m),
      );
    }
    return TextEditingValue(
      text: text.replaceRange(
        start,
        end,
        '$marker${text.substring(start, end)}$marker',
      ),
      selection: TextSelection(baseOffset: start + m, extentOffset: end + m),
    );
  }

  /// Makes every line touched by the selection a [kind] list item, or plain
  /// text again when they all already are.
  static TextEditingValue toggleList(TextEditingValue value, MdListKind kind) {
    final text = value.text;
    final sel = value.selection;
    if (!sel.isValid) return value;
    final first = _lineStart(text, sel.start);
    var last = text.indexOf('\n', sel.end);
    if (last < 0) last = text.length;

    final lines = text.substring(first, last).split('\n');
    final allOfKind = lines.every((l) => _kindOf(l) == kind);
    final changed = [
      for (final line in lines)
        allOfKind ? _stripPrefix(line) : kind.prefix + _stripPrefix(line),
    ].join('\n');

    final newText = text.replaceRange(first, last, changed);
    final delta = changed.length - (last - first);
    // A single caret stays put relative to the line's text.
    final caret = sel.isCollapsed
        ? (sel.end + delta).clamp(first, first + changed.length)
        : null;
    return TextEditingValue(
      text: newText,
      selection: caret != null
          ? TextSelection.collapsed(offset: caret)
          : TextSelection(
              baseOffset: first,
              extentOffset: first + changed.length,
            ),
    );
  }

  /// Start of the line that contains [offset].
  static int _lineStart(String text, int offset) =>
      offset <= 0 ? 0 : text.lastIndexOf('\n', offset - 1) + 1;

  static MdListKind? _kindOf(String line) {
    if (_checkbox.hasMatch(line)) return MdListKind.checkbox;
    if (_bullet.hasMatch(line)) return MdListKind.bullet;
    return null;
  }

  static String _stripPrefix(String line) {
    if (_checkbox.firstMatch(line) case final m?) {
      return m.group(1)! + line.substring(m.end);
    }
    if (_bullet.firstMatch(line) case final m?) {
      return m.group(1)! + line.substring(m.end);
    }
    return line;
  }

  /// Called when Enter was typed on a list line: the new line continues the
  /// list (a fresh, unticked checkbox), and Enter on an empty item ends the
  /// list instead. Returns null when [newValue] isn't such an edit.
  static TextEditingValue? continueList(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final sel = newValue.selection;
    if (!sel.isCollapsed || sel.start < 1) return null;
    final at = sel.start;
    final inserted =
        newValue.text.length == oldValue.text.length + 1 &&
        newValue.text[at - 1] == '\n' &&
        newValue.text.replaceRange(at - 1, at, '') == oldValue.text;
    if (!inserted) return null;

    final lineStart = _lineStart(newValue.text, at - 1);
    final line = newValue.text.substring(lineStart, at - 1);
    final kind = _kindOf(line);
    if (kind == null) return null;

    final indent = RegExp(r'^\s*').stringMatch(line)!;
    if (_stripPrefix(line).trim().isEmpty) {
      // An empty item: drop it and the new line, ending the list.
      return TextEditingValue(
        text: newValue.text.replaceRange(lineStart, at, ''),
        selection: TextSelection.collapsed(offset: lineStart),
      );
    }
    final prefix = indent + kind.prefix;
    return TextEditingValue(
      text: newValue.text.replaceRange(at, at, prefix),
      selection: TextSelection.collapsed(offset: at + prefix.length),
    );
  }
}

/// Applies [MarkdownLite.continueList] while typing.
class ListContinuationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => MarkdownLite.continueList(oldValue, newValue) ?? newValue;
}

enum MdListKind {
  bullet('- '),
  checkbox('- [ ] ');

  final String prefix;
  const MdListKind(this.prefix);
}

class MdSpan extends Equatable {
  final String text;
  final bool bold;
  final bool italic;

  const MdSpan(this.text, {this.bold = false, this.italic = false});

  @override
  List<Object?> get props => [text, bold, italic];
}

sealed class MdBlock extends Equatable {
  /// The source line, for edits such as ticking a checkbox.
  final int line;

  const MdBlock({required this.line});
}

sealed class MdTextBlock extends MdBlock {
  final List<MdSpan> spans;

  const MdTextBlock({required super.line, required this.spans});

  String get plainText => spans.map((s) => s.text).join();

  @override
  List<Object?> get props => [line, spans];
}

class MdParagraph extends MdTextBlock {
  const MdParagraph({required super.line, required super.spans});
}

class MdBullet extends MdTextBlock {
  const MdBullet({required super.line, required super.spans});
}

class MdCheckbox extends MdTextBlock {
  final bool checked;

  const MdCheckbox({
    required super.line,
    required super.spans,
    required this.checked,
  });

  @override
  List<Object?> get props => [...super.props, checked];
}

class MdBlank extends MdBlock {
  const MdBlank({required super.line});

  @override
  List<Object?> get props => [line];
}
