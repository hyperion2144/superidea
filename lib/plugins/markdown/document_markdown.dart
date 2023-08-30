import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';

import 'document_markdown_decoder.dart';

/// Converts a markdown to [Document].
///
/// [customParsers] is a list of custom parsers that will be used to parse the markdown.
Document markdownToDocument(
  String markdown, {
  List<NodeParser> customParsers = const [],
}) {
  return const AppFlowyEditorMarkdownCodec().decode(markdown);
}

class AppFlowyEditorMarkdownCodec extends Codec<Document, String> {
  const AppFlowyEditorMarkdownCodec({
    this.encodeParsers = const [],
  });

  final List<NodeParser> encodeParsers;

  @override
  Converter<String, Document> get decoder => DocumentMarkdownDecoder();

  @override
  Converter<Document, String> get encoder => DocumentMarkdownEncoder(
        parsers: encodeParsers,
      );
}
