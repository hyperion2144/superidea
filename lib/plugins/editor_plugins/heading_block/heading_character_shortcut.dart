import 'package:appflowy_editor/appflowy_editor.dart' hide formatMarkdownSymbol;
import 'package:superidea/plugins/editor_plugins/base/markdow_format.dart';

import '../patterns.dart';

/// Convert '# ' to bulleted list
///
/// - support
///   - desktop
///   - mobile
///   - web
///
CharacterShortcutEvent formatSignToHeading2 = CharacterShortcutEvent(
  key: 'format sign to heading list',
  character: ' ',
  handler: (editorState) async => await formatMarkdownSymbol(
    editorState,
    false,
    (node) => true,
    (_, text, selection) {
      return headerPattern.hasMatch('$text ');
    },
    (text, node, delta) {
      final match = headerPattern.firstMatch('$text ');
      return headingNode(
        level: match?[1] == null ? 1 : match![1]!.length,
        delta: delta.compose(Delta()..delete(text.split('').length)),
      );
    },
  ),
);
