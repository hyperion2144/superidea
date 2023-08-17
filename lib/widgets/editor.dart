import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/i18n.dart';
import 'package:superidea/preview_editor/editor_controller.dart';
import 'package:superidea/raw_editor/controller.dart';
import 'package:superidea/theme.dart';

enum Mode {
  preview,
  raw,
}

class MarkdownEditor extends StatefulWidget {
  final EditorController? previewController;
  final MarkdownController? rawController;
  final Mode mode;

  const MarkdownEditor({
    super.key,
    this.previewController,
    this.rawController,
    required this.mode,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, key) {
        return KeyEventResult.ignored;
      },
      child: TextField(
        controller: widget.mode == Mode.preview
            ? widget.previewController
            : widget.rawController,
        autofocus: true,
        autocorrect: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          focusColor: MacosColors.systemGrayColor,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: 'Start writing...'.i18n,
          hintStyle: MacosTheme.of(context).typography.body.copyWith(
                color: MacosColors.placeholderTextColor,
                fontSize: 15,
              ),
        ),
        style: MacosTheme.of(context).typography.body.copyWith(fontSize: 15),
        strutStyle: StrutStyle.fromTextStyle(
          MacosTheme.of(context).typography.body,
          height: 1.5,
          fontSize: 15,
        ),
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        cursorColor: primaryColor,
      ),
    );
  }
}
