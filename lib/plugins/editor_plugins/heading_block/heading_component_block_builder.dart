import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeadingBlockComponentBuilder2 extends BlockComponentBuilder {
  HeadingBlockComponentBuilder2({
    this.configuration = const BlockComponentConfiguration(),
    this.textStyleBuilder,
  });

  @override
  final BlockComponentConfiguration configuration;

  /// The text style of the heading block.
  final TextStyle Function(int level)? textStyleBuilder;

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return HeadingBlockComponentWidget(
      key: node.key,
      node: node,
      configuration: configuration,
      textStyleBuilder: textStyleBuilder,
      showActions: showActions(node),
      actionBuilder: (context, state) => actionBuilder(
        blockComponentContext,
        state,
      ),
    );
  }

  @override
  bool validate(Node node) =>
      node.delta != null &&
      node.children.isEmpty &&
      node.attributes[HeadingBlockKeys.level] is int;
}

class HeadingBlockComponentWidget extends BlockComponentStatefulWidget {
  const HeadingBlockComponentWidget({
    super.key,
    required super.node,
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
    this.textStyleBuilder,
  });

  /// The text style of the heading block.
  final TextStyle Function(int level)? textStyleBuilder;

  @override
  State<HeadingBlockComponentWidget> createState() =>
      _HeadingBlockComponentWidgetState();
}

class _HeadingBlockComponentWidgetState
    extends State<HeadingBlockComponentWidget>
    with
        SelectableMixin,
        DefaultSelectableMixin,
        BlockComponentConfigurable,
        BlockComponentBackgroundColorMixin,
        BlockComponentTextDirectionMixin {
  @override
  final forwardKey = GlobalKey(debugLabel: 'flowy_rich_text');

  @override
  GlobalKey<State<StatefulWidget>> get containerKey => widget.node.key;

  @override
  GlobalKey<State<StatefulWidget>> blockComponentKey = GlobalKey(
    debugLabel: HeadingBlockKeys.type,
  );

  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  Node get node => widget.node;

  late final editorState = Provider.of<EditorState>(context);

  int get level => widget.node.attributes[HeadingBlockKeys.level] as int? ?? 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = calculateTextDirection(
      defaultTextDirection: Directionality.maybeOf(context),
    );

    Widget child = Container(
      color: backgroundColor,
      width: double.infinity,
      child: Row(
        children: [
          AppFlowyRichText(
            key: forwardKey,
            node: widget.node,
            editorState: editorState,
            textSpanDecorator: (textSpan) =>
                textSpan.updateTextStyle(textStyle).updateTextStyle(
                      widget.textStyleBuilder?.call(level) ??
                          defaultTextStyle(level),
                    ),
            placeholderText: placeholderText,
            placeholderTextSpanDecorator: (textSpan) => textSpan
                .updateTextStyle(
                  placeholderTextStyle,
                )
                .updateTextStyle(
                  widget.textStyleBuilder?.call(level) ??
                      defaultTextStyle(level),
                ),
            textDirection: textDirection,
          ),
          const Divider(thickness: 2),
        ],
      ),
    );

    child = Padding(
      key: blockComponentKey,
      padding: padding,
      child: child,
    );

    if (widget.showActions && widget.actionBuilder != null) {
      child = BlockComponentActionWrapper(
        node: node,
        actionBuilder: widget.actionBuilder!,
        child: child,
      );
    }

    return child;
  }

  TextStyle? defaultTextStyle(int level) {
    final fontSizes = [32.0, 28.0, 24.0, 18.0, 18.0, 18.0];
    final fontSize = fontSizes.elementAtOrNull(level) ?? 18.0;
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
