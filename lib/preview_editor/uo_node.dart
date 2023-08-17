import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

///Tag [MarkdownTag.ol]、[MarkdownTag.ul]
///
/// ordered list and unordered widget
class UlOrOLNode2 extends UlOrOLNode {
  UlOrOLNode2(super.tag, super.attribute, super.config);

  @override
  InlineSpan build() {
    final List<InlineSpan> _children = [];
    for (final node in children) {
      final childNode = node.build();
      if (childNode is TextSpan) {
        childNode.children?.add(TextSpan(text: '\n'));
      }
      _children.add(childNode);
    }
    return TextSpan(style: style, children: _children);
  }

  @override
  TextStyle? get style => parentStyle;
}
