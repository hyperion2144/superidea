import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';
import 'package:superidea/widgets/side_sheet.dart';

void showModalSideForm(BuildContext context, String header, Widget body) =>
    showModalSideSheet(
      context,
      transitionDuration: const Duration(milliseconds: 400),
      header: 'Tag'.i18n,
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
      body: body,
    );
