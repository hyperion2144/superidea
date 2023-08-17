import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

///Tag: [MarkdownTag.h1] ~ [MarkdownTag.h6]
///
///An ATX heading consists of a string of characters
///A setext heading consists of one or more lines of text
class HeadingNode2 extends HeadingNode {
  HeadingNode2(super.headingConfig);

  @override
  InlineSpan build() {
    return childrenSpan;
  }
}
