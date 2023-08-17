import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

///Tag [MarkdownTag.li]
///
/// A list is a sequence of one or more list items of the same type.
/// The list items may be separated by any number of blank lines.
class ListNode2 extends ListNode {
  ListNode2(super.config);

  @override
  InlineSpan build() {
    return childrenSpan;
  }
}
