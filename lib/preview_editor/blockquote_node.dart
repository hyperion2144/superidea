import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

///Tag: [MarkdownTag.blockquote]
///
/// A block quote marker, optionally preceded by up to three spaces of indentation
class BlockquoteNode2 extends BlockquoteNode {
  BlockquoteNode2(super.config);

  @override
  InlineSpan build() {
    return childrenSpan;
  }
}
