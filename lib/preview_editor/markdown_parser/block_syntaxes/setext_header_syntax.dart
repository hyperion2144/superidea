import 'package:markdown/markdown.dart';

import '../patterns.dart';

/// Parses setext-style headers.
class SetextHeaderSyntax extends BlockSyntax {
  @override
  RegExp get pattern => setextPattern;

  const SetextHeaderSyntax();

  @override
  bool canParse(BlockParser parser) {
    final lastSyntax = parser.currentSyntax;
    if (parser.setextHeadingDisabled || lastSyntax is! ParagraphSyntax) {
      return false;
    }
    return pattern.hasMatch(parser.current.content);
  }

  @override
  Node? parse(BlockParser parser) {
    final lines = parser.linesToConsume;
    if (lines.length < 2) {
      return null;
    }

    // Remove the last line which is a marker.
    lines.removeLast();

    final marker = parser.current.content.trim();
    final level = (marker[0] == '=') ? '1' : '2';
    final content = parser.linesToConsume.map((e) => e.content).join();

    parser.advance();
    return Element('h$level', [UnparsedContent(content)]);
  }
}
