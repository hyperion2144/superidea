import 'package:animations/animations.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';
import 'package:superidea/plugins/editor_plugins/editor_style.dart';
import '../plugins/editor_plugins/code_block/code_block_component.dart';
import '../plugins/editor_plugins/code_block/code_block_shortcut_event.dart';
import '../plugins/editor_plugins/heading_block/heading_block_ccomponent.dart';
import '../plugins/editor_plugins/heading_block/heading_character_shortcut.dart';
import '../plugins/editor_plugins/shortcut/backspace_command.dart';
import '../plugins/editor_plugins/shortcut/paste_command.dart';

class ArticleEditorPage extends StatefulWidget {
  const ArticleEditorPage({
    super.key,
    required this.styleCustomizer,
    required this.editorState,
    required this.closeContainer,
  });

  final EditorStyleCustomizer styleCustomizer;
  final EditorState editorState;
  final VoidCallback closeContainer;

  @override
  State<ArticleEditorPage> createState() => _ArticleEditorPageState();
}

class _ArticleEditorPageState extends State<ArticleEditorPage> {
  late final List<SelectionMenuItem> slashMenuItems;

  late final Map<String, BlockComponentBuilder> blockComponentBuilders =
      _customBlockComponentBuilders();

  final List<CommandShortcutEvent> commandShortcutEvents = [
    ...codeBlockCommands,
    customPasteCommand,
    customBackspaceCommand,
    ...standardCommandShortcutEvents,
  ];

  List<CharacterShortcutEvent> get characterShortcutEvents => [
        ...codeBlockCharacterEvents,
        formatSignToHeading2,
        customSlashCommand(
          slashMenuItems,
          style: styleCustomizer.selectionMenuStyleBuilder(),
        ),
        ...standardCharacterShortcutEvents
          ..removeWhere(
            (element) => element == slashCommand,
          ),
      ];

  late final showSlashMenu = customSlashCommand(
    slashMenuItems,
    shouldInsertSlash: false,
    style: styleCustomizer.selectionMenuStyleBuilder(),
  ).handler;

  EditorStyleCustomizer get styleCustomizer => widget.styleCustomizer;

  @override
  void initState() {
    super.initState();

    slashMenuItems = _customSlashMenuItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool titleHover = false;

  @override
  Widget build(BuildContext context) {
    final (autoFocus, selection) = _computeAutoFocusParameters();

    return MacosWindow(
      child: MacosScaffold(
        toolBar: ToolBar(
          leading: const SizedBox.shrink(),
          centerTitle: true,
          title: MouseRegion(
            onHover: (_) {
              setState(() {
                titleHover = true;
              });
            },
            onExit: (_) {
              setState(() {
                titleHover = false;
              });
            },
            child: GestureDetector(
              onTap: () {
                showModal(
                  context: context,
                  builder: (context) {
                    return Center();
                  },
                );
              },
              child: Row(
                children: [
                  const Text('New Article'),
                  if (titleHover) const SizedBox(width: 8),
                  if (titleHover) const MacosIcon(Iconsax.edit)
                ],
              ),
            ),
          ),
          actions: [
            ToolBarIconButton(
              label: 'Back'.i18n,
              icon: const MacosIcon(CupertinoIcons.arrow_left),
              showLabel: false,
              tooltipMessage: 'Back'.i18n,
              onPressed: widget.closeContainer,
            ),
            ToolBarIconButton(
              label: 'Draft'.i18n,
              icon: const MacosIcon(Iconsax.tick_circle),
              tooltipMessage: 'Draft'.i18n,
              showLabel: false,
              onPressed: () {
                // TODO: save as draft.
              },
            ),
            ToolBarIconButton(
              label: 'Save'.i18n,
              icon: const MacosIcon(
                Iconsax.tick_circle,
                color: MacosColors.systemGreenColor,
              ),
              tooltipMessage: 'Save'.i18n,
              showLabel: false,
              onPressed: () {
                // TODO: Save article.
              },
            ),
          ],
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                  ),
                  child: FloatingToolbar(
                    style: styleCustomizer.floatingToolbarStyleBuilder(),
                    items: const [],
                    editorState: widget.editorState,
                    scrollController: scrollController,
                    child: AppFlowyEditor(
                      editable: true,
                      autoFocus: autoFocus,
                      focusedSelection: selection,
                      scrollController: scrollController,
                      editorState: widget.editorState,
                      editorStyle: styleCustomizer.style(),
                      blockComponentBuilders: _customBlockComponentBuilders(),
                      characterShortcutEvents: characterShortcutEvents,
                      commandShortcutEvents: commandShortcutEvents,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, BlockComponentBuilder> _customBlockComponentBuilders() {
    final customBlockComponents = {
      ...standardBlockComponentBuilderMap,
      ParagraphBlockKeys.type: TextBlockComponentBuilder(
        configuration: standardBlockComponentConfiguration.copyWith(
          placeholderText: (_) => '开始写作，输入符号"/"来插入格式块',
        ),
      ),
      HeadingBlockKeys.type: HeadingBlockComponentBuilder2(
          textStyleBuilder: (level) =>
              styleCustomizer.headingStyleBuilder(level),
          configuration: standardBlockComponentConfiguration.copyWith(
            placeholderText: (node) =>
                '${'Heading'.i18n} ${node.attributes[HeadingBlockKeys.level]}',
          )),
      CodeBlockKeys.type: CodeBlockComponentBuilder(
        configuration: standardBlockComponentConfiguration.copyWith(
          textStyle: (_) => styleCustomizer.codeBlockStyleBuilder(),
        ),
      ),
      ImageBlockKeys.type: ImageBlockComponentBuilder(),
    };

    return customBlockComponents;
  }

  List<SelectionMenuItem> _customSlashMenuItems() {
    final items = [...standardSelectionMenuItems];
    // final imageItem = items.firstWhereOrNull(
    //   (element) => element.name == AppFlowyEditorLocalizations.current.image,
    // );
    // if (imageItem != null) {
    //   final imageItemIndex = items.indexOf(imageItem);
    // if (imageItemIndex != -1) {
    //   items[imageItemIndex] = customImageMenuItem;
    // }
    // }

    return [
      ...items,
      codeBlockItem,
    ];
  }

  (bool, Selection?) _computeAutoFocusParameters() {
    if (widget.editorState.document.isEmpty) {
      return (
        true,
        Selection.collapsed(
          Position(path: [0], offset: 0),
        ),
      );
    }
    final nodes = widget.editorState.document.root.children
        .where((element) => element.delta != null);
    final isAllEmpty =
        nodes.isNotEmpty && nodes.every((element) => element.delta!.isEmpty);
    if (isAllEmpty) {
      return (
        true,
        Selection.collapsed(
          Position(path: nodes.first.path, offset: 0),
        )
      );
    }
    return const (false, null);
  }
}
