import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:weesh_mobile/features/pabili/data/repositories/pabili_repository.dart';

import 'dart:async';

// Riverpod Provider for Shopping List State
// We now store the JSON serialized AppFlowy document string to persist
// complex formatting (bullets, bold text) offline easily.
class PabiliListNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    final repo = ref.watch(pabiliRepositoryProvider);
    return await repo.getDraft() ?? '';
  }

  Future<void> setDocument(String json) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(pabiliRepositoryProvider);
      await repo.saveDraft(json);
      return json;
    });
  }
}

final pabiliListProvider = AsyncNotifierProvider<PabiliListNotifier, String>(() {
  return PabiliListNotifier();
});

class PabiliCustomListScreen extends ConsumerStatefulWidget {
  const PabiliCustomListScreen({super.key});

  @override
  ConsumerState<PabiliCustomListScreen> createState() => _PabiliCustomListScreenState();
}

class _PabiliCustomListScreenState extends ConsumerState<PabiliCustomListScreen> {
  EditorState? _editorState;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void dispose() {
    _editorState?.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pabiliAsync = ref.watch(pabiliListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Shopping List',
        backgroundColor: AppColors.background,
      ),
      body: pabiliAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading list: $err')),
        data: (savedJson) {
          // Initialize editor state once when data is ready
          if (_editorState == null) {
            if (savedJson.isNotEmpty) {
              try {
                final json = jsonDecode(savedJson) as Map<String, dynamic>;
                _editorState = EditorState(document: Document.fromJson(json));
              } catch (e) {
                debugPrint('Failed to decode saved Pabili JSON: $e');
                _editorState = EditorState.blank();
              }
            } else {
              _editorState = EditorState.blank();
            }
          }

          return SafeArea(
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
                    child: AppFlowyEditor(
                      editorState: _editorState!,
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
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const Gap(16),
                      FilledButton(
                        onPressed: () {
                          if (_editorState == null) return;
                          
                          // Validation: Prevent empty lists
                          final docJson = _editorState!.document.toJson();
                          final documentJsonStr = jsonEncode(docJson);
                          
                          // Simple check: Is there any actual text content in any node?
                          bool hasContent = false;
                          for (final node in _editorState!.document.root.children) {
                            final text = node.attributes['delta']?.toString() ?? '';
                            if (text.trim().isNotEmpty && text != '[]') {
                              hasContent = true;
                              break;
                            }
                          }

                          if (!hasContent) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please add at least one item to your list')),
                            );
                            return;
                          }

                          // Save document export to persistence and proceed 
                          // Pending: Implement full Pabili order submission to Supabase
                          ref.read(pabiliListProvider.notifier).setDocument(documentJsonStr);
                          context.push('/booking_confirmed');
                        },
                        child: const Text('Confirm Pabili'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
