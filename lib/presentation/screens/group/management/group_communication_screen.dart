import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../data/models/group_model.dart';

class GroupCommunicationScreen extends StatefulWidget {
  final String groupId;
  final String? bookingId;

  const GroupCommunicationScreen({
    super.key,
    required this.groupId,
    this.bookingId,
  });

  @override
  State<GroupCommunicationScreen> createState() => _GroupCommunicationScreenState();
}

class _GroupCommunicationScreenState extends State<GroupCommunicationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // State
  List<GroupCommunicationModel> _communications = [];
  List<GroupMemberModel> _members = [];
  GroupModel? _groupInfo;
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedType = 'all'; // all, announcement, chat, survey, vote
  
  // Controllers
  final _searchController = TextEditingController();
  final _messageController = TextEditingController();
  
  // Form state for creating communications
  String _communicationType = 'announcement';
  String _communicationTitle = '';
  String _communicationContent = '';
  List<String> _selectedRecipients = [];
  DateTime? _scheduledTime;
  List<PlatformFile> _attachments = [];
  Map<String, dynamic> _surveyOptions = {};
  Map<String, dynamic> _voteOptions = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _groupInfo = _createMockGroup();
        _members = _createMockMembers();
        _communications = _createMockCommunications();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니케이션'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read),
                    SizedBox(width: 8),
                    Text('모두 읽음 처리'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_messages',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('메시지 내보내기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('알림 설정'),
                  ],
                ),
              ),
            ],
            onSelected: _handleMenuAction,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.campaign),
              text: '공지사항 (${_getCountByType('announcement')})',
            ),
            Tab(
              icon: const Icon(Icons.chat),
              text: '채팅 (${_getCountByType('chat')})',
            ),
            Tab(
              icon: const Icon(Icons.poll),
              text: '설문/투표 (${_getCountByType('survey') + _getCountByType('vote')})',
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: '전체 기록',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAnnouncementsTab(),
                _buildChatTab(),
                _buildSurveyVoteTab(),
                _buildHistoryTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCommunicationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAnnouncementsTab() {
    final announcements = _communications
        .where((c) => c.type == 'announcement')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: announcements.isEmpty
              ? _buildEmptyState('공지사항', Icons.campaign)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return _buildAnnouncementCard(announcement);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '제목, 내용으로 검색...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                isDense: true,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: _selectedType,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('전체')),
              DropdownMenuItem(value: 'announcement', child: Text('공지사항')),
              DropdownMenuItem(value: 'chat', child: Text('채팅')),
              DropdownMenuItem(value: 'survey', child: Text('설문')),
              DropdownMenuItem(value: 'vote', child: Text('투표')),
            ],
            onChanged: (value) {
              setState(() => _selectedType = value ?? 'all');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(GroupCommunicationModel announcement) {
    final unreadCount = _members.length - announcement.readByIds.length;
    final isScheduled = announcement.scheduledAt != null && 
        announcement.scheduledAt!.isAfter(DateTime.now());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isScheduled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        Text(
                          '예약됨',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('수정'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 8),
                          Text('복제'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('삭제', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleAnnouncementAction(announcement, value as String),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _getMemberName(announcement.senderId),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(announcement.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '미읽음 $unreadCount명',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '모두 읽음',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewAnnouncementDetails(announcement),
                    icon: const Icon(Icons.visibility),
                    label: const Text('상세 보기'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewReadStatus(announcement),
                    icon: const Icon(Icons.people),
                    label: const Text('읽음 현황'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        _buildChatHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: 10, // Mock chat messages
            itemBuilder: (context, index) {
              return _buildChatMessage(index);
            },
          ),
        ),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.group, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _groupInfo?.name ?? '그룹 채팅',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_members.length}명 참여',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showChatOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(int index) {
    final isMe = index % 3 == 0;
    final member = _members[index % _members.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _getRoleColor(member.role),
              child: Text(
                member.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Theme.of(context).primaryColor : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _generateMockMessage(index),
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: const Text(
                '나',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            icon: const Icon(Icons.attach_file),
            onPressed: _attachFile,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyVoteTab() {
    final surveysAndVotes = _communications
        .where((c) => c.type == 'survey' || c.type == 'vote')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return Column(
      children: [
        _buildSurveyVoteHeader(),
        Expanded(
          child: surveysAndVotes.isEmpty
              ? _buildEmptyState('설문/투표', Icons.poll)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: surveysAndVotes.length,
                  itemBuilder: (context, index) {
                    final item = surveysAndVotes[index];
                    return _buildSurveyVoteCard(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSurveyVoteHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '설문 및 투표',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _createSurvey(),
            icon: const Icon(Icons.poll),
            label: const Text('설문 생성'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _createVote(),
            icon: const Icon(Icons.how_to_vote),
            label: const Text('투표 생성'),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyVoteCard(GroupCommunicationModel item) {
    final responseRate = (item.responses.length / _members.length * 100).round();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.type == 'survey' ? Colors.blue.shade100 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.type == 'survey' ? '설문' : '투표',
                    style: TextStyle(
                      color: item.type == 'survey' ? Colors.blue.shade700 : Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('응답률: $responseRate% (${item.responses.length}/${_members.length}명)'),
                const Spacer(),
                Text(
                  _formatDateTime(item.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: responseRate / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                item.type == 'survey' ? Colors.blue : Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewSurveyResults(item),
                    icon: const Icon(Icons.analytics),
                    label: const Text('결과 보기'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _participateInSurvey(item),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('참여하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final allCommunications = _getFilteredCommunications();
    
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: allCommunications.isEmpty
              ? _buildEmptyState('통신 기록', Icons.history)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allCommunications.length,
                  itemBuilder: (context, index) {
                    final communication = allCommunications[index];
                    return _buildHistoryCard(communication);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(GroupCommunicationModel communication) {
    final typeIcon = _getCommunicationIcon(communication.type);
    final typeColor = _getCommunicationColor(communication.type);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor,
          child: Icon(typeIcon, color: Colors.white, size: 20),
        ),
        title: Text(
          communication.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              communication.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(_getCommunicationTypeLabel(communication.type)),
                const SizedBox(width: 8),
                Text('•'),
                const SizedBox(width: 8),
                Text(_formatDateTime(communication.createdAt)),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('보기'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('수정'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('삭제', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleCommunicationAction(communication, value as String),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String type, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '$type이 없습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 ${type.toLowerCase()}을 만들어보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateCommunicationDialog,
            icon: const Icon(Icons.add),
            label: Text('$type 만들기'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _getCountByType(String type) {
    return _communications.where((c) => c.type == type).length;
  }

  List<GroupCommunicationModel> _getFilteredCommunications() {
    return _communications.where((communication) {
      if (_selectedType != 'all' && communication.type != _selectedType) {
        return false;
      }
      
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        return communication.title.toLowerCase().contains(searchLower) ||
            communication.content.toLowerCase().contains(searchLower);
      }
      
      return true;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String _getMemberName(String memberId) {
    final member = _members.firstWhere(
      (m) => m.id == memberId,
      orElse: () => const GroupMemberModel(
        id: '',
        groupId: '',
        userId: '',
        departmentId: '',
        role: GroupRole.member,
        status: MemberStatus.active,
        name: '알 수 없음',
        email: '',
        phone: '',
        position: '',
        permissions: {},
        personalInfo: {},
        joinedAt: '',
        invitedBy: '',
      ),
    );
    return member.name;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  IconData _getCommunicationIcon(String type) {
    switch (type) {
      case 'announcement':
        return Icons.campaign;
      case 'chat':
        return Icons.chat;
      case 'survey':
        return Icons.poll;
      case 'vote':
        return Icons.how_to_vote;
      default:
        return Icons.message;
    }
  }

  Color _getCommunicationColor(String type) {
    switch (type) {
      case 'announcement':
        return Colors.blue;
      case 'chat':
        return Colors.green;
      case 'survey':
        return Colors.purple;
      case 'vote':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getCommunicationTypeLabel(String type) {
    switch (type) {
      case 'announcement':
        return '공지사항';
      case 'chat':
        return '채팅';
      case 'survey':
        return '설문';
      case 'vote':
        return '투표';
      default:
        return type;
    }
  }

  Color _getRoleColor(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return Colors.red;
      case GroupRole.manager:
        return Colors.orange;
      case GroupRole.coordinator:
        return Colors.blue;
      case GroupRole.member:
        return Colors.green;
      case GroupRole.viewer:
        return Colors.grey;
    }
  }

  String _generateMockMessage(int index) {
    final messages = [
      '안녕하세요! 제주도 여행 일정이 확정되었습니다.',
      '참가자 명단 확인 부탁드립니다.',
      '혹시 추가 질문 있으신 분 계신가요?',
      '내일 오후 2시에 사전 미팅 있습니다.',
      '여권 준비 완료하신 분들 체크 부탁드려요.',
      '감사합니다! 잘 부탁드립니다.',
      '날씨가 좋네요. 여행 기대됩니다!',
      '준비물 리스트 공유드렸습니다.',
      '숙소 정보 확인해주세요.',
      '모두 수고 많으셨습니다.',
    ];
    return messages[index % messages.length];
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        _markAllAsRead();
        break;
      case 'export_messages':
        _exportMessages();
        break;
      case 'settings':
        _showNotificationSettings();
        break;
    }
  }

  void _handleAnnouncementAction(GroupCommunicationModel announcement, String action) {
    switch (action) {
      case 'edit':
        _editAnnouncement(announcement);
        break;
      case 'duplicate':
        _duplicateAnnouncement(announcement);
        break;
      case 'delete':
        _deleteAnnouncement(announcement);
        break;
    }
  }

  void _handleCommunicationAction(GroupCommunicationModel communication, String action) {
    switch (action) {
      case 'view':
        _viewCommunicationDetails(communication);
        break;
      case 'edit':
        _editCommunication(communication);
        break;
      case 'delete':
        _deleteCommunication(communication);
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('검색'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '제목, 내용으로 검색...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = _searchController.text);
              Navigator.pop(context);
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  void _showCreateCommunicationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '새 커뮤니케이션 만들기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildCreateOption('공지사항', Icons.campaign, () => _createAnnouncement()),
                  _buildCreateOption('채팅 메시지', Icons.chat, () => _sendChatMessage()),
                  _buildCreateOption('설문 조사', Icons.poll, () => _createSurvey()),
                  _buildCreateOption('투표', Icons.how_to_vote, () => _createVote()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions() {
    // TODO: Show chat options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('채팅 옵션 기능 구현 예정')),
    );
  }

  void _attachFile() {
    // TODO: Implement file attachment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('파일 첨부 기능 구현 예정')),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    // TODO: Send chat message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('메시지 전송: ${_messageController.text}')),
    );
    
    _messageController.clear();
  }

  void _markAllAsRead() {
    // TODO: Mark all communications as read
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 메시지를 읽음으로 표시했습니다')),
    );
  }

  void _exportMessages() {
    // TODO: Export messages
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('메시지 내보내기 기능 구현 예정')),
    );
  }

  void _showNotificationSettings() {
    // TODO: Show notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 설정 기능 구현 예정')),
    );
  }

  void _viewAnnouncementDetails(GroupCommunicationModel announcement) {
    // TODO: Show announcement details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 상세 보기 기능 구현 예정')),
    );
  }

  void _viewReadStatus(GroupCommunicationModel announcement) {
    // TODO: Show read status
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('읽음 현황 기능 구현 예정')),
    );
  }

  void _editAnnouncement(GroupCommunicationModel announcement) {
    // TODO: Edit announcement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 수정 기능 구현 예정')),
    );
  }

  void _duplicateAnnouncement(GroupCommunicationModel announcement) {
    // TODO: Duplicate announcement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 복제 기능 구현 예정')),
    );
  }

  void _deleteAnnouncement(GroupCommunicationModel announcement) {
    // TODO: Delete announcement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 삭제 기능 구현 예정')),
    );
  }

  void _createAnnouncement() {
    Navigator.pop(context);
    // TODO: Show create announcement form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 작성 기능 구현 예정')),
    );
  }

  void _sendChatMessage() {
    Navigator.pop(context);
    _tabController.animateTo(1);
  }

  void _createSurvey() {
    Navigator.pop(context);
    // TODO: Show create survey form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설문 생성 기능 구현 예정')),
    );
  }

  void _createVote() {
    Navigator.pop(context);
    // TODO: Show create vote form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('투표 생성 기능 구현 예정')),
    );
  }

  void _viewSurveyResults(GroupCommunicationModel survey) {
    // TODO: Show survey results
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설문 결과 보기 기능 구현 예정')),
    );
  }

  void _participateInSurvey(GroupCommunicationModel survey) {
    // TODO: Show survey participation form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설문 참여 기능 구현 예정')),
    );
  }

  void _viewCommunicationDetails(GroupCommunicationModel communication) {
    // TODO: Show communication details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('커뮤니케이션 상세 보기 기능 구현 예정')),
    );
  }

  void _editCommunication(GroupCommunicationModel communication) {
    // TODO: Edit communication
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('커뮤니케이션 수정 기능 구현 예정')),
    );
  }

  void _deleteCommunication(GroupCommunicationModel communication) {
    // TODO: Delete communication
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('커뮤니케이션 삭제 기능 구현 예정')),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // Mock data creators
  GroupModel _createMockGroup() {
    return const GroupModel(
      id: 'group_1',
      name: '삼성전자 여행 그룹',
      description: '삼성전자 임직원 여행 그룹',
      type: GroupType.corporate,
      status: GroupStatus.active,
      organizationNumber: '124-81-00998',
      address: '경기도 수원시 영통구 삼성로 129',
      contactPerson: '김여행',
      contactPhone: '010-1234-5678',
      contactEmail: 'travel@samsung.com',
      settings: {},
      departmentIds: ['dept_1', 'dept_2'],
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      createdBy: 'admin',
    );
  }

  List<GroupMemberModel> _createMockMembers() {
    return [
      const GroupMemberModel(
        id: 'member_1',
        groupId: 'group_1',
        userId: 'user_1',
        departmentId: 'dept_1',
        role: GroupRole.admin,
        status: MemberStatus.active,
        name: '김관리',
        email: 'admin@samsung.com',
        phone: '010-1111-1111',
        position: '여행팀장',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-01',
        invitedBy: 'system',
      ),
      const GroupMemberModel(
        id: 'member_2',
        groupId: 'group_1',
        userId: 'user_2',
        departmentId: 'dept_2',
        role: GroupRole.member,
        status: MemberStatus.active,
        name: '이직원',
        email: 'employee@samsung.com',
        phone: '010-2222-2222',
        position: '사원',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-02',
        invitedBy: 'member_1',
      ),
      const GroupMemberModel(
        id: 'member_3',
        groupId: 'group_1',
        userId: 'user_3',
        departmentId: 'dept_1',
        role: GroupRole.coordinator,
        status: MemberStatus.active,
        name: '박코디',
        email: 'coordinator@samsung.com',
        phone: '010-3333-3333',
        position: '코디네이터',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-03',
        invitedBy: 'member_1',
      ),
    ];
  }

  List<GroupCommunicationModel> _createMockCommunications() {
    return [
      GroupCommunicationModel(
        id: 'comm_1',
        groupId: widget.groupId,
        type: 'announcement',
        title: '제주도 여행 일정 확정 안내',
        content: '안녕하세요. 제주도 3박 4일 여행 일정이 최종 확정되었습니다. 자세한 일정표는 첨부 파일을 확인해주세요.',
        senderId: 'member_1',
        recipientIds: _members.map((m) => m.id).toList(),
        metadata: {},
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        readByIds: ['member_1', 'member_2'],
        responses: [],
      ),
      GroupCommunicationModel(
        id: 'comm_2',
        groupId: widget.groupId,
        type: 'survey',
        title: '여행 만족도 조사',
        content: '지난 여행에 대한 만족도 조사를 진행합니다. 많은 참여 부탁드립니다.',
        senderId: 'member_3',
        recipientIds: _members.map((m) => m.id).toList(),
        metadata: {'options': ['매우 만족', '만족', '보통', '불만족', '매우 불만족']},
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        readByIds: ['member_3'],
        responses: [],
      ),
    ];
  }
}