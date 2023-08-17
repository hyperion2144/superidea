import 'parser.dart';

abstract class Block {
  Block();

  /// Get the regex used to identify the beginning of this block, if any.
  RegExp get pattern;

  /// Get the block marker if it have.
  /// Like "> ","- ","1. "...
  String? get marker;

  Block? parent;

  bool canMatch(LineParser parser) {
    return pattern.hasMatch(parser.textParser.source);
  }

  void match(LineParser parser);
}
