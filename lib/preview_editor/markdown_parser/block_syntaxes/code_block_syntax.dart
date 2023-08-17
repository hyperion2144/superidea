import 'package:markdown/markdown.dart';

import '../../util.dart';
import '../patterns.dart';

/// Parses preformatted code blocks that are indented four spaces.
class CodeBlockSyntax extends BlockSyntax {
  @override
  RegExp get pattern => indentPattern;

  @override
  bool canEndBlock(BlockParser parser) => false;

  const CodeBlockSyntax();

  @override
  List<Line> parseChildLines(BlockParser parser) {
    final childLines = <Line>[];

    while (!parser.isDone) {
      final isBlankLine = parser.current.isBlankLine;
      if (isBlankLine && _shouldEnd(parser)) {
        break;
      }

      if (!isBlankLine &&
          childLines.isNotEmpty &&
          pattern.hasMatch(parser.current.content) != true) {
        break;
      }

      childLines.add(Line(
        parser.current.content,
        tabRemaining: parser.current.tabRemaining,
      ));

      parser.advance();
    }

    return childLines;
  }

  @override
  Node parse(BlockParser parser) {
    final childLines = parseChildLines(parser);

    var content = childLines.map((e) => e.content).join('');
    if (parser.document.encodeHtml) {
      content = escapeHtml(content, escapeApos: false);
    }

    return Element('pre', [Element.text('code', content)]);
  }

  bool _shouldEnd(BlockParser parser) {
    var i = 1;
    while (true) {
      final nextLine = parser.peek(i);
      // EOF
      if (nextLine == null) {
        return true;
      }

      // It does not matter how many blank lines between chunks:
      // https://spec.commonmark.org/0.30/#example-111
      if (nextLine.isBlankLine) {
        i++;
        continue;
      }

      return pattern.hasMatch(nextLine.content) == false;
    }
  }
}
