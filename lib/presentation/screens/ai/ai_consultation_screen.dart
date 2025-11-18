import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../services/ai/recommendation/dialogflow_service.dart';
import '../../../services/ai/profiling/user_preference_analyzer.dart';
import '../../../services/ai/profiling/travel_style_classifier.dart';
import '../../../services/ai/profiling/budget_analyzer.dart';
import '../../../data/models/ai_recommendation_model.dart';

class AIConsultationScreen extends StatefulWidget {
  const AIConsultationScreen({super.key});

  @override
  State<AIConsultationScreen> createState() => _AIConsultationScreenState();
}

class _AIConsultationScreenState extends State<AIConsultationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  late String _sessionId;
  bool _isLoading = false;
  bool _showTypingIndicator = false;
  ConversationContext? _currentContext;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _fadeController.forward();
    _initializeConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _initializeConversation() async {
    await _sendInitialMessage();
  }

  Future<void> _sendInitialMessage() async {
    final dialogflowService = context.read<DialogflowService>();
    
    try {
      setState(() => _isLoading = true);
      
      final response = await dialogflowService.processMessage(
        sessionId: _sessionId,
        message: "start",
      );
      
      _addMessage(ChatMessage(
        text: response.response,
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: response.quickReplies,
        suggestions: response.suggestions,
        recommendations: response.recommendations,
      ));
      
      _currentContext = response.updatedContext;
    } catch (e) {
      _addMessage(ChatMessage(
        text: "안녕하세요! TravelMate AI 컨설턴트입니다. 완벽한 여행을 계획해드릴게요!",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
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

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _addMessage(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    setState(() {
      _showTypingIndicator = true;
      _isLoading = true;
    });

    final dialogflowService = context.read<DialogflowService>();

    try {
      final response = await dialogflowService.processMessage(
        sessionId: _sessionId,
        message: message,
      );

      setState(() => _showTypingIndicator = false);

      await Future.delayed(const Duration(milliseconds: 500));

      _addMessage(ChatMessage(
        text: response.response,
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: response.quickReplies,
        suggestions: response.suggestions,
        recommendations: response.recommendations,
      ));

      _currentContext = response.updatedContext;
    } catch (e) {
      setState(() => _showTypingIndicator = false);
      _addMessage(ChatMessage(
        text: "죄송합니다. 처리 중 문제가 발생했습니다. 다시 시도해주세요.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleQuickReply(QuickReply reply) {
    _sendMessage(reply.text);
  }

  void _handleSuggestion(ActionSuggestion suggestion) {
    switch (suggestion.action) {
      case 'view_package':
        _navigateToRecommendations();
        break;
      case 'compare_options':
        _navigateToComparison();
        break;
      case 'upload_image':
        _handleImageUpload();
        break;
      default:
        _sendMessage(suggestion.title);
    }
  }

  void _navigateToRecommendations() {
    Navigator.pushNamed(context, '/personalized-recommendations');
  }

  void _navigateToComparison() {
    Navigator.pushNamed(context, '/package-comparison');
  }

  void _handleImageUpload() {
    // TODO: Implement image upload and analysis
    showModalBottomSheet(
      context: context,
      builder: (context) => const ImageUploadSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 여행 컨설턴트'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor:  AppColors.textLight 
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _restartConversation(),
            tooltip: '대화 초기화',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            if (_currentContext != null) _buildConversationStatus(),
            Expanded(child: _buildMessageList()),
            if (_showTypingIndicator) _buildTypingIndicator(),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: AppColors.textDisabled),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStateIcon(_currentContext!.currentState),
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getStateDescription(_currentContext!.currentState),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_currentContext!.confidenceScores.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(_calculateAverageConfidence() * 100).toInt()}%',
                style: const TextStyle(
                  color:  AppColors.textLight 
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return SlideTransition(
          position: _slideAnimation,
          child: ChatBubble(
            message: message,
            onQuickReplyTap: _handleQuickReply,
            onSuggestionTap: _handleSuggestion,
            onRecommendationTap: (recommendation) {
              Navigator.pushNamed(
                context,
                '/package-details',
                arguments: recommendation,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor:  AppColors.info 
            child: Icon(Icons.smart_toy, color:  AppColors.textLight  size: 16),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textDisabled,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TypingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:  AppColors.textLight 
        border: Border(top: BorderSide(color: AppColors.textDisabled)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _handleImageUpload,
            tooltip: '이미지 업로드',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                _sendMessage(text);
                _messageController.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: _isLoading
                ? null
                : () {
                    _sendMessage(_messageController.text);
                    _messageController.clear();
                  },
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  IconData _getStateIcon(ConversationState state) {
    switch (state) {
      case ConversationState.greeting:
        return Icons.waving_hand;
      case ConversationState.gatheringPreferences:
        return Icons.quiz;
      case ConversationState.analyzing:
        return Icons.analytics;
      case ConversationState.presentingOptions:
        return Icons.recommend;
      case ConversationState.refining:
        return Icons.tune;
      case ConversationState.finalizing:
        return Icons.check_circle;
      case ConversationState.completed:
        return Icons.task_alt;
    }
  }

  String _getStateDescription(ConversationState state) {
    switch (state) {
      case ConversationState.greeting:
        return '대화 시작';
      case ConversationState.gatheringPreferences:
        return '선호도 수집 중';
      case ConversationState.analyzing:
        return '분석 중';
      case ConversationState.presentingOptions:
        return '추천 제시 중';
      case ConversationState.refining:
        return '세부 조정 중';
      case ConversationState.finalizing:
        return '최종 확인 중';
      case ConversationState.completed:
        return '완료';
    }
  }

  double _calculateAverageConfidence() {
    if (_currentContext?.confidenceScores.isEmpty ?? true) return 0.0;
    final scores = _currentContext!.confidenceScores.values;
    return scores.fold<double>(0.0, (sum, score) => sum + score) / scores.length;
  }

  void _restartConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대화 초기화'),
        content: const Text('지금까지의 대화를 초기화하고 새로 시작하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _currentContext = null;
                _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
              });
              _initializeConversation();
            },
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('대화 기록'),
              onTap: () {
                Navigator.pop(context);
                _showConversationHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('AI 설정'),
              onTap: () {
                Navigator.pop(context);
                _showAISettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('피드백'),
              onTap: () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationHistory() {
    // TODO: Implement conversation history
  }

  void _showAISettings() {
    // TODO: Implement AI settings
  }

  void _showFeedbackDialog() {
    // TODO: Implement feedback dialog
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<QuickReply>? quickReplies;
  final List<ActionSuggestion>? suggestions;
  final List<AIRecommendationModel>? recommendations;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickReplies,
    this.suggestions,
    this.recommendations,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(QuickReply)? onQuickReplyTap;
  final Function(ActionSuggestion)? onSuggestionTap;
  final Function(AIRecommendationModel)? onRecommendationTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.onQuickReplyTap,
    this.onSuggestionTap,
    this.onRecommendationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor:  AppColors.info 
              child: Icon(Icons.smart_toy, color:  AppColors.textLight  size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).primaryColor
                        : AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ?  AppColors.textLight :  AppColors.textPrimary,
                    ),
                  ),
                ),
                if (message.quickReplies?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  _buildQuickReplies(),
                ],
                if (message.suggestions?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  _buildSuggestions(),
                ],
                if (message.recommendations?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  _buildRecommendations(context),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:  AppColors.textSecondary 
                      ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, color:  AppColors.textLight  size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: message.quickReplies!.map((reply) {
        return ActionChip(
          label: Text(reply.text),
          onPressed: () => onQuickReplyTap?.call(reply),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: message.suggestions!.map((suggestion) {
        return Card(
          child: ListTile(
            title: Text(suggestion.title),
            subtitle: Text(suggestion.description),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onSuggestionTap?.call(suggestion),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '추천 여행 패키지',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...message.recommendations!.map((recommendation) {
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recommendation.packageImageUrl ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: AppColors.textDisabled,
                      child: const Icon(Icons.image),
                    );
                  },
                ),
              ),
              title: Text(recommendation.packageTitle),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${recommendation.destination} • ${recommendation.duration}일'),
                  Text(
                    '₩${recommendation.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color:  AppColors.info 
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () => onRecommendationTap?.call(recommendation),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.4,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(_animations[index].value),
              ),
            );
          },
        );
      }),
    );
  }
}

class ImageUploadSheet extends StatelessWidget {
  const ImageUploadSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '이미지로 여행 추천받기',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('카메라로 촬영'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement camera capture
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('갤러리에서 선택'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement gallery selection
            },
          ),
        ],
      ),
    );
  }
}

class QuickReply {
  final String text;
  final String value;

  const QuickReply({
    required this.text,
    required this.value,
  });
}

class ActionSuggestion {
  final String action;
  final String title;
  final String description;

  const ActionSuggestion({
    required this.action,
    required this.title,
    required this.description,
  });
}