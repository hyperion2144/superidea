import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart' hide ReorderableList;
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:superidea/i18n.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/theme.dart';
import 'package:superidea/widgets/side_sheet.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

enum LinkKind { internal, external }

class ItemData {
  ItemData(
    this.title,
    this.key,
    this.kind,
    this.link,
  );

  final String title;
  final LinkKind kind;
  final String link;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

class _MenuPageState extends State<MenuPage> {
  late List<ItemData> _items;
  final _formkey = GlobalKey<FormState>();

  _MenuPageState() {
    // TODO: Get item data from database.
    _items = [
      ItemData(
        'Homepage'.i18n,
        const Key('/'),
        LinkKind.internal,
        '/',
      ),
      ItemData(
        'Archives'.i18n,
        const Key('/archives'),
        LinkKind.internal,
        '/archives',
      ),
      ItemData(
        'About'.i18n,
        const Key('/post/about'),
        LinkKind.internal,
        '/post/about',
      ),
      ItemData(
        'Tags'.i18n,
        const Key('/tags'),
        LinkKind.internal,
        '/tags',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  @override
  Widget build(BuildContext context) {
    Color toolbarIconColor = MacosTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 0.5),
      const Color.fromRGBO(255, 255, 255, 0.5),
    );

    return MacosScaffold(
      toolBar: ToolBar(
        leading: MacosTooltip(
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
        actions: [
          ToolBarIconButton(
            label: 'New'.i18n + 'Menu'.i18n,
            showLabel: false,
            icon: Tooltip(
              message: 'New'.i18n + 'Menu'.i18n,
              child: const MacosIcon(
                CupertinoIcons.add,
              ),
            ),
            onPressed: () {
              showSideSheet(context);
            },
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return ReorderableList(
              onReorder: _reorderCallback,
              onReorderDone: _reorderDone,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: _items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ReorderableItem(
                            key: item.key,
                            childBuilder: (context, state) {
                              return Material(
                                child: Opacity(
                                  opacity:
                                      state == ReorderableItemState.placeholder
                                          ? 0.0
                                          : 1.0,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color:
                                            MacosTheme.of(context).dividerColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(8),
                                    leading: ReorderableListener(
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: MacosIcon(EvaIcons.move),
                                      ),
                                    ),
                                    title: Text(item.title),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: MacosColors.controlColor,
                                              border: Border.all(
                                                  color: MacosTheme.of(context)
                                                      .dividerColor),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.kind.name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    MacosColors.systemGrayColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.link,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color:
                                                  MacosColors.systemGrayColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: MacosIconButton(
                                      icon: const MacosIcon(
                                          LineAwesome.trash_solid),
                                      onPressed: () {
                                        setState(() {
                                          _items.remove(item);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      showSideSheet(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> showSideSheet(BuildContext context) {
    return showModalSideSheet(
      context,
      transitionDuration: const Duration(milliseconds: 400),
      header: 'Menu'.i18n,
      titleStyle: MacosTheme.of(context).typography.title1,
      barrierColor: MacosColors.systemGrayColor.darkColor,
      closeButton: Tooltip(
        message: 'Close'.i18n,
        child: MacosIconButton(
          icon: const MacosIcon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        PushButton(
          secondary: true,
          controlSize: ControlSize.large,
          child: Text('Cancel'.i18n),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        PushButton(
          controlSize: ControlSize.large,
          child: Text('Save'.i18n),
          // onPressed: () {},
        ),
      ],
      body: MenuForm(formkey: _formkey),
    );
  }
}

class MenuForm extends StatelessWidget {
  const MenuForm({
    super.key,
    required GlobalKey<FormState> formkey,
  }) : _formkey = formkey;

  final GlobalKey<FormState> _formkey;

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: primaryColor,
        ),
      ),
    );

    return StatefulBuilder(builder: (
      context,
      setState,
    ) {
      return Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name'.i18n),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: TextField(
                  decoration: inputDecoration,
                ),
              ),
              const SizedBox(height: 40),
              ToggleSwitch(
                activeBgColor: const [primaryColor],
                inactiveBgColor: MacosColors.controlBackgroundColor,
                fontSize: 14,
                minHeight: 30,
                borderWidth: 1,
                borderColor: [MacosTheme.of(context).dividerColor],
                labels: [
                  'Internal'.i18n,
                  'External'.i18n,
                ],
              ),
              const SizedBox(height: 30),
              Text('Link'.i18n),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: TextField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Input or Select from below'.i18n,
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: DropdownButtonFormField2(
                  isExpanded: true,
                  value: 'Homepage',
                  decoration: inputDecoration.copyWith(
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Homepage',
                      child: Row(
                        children: [
                          const MacosIcon(LineAwesome.home_solid),
                          const SizedBox(width: 6),
                          Text('Homepage'.i18n),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Archives',
                      child: Row(
                        children: [
                          const MacosIcon(LineAwesome.archive_solid),
                          const SizedBox(width: 6),
                          Text('Archives'.i18n),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Tags',
                      child: Row(
                        children: [
                          const MacosIcon(LineAwesome.tags_solid),
                          const SizedBox(width: 6),
                          Text('Tags'.i18n),
                        ],
                      ),
                    ),
                  ].toList(),
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  iconStyleData: const IconStyleData(
                    icon: MacosIcon(Icons.expand_more),
                    iconSize: 24,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 30,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
