import 'package:animations/animations.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superidea/i18n.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:superidea/ffi.dart'
    if (dart.library.html) 'package:superidea/ffi_web.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with SingleTickerProviderStateMixin {
  late Future<Platform> platform;
  late Future<bool> isRelease;
  late AnimationController _controller;

  final List<int> _selectedItems = [];

  @override
  void initState() {
    super.initState();

    platform = api.platform();
    isRelease = api.rustReleaseMode();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAnimationRunningForwardsOrComplete {
    switch (_controller.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String searchTitle = 'Search'.i18n + 'Article'.i18n;
    String newTitle = 'New'.i18n + 'Article'.i18n;

    Color toolbarIconColor = MacosTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 0.5),
      const Color.fromRGBO(255, 255, 255, 0.5),
    );

    return MacosScaffold(
      toolBar: ToolBar(
        leading: Row(
          children: [
            MacosTooltip(
              message: 'Toggle Sidebar'.i18n,
              child: MacosIconButton(
                icon: MacosIcon(
                  CupertinoIcons.sidebar_left,
                  color: toolbarIconColor,
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
            if (_selectedItems.isNotEmpty)
              Material(
                child: InkWell(
                  // TODO: Delete selected article.
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    color: MacosColors.sliderBackgroundColor,
                    constraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                      maxHeight: 20,
                    ),
                    child: Row(
                      children: [
                        MacosIcon(
                          CupertinoIcons.trash,
                          color: toolbarIconColor,
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
              )
          ],
        ),
        actions: [
          // TODO: Search article.
          CustomToolbarItem(
            inToolbarBuilder: (context) {
              return Visibility(
                visible: _controller.status == AnimationStatus.dismissed,
                child: Tooltip(
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
                        autocorrect: true,
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
            icon: Tooltip(
              message: newTitle,
              child: const MacosIcon(CupertinoIcons.add),
            ),
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ArticleTile(
                      title: 'About'.i18n,
                      dateTime: DateTime.now(),
                      isPublished: true,
                      hide: true,
                      onSelect: (value) {
                        if (value) {
                          setState(() {
                            _selectedItems.add(1);
                          });
                        } else {
                          setState(() {
                            _selectedItems.remove(1);
                          });
                        }
                      },
                    ),
                    ArticleTile(
                        title: 'Hello Superidea',
                        dateTime: DateTime.now(),
                        isPublished: true,
                        cover: Image.asset(
                          'assets/images/superidea_cover.jpeg',
                          fit: BoxFit.fitHeight,
                        ),
                        tags: const ['Superidea'],
                        onSelect: (value) {
                          if (value) {
                            setState(() {
                              _selectedItems.add(2);
                            });
                          } else {
                            setState(() {
                              _selectedItems.remove(2);
                            });
                          }
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ArticleTile extends StatefulWidget {
  const ArticleTile({
    super.key,
    required this.title,
    required this.dateTime,
    this.cover,
    this.isPublished = false,
    this.top = false,
    this.hide = false,
    this.tags = const [],
    required this.onSelect,
  });

  // Article title.
  final String title;
  // Create time.
  final DateTime dateTime;
  final bool isPublished;
  final bool top;
  final bool hide;
  final Image? cover;
  final List<String> tags;
  final ValueChanged<bool> onSelect;

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
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
        backgroundColor: MacosColors.black,
        isLabelVisible: widget.hide,
        offset: Offset(widget.hide && widget.top ? -58 : -20, 0),
        label: const Text('HIDE'),
        child: Badge(
          backgroundColor: MacosColors.black,
          isLabelVisible: widget.top,
          offset: const Offset(-20, 0),
          label: const Text('TOP'),
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
                        Text(widget.title),
                        const Spacer(),
                        // SubTitle.
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '·',
                                style: TextStyle(
                                  color: widget.isPublished
                                      ? MacosColors.appleGreen
                                      : MacosColors.appleRed,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Text(
                              widget.isPublished
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
                              formatDate(
                                  widget.dateTime, [yyyy, '-', mm, '-', dd]),
                              style: subTitleStyle,
                            ),
                            const SizedBox(width: 5),
                            if (widget.tags.isNotEmpty)
                              const MacosIcon(
                                LineAwesome.tag_solid,
                                color: MacosColors.systemGrayColor,
                              ),
                            for (var tag in widget.tags)
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
                  if (widget.cover != null)
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: widget.cover,
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
