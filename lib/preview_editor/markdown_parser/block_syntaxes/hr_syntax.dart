import 'package:markdown/markdown.dart';

import '../patterns.dart';

/// Parses horizontal rules like `---`, `_ _ _`, `*  *  *`, etc.
class HorizontalRuleSyntax extends BlockSyntax {
  @override
  RegExp get pattern => hrPattern;

  const HorizontalRuleSyntax();

  @override
  Node parse(BlockParser parser) {
    final content = parser.current.content;
    parser.advance();
    return Element.text('hr', content);
  }
}
