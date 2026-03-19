import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';

// Riverpod Provider for Shopping List State
// We now store the JSON serialized AppFlowy document string to persist
// complex formatting (bullets, bold text) offline easily.
class PabiliListNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setDocument(String json) {
    state = json;
  }
}

final pabiliListProvider = NotifierProvider<PabiliListNotifier, String>(() {
  return PabiliListNotifier();
});

class PabiliCustomListScreen extends ConsumerStatefulWidget {
  const PabiliCustomListScreen({super.key});

  @override
  ConsumerState<PabiliCustomListScreen> createState() => _PabiliCustomListScreenState();
}

class _PabiliCustomListScreenState extends ConsumerState<PabiliCustomListScreen> {
  late EditorState _editorState;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize an empty AppFlowy editor document state.
    // Users can use markdown shortcuts (e.g. "- " for bullets) directly in the editor.
    _editorState = EditorState.blank();
  }

  @override
  void dispose() {
    _editorState.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Shopping List',
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.section, vertical: 8),
              width: double.infinity,
              color: AppColors.surface,
              child: Text(
                'Type your items below. Use "- " for bullets, "1. " for numbers, or **bold** to organize your checklist clearly.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.section),
                // AppFlowyEditor provides its own scrollable rich-text field area
                child: AppFlowyEditor(
                  editorState: _editorState,
                ),
              ),
            ),

            // Bottom Confirm Container
            Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      labelText: 'Est. Goods Cost (Optional)',
                      prefixText: '₱ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Gap(16),
                  FilledButton(
                    onPressed: () {
                      // Save document export to Riverpod and proceed 
                      final documentJson = jsonEncode(_editorState.document.toJson());
                      ref.read(pabiliListProvider.notifier).setDocument(documentJson);
                      context.push('/booking_confirmed');
                    },
                    child: const Text('Confirm Pabili'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
