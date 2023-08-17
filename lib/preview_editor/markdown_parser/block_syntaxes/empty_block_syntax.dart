import 'package:markdown/markdown.dart';

import '../patterns.dart';

class EmptyBlockSyntax extends BlockSyntax {
  @override
  RegExp get pattern => emptyPattern;

  const EmptyBlockSyntax();

  @override
  Node? parse(BlockParser parser) {
    final content = parser.current.content;
    parser.encounteredBlankLine = true;
    parser.advance();

    // Don't actually emit anything.
    return Text(content);
  }
}
