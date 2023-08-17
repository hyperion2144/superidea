import '../nodes/node.dart';
import 'block.dart';
import 'text_parser.dart';

class LineParser {
  final TextParser textParser;

  final List<Block> blocks = [];

  Block? currentBlock;

  LineParser({
    required String source,
  }) : textParser = TextParser(source);

  SpanNode parse(Block? lastBlock) {
    for (final block in blocks) {
      currentBlock = block;
      block.match(this);
    }

    return TextSpanNode('');
  }
}
