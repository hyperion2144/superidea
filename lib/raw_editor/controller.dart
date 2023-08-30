import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class MarkdownController extends TextEditingController {
  final String lineSeparator;

  MarkdownController({
    super.text,
    this.lineSeparator = '\n',
  });

  MarkdownController copyWith({
    String? text,
    String? lineSeparator,
    bool? lineWrap,
  }) {
    return MarkdownController(
      text: text ?? this.text,
      lineSeparator: lineSeparator ?? this.lineSeparator,
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // 拆分行
    final lines = super.text.split(lineSeparator);
    // 解析单行
    final List<InlineSpan> children = [];
    for (final line in lines) {
      // 将该行包裹在warp中
      children.add(
        TextSpan(
          text: line,
          style: const TextStyle(
            textBaseline: TextBaseline.alphabetic,
            decoration: TextDecoration.lineThrough,
            decorationColor: MacosColors.controlColor,
            decorationStyle: TextDecorationStyle.double,
          ),
        ),
      );
    }

    return TextSpan(style: style, children: children);
  }
}
