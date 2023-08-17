import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';

void showWarnModal(BuildContext context, VoidCallback onDelete) {
  showMacosAlertDialog(
    barrierColor: MacosColors.white.withOpacity(0.1),
    context: context,
    builder: (context) {
      return BackdropFilter(
        blendMode: BlendMode.src,
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: MacosAlertDialog(
          appIcon: const MacosIcon(Icons.warning),
          title: Text('Warning'.i18n),
          message: Text(
              'After deletion, it cannot be undone. Are you sure you want to delete it?'
                  .i18n),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: Text('Delete'.i18n),
          ),
          secondaryButton: PushButton(
            controlSize: ControlSize.large,
            secondary: true,
            onPressed: Navigator.of(context).pop,
            child: Text('Cancel'.i18n),
          ),
        ),
      );
    },
  );
}
