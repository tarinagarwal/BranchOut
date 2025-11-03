import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/message_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String otherUserName;
  final String? otherUserPhoto;

  const ChatScreen({
    super.key,
    required this.matchId,
    required this.otherUserName,
    this.otherUserPhoto,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load messages when screen opens
    Future.microtask(() {
      ref.read(chatProvider(widget.matchId).notifier).loadMessages();
      ref.read(chatProvider(widget.matchId).notifier).connectSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(chatProvider(widget.matchId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.otherUserPhoto != null
                  ? NetworkImage(widget.otherUserPhoto!)
                  : null,
              child: widget.otherUserPhoto == null
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(widget.otherUserName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hi! 👋'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading messages: $error'),
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    // TODO: Get current user ID from auth provider
    final isMe = true; // Placeholder

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type == 'code')
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              )
            else
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _showCodeInput,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    ref.read(chatProvider(widget.matchId).notifier).sendMessage(
          content: content,
          type: 'text',
        );

    _messageController.clear();
    _scrollToBottom();
  }

  void _showCodeInput() {
    showDialog(
      context: context,
      builder: (context) {
        final codeController = TextEditingController();
        return AlertDialog(
          title: const Text('Share Code Snippet'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Paste your code here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 10,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = codeController.text.trim();
                if (code.isNotEmpty) {
                  ref.read(chatProvider(widget.matchId).notifier).sendMessage(
                        content: code,
                        type: 'code',
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _pickImage() {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image sharing coming soon')),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Unmatch'),
            onTap: () {
              Navigator.pop(context);
              _confirmUnmatch();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Show report dialog
            },
          ),
        ],
      ),
    );
  }

  void _confirmUnmatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unmatch?'),
        content: const Text('Are you sure you want to unmatch? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement unmatch
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unmatch'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    ref.read(chatProvider(widget.matchId).notifier).disconnectSocket();
    super.dispose();
  }
}
