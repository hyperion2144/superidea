import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_widget/markdown_widget.dart';
import 'package:superidea/theme.dart';

import 'blockquote_node.dart';
import 'code_block_node.dart';
import 'heading_node.dart';
import 'list_node.dart';
import 'uo_node.dart';

class SpanBuilder implements md.NodeVisitor {
  final List<SpanNode> _spans = [];

  int _currentSpanIndex = 0;

  String text = '';

  final List<SpanNode> _spanStack = [];

  final TextStyle? rootStyle;

  final MarkdownConfig config = MarkdownConfig.defaultConfig;

  SpanBuilder({this.rootStyle});

  TextSpan visit(List<md.Node> nodes) {
    text = '';
    _spans.clear();
    _spanStack.clear();
    _currentSpanIndex = 0;
    for (final node in nodes) {
      final emptyNode = ConcreteElementNode();
      _spans.add(emptyNode);
      _currentSpanIndex = _spans.length - 1;
      _spanStack.add(emptyNode);
      node.accept(this);
      _spanStack.removeLast();
    }

    final children = _spans.map((e) {
      final span = e.build();
      if (span is TextSpan) {
        span.children?.add(TextSpan(text: '\n'));
      }
      return span;
    }).toList();
    _spans.clear();
    _spanStack.clear();

    return TextSpan(style: rootStyle, children: children);
  }

  @override
  void visitElementAfter(md.Element element) {
    _spanStack.removeLast();
  }

  @override
  bool visitElementBefore(md.Element element) {
    final node = getNodeByElement(element, config);
    final last = _spanStack.last;
    if (last is ElementNode) {
      last.accept(node);
    }
    _spanStack.add(node);

    return true;
  }

  @override
  void visitText(md.Text text) {
    final last = _spanStack.last;
    if (last is ElementNode) {
      final textNode = TextNode(text: text.text, style: config.p.textStyle);
      last.accept(textNode);
    }
  }

  ///every tag has it's own [SpanNodeGenerator]
  final _tag2node = <String, SpanNodeGenerator>{
    MarkdownTag.h1.name: (e, config, visitor) => HeadingNode2(config.h1),
    MarkdownTag.h2.name: (e, config, visitor) => HeadingNode2(config.h2),
    MarkdownTag.h3.name: (e, config, visitor) => HeadingNode2(config.h3),
    MarkdownTag.h4.name: (e, config, visitor) => HeadingNode2(config.h4),
    MarkdownTag.h5.name: (e, config, visitor) => HeadingNode2(config.h5),
    MarkdownTag.h6.name: (e, config, visitor) => HeadingNode2(config.h6),
    'number': (e, config, visitor) => TextNode(
        text: e.textContent,
        style: config.p.textStyle.copyWith(color: primaryColor)),
    MarkdownTag.li.name: (e, config, visitor) => ListNode2(config),
    MarkdownTag.ol.name: (e, config, visitor) =>
        UlOrOLNode2(e.tag, e.attributes, config.li),
    MarkdownTag.ul.name: (e, config, visitor) =>
        UlOrOLNode2(e.tag, e.attributes, config.li),
    MarkdownTag.blockquote.name: (e, config, visitor) =>
        BlockquoteNode2(config.blockquote),
    MarkdownTag.pre.name: (e, config, visitor) =>
        CodeBlockNode2(e.textContent, config.pre),
    MarkdownTag.hr.name: (e, config, visitor) =>
        TextNode(text: e.textContent, style: TextStyle(color: config.hr.color)),
    MarkdownTag.p.name: (e, config, visitor) => ParagraphNode(config.p),
    MarkdownTag.a.name: (e, config, visitor) =>
        LinkNode(e.attributes, config.a),
    MarkdownTag.del.name: (e, config, visitor) => DelNode(),
    MarkdownTag.strong.name: (e, config, visitor) => StrongNode(),
    MarkdownTag.em.name: (e, config, visitor) => EmNode(),
    MarkdownTag.code.name: (e, config, visitor) =>
        CodeNode(e.textContent, config.code),
  };

  SpanNode getNodeByElement(md.Element element, MarkdownConfig config) {
    return _tag2node[element.tag]?.call(element, config, this) ??
        TextNode(text: element.textContent);
  }
}

///use [SpanNodeGenerator] will return a [SpanNode]
typedef SpanNodeGenerator = SpanNode Function(
    md.Element e, MarkdownConfig config, SpanBuilder visitor);
