import 'package:appflowy_editor/appflowy_editor.dart' hide formatMarkdownSymbol;
import 'package:superidea/plugins/editor_plugins/base/markdow_format.dart';

/// Convert '# ' to bulleted list
///
/// - support
///   - desktop
///   - mobile
///   - web
///
CharacterShortcutEvent formatSignToHeading = CharacterShortcutEvent(
  key: 'format sign to heading list',
  character: ' ',
  handler: (editorState) async => await formatMarkdownSymbol(
    editorState,
    false,
    (node) => true,
    (_, text, selection) {
      final characters = text.split('');
      // only supports heading1 to heading6 levels
      // if the characters is empty, the every function will return true directly
      return characters.isNotEmpty &&
          characters.every((element) => element == '#') &&
          characters.length < 7;
    },
    (text, node, delta) {
      final numberOfSign = text.split('').length;
      return headingNode(
        level: numberOfSign,
        delta: Delta()
          ..insert('$text ')
          ..toPlainText(),
      );
    },
  ),
);

