import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/ai/hyperclova_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  late HyperClovaService _aiService;
  bool _isLoading = false;
  
  // Quick action buttons
  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.beach_access, 'label': '해변 휴양지 추천', 'query': '조용하고 아름다운 해변 휴양지를 추천해주세요'},
    {'icon': Icons.location_city, 'label': '도시 여행 추천', 'query': '문화와 쇼핑을 즐길 수 있는 도시 여행지를 추천해주세요'},
    {'icon': Icons.family_restroom, 'label': '가족 여행지', 'query': '아이들과 함께 가기 좋은 가족 여행지를 추천해주세요'},
    {'icon': Icons.savings, 'label': '저예산 여행', 'query': '100만원 이하로 갈 수 있는 해외여행지를 추천해주세요'},
  ];

  @override
  void initState() {
    super.initState();
    // TODO: 실제 API 키로 교체 필요
    _aiService = HyperClovaService(
      apiKey: 'YOUR_CLOVA_STUDIO_API_KEY',
      apigwApiKey: 'YOUR_APIGW_API_KEY',
    );
    
    // 환영 메시지
    _addMessage(
      '안녕하세요! 저는 스카이 항공의 AI 여행 컨설턴트입니다. 🛫\n\n'
      'HyperCLOVA X SEED 모델 기반으로 여러분의 완벽한 여행을 도와드리겠습니다.\n\n'
      '무엇을 도와드릴까요?',
      false,
    );
  }

  void _addMessage(String content, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        content: content,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    
    // 스크롤을 최하단으로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    _addMessage(message, true);
    _messageController.clear();
    
    setState(() => _isLoading = true);
    
    try {
      // HyperCLOVA X SEED 모델로 응답 받기
      final response = await _aiService.chatWithAssistant(
        messages: _messages,
        userMessage: message,
      );
      
      _addMessage(response, false);
    } catch (e) {
      _addMessage(
        '죄송합니다. 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology, color: AppColors.info ,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI 여행 컨설턴트'),
                Text(
                  'Powered by HyperCLOVA X SEED',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary 600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addMessage(
                  '대화가 초기화되었습니다. 무엇을 도와드릴까요?',
                  false,
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildLoadingIndicator();
                }
                
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Quick actions (shown when no messages or at start)
          if (_messages.length <= 1)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickActions.length,
                itemBuilder: (context, index) {
                  final action = _quickActions[index];
                  return _buildQuickActionCard(action);
                },
              ),
            ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textLight 
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '여행에 대해 무엇이든 물어보세요...',
                      filled: true,
                      fillColor: AppColors.textSecondary 100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0066CC),
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.textLight ,
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.info.shade100,
              child: const Icon(Icons.smart_toy, color: AppColors.info ,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF0066CC) : AppColors.textSecondary 100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? AppColors.textLight : AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? AppColors.textLight 0 : AppColors.textSecondary 600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.textSecondary 300],
              child: const Icon(Icons.person, color: AppColors.textLight ,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.info.shade100,
            child: const Icon(Icons.smart_toy, color: AppColors.info ,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textSecondary 100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary 600]!),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI가 답변을 생성하고 있습니다...',
                  style: TextStyle(color: AppColors.textSecondary 600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () => _sendMessage(action['query']),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.textLight 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textDisabled),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action['icon'], color: AppColors.info  size: 28),
            const SizedBox(height: 8),
            Text(
              action['label'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}