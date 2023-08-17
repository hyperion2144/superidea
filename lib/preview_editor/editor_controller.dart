import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'markdown_parser/block_syntaxes/blockquote_syntax.dart';
import 'markdown_parser/block_syntaxes/code_block_syntax.dart';
import 'markdown_parser/block_syntaxes/empty_block_syntax.dart';
import 'markdown_parser/block_syntaxes/header_syntax.dart';
import 'markdown_parser/block_syntaxes/hr_syntax.dart';
import 'markdown_parser/block_syntaxes/html_block_syntax.dart';
import 'markdown_parser/block_syntaxes/paragraph_syntax.dart';
import 'markdown_parser/block_syntaxes/setext_header_syntax.dart';
import 'markdown_parser/block_syntaxes/unorder_list_syntax.dart';
import 'span_builder.dart';

class EditorController extends TextEditingController {
  final document = md.Document(
    encodeHtml: false,
    withDefaultBlockSyntaxes: false,
    withDefaultInlineSyntaxes: false,
    blockSyntaxes: [
      const EmptyBlockSyntax(),
      const HtmlBlockSyntax(),
      const SetextHeaderSyntax(),
      const HeaderSyntax(),
      const CodeBlockSyntax(),
      const BlockquoteSyntax(),
      const HorizontalRuleSyntax(),
      const UnorderedListSyntax(),
      const ParagraphSyntax(),
    ],
  );

  EditorController({super.text});

  @override
  set value(TextEditingValue newValue) {
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final lines = super.text.split('\n');
    final nodes = document.parseLines(lines);

    return SpanBuilder(rootStyle: style).visit(nodes);
  }
}
