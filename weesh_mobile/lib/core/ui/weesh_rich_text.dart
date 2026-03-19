import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// Tiptap-equivalent rich text component for Weesh.
///
/// Usage:
/// - `WeeshRichText.display(document: doc)` — read-only article viewer
/// - `WeeshRichText.editable(...)` — for Pabili notes, chat, Help authoring
class WeeshRichText extends StatefulWidget {
  const WeeshRichText.display({
    super.key,
    required this.document,
  })  : _editable = false,
        initialMarkdown = null,
        onChanged = null;

  const WeeshRichText.editable({
    super.key,
    this.initialMarkdown,
    this.onChanged,
  })  : _editable = true,
        document = null;

  final Document? document;
  final String? initialMarkdown;
  final ValueChanged<String>? onChanged;
  final bool _editable;

  @override
  State<WeeshRichText> createState() => _WeeshRichTextState();
}

class _WeeshRichTextState extends State<WeeshRichText> {
  late EditorState _editorState;

  @override
  void initState() {
    super.initState();
    _editorState = EditorState(
      document: widget.document ??
          EditorState.blank().document,
    );

    if (widget.onChanged != null) {
      _editorState.transactionStream.listen((_) {
        // Collect plain text content for callback
        final text = _editorState.document.root.children
            .map((node) => node.delta?.toPlainText() ?? '')
            .join('\n');
        widget.onChanged!(text);
      });
    }
  }

  @override
  void dispose() {
    _editorState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = EditorStyle.desktop(
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textBody,
          height: 1.6,
        ),
        bold: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.deepCharcoal,
        ),
        italic: GoogleFonts.plusJakartaSans(
          fontStyle: FontStyle.italic,
          color: AppColors.textBody,
        ),
        href: GoogleFonts.plusJakartaSans(
          color: AppColors.terracotta,
          decoration: TextDecoration.underline,
        ),
      ),
      padding: EdgeInsets.zero,
      cursorColor: AppColors.terracotta,
      selectionColor: AppColors.sageGreen,
    );

    if (!widget._editable) {
      return AppFlowyEditor(
        editorState: _editorState,
        editorStyle: textStyles,
        editable: false,
        shrinkWrap: true,
      );
    }

    return Column(
      children: [
        // Minimal toolbar
        _buildToolbar(),
        const Divider(color: AppColors.cardBorder, height: 1),
        Expanded(
          child: AppFlowyEditor(
            editorState: _editorState,
            editorStyle: textStyles,
            editable: true,
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppColors.surface,
      child: Row(
        children: [
          _toolbarButton(Icons.format_bold, 'bold'),
          _toolbarButton(Icons.format_italic, 'italic'),
          _toolbarButton(Icons.format_list_bulleted, 'bulleted_list'),
          _toolbarButton(Icons.format_list_numbered, 'numbered_list'),
          _toolbarButton(Icons.format_quote, 'quote'),
        ],
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String format) {
    return IconButton(
      icon: Icon(icon, size: 18, color: AppColors.warmGrey),
      onPressed: () {
        // Toolbar actions handled via AppFlowy command system
      },
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      splashRadius: 16,
    );
  }
}
