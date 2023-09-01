import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/highlight.dart' as highlight;
import 'package:highlight/languages/all.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:superidea/plugins/editor_plugins/base/string_extension.dart';

class CodeBlockKeys {
  const CodeBlockKeys._();

  static const String type = 'code';

  /// The content of a code block.
  ///
  /// The value is a String.
  static const String delta = 'delta';

  /// The language of a code block.
  ///
  /// The value is a String.
  static const String language = 'language';
}

Node codeBlockNode({
  Delta? delta,
  String? language,
}) {
  final attributes = {
    CodeBlockKeys.delta: (delta ?? Delta()).toJson(),
    CodeBlockKeys.language: language,
  };
  return Node(
    type: CodeBlockKeys.type,
    attributes: attributes,
  );
}

// defining the callout block menu item for selection
SelectionMenuItem codeBlockItem = SelectionMenuItem.node(
  name: 'Code Block',
  iconData: Icons.abc,
  keywords: ['code', 'codeblock'],
  nodeBuilder: (editorState, _) => codeBlockNode(),
  replace: (_, node) => node.delta?.isEmpty ?? false,
);

class CodeBlockComponentBuilder extends BlockComponentBuilder {
  CodeBlockComponentBuilder({
    this.configuration = const BlockComponentConfiguration(),
    this.padding = const EdgeInsets.all(0),
  });

  @override
  final BlockComponentConfiguration configuration;

  final EdgeInsets padding;

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return CodeBlockComponentWidget(
      key: node.key,
      node: node,
      configuration: configuration,
      padding: padding,
      showActions: showActions(node),
      actionBuilder: (context, state) => actionBuilder(
        blockComponentContext,
        state,
      ),
    );
  }

  @override
  bool validate(Node node) => node.delta != null;
}

class CodeBlockComponentWidget extends BlockComponentStatefulWidget {
  const CodeBlockComponentWidget({
    super.key,
    required super.node,
    this.theme = const {},
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
    this.padding = const EdgeInsets.all(0),
  });

  final EdgeInsets padding;
  final Map<String, TextStyle> theme;

  @override
  State<CodeBlockComponentWidget> createState() =>
      _CodeBlockComponentWidgetState();
}

class _CodeBlockComponentWidgetState extends State<CodeBlockComponentWidget>
    with SelectableMixin, DefaultSelectableMixin, BlockComponentConfigurable {
  // the key used to forward focus to the richtext child
  @override
  final forwardKey = GlobalKey(debugLabel: 'flowy_rich_text');

  @override
  GlobalKey<State<StatefulWidget>> blockComponentKey = GlobalKey(
    debugLabel: CodeBlockKeys.type,
  );

  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  GlobalKey<State<StatefulWidget>> get containerKey => node.key;

  @override
  Node get node => widget.node;

  final supportedLanguages = [
    'Assembly',
    'Bash',
    'BASIC',
    'C',
    'C#',
    'CPP',
    'Clojure',
    'CSS',
    'Dart',
    'Docker',
    'Elixir',
    'Elm',
    'Erlang',
    'Fortran',
    'Go',
    'GraphQL',
    'Haskell',
    'HTML',
    'Java',
    'JavaScript',
    'JSON',
    'Kotlin',
    'LaTeX',
    'Lisp',
    'Lua',
    'Markdown',
    'MATLAB',
    'Objective-C',
    'OCaml',
    'Perl',
    'PHP',
    'PowerShell',
    'Python',
    'R',
    'Ruby',
    'Rust',
    'Scala',
    'Shell',
    'SQL',
    'Swift',
    'TypeScript',
    'Visual Basic',
    'XML',
    'YAML',
  ];
  late final languages = supportedLanguages
      .map((e) => e.toLowerCase())
      .toSet()
      .intersection(allLanguages.keys.toSet())
      .toList()
    ..add('auto')
    ..add('c')
    ..sort();

  late final editorState = context.read<EditorState>();

  String? get language => node.attributes[CodeBlockKeys.language] as String?;
  String? autoDetectLanguage;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: MacosColors.controlColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitchLanguageButton(context),
          _buildCodeBlock(context),
        ],
      ),
    );

    child = Padding(
      key: blockComponentKey,
      padding: padding,
      child: child,
    );

    if (widget.actionBuilder != null) {
      child = BlockComponentActionWrapper(
        node: widget.node,
        actionBuilder: widget.actionBuilder!,
        child: child,
      );
    }

    return child;
  }

  Widget _buildCodeBlock(BuildContext context) {
    final delta = node.delta ?? Delta();
    final content = delta.toPlainText();

    final result = highlight.highlight.parse(
      content,
      language: language,
      autoDetection: language == null,
    );
    autoDetectLanguage = language ?? result.language;

    final codeNodes = result.nodes;
    if (codeNodes == null) {
      throw Exception('Code block parse error.');
    }
    final codeTextSpans = _convert(codeNodes);
    return Padding(
      padding: widget.padding,
      child: AppFlowyRichText(
        key: forwardKey,
        node: widget.node,
        editorState: editorState,
        placeholderText: placeholderText,
        lineHeight: 1.5,
        textSpanDecorator: (textSpan) => TextSpan(
          style: textStyle,
          children: codeTextSpans,
        ),
        placeholderTextSpanDecorator: (textSpan) => TextSpan(
          style: textStyle,
        ),
      ),
    );
  }

  Widget _buildSwitchLanguageButton(BuildContext context) {
    return MacosPopupButton(
      value: language != null
          ? languages.contains(language)
              ? language
              : 'auto'
          : 'auto',
      items: languages
          .map((e) => MacosPopupMenuItem(
                key: Key(e),
                value: e,
                child: Text(e.capitalize()),
              ))
          .toList(),
      onChanged: (value) {
        updateLanguage(value ?? 'auto');
      },
    );
  }

  Future<void> updateLanguage(String language) async {
    final transaction = editorState.transaction
      ..updateNode(node, {
        CodeBlockKeys.language: language == 'auto' ? null : language,
      })
      ..afterSelection = Selection.collapse(
        node.path,
        node.delta?.length ?? 0,
      );
    await editorState.apply(transaction);
  }

  // Copy from flutter.highlight package.
  // https://github.com/git-touch/highlight.dart/blob/master/flutter_highlight/lib/flutter_highlight.dart
  List<TextSpan> _convert(List<highlight.Node> nodes) {
    final List<TextSpan> spans = [];
    var currentSpans = spans;
    final List<List<TextSpan>> stack = [];

    void traverse(highlight.Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(
                  text: node.value,
                  style: a11yLightTheme[node.className!],
                ),
        );
      } else if (node.children != null) {
        final List<TextSpan> tmp = [];
        currentSpans.add(
          TextSpan(
            children: tmp,
            style: a11yLightTheme[node.className!],
          ),
        );
        stack.add(currentSpans);
        currentSpans = tmp;

        for (final n in node.children!) {
          traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (final node in nodes) {
      traverse(node);
    }

    return spans;
  }
}
