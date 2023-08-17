import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';
import 'package:superidea/theme.dart';
import 'package:superidea/widgets/side_modal_form.dart';
import 'package:superidea/widgets/warn_modal.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _ItemData {
  final String name;
  final String url;
  final bool inused;
  final Key key;

  _ItemData(
    this.name,
    this.inused,
    this.key,
    this.url,
  );
}

class _TagPageState extends State<TagPage> {
  late List<_ItemData> _items;
  final _formkey = GlobalKey<FormState>();

  _TagPageState() {
    _items = [
      _ItemData(
        'superidea',
        true,
        const Key('superidea'),
        'xxfkds',
      ),
      _ItemData(
        'test',
        false,
        const Key('test'),
        'test',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color toolbarIconColor = MacosTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 0.5),
      const Color.fromRGBO(255, 255, 255, 0.5),
    );

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
              showModalSideForm(
                context,
                'Tag',
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tag'.i18n + 'Name'.i18n),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                            decoration: inputDecoration,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text('${'Tag'.i18n}URL'),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                            decoration: inputDecoration,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Material(
                color: MacosColors.transparent,
                child: Wrap(
                  spacing: 20,
                  children: _items.map((item) {
                    return _Tag(
                      key: item.key,
                      item: item,
                      onDelete: () {
                        setState(() {
                          _items.remove(item);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final _ItemData item;
  final VoidCallback onDelete;

  const _Tag({
    required this.item,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            const MacosIcon(CupertinoIcons.tag),
            const SizedBox(width: 8),
            Text(
              item.name,
              style: MacosTheme.of(context)
                  .typography
                  .footnote
                  .copyWith(fontSize: 14),
            ),
            Visibility(
              visible: !item.inused,
              child: const VerticalDivider(
                color: primaryColor,
                thickness: 0.6,
              ),
            ),
            Visibility(
              visible: !item.inused,
              child: GestureDetector(
                onTap: () {
                  showWarnModal(context, onDelete);
                },
                child: const MacosIcon(CupertinoIcons.delete),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
