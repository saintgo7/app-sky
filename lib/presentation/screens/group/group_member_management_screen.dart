import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../data/models/group_model.dart';

class GroupMemberManagementScreen extends StatefulWidget {
  final String groupId;

  const GroupMemberManagementScreen({super.key, required this.groupId});

  @override
  State<GroupMemberManagementScreen> createState() => _GroupMemberManagementScreenState();
}

class _GroupMemberManagementScreenState extends State<GroupMemberManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // State
  List<GroupMemberModel> _members = [];
  List<DepartmentModel> _departments = [];
  List<GroupInvitationModel> _invitations = [];
  GroupModel? _groupInfo;
  bool _isLoading = true;
  String _searchQuery = '';
  GroupRole? _filterRole;
  MemberStatus? _filterStatus;
  String? _filterDepartment;

  // Controllers
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Load from backend
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _groupInfo = _createMockGroup();
        _members = _createMockMembers();
        _departments = _createMockDepartments();
        _invitations = _createMockInvitations();
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
        title: const Text('구성원 관리'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textLight 
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showInviteDialog,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk_invite',
                child: Row(
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 8),
                    Text('일괄 초대'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('내보내기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('설정'),
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
              icon: const Icon(Icons.people),
              text: '구성원 (${_members.length})',
            ),
            Tab(
              icon: const Icon(Icons.mail),
              text: '초대 (${_invitations.length})',
            ),
            Tab(
              icon: const Icon(Icons.business),
              text: '부서 (${_departments.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchAndFilter(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMembersTab(),
                      _buildInvitationsTab(),
                      _buildDepartmentsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '이름, 이메일, 부서로 검색...',
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
              fillColor: AppColors.background,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  '전체 권한',
                  _filterRole?.name ?? '전체',
                  () => _showRoleFilter(),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '전체 상태',
                  _filterStatus?.name ?? '전체',
                  () => _showStatusFilter(),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '전체 부서',
                  _filterDepartment ?? '전체',
                  () => _showDepartmentFilter(),
                ),
                const SizedBox(width: 8),
                if (_filterRole != null || _filterStatus != null || _filterDepartment != null)
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear),
                    label: const Text('필터 초기화'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textDisabled),
          borderRadius: BorderRadius.circular(16),
          color: value != '전체' ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 12,
                color: value != '전체' ? Theme.of(context).primaryColor : null,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: value != '전체' ? Theme.of(context).primaryColor : AppColors.textSecondary 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    final filteredMembers = _getFilteredMembers();
    
    if (filteredMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: AppColors.textSecondary ,
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty || _hasActiveFilters()
                  ? '조건에 맞는 구성원이 없습니다'
                  : '아직 구성원이 없습니다',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty || _hasActiveFilters()
                  ? '검색어나 필터를 변경해보세요'
                  : '새 구성원을 초대해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary 
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showInviteDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('구성원 초대'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredMembers.length,
        itemBuilder: (context, index) {
          final member = filteredMembers[index];
          return _buildMemberCard(member);
        },
      ),
    );
  }

  Widget _buildMemberCard(GroupMemberModel member) {
    final department = _departments.firstWhere(
      (dept) => dept.id == member.departmentId,
      orElse: () => const DepartmentModel(
        id: '',
        groupId: '',
        name: '미배정',
        description: '',
        memberIds: [],
        settings: {},
        createdAt: '',
        updatedAt: '',
        createdBy: '',
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(member.role),
          child: Text(
            member.name.isNotEmpty ? member.name[0] : 'U',
            style: const TextStyle(color: AppColors.textLight  fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildStatusChip(member.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.business, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  department.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.admin_panel_settings, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  _getRoleLabel(member.role),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (member.position.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                member.position,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary 
                    ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton(
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
              value: 'change_role',
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings),
                  SizedBox(width: 8),
                  Text('권한 변경'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'change_department',
              child: Row(
                children: [
                  Icon(Icons.business),
                  SizedBox(width: 8),
                  Text('부서 변경'),
                ],
              ),
            ),
            PopupMenuItem(
              value: member.status == MemberStatus.active ? 'suspend' : 'activate',
              child: Row(
                children: [
                  Icon(member.status == MemberStatus.active 
                      ? Icons.block 
                      : Icons.check_circle),
                  const SizedBox(width: 8),
                  Text(member.status == MemberStatus.active ? '정지' : '활성화'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.delete, color: AppColors.danger ,
                  SizedBox(width: 8),
                  Text('제거', style: TextStyle(color: AppColors.danger ),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleMemberAction(member, value as String),
        ),
        onTap: () => _showMemberDetails(member),
      ),
    );
  }

  Widget _buildStatusChip(MemberStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case MemberStatus.active:
        color = AppColors.success 
        label = '활성';
        break;
      case MemberStatus.inactive:
        color = AppColors.textSecondary 
        label = '비활성';
        break;
      case MemberStatus.suspended:
        color = AppColors.danger 
        label = '정지';
        break;
      case MemberStatus.pending:
        color = AppColors.warning 
        label = '대기';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInvitationsTab() {
    final filteredInvitations = _invitations.where((invitation) {
      return _searchQuery.isEmpty ||
          invitation.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          invitation.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredInvitations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mail_outline, size: 64, color: AppColors.textSecondary ,
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? '조건에 맞는 초대가 없습니다' : '보낸 초대가 없습니다',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty ? '검색어를 변경해보세요' : '새 구성원을 초대해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary 
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredInvitations.length,
      itemBuilder: (context, index) {
        final invitation = filteredInvitations[index];
        return _buildInvitationCard(invitation);
      },
    );
  }

  Widget _buildInvitationCard(GroupInvitationModel invitation) {
    final department = _departments.firstWhere(
      (dept) => dept.id == invitation.departmentId,
      orElse: () => const DepartmentModel(
        id: '',
        groupId: '',
        name: '미배정',
        description: '',
        memberIds: [],
        settings: {},
        createdAt: '',
        updatedAt: '',
        createdBy: '',
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getInvitationStatusColor(invitation.status),
          child: Icon(
            _getInvitationStatusIcon(invitation.status),
            color: AppColors.textLight 
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(invitation.name)),
            _buildInvitationStatusChip(invitation.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invitation.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.business, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  department.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.admin_panel_settings, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  _getRoleLabel(invitation.role),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(invitation.invitedAt)} 초대',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary 
                      ),
                ),
                if (invitation.status == 'pending') ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${_getDaysUntilExpiry(invitation)}일 남음)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warning 
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            if (invitation.status == 'pending') ...[
              const PopupMenuItem(
                value: 'resend',
                child: Row(
                  children: [
                    Icon(Icons.send),
                    SizedBox(width: 8),
                    Text('재전송'),
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
            ],
            const PopupMenuItem(
              value: 'cancel',
              child: Row(
                children: [
                  Icon(Icons.cancel, color: AppColors.danger ,
                  SizedBox(width: 8),
                  Text('취소', style: TextStyle(color: AppColors.danger ),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleInvitationAction(invitation, value as String),
        ),
      ),
    );
  }

  Widget _buildInvitationStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'pending':
        color = AppColors.warning 
        label = '대기중';
        break;
      case 'accepted':
        color = AppColors.success 
        label = '수락됨';
        break;
      case 'rejected':
        color = AppColors.danger 
        label = '거절됨';
        break;
      case 'expired':
        color = AppColors.textSecondary 
        label = '만료됨';
        break;
      default:
        color = AppColors.textSecondary 
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDepartmentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _departments.length + 1,
      itemBuilder: (context, index) {
        if (index == _departments.length) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.textSecondary 
                child: Icon(Icons.add, color: AppColors.textLight ,
              ),
              title: const Text('새 부서 추가'),
              subtitle: const Text('새로운 부서를 생성합니다'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _createDepartment,
            ),
          );
        }
        
        final department = _departments[index];
        return _buildDepartmentCard(department);
      },
    );
  }

  Widget _buildDepartmentCard(DepartmentModel department) {
    final memberCount = department.memberIds.length;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            department.name.isNotEmpty ? department.name[0] : 'D',
            style: const TextStyle(color: AppColors.textLight  fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          department.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (department.description.isNotEmpty)
              Text(department.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  '$memberCount명',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
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
              value: 'members',
              child: Row(
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text('구성원 관리'),
                ],
              ),
            ),
            if (memberCount == 0) ...[
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.danger ,
                    SizedBox(width: 8),
                    Text('삭제', style: TextStyle(color: AppColors.danger ),
                  ],
                ),
              ),
            ],
          ],
          onSelected: (value) => _handleDepartmentAction(department, value as String),
        ),
        onTap: () => _showDepartmentDetails(department),
      ),
    );
  }

  // Helper methods and mock data
  List<GroupMemberModel> _getFilteredMembers() {
    return _members.where((member) {
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!member.name.toLowerCase().contains(searchLower) &&
            !member.email.toLowerCase().contains(searchLower)) {
          return false;
        }
      }
      
      if (_filterRole != null && member.role != _filterRole) return false;
      if (_filterStatus != null && member.status != _filterStatus) return false;
      if (_filterDepartment != null && member.departmentId != _filterDepartment) return false;
      
      return true;
    }).toList();
  }

  bool _hasActiveFilters() {
    return _filterRole != null || _filterStatus != null || _filterDepartment != null;
  }

  void _clearFilters() {
    setState(() {
      _filterRole = null;
      _filterStatus = null;
      _filterDepartment = null;
    });
  }

  Color _getRoleColor(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return AppColors.danger 
      case GroupRole.manager:
        return AppColors.warning 
      case GroupRole.coordinator:
        return AppColors.info 
      case GroupRole.member:
        return AppColors.success 
      case GroupRole.viewer:
        return AppColors.textSecondary 
    }
  }

  String _getRoleLabel(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return '관리자';
      case GroupRole.manager:
        return '매니저';
      case GroupRole.coordinator:
        return '코디네이터';
      case GroupRole.member:
        return '멤버';
      case GroupRole.viewer:
        return '뷰어';
    }
  }

  Color _getInvitationStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning 
      case 'accepted':
        return AppColors.success 
      case 'rejected':
        return AppColors.danger 
      case 'expired':
        return AppColors.textSecondary 
      default:
        return AppColors.textSecondary 
    }
  }

  IconData _getInvitationStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'expired':
        return Icons.access_time;
      default:
        return Icons.mail;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  int _getDaysUntilExpiry(GroupInvitationModel invitation) {
    return invitation.expiresAt.difference(DateTime.now()).inDays;
  }

  // Mock data creators
  GroupModel _createMockGroup() {
    return const GroupModel(
      id: 'group_1',
      name: '삼성전자',
      description: '글로벌 기술 선도기업',
      type: GroupType.corporate,
      status: GroupStatus.active,
      organizationNumber: '124-81-00998',
      address: '경기도 수원시 영통구 삼성로 129',
      contactPerson: '김여행',
      contactPhone: '010-1234-5678',
      contactEmail: 'travel@samsung.com',
      settings: {},
      departmentIds: ['dept_1', 'dept_2', 'dept_3'],
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
        role: GroupRole.manager,
        status: MemberStatus.active,
        name: '이매니저',
        email: 'manager@samsung.com',
        phone: '010-2222-2222',
        position: '부팀장',
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
        position: '여행기획자',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-03',
        invitedBy: 'member_1',
      ),
    ];
  }

  List<DepartmentModel> _createMockDepartments() {
    return [
      const DepartmentModel(
        id: 'dept_1',
        groupId: 'group_1',
        name: '경영지원팀',
        description: '경영지원 업무 총괄',
        memberIds: ['member_1', 'member_3'],
        settings: {},
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
        createdBy: 'admin',
      ),
      const DepartmentModel(
        id: 'dept_2',
        groupId: 'group_1',
        name: '개발팀',
        description: 'SW 개발',
        memberIds: ['member_2'],
        settings: {},
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
        createdBy: 'admin',
      ),
      const DepartmentModel(
        id: 'dept_3',
        groupId: 'group_1',
        name: '마케팅팀',
        description: '마케팅 전략 수립',
        memberIds: [],
        settings: {},
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
        createdBy: 'admin',
      ),
    ];
  }

  List<GroupInvitationModel> _createMockInvitations() {
    return [
      GroupInvitationModel(
        id: 'inv_1',
        groupId: 'group_1',
        email: 'new@samsung.com',
        name: '신입사',
        departmentId: 'dept_1',
        role: GroupRole.member,
        invitedBy: 'member_1',
        invitedAt: DateTime.now().subtract(const Duration(days: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 5)),
        status: 'pending',
      ),
    ];
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'bulk_invite':
        _showBulkInviteDialog();
        break;
      case 'export':
        _exportMembers();
        break;
      case 'settings':
        _showGroupSettings();
        break;
    }
  }

  void _handleMemberAction(GroupMemberModel member, String action) {
    switch (action) {
      case 'edit':
        _editMember(member);
        break;
      case 'change_role':
        _changeRole(member);
        break;
      case 'change_department':
        _changeDepartment(member);
        break;
      case 'suspend':
      case 'activate':
        _toggleMemberStatus(member);
        break;
      case 'remove':
        _removeMember(member);
        break;
    }
  }

  void _handleInvitationAction(GroupInvitationModel invitation, String action) {
    switch (action) {
      case 'resend':
        _resendInvitation(invitation);
        break;
      case 'edit':
        _editInvitation(invitation);
        break;
      case 'cancel':
        _cancelInvitation(invitation);
        break;
    }
  }

  void _handleDepartmentAction(DepartmentModel department, String action) {
    switch (action) {
      case 'edit':
        _editDepartment(department);
        break;
      case 'members':
        _manageDepartmentMembers(department);
        break;
      case 'delete':
        _deleteDepartment(department);
        break;
    }
  }

  // Dialog methods
  void _showInviteDialog() {
    // TODO: Implement invite dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('구성원 초대 기능 구현 예정')),
    );
  }

  void _showBulkInviteDialog() {
    // TODO: Implement bulk invite dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('일괄 초대 기능 구현 예정')),
    );
  }

  void _showRoleFilter() {
    // TODO: Implement role filter dialog
  }

  void _showStatusFilter() {
    // TODO: Implement status filter dialog
  }

  void _showDepartmentFilter() {
    // TODO: Implement department filter dialog
  }

  void _showMemberDetails(GroupMemberModel member) {
    // TODO: Implement member details dialog
  }

  void _showDepartmentDetails(DepartmentModel department) {
    // TODO: Implement department details screen
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

  // Action implementations
  void _createDepartment() {
    // TODO: Implement department creation
  }

  void _editMember(GroupMemberModel member) {
    // TODO: Implement member editing
  }

  void _changeRole(GroupMemberModel member) {
    // TODO: Implement role change
  }

  void _changeDepartment(GroupMemberModel member) {
    // TODO: Implement department change
  }

  void _toggleMemberStatus(GroupMemberModel member) {
    // TODO: Implement status toggle
  }

  void _removeMember(GroupMemberModel member) {
    // TODO: Implement member removal
  }

  void _resendInvitation(GroupInvitationModel invitation) {
    // TODO: Implement invitation resend
  }

  void _editInvitation(GroupInvitationModel invitation) {
    // TODO: Implement invitation editing
  }

  void _cancelInvitation(GroupInvitationModel invitation) {
    // TODO: Implement invitation cancellation
  }

  void _editDepartment(DepartmentModel department) {
    // TODO: Implement department editing
  }

  void _manageDepartmentMembers(DepartmentModel department) {
    // TODO: Implement department member management
  }

  void _deleteDepartment(DepartmentModel department) {
    // TODO: Implement department deletion
  }

  void _exportMembers() {
    // TODO: Implement member export
  }

  void _showGroupSettings() {
    // TODO: Implement group settings
  }
}