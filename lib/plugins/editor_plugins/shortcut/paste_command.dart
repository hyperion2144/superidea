import 'package:appflowy_editor/appflowy_editor.dart' hide markdownToDocument;
import 'package:flutter/material.dart';

import '../../markdown/document_markdown.dart';

final CommandShortcutEvent customPasteCommand = CommandShortcutEvent(
  key: 'paste the content',
  command: 'ctrl+v',
  macOSCommand: 'cmd+v',
  handler: _pasteCommandHandler,
);

CommandShortcutEventHandler _pasteCommandHandler = (editorState) {
  if (PlatformExtension.isMobile) {
    assert(false, 'pasteCommand is not supported on mobile platform.');
    return KeyEventResult.ignored;
  }

  var selection = editorState.selection;
  if (selection == null) {
    return KeyEventResult.ignored;
  }

  // delete the selection first.
  if (!selection.isCollapsed) {
    editorState.deleteSelection(selection);
  }

  // fetch selection again.
  selection = editorState.selection;
  if (selection == null) {
    return KeyEventResult.skipRemainingHandlers;
  }
  assert(selection.isCollapsed);

  () async {
    final data = await AppFlowyClipboard.getData();
    final text = data.text;
    final html = data.html;
    if (html != null && html.isNotEmpty) {
      pasteHTML(editorState, html);
    } else if (text != null && text.isNotEmpty) {
      handlePastePlainText(editorState, data.text!);
    }
  }();

  return KeyEventResult.handled;
};

void handlePastePlainText(EditorState editorState, String plainText) {
  final selection = editorState.selection?.normalized;
  if (selection == null) {
    return;
  }

  final lines = plainText
      .split("\n")
      .map((e) => e.replaceAll(RegExp(r'\r'), ""))
      .toList();

  if (lines.isEmpty) {
    return;
  } else {
    _pasteMarkdown(editorState, plainText);
  }
}

void _pasteMarkdown(EditorState editorState, String markdown) {
  final selection = editorState.selection;
  if (selection == null) {
    return;
  }

  // final lines = markdown.split('\n');

  // if (lines.length == 1) {
  //   _pasteSingleLine(editorState, selection, lines[0]);
  //   return;
  // }

  var path = selection.end.path.next;
  final node = editorState.document.nodeAtPath(selection.end.path);
  final delta = node?.delta;
  if (delta != null && delta.toPlainText().isEmpty) {
    path = selection.end.path;
  }
  final document = markdownToDocument(markdown);
  final transaction = editorState.transaction;
  var afterPath = path;
  for (var i = 0; i < document.root.children.length - 1; i++) {
    afterPath = afterPath.next;
  }
  final offset = document.root.children.lastOrNull?.delta?.length ?? 0;
  transaction
    ..insertNodes(path, document.root.children)
    ..afterSelection = Selection.collapse(
      afterPath,
      offset,
    );
  editorState.apply(transaction);
}
