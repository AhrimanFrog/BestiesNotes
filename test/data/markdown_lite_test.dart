import 'package:besties_notes/data/markdown_lite.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue v(String text, int start, [int? end]) => TextEditingValue(
  text: text,
  selection: TextSelection(baseOffset: start, extentOffset: end ?? start),
);

void main() {
  group('parse', () {
    test('one block per line', () {
      final blocks = MarkdownLite.parse(
        'Plan\n- verbs\n- [ ] page 12\n* [x] page 11\n\nend',
      );
      expect(blocks.map((b) => b.runtimeType), [
        MdParagraph,
        MdBullet,
        MdCheckbox,
        MdCheckbox,
        MdBlank,
        MdParagraph,
      ]);
      expect((blocks[2] as MdCheckbox).checked, isFalse);
      expect((blocks[3] as MdCheckbox).checked, isTrue);
      expect((blocks[2] as MdCheckbox).plainText, 'page 12');
      expect(blocks[5].line, 5);
    });

    test('bold, italic, and italic inside bold', () {
      expect(MarkdownLite.parseInline('a **b** _c_ *d* **e _f_**'), const [
        MdSpan('a '),
        MdSpan('b', bold: true),
        MdSpan(' '),
        MdSpan('c', italic: true),
        MdSpan(' '),
        MdSpan('d', italic: true),
        MdSpan(' '),
        MdSpan('e ', bold: true),
        MdSpan('f', bold: true, italic: true),
      ]);
    });

    test('an item with no text yet is a gap, not a checkbox', () {
      const body = '- [x] page 12\n- [ ] ';
      expect(MarkdownLite.parse(body).last, const MdBlank(line: 1));
      expect(MarkdownLite.checklistProgress(body), (done: 1, total: 1));
    });

    test('unmatched marks stay as text', () {
      expect(MarkdownLite.parseInline('2 * 3 = 6, snake_case'), const [
        MdSpan('2 * 3 = 6, snake_case'),
      ]);
    });
  });

  test('toggleCheckbox flips only that line', () {
    const body = '- [ ] one\n- [x] two\ntext';
    expect(MarkdownLite.toggleCheckbox(body, 0), '- [x] one\n- [x] two\ntext');
    expect(MarkdownLite.toggleCheckbox(body, 1), '- [ ] one\n- [ ] two\ntext');
    expect(MarkdownLite.toggleCheckbox(body, 2), body);
  });

  test('checklistProgress and plainText', () {
    const body = '**Homework**\n- [x] read\n- [ ] write';
    expect(MarkdownLite.checklistProgress(body), (done: 1, total: 2));
    expect(MarkdownLite.plainText(body), 'Homework · read · write');
  });

  group('editing', () {
    test('toggleWrap wraps and unwraps the selection', () {
      final bold = MarkdownLite.toggleWrap(v('a word b', 2, 6), '**');
      expect(bold.text, 'a **word** b');
      expect(
        bold.selection,
        const TextSelection(baseOffset: 4, extentOffset: 8),
      );
      expect(MarkdownLite.toggleWrap(bold, '**').text, 'a word b');
    });

    test('toggleWrap with a caret inserts a pair around it', () {
      final r = MarkdownLite.toggleWrap(v('ab', 1), '_');
      expect(r.text, 'a__b');
      expect(r.selection, const TextSelection.collapsed(offset: 2));
    });

    test('toggleList converts every selected line, then back', () {
      final list = MarkdownLite.toggleList(
        v('one\ntwo\nthree', 1, 5),
        MdListKind.checkbox,
      );
      expect(list.text, '- [ ] one\n- [ ] two\nthree');
      expect(
        MarkdownLite.toggleList(list, MdListKind.checkbox).text,
        'one\ntwo\nthree',
      );
    });

    test('toggleList switches a bullet to a checkbox', () {
      final r = MarkdownLite.toggleList(v('- milk', 6), MdListKind.checkbox);
      expect(r.text, '- [ ] milk');
      expect(r.selection, const TextSelection.collapsed(offset: 10));
    });

    test('Enter continues a list with a fresh item', () {
      final r = MarkdownLite.continueList(
        v('- [x] done', 10),
        v('- [x] done\n', 11),
      );
      expect(r!.text, '- [x] done\n- [ ] ');
      expect(r.selection, const TextSelection.collapsed(offset: 17));
    });

    test('Enter on an empty item ends the list', () {
      final r = MarkdownLite.continueList(v('- a\n- ', 6), v('- a\n- \n', 7));
      expect(r!.text, '- a\n');
      expect(r.selection, const TextSelection.collapsed(offset: 4));
    });

    test('Enter on plain text or a paste is left alone', () {
      expect(MarkdownLite.continueList(v('a', 1), v('a\n', 2)), isNull);
      expect(MarkdownLite.continueList(v('- a', 3), v('- a\nb\n', 6)), isNull);
    });
  });
}
