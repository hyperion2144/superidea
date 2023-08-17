import 'package:markdown/markdown.dart' hide ParagraphSyntax, CodeBlockSyntax;

import '../../charcode.dart';
import '../../util.dart';
import '../patterns.dart';

/// Parses email-style blockquotes: `> quote`.
class BlockquoteSyntax extends BlockSyntax {
  @override
  RegExp get pattern => blockquotePattern;

  const BlockquoteSyntax();

  /// Whether this blockquote ends with a lazy continuation line.
  // The definition of lazy continuation lines:
  // https://spec.commonmark.org/0.30/#lazy-continuation-line
  static var _lazyContinuation = false;

  @override
  List<Line> parseChildLines(BlockParser parser) {
    // Grab all of the lines that form the blockquote, stripping off the ">".
    final childLines = <Line>[];
    _lazyContinuation = false;

    while (!parser.isDone) {
      final currentLine = parser.current;
      final match = pattern.firstMatch(parser.current.content);
      if (match != null) {
        // A block quote marker consists of a `>` together with an optional
        // following space of indentation, see
        // https://spec.commonmark.org/0.30/#block-quote-marker.
        final markerStart = match.match.indexOf('>');
        int markerEnd;
        if (currentLine.content.length > 1) {
          var hasSpace = false;
          // Check if there is a following space if the marker is not at the end
          // of this line.
          if (markerStart < currentLine.content.length - 1) {
            final nextChar = currentLine.content.codeUnitAt(markerStart + 1);
            hasSpace = nextChar == $tab || nextChar == $space;
          }
          markerEnd = markerStart + (hasSpace ? 2 : 1);
        } else {
          markerEnd = markerStart + 1;
        }
        childLines.add(Line(currentLine.content.substring(0, markerEnd - 1)));
        childLines
            .add(Line(currentLine.content.substring(markerEnd - 1, markerEnd)));
        childLines.add(Line(currentLine.content.substring(markerEnd)));
        parser.advance();
        _lazyContinuation = false;
        continue;
      }
      break;
    }

    return childLines;
  }

  @override
  Node parse(BlockParser parser) {
    final childLines = parseChildLines(parser);

    // Recursively parse the contents of the blockquote.
    final children = BlockParser(childLines, parser.document).parseLines(
      // The setext heading underline cannot be a lazy continuation line in a
      // block quote.
      // https://spec.commonmark.org/0.30/#example-93
      disabledSetextHeading: _lazyContinuation,
      parentSyntax: this,
    );

    return Element('blockquote', children);
  }
}
