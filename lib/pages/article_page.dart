import 'package:animations/animations.dart';
import 'package:appflowy_editor/appflowy_editor.dart' hide pasteCommand;
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';
import 'package:superidea/pages/article_editor_page.dart';
import 'package:superidea/plugins/editor_plugins/editor_style.dart';
import 'package:superidea/theme.dart';
import 'package:superidea/widgets/warn_modal.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ItemData {
  _ItemData(
    this.title,
    this.published,
    this.createAt,
    this.hide,
    this.top,
    this.cover,
    this.tags,
    this.key,
    this.url,
  );

  final Image? cover;
  final DateTime createAt;
  final bool hide;
  final Key key;
  final bool published;
  final List<String> tags;
  final String title;
  final bool top;
  final String url;
}

class _ArticlePageState extends State<ArticlePage> {
  int pageIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    pages = [
      ArticleListPage(openContainer: () {
        setState(() {
          pageIndex = 1;
        });

        final scope = MacosWindowScope.of(context);
        if (scope.isSidebarShown) {
          scope.toggleSidebar();
        }
      }),
      ArticleEditorPage(
        closeContainer: () {
          setState(() {
            pageIndex = 0;
          });

          MacosWindowScope.of(context).toggleSidebar();
        },
        styleCustomizer: EditorStyleCustomizer(
          context: context,
          padding: const EdgeInsets.all(10),
        ),
        editorState: EditorState(
          document: Document.blank(withInitialText: true),
        ),
      )
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          // animation: animation,
          // secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: pages[pageIndex],
    );
  }
}

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({
    super.key,
    required this.openContainer,
  });

  final VoidCallback openContainer;

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage>
    with SingleTickerProviderStateMixin {
  _ArticleListPageState() {
    // TODO: Get item data from database.
    _items = [
      _ItemData(
        'About',
        true,
        DateTime.now(),
        true,
        false,
        null,
        [],
        const Key('/about'),
        '/about',
      ),
      _ItemData(
        'Hello Superidea',
        true,
        DateTime.now(),
        false,
        true,
        Image.asset('assets/images/superidea_cover.jpeg'),
        [],
        const Key('/post/hello superidea'),
        '/post/hello superidea',
      ),
    ];
  }

  late AnimationController _controller;
  late List<_ItemData> _items;
  final List<_ItemData> _selectedItems = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: 0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    )..addStatusListener((status) {
        setState(() {
          // setState needs to be called to trigger a rebuild because
          // the 'HIDE FAB'/'SHOW FAB' button needs to be updated based
          // the latest value of [_controller.status].
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    String searchTitle = 'Search'.i18n + 'Article'.i18n;
    String newTitle = 'New'.i18n + 'Article'.i18n;

    return MacosScaffold(
      toolBar: ToolBar(
        leading: Row(
          children: [
            MacosTooltip(
              message: 'Toggle Sidebar'.i18n,
              child: MacosIconButton(
                icon: MacosIcon(
                  CupertinoIcons.sidebar_left,
                  color: toolbarIconColor(context),
                  size: 20.0,
                ),
                boxConstraints: const BoxConstraints(
                  minHeight: 20,
                  minWidth: 20,
                  maxWidth: 48,
                  maxHeight: 38,
                ),
                onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: _selectedItems.isNotEmpty,
              child: Material(
                color: MacosColors.transparent,
                child: InkWell(
                  // TODO: Delete selected article.
                  onTap: () {
                    showWarnModal(context, () {
                      setState(() {
                        for (var item in _selectedItems) {
                          _items.remove(item);
                        }
                        _selectedItems.cast();
                      });
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    // color: MacosColors.sliderBackgroundColor,
                    constraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                      maxHeight: 30,
                    ),
                    child: Row(
                      children: [
                        MacosIcon(
                          CupertinoIcons.trash,
                          color: toolbarIconColor(context),
                          size: 15.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${'Selected'.i18n}${_selectedItems.length}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          // TODO: Search article.
          CustomToolbarItem(
            inToolbarBuilder: (context) {
              return Visibility(
                visible: _controller.status == AnimationStatus.dismissed,
                child: MacosTooltip(
                  message: searchTitle,
                  child: MacosIconButton(
                    icon: MacosIconTheme(
                      data: MacosTheme.of(context).iconTheme.copyWith(
                            color: MacosTheme.of(context).brightness.resolve(
                                  const Color.fromRGBO(0, 0, 0, 0.5),
                                  const Color.fromRGBO(255, 255, 255, 0.5),
                                ),
                          ),
                      child: const MacosIcon(
                        CupertinoIcons.search,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      _controller.forward();
                    },
                  ),
                ),
              );
            },
          ),
          CustomToolbarItem(
            inToolbarBuilder: (context) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeScaleTransition(
                    animation: _controller,
                    child: child,
                  );
                },
                child: Visibility(
                  visible: _controller.status != AnimationStatus.dismissed,
                  child: SizedBox(
                    width: 200,
                    child: Focus(
                      onFocusChange: (focus) {
                        if (!focus) _controller.reverse();
                      },
                      child: MacosTextField(
                        autofocus: true,
                        placeholder: searchTitle,
                        suffix: const MacosIcon(CupertinoIcons.search),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // TODO: Add new article, convert to the new article page.
          ToolBarIconButton(
            label: newTitle,
            showLabel: false,
            icon: const MacosIcon(CupertinoIcons.add),
            tooltipMessage: newTitle,
            onPressed: widget.openContainer,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Material(
                color: MacosColors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _items.map(
                    (item) {
                      return _ArticleTile(
                        key: item.key,
                        item: item,
                        onSelect: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedItems.add(item);
                            });
                          } else {
                            setState(() {
                              _selectedItems.remove(item);
                            });
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ArticleTile extends StatefulWidget {
  const _ArticleTile({
    required this.onSelect,
    required this.item,
    super.key,
  });

  final _ItemData item;
  final ValueChanged<bool> onSelect;

  @override
  State<_ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<_ArticleTile> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle subTitleStyle =
        MacosTheme.of(context).typography.subheadline.copyWith(
              color: MacosColors.placeholderTextColor,
            );

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Badge(
        backgroundColor: MacosColors.appleRed,
        isLabelVisible: widget.item.top,
        offset: const Offset(-20, 0),
        label: const Text('TOP'),
        child: Badge(
          backgroundColor: MacosColors.black,
          isLabelVisible: widget.item.hide,
          offset: Offset(widget.item.hide && widget.item.top ? -58 : -20, 0),
          label: const Text('HIDE'),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // TODO: Open article.
            onTap: () {},
            hoverColor: MacosColors.controlBackgroundColor,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: MacosTheme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // leading checkbox.
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MacosCheckbox(
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                        widget.onSelect(value);
                      },
                    ),
                  ),
                  // Multiline title.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title.
                        Text(widget.item.title),
                        const Spacer(),
                        // SubTitle.
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '·',
                                style: TextStyle(
                                  color: widget.item.published
                                      ? MacosColors.appleGreen
                                      : MacosColors.appleRed,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Text(
                              widget.item.published
                                  ? 'Published'.i18n
                                  : 'Unpublished'.i18n,
                              style: subTitleStyle,
                            ),
                            const SizedBox(width: 5),
                            const MacosIcon(
                              LineAwesome.calendar_minus,
                              color: MacosColors.systemGrayColor,
                            ),
                            Text(
                              formatDate(widget.item.createAt,
                                  [yyyy, '-', mm, '-', dd]),
                              style: subTitleStyle,
                            ),
                            const SizedBox(width: 5),
                            if (widget.item.tags.isNotEmpty)
                              const MacosIcon(
                                LineAwesome.tag_solid,
                                color: MacosColors.systemGrayColor,
                              ),
                            for (var tag in widget.item.tags)
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  tag,
                                  style: subTitleStyle,
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: widget.item.cover != null,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: widget.item.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
