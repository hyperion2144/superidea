import 'package:flutter/material.dart';

abstract class SpanNode {
  SpanNode();

  final List<SpanNode> _children = [];
  List<TextSpan> get childrenSpan =>
      List.generate(_children.length, (i) => _children[i].build());

  TextSpan build() {
    return TextSpan(style: style, children: childrenSpan);
  }

  TextStyle? get style;
}

class TextSpanNode extends SpanNode {
  final String text;
  final TextStyle? _style;

  TextSpanNode(this.text, {TextStyle? style}) : _style = style;

  @override
  TextSpan build() {
    return TextSpan(text: text, style: _style);
  }

  @override
  TextStyle? get style => _style;
}
