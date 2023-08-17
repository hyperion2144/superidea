import 'package:markdown/markdown.dart';

import '../patterns.dart';

/// Parses paragraphs of regular text.
class ParagraphSyntax extends BlockSyntax {
  @override
  RegExp get pattern => dummyPattern;

  @override
  bool canEndBlock(BlockParser parser) => false;

  const ParagraphSyntax();

  @override
  bool canParse(BlockParser parser) => true;

  @override
  Node? parse(BlockParser parser) {
    final childLines = <String>[parser.current.content];

    parser.advance();
    var interruptedBySetextHeading = false;
    // Eat until we hit something that ends a paragraph.
    while (!parser.isDone) {
      final syntax = interruptedBy(parser);
      if (syntax != null) {
        interruptedBySetextHeading = syntax is SetextHeaderSyntax;
        break;
      }
      childLines.add(parser.current.content);
      parser.advance();
    }

    // It is not a paragraph, but a setext heading.
    if (interruptedBySetextHeading) {
      return null;
    }

    final contents = UnparsedContent(childLines.join());
    return Element('p', [contents]);
  }
}
