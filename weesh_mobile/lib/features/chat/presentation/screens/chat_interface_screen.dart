import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChatInterfaceScreen extends StatefulWidget {
  const ChatInterfaceScreen({super.key});

  @override
  State<ChatInterfaceScreen> createState() => _ChatInterfaceScreenState();
}

class _ChatInterfaceScreenState extends State<ChatInterfaceScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Ok po sir, I am on the way.',
      'isDriver': true,
      'time': '2:45 PM'
    },
    {
      'text': 'Doon po sa kanto yung pickup.',
      'isDriver': false,
      'time': '2:44 PM'
    },
    {'text': 'Saan po kayo banda?', 'isDriver': true, 'time': '2:43 PM'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {'text': text, 'isDriver': false, 'time': 'Now'});
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ignore: weesh_no_generic_appbar
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child:
                  const Icon(Iconsax.user, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text('Kuya Ben'),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
          color: AppColors.textBody,
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.call, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppPadding.section),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatBubble(
                    context,
                    text: msg['text'] as String,
                    isDriver: msg['isDriver'] as bool,
                    time: msg['time'] as String,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.neutral200,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Iconsax.send_1,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context,
      {required String text, required bool isDriver, required String time}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment:
            isDriver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDriver ? AppColors.surface : AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isDriver ? 4 : 16),
                bottomRight: Radius.circular(isDriver ? 16 : 4),
              ),
              border: isDriver ? Border.all(color: AppColors.neutral200) : null,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isDriver ? AppColors.textBody : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral500,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
