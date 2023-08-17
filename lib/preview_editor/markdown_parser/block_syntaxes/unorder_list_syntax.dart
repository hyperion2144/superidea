import 'package:markdown/markdown.dart';

import '../patterns.dart';
import '../test_parser.dart';

/// Parses unordered lists.
class UnorderedListSyntax extends ListSyntax {
  @override
  RegExp get pattern => listPattern;

  @override
  bool canParse(BlockParser parser) {
    // Check if it matches `hrPattern`, otherwise it will produce an infinite
    // loop if put `UnorderedListSyntax` or `UnorderedListWithCheckboxSyntax`
    // bofore `HorizontalRuleSyntax` and parse:
    // ```
    // * * *
    // ```
    if (hrPattern.hasMatch(parser.current.content)) {
      return false;
    }

    return pattern.hasMatch(parser.current.content);
  }

  const UnorderedListSyntax();

  @override
  Node parse(BlockParser parser) {
    while (!parser.isDone) {
      final childLines = <Node>[];
      final match = pattern.firstMatch(parser.current.content);

      if (match != null) {
        final textParser = TextParser(parser.current.content);
        final markerStart = textParser.pos;
        final digits = match[1] ?? '';
        if (digits.isNotEmpty) {
          textParser.advanceBy(digits.length);
        }
        textParser.advance();

        // See https://spec.commonmark.org/0.30/#ordered-list-marker
        final marker = textParser.substring(
          markerStart,
          textParser.pos,
        );
        final line = textParser.substring(textParser.pos);

        final ordered = match[1] != null;

        childLines.add(Element('number', [Text(marker)]));
        childLines.add(Text(line));

        parser.advance();
        return Element(ordered ? 'ol' : 'ul', childLines);
      }
      break;
    }

    return Element.empty('p');
  }
}
