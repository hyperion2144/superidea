import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as hi;
import 'package:markdown_widget/markdown_widget.dart';

class CodeBlockNode2 extends CodeBlockNode {
  CodeBlockNode2(super.content, super.preConfig);

  @override
  InlineSpan build() {
    final splitContents = content.split(RegExp(r'(\r?\n)|(\r?\t)|(\r)'));
    // if (splitContents.last.isEmpty) splitContents.removeLast();

    final List<InlineSpan> children = [];
    for (int i = 0; i < splitContents.length; i++) {
      var content = splitContents[i];
      if (i + 1 < splitContents.length) {
        content += '\n';
      }

      if (content.isEmpty) continue;

      children.add(TextSpan(
        children: highLightSpans(
          content,
          language: preConfig.language,
          theme: preConfig.theme,
          textStyle: style,
          styleNotMatched: preConfig.styleNotMatched,
        ),
      ));
    }

    return TextSpan(
        style: preConfig.textStyle.merge(parentStyle), children: children);
  }
}

///transform code to highlight code
List<InlineSpan> highLightSpans(
  String input, {
  String? language,
  bool autoDetectionLanguage = false,
  Map<String, TextStyle> theme = const {},
  TextStyle? textStyle,
  TextStyle? styleNotMatched,
  int tabSize = 8,
}) {
  return convertHiNodes(
      hi.highlight
          .parse(input,
              language: autoDetectionLanguage ? null : language,
              autoDetection: autoDetectionLanguage)
          .nodes!,
      theme,
      textStyle,
      styleNotMatched);
}

List<TextSpan> convertHiNodes(
  List<hi.Node> nodes,
  Map<String, TextStyle> theme,
  TextStyle? style,
  TextStyle? styleNotMatched,
) {
  List<TextSpan> spans = [];
  var currentSpans = spans;
  List<List<TextSpan>> stack = [];

  _traverse(hi.Node node, TextStyle? parentStyle) {
    final nodeStyle = parentStyle ?? theme[node.className ?? ''];
    final finallyStyle = (nodeStyle ?? styleNotMatched)?.merge(style);
    if (node.value != null) {
      currentSpans.add(node.className == null
          ? TextSpan(text: node.value, style: finallyStyle)
          : TextSpan(text: node.value, style: finallyStyle));
    } else if (node.children != null) {
      List<TextSpan> tmp = [];
      currentSpans.add(TextSpan(children: tmp, style: finallyStyle));
      stack.add(currentSpans);
      currentSpans = tmp;

      for (var n in node.children!) {
        _traverse(n, nodeStyle);
        if (n == node.children!.last) {
          currentSpans = stack.isEmpty ? spans : stack.removeLast();
        }
      }
    }
  }

  for (var node in nodes) {
    _traverse(node, null);
  }
  return spans;
}
