import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class AIInsightsView extends ConsumerStatefulWidget {
  const AIInsightsView({super.key});

  @override
  ConsumerState<AIInsightsView> createState() => _AIInsightsViewState();
}

class _AIInsightsViewState extends ConsumerState<AIInsightsView> {
  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(aiChatProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('GuardianX AI Insights', style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              // Addiction Risk Score Gauge Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.successGreen,
                      ),
                      child: const Center(
                        child: Text(
                          '22',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Addiction Risk Score', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                        Text('Low Risk (Optimal Usage Balance)', style: TextStyle(color: AppTheme.successGreen, fontSize: 12)),
                        Text('Gaming: 35m • Social: 75m • Edu: 45m', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('AI Assistant (Ask Anything)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              // Chat Messages Stream
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = chatMessages[index];
                    final isUser = msg.sender == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? AppTheme.primaryPurple : AppTheme.cardDarkBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: isUser ? null : Border.all(color: AppTheme.accentBlue.withOpacity(0.4)),
                        ),
                        child: Text(
                          msg.text,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Prompt Input Area
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g. "How much YouTube today?"',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: AppTheme.cardDarkBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: AppTheme.primaryPurple),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: AppTheme.accentBlue),
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: () {
                        if (_queryController.text.trim().isNotEmpty) {
                          ref.read(aiChatProvider.notifier).sendMessage(_queryController.text.trim());
                          _queryController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
