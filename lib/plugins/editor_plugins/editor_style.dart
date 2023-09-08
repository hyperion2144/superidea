import 'package:appflowy_editor/appflowy_editor.dart' hide Log;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:superidea/plugins/cubit/document_appearance_cubit.dart';

class EditorStyleCustomizer {
  EditorStyleCustomizer({
    required this.context,
    required this.padding,
  });

  final BuildContext context;
  final EdgeInsets padding;

  EditorStyle style() {
    if (PlatformExtension.isDesktopOrWeb) {
      return desktop();
    } else if (PlatformExtension.isMobile) {
      return mobile();
    }
    throw UnimplementedError();
  }

  EditorStyle desktop() {
    final theme = MacosTheme.of(context);
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    final fontFamily = context.read<DocumentAppearanceCubit>().state.fontFamily;
    return EditorStyle.desktop(
      padding: padding,
      cursorColor: theme.primaryColor,
      textStyleConfiguration: TextStyleConfiguration(
        text: baseTextStyle(fontFamily).copyWith(
          fontSize: fontSize,
          color: theme.typography.body.color,
          height: 1.5,
        ),
        bold: baseTextStyle(fontFamily, fontWeight: FontWeight.bold).copyWith(
          fontWeight: FontWeight.w600,
        ),
        italic: baseTextStyle(fontFamily).copyWith(
          fontStyle: FontStyle.italic,
        ),
        underline: baseTextStyle(fontFamily).copyWith(
          decoration: TextDecoration.underline,
        ),
        strikethrough: baseTextStyle(fontFamily).copyWith(
          decoration: TextDecoration.lineThrough,
        ),
        href: baseTextStyle(fontFamily).copyWith(
          color: theme.primaryColor,
          decoration: TextDecoration.underline,
        ),
        code: GoogleFonts.robotoMono(
          textStyle: baseTextStyle(fontFamily).copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: Colors.red,
            backgroundColor: MacosColors.controlColor,
          ),
        ),
      ),
      textSpanDecorator: customizeAttributeDecorator,
    );
  }

  EditorStyle mobile() {
    final theme = MacosTheme.of(context);
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    final fontFamily = context.read<DocumentAppearanceCubit>().state.fontFamily;

    return EditorStyle.desktop(
      padding: padding,
      cursorColor: theme.primaryColor,
      textStyleConfiguration: TextStyleConfiguration(
        text: baseTextStyle(fontFamily).copyWith(
          fontSize: fontSize,
          color: theme.typography.body.color,
          height: 1.5,
        ),
        bold: baseTextStyle(fontFamily).copyWith(
          fontWeight: FontWeight.w600,
        ),
        italic: baseTextStyle(fontFamily).copyWith(fontStyle: FontStyle.italic),
        underline: baseTextStyle(fontFamily)
            .copyWith(decoration: TextDecoration.underline),
        strikethrough: baseTextStyle(fontFamily)
            .copyWith(decoration: TextDecoration.lineThrough),
        href: baseTextStyle(fontFamily).copyWith(
          color: theme.primaryColor,
          decoration: TextDecoration.underline,
        ),
        code: GoogleFonts.robotoMono(
          textStyle: baseTextStyle(fontFamily).copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: Colors.red,
            backgroundColor: MacosColors.controlColor,
          ),
        ),
      ),
    );
  }

  TextStyle headingStyleBuilder(int level) {
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    final fontSizes = [
      fontSize + 16,
      fontSize + 12,
      fontSize + 8,
      fontSize + 4,
      fontSize + 2,
      fontSize
    ];
    return TextStyle(
      fontSize: fontSizes.elementAtOrNull(level - 1) ?? fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle codeBlockStyleBuilder() {
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    final fontFamily = context.read<DocumentAppearanceCubit>().state.fontFamily;
    return baseTextStyle(fontFamily).copyWith(
      fontSize: fontSize,
      height: 1.5,
      color: MacosTheme.of(context).typography.body.color,
    );
  }

  TextStyle outlineBlockPlaceholderStyleBuilder() {
    final theme = MacosTheme.of(context);
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    return TextStyle(
      fontFamily: 'poppins',
      fontSize: fontSize,
      height: 1.5,
      color: theme.typography.body.color?.withOpacity(0.6),
    );
  }

  SelectionMenuStyle selectionMenuStyleBuilder() {
    final theme = MacosTheme.of(context);
    return SelectionMenuStyle(
      selectionMenuBackgroundColor: MacosColors.controlBackgroundColor,
      selectionMenuItemTextColor: MacosColors.controlTextColor,
      selectionMenuItemIconColor: theme.iconTheme.color!,
      selectionMenuItemSelectedIconColor: theme.iconTheme.color!,
      selectionMenuItemSelectedTextColor: MacosColors.controlTextColor,
      selectionMenuItemSelectedColor: MacosColors.selectedTextBackgroundColor,
    );
  }

  FloatingToolbarStyle floatingToolbarStyleBuilder() {
    return const FloatingToolbarStyle(
      backgroundColor: MacosColors.controlBackgroundColor,
    );
  }

  TextStyle baseTextStyle(
    String fontFamily, {
    FontWeight? fontWeight,
  }) {
    try {
      return GoogleFonts.getFont(
        fontFamily,
        fontWeight: fontWeight,
        wordSpacing: 2,
        letterSpacing: 1.2,
      );
    } on Exception {
      return GoogleFonts.getFont(
        'Poppins',
        wordSpacing: 5,
        letterSpacing: 2,
      );
    }
  }

  InlineSpan customizeAttributeDecorator(
    BuildContext context,
    Node node,
    int index,
    TextInsert text,
    TextSpan textSpan,
  ) {
    final attributes = text.attributes;
    if (attributes == null) {
      return textSpan;
    }

    return defaultTextSpanDecoratorForAttribute(
      context,
      node,
      index,
      text,
      textSpan,
    );
  }
}
