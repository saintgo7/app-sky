import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../data/models/group_model.dart';

class GroupAccountScreen extends StatefulWidget {
  final GroupModel? existingGroup;

  const GroupAccountScreen({super.key, this.existingGroup});

  @override
  State<GroupAccountScreen> createState() => _GroupAccountScreenState();
}

class _GroupAccountScreenState extends State<GroupAccountScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orgNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  
  GroupType _selectedType = GroupType.corporate;
  bool _isLoading = false;
  List<PlatformFile>? _verificationDocuments;
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.existingGroup != null) {
      _populateExistingData();
    }
    
    _initializeSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _orgNumberController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    super.dispose();
  }

  void _populateExistingData() {
    final group = widget.existingGroup!;
    _nameController.text = group.name;
    _descriptionController.text = group.description;
    _orgNumberController.text = group.organizationNumber;
    _addressController.text = group.address;
    _contactPersonController.text = group.contactPerson;
    _contactPhoneController.text = group.contactPhone;
    _contactEmailController.text = group.contactEmail;
    _selectedType = group.type;
    _settings = Map.from(group.settings);
  }

  void _initializeSettings() {
    _settings = {
      'allowSubAccounts': true,
      'requireApproval': true,
      'enableTracking': false,
      'enableNotifications': true,
      'enableFinancialReports': true,
      'enableBulkOperations': true,
      'maxMembers': _selectedType == GroupType.corporate ? 500 : 1000,
      'dataRetentionDays': 365,
      'currency': 'KRW',
      'timezone': 'Asia/Seoul',
      'language': 'ko',
      ..._settings,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingGroup != null ? '단체 계정 수정' : '단체 계정 생성'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textLight 
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.business), text: '기본 정보'),
            Tab(icon: Icon(Icons.verified), text: '인증'),
            Tab(icon: Icon(Icons.settings), text: '설정'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBasicInfoTab(),
            _buildVerificationTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupTypeSelection(),
          const SizedBox(height: 24),
          _buildBasicInfoForm(),
          const SizedBox(height: 24),
          _buildContactInfoForm(),
        ],
      ),
    );
  }

  Widget _buildGroupTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '단체 유형',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GroupType.values.map((type) {
                return ChoiceChip(
                  label: Text(_getTypeLabel(type)),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                        _updateSettingsForType(type);
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              _getTypeDescription(_selectedType),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 정보',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '단체명 *',
                hintText: '예: 삼성전자, 서울대학교, 서울시청',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '단체명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '단체 설명',
                hintText: '단체에 대한 간단한 설명을 입력해주세요',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _orgNumberController,
              decoration: InputDecoration(
                labelText: _getOrgNumberLabel(_selectedType),
                hintText: _getOrgNumberHint(_selectedType),
                prefixIcon: const Icon(Icons.numbers),
                border: const OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '${_getOrgNumberLabel(_selectedType)}을(를) 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '주소 *',
                hintText: '단체의 주소를 입력해주세요',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '주소를 입력해주세요';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '담당자 정보',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactPersonController,
              decoration: const InputDecoration(
                labelText: '담당자명 *',
                hintText: '여행 관리 담당자명',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '담당자명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactPhoneController,
              decoration: const InputDecoration(
                labelText: '연락처 *',
                hintText: '010-0000-0000',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '연락처를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactEmailController,
              decoration: const InputDecoration(
                labelText: '이메일 *',
                hintText: 'contact@company.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '이메일을 입력해주세요';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return '올바른 이메일 형식이 아닙니다';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerificationInfo(),
          const SizedBox(height: 24),
          _buildDocumentUpload(),
          const SizedBox(height: 24),
          _buildVerificationStatus(),
        ],
      ),
    );
  }

  Widget _buildVerificationInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '인증 안내',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildVerificationRequirement(
              '사업자등록증 (기업)',
              '법인등록증 또는 개인사업자등록증',
              _selectedType == GroupType.corporate,
            ),
            _buildVerificationRequirement(
              '고유번호증 (관공서)',
              '기관 고유번호증 또는 설립허가증',
              _selectedType == GroupType.government,
            ),
            _buildVerificationRequirement(
              '학교법인증 (교육기관)',
              '학교법인증 또는 설립인가서',
              _selectedType == GroupType.school || _selectedType == GroupType.university,
            ),
            _buildVerificationRequirement(
              '단체등록증 (비영리)',
              '비영리단체등록증 또는 설립허가서',
              _selectedType == GroupType.ngo,
            ),
            const Divider(),
            Row(
              children: [
                Icon(Icons.info, color: AppColors.info  size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '인증 완료 후 단체 할인 및 전용 서비스를 이용할 수 있습니다.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationRequirement(String title, String description, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isRequired ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isRequired ? AppColors.success : AppColors.textSecondary 
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isRequired ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUpload() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '서류 업로드',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textDisabled,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: AppColors.textDisabled,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '인증 서류를 업로드해주세요',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PDF, JPG, PNG 파일 (최대 5MB)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _uploadDocuments,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('파일 선택'),
                  ),
                ],
              ),
            ),
            if (_verificationDocuments?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              ...(_verificationDocuments!.map((file) {
                return ListTile(
                  leading: Icon(
                    _getFileIcon(file.extension),
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(file.name),
                  subtitle: Text('${(file.size / 1024 / 1024).toStringAsFixed(1)} MB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeDocument(file),
                  ),
                );
              }).toList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '인증 상태',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildStatusItem(
              '기본 정보',
              widget.existingGroup != null ? '완료' : '대기',
              widget.existingGroup != null ? AppColors.success : AppColors.warning 
            ),
            _buildStatusItem(
              '서류 업로드',
              _verificationDocuments?.isNotEmpty == true ? '완료' : '대기',
              _verificationDocuments?.isNotEmpty == true ? AppColors.success : AppColors.textSecondary 
            ),
            _buildStatusItem(
              '관리자 승인',
              '대기',
              AppColors.textSecondary 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGeneralSettings(),
          const SizedBox(height: 16),
          _buildPermissionSettings(),
          const SizedBox(height: 16),
          _buildNotificationSettings(),
          const SizedBox(height: 16),
          _buildDataSettings(),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '일반 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('하위 계정 허용'),
              subtitle: const Text('부서별/학년별 하위 그룹 생성 허용'),
              value: _settings['allowSubAccounts'] ?? true,
              onChanged: (value) {
                setState(() {
                  _settings['allowSubAccounts'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('가입 승인 필요'),
              subtitle: const Text('새 멤버 가입 시 관리자 승인 필요'),
              value: _settings['requireApproval'] ?? true,
              onChanged: (value) {
                setState(() {
                  _settings['requireApproval'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('위치 추적 허용'),
              subtitle: const Text('여행 중 참가자 위치 추적 (동의 하에)'),
              value: _settings['enableTracking'] ?? false,
              onChanged: (value) {
                setState(() {
                  _settings['enableTracking'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '권한 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('재무 보고서 활성화'),
              subtitle: const Text('비용 관리 및 정산 기능 사용'),
              value: _settings['enableFinancialReports'] ?? true,
              onChanged: (value) {
                setState(() {
                  _settings['enableFinancialReports'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('일괄 작업 허용'),
              subtitle: const Text('Excel 업로드 등 대용량 데이터 처리'),
              value: _settings['enableBulkOperations'] ?? true,
              onChanged: (value) {
                setState(() {
                  _settings['enableBulkOperations'] = value;
                });
              },
            ),
            ListTile(
              title: const Text('최대 멤버 수'),
              subtitle: Text('현재: ${_settings['maxMembers']}명'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editMaxMembers(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '알림 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('푸시 알림 활성화'),
              subtitle: const Text('중요 공지사항 및 일정 변경 알림'),
              value: _settings['enableNotifications'] ?? true,
              onChanged: (value) {
                setState(() {
                  _settings['enableNotifications'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '데이터 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('데이터 보관 기간'),
              subtitle: Text('${_settings['dataRetentionDays']}일'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editRetentionPeriod(),
            ),
            ListTile(
              title: const Text('기본 통화'),
              subtitle: Text('${_settings['currency']}'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editCurrency(),
            ),
            ListTile(
              title: const Text('시간대'),
              subtitle: Text('${_settings['timezone']}'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editTimezone(),
            ),
            ListTile(
              title: const Text('언어'),
              subtitle: Text(_getLanguageName(_settings['language'])),
              trailing: const Icon(Icons.edit),
              onTap: () => _editLanguage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight 
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveGroup,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.existingGroup != null ? '수정' : '생성'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getTypeLabel(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return '기업';
      case GroupType.government:
        return '관공서';
      case GroupType.school:
        return '초중고';
      case GroupType.university:
        return '대학교';
      case GroupType.ngo:
        return '비영리단체';
    }
  }

  String _getTypeDescription(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return '사업자등록증이 있는 기업 및 법인';
      case GroupType.government:
        return '중앙정부, 지방자치단체 및 공공기관';
      case GroupType.school:
        return '초등학교, 중학교, 고등학교';
      case GroupType.university:
        return '대학교, 대학원 및 전문대학';
      case GroupType.ngo:
        return '비영리단체, 종교단체, 동호회 등';
    }
  }

  String _getOrgNumberLabel(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return '사업자등록번호 *';
      case GroupType.government:
        return '기관고유번호 *';
      case GroupType.school:
      case GroupType.university:
        return '학교법인번호 *';
      case GroupType.ngo:
        return '단체등록번호 *';
    }
  }

  String _getOrgNumberHint(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return '000-00-00000';
      case GroupType.government:
        return '000-00-00000';
      case GroupType.school:
      case GroupType.university:
        return '0000000000';
      case GroupType.ngo:
        return '0000000000';
    }
  }

  void _updateSettingsForType(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        _settings['maxMembers'] = 500;
        _settings['enableTracking'] = false;
        break;
      case GroupType.government:
        _settings['maxMembers'] = 1000;
        _settings['enableTracking'] = true;
        break;
      case GroupType.school:
      case GroupType.university:
        _settings['maxMembers'] = 2000;
        _settings['enableTracking'] = true;
        _settings['requireApproval'] = true;
        break;
      case GroupType.ngo:
        _settings['maxMembers'] = 200;
        _settings['enableTracking'] = false;
        break;
    }
  }

  Future<void> _uploadDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _verificationDocuments = result.files;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 선택 중 오류가 발생했습니다: $e')),
      );
    }
  }

  void _removeDocument(PlatformFile file) {
    setState(() {
      _verificationDocuments?.remove(file);
    });
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _editMaxMembers() {
    // TODO: Implement max members editor
  }

  void _editRetentionPeriod() {
    // TODO: Implement retention period editor
  }

  void _editCurrency() {
    // TODO: Implement currency selector
  }

  void _editTimezone() {
    // TODO: Implement timezone selector
  }

  void _editLanguage() {
    // TODO: Implement language selector
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      default:
        return languageCode;
    }
  }

  Future<void> _saveGroup() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필수 항목을 입력해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final groupData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'type': _selectedType.name,
        'organizationNumber': _orgNumberController.text,
        'address': _addressController.text,
        'contactPerson': _contactPersonController.text,
        'contactPhone': _contactPhoneController.text,
        'contactEmail': _contactEmailController.text,
        'settings': _settings,
        'verificationDocuments': _verificationDocuments?.map((f) => f.name).toList(),
      };

      // TODO: Save to backend
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingGroup != null ? '단체 계정이 수정되었습니다' : '단체 계정이 생성되었습니다'),
            backgroundColor: AppColors.success 
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}