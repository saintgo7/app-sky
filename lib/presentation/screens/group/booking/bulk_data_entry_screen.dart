import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

import '../../../../data/models/group_model.dart';

class BulkDataEntryScreen extends StatefulWidget {
  final String groupId;
  final Map<String, dynamic>? customizationData;

  const BulkDataEntryScreen({
    super.key,
    required this.groupId,
    this.customizationData,
  });

  @override
  State<BulkDataEntryScreen> createState() => _BulkDataEntryScreenState();
}

class _BulkDataEntryScreenState extends State<BulkDataEntryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // State
  List<ParticipantDataModel> _participants = [];
  GroupModel? _groupInfo;
  List<DepartmentModel> _departments = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  
  // Excel data processing
  Excel? _excelData;
  String? _selectedSheetName;
  List<String> _availableSheets = [];
  Map<String, int> _columnMapping = {};
  List<Map<String, String>> _previewData = [];
  
  // Form controllers
  final _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Required columns for participant data
  static const List<String> requiredColumns = [
    'name', 'email', 'phone', 'department',
  ];
  
  static const List<String> optionalColumns = [
    'position', 'birthDate', 'gender', 'passportNumber', 'passportExpiry',
    'emergencyContact', 'emergencyPhone', 'dietaryRestrictions',
    'medicalInfo', 'roomPreference', 'specialRequests',
  ];

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
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _groupInfo = _createMockGroup();
        _departments = _createMockDepartments();
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
        title: const Text('참가자 일괄 관리'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadTemplate,
            tooltip: '템플릿 다운로드',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('전체 삭제'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('내보내기'),
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
              icon: const Icon(Icons.upload_file),
              text: 'Excel 업로드',
            ),
            Tab(
              icon: const Icon(Icons.people),
              text: '참가자 관리 (${_participants.length})',
            ),
            Tab(
              icon: const Icon(Icons.assignment),
              text: '여권/비자 관리',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUploadTab(),
                _buildParticipantsTab(),
                _buildDocumentsTab(),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUploadSection(),
          if (_excelData != null) ...[
            const SizedBox(height: 24),
            _buildSheetSelection(),
          ],
          if (_selectedSheetName != null) ...[
            const SizedBox(height: 24),
            _buildColumnMapping(),
          ],
          if (_previewData.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildDataPreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Excel 파일 업로드',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Excel 파일을 업로드해주세요',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '.xlsx, .xls 파일 지원 (최대 10MB)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickExcelFile,
                        icon: const Icon(Icons.attach_file),
                        label: const Text('파일 선택'),
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: _downloadTemplate,
                        icon: const Icon(Icons.download),
                        label: const Text('템플릿 다운로드'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_excelData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Excel 파일이 업로드되었습니다',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSheetSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '시트 선택',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSheets.map((sheetName) {
                return ChoiceChip(
                  label: Text(sheetName),
                  selected: _selectedSheetName == sheetName,
                  onSelected: (selected) {
                    if (selected) {
                      _selectSheet(sheetName);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnMapping() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '컬럼 매핑',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Excel의 컬럼을 시스템 필드에 매핑해주세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 16),
            ...requiredColumns.map((field) => _buildFieldMapping(field, true)),
            const Divider(),
            ...optionalColumns.map((field) => _buildFieldMapping(field, false)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetMapping,
                    child: const Text('매핑 초기화'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _validateAndPreview,
                    child: const Text('미리보기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldMapping(String field, bool isRequired) {
    final availableColumns = _getAvailableColumns();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '${_getFieldLabel(field)}${isRequired ? ' *' : ''}',
              style: TextStyle(
                fontWeight: isRequired ? FontWeight.bold : FontWeight.normal,
                color: isRequired ? Colors.black : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _columnMapping[field],
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: isRequired ? '필수 선택' : '선택 안함',
              ),
              items: [
                if (!isRequired)
                  const DropdownMenuItem<int>(
                    value: -1,
                    child: Text('선택 안함'),
                  ),
                ...availableColumns.asMap().entries.map(
                  (entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text('${entry.key + 1}열: ${entry.value}'),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  if (value == -1) {
                    _columnMapping.remove(field);
                  } else {
                    _columnMapping[field] = value!;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '데이터 미리보기 (${_previewData.length}명)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: _processData,
                  icon: const Icon(Icons.check),
                  label: const Text('데이터 가져오기'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _previewData.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 40, child: Text('#')),
                          ...requiredColumns.map((field) => Expanded(
                                child: Text(
                                  _getFieldLabel(field),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      ),
                    );
                  }
                  
                  final data = _previewData[index - 1];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 40, child: Text('$index')),
                        ...requiredColumns.map((field) => Expanded(
                              child: Text(
                                data[field] ?? '',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTab() {
    final filteredParticipants = _getFilteredParticipants();
    
    return Column(
      children: [
        _buildSearchAndActions(),
        Expanded(
          child: filteredParticipants.isEmpty
              ? _buildEmptyParticipants()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredParticipants.length,
                  itemBuilder: (context, index) {
                    final participant = filteredParticipants[index];
                    return _buildParticipantCard(participant, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchAndActions() {
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
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addParticipant,
                  icon: const Icon(Icons.person_add),
                  label: const Text('참가자 추가'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _validateAllData,
                  icon: const Icon(Icons.verified),
                  label: const Text('데이터 검증'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyParticipants() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? '검색 결과가 없습니다'
                : '참가자 데이터가 없습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? '검색어를 변경해보세요'
                : 'Excel 파일을 업로드하거나 직접 추가해주세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(0),
            icon: const Icon(Icons.upload_file),
            label: const Text('Excel 업로드'),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(ParticipantDataModel participant, int index) {
    final hasErrors = participant.validationErrors.isNotEmpty;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: hasErrors ? Colors.red : Colors.green,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                participant.name.isNotEmpty ? participant.name : '이름 없음',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (hasErrors)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '오류 ${participant.validationErrors.length}',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (participant.email.isNotEmpty) Text(participant.email),
            if (participant.department.isNotEmpty) 
              Text('부서: ${participant.department}'),
            if (hasErrors) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: participant.validationErrors.map((error) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
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
          onSelected: (value) => _handleParticipantAction(participant, value as String),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildParticipantDetails(participant),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantDetails(ParticipantDataModel participant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('이름', participant.name),
        _buildDetailRow('이메일', participant.email),
        _buildDetailRow('전화번호', participant.phone),
        _buildDetailRow('부서', participant.department),
        _buildDetailRow('직책', participant.position),
        _buildDetailRow('생년월일', participant.birthDate),
        _buildDetailRow('성별', participant.gender),
        _buildDetailRow('여권번호', participant.passportNumber),
        _buildDetailRow('여권만료일', participant.passportExpiry),
        _buildDetailRow('비상연락처', participant.emergencyContact),
        _buildDetailRow('비상연락처 전화', participant.emergencyPhone),
        _buildDetailRow('식이제한', participant.dietaryRestrictions),
        _buildDetailRow('의료정보', participant.medicalInfo),
        _buildDetailRow('룸 선호', participant.roomPreference),
        _buildDetailRow('특별요청', participant.specialRequests),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final participantsWithDocuments = _participants
        .where((p) => p.passportNumber.isNotEmpty)
        .toList();
    
    return Column(
      children: [
        _buildDocumentsHeader(participantsWithDocuments.length),
        Expanded(
          child: participantsWithDocuments.isEmpty
              ? _buildEmptyDocuments()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: participantsWithDocuments.length,
                  itemBuilder: (context, index) {
                    final participant = participantsWithDocuments[index];
                    return _buildDocumentCard(participant);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDocumentsHeader(int documentsCount) {
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
              '여권/비자 정보 ($documentsCount/${_participants.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _exportDocumentsReport,
            icon: const Icon(Icons.download),
            label: const Text('보고서 내보내기'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDocuments() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '여권/비자 정보가 없습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '참가자 데이터에 여권 정보를 추가해주세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(ParticipantDataModel participant) {
    final isExpiringSoon = _isPassportExpiringSoon(participant.passportExpiry);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpiringSoon ? Colors.orange : Colors.green,
          child: Icon(
            isExpiringSoon ? Icons.warning : Icons.assignment,
            color: Colors.white,
          ),
        ),
        title: Text(
          participant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('여권: ${participant.passportNumber}'),
            Text('만료: ${participant.passportExpiry}'),
            if (isExpiringSoon)
              Text(
                '만료 임박!',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showDocumentDetails(participant),
      ),
    );
  }

  Widget _buildBottomBar() {
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
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _participants.isEmpty ? null : _saveAndContinue,
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('저장 후 계속'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<String> _getAvailableColumns() {
    if (_excelData == null || _selectedSheetName == null) return [];
    
    final sheet = _excelData!.tables[_selectedSheetName]!;
    if (sheet.rows.isEmpty) return [];
    
    return sheet.rows.first.map((cell) => cell?.value?.toString() ?? '').toList();
  }

  String _getFieldLabel(String field) {
    const fieldLabels = {
      'name': '이름',
      'email': '이메일',
      'phone': '전화번호',
      'department': '부서',
      'position': '직책',
      'birthDate': '생년월일',
      'gender': '성별',
      'passportNumber': '여권번호',
      'passportExpiry': '여권만료일',
      'emergencyContact': '비상연락처',
      'emergencyPhone': '비상연락처 전화',
      'dietaryRestrictions': '식이제한',
      'medicalInfo': '의료정보',
      'roomPreference': '룸 선호',
      'specialRequests': '특별요청',
    };
    
    return fieldLabels[field] ?? field;
  }

  List<ParticipantDataModel> _getFilteredParticipants() {
    if (_searchQuery.isEmpty) return _participants;
    
    final searchLower = _searchQuery.toLowerCase();
    return _participants.where((participant) {
      return participant.name.toLowerCase().contains(searchLower) ||
          participant.email.toLowerCase().contains(searchLower) ||
          participant.department.toLowerCase().contains(searchLower);
    }).toList();
  }

  bool _isPassportExpiringSoon(String expiryDate) {
    if (expiryDate.isEmpty) return false;
    
    try {
      final parts = expiryDate.split('-');
      if (parts.length != 3) return false;
      
      final expiry = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      
      final sixMonthsFromNow = DateTime.now().add(const Duration(days: 180));
      return expiry.isBefore(sixMonthsFromNow);
    } catch (e) {
      return false;
    }
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_all':
        _clearAllData();
        break;
      case 'export':
        _exportData();
        break;
    }
  }

  void _handleParticipantAction(ParticipantDataModel participant, String action) {
    switch (action) {
      case 'edit':
        _editParticipant(participant);
        break;
      case 'duplicate':
        _duplicateParticipant(participant);
        break;
      case 'delete':
        _deleteParticipant(participant);
        break;
    }
  }

  Future<void> _pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final excel = Excel.decodeBytes(bytes);
        
        setState(() {
          _excelData = excel;
          _availableSheets = excel.tables.keys.toList();
          _selectedSheetName = null;
          _columnMapping.clear();
          _previewData.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel 파일이 업로드되었습니다')),
        );
      }
    } catch (e) {
      _showErrorDialog('파일 업로드 중 오류가 발생했습니다: $e');
    }
  }

  void _downloadTemplate() {
    // TODO: Generate and download Excel template
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('템플릿 다운로드 기능 구현 예정')),
    );
  }

  void _selectSheet(String sheetName) {
    setState(() {
      _selectedSheetName = sheetName;
      _columnMapping.clear();
      _previewData.clear();
    });
  }

  void _resetMapping() {
    setState(() {
      _columnMapping.clear();
    });
  }

  void _validateAndPreview() {
    // Validate required fields are mapped
    final missingFields = requiredColumns.where(
      (field) => !_columnMapping.containsKey(field),
    ).toList();
    
    if (missingFields.isNotEmpty) {
      _showErrorDialog(
        '필수 필드를 매핑해주세요: ${missingFields.map(_getFieldLabel).join(', ')}',
      );
      return;
    }
    
    _generatePreview();
  }

  void _generatePreview() {
    if (_excelData == null || _selectedSheetName == null) return;
    
    final sheet = _excelData!.tables[_selectedSheetName]!;
    final rows = sheet.rows.skip(1).take(10).toList(); // Skip header, take first 10 rows
    
    final previewData = <Map<String, String>>[];
    
    for (final row in rows) {
      final data = <String, String>{};
      
      for (final entry in _columnMapping.entries) {
        final field = entry.key;
        final columnIndex = entry.value;
        
        if (columnIndex < row.length) {
          data[field] = row[columnIndex]?.value?.toString() ?? '';
        }
      }
      
      previewData.add(data);
    }
    
    setState(() {
      _previewData = previewData;
    });
  }

  void _processData() {
    setState(() => _isProcessing = true);
    
    try {
      if (_excelData == null || _selectedSheetName == null) return;
      
      final sheet = _excelData!.tables[_selectedSheetName]!;
      final rows = sheet.rows.skip(1).toList(); // Skip header
      
      final participants = <ParticipantDataModel>[];
      
      for (final row in rows) {
        final data = <String, String>{};
        
        for (final entry in _columnMapping.entries) {
          final field = entry.key;
          final columnIndex = entry.value;
          
          if (columnIndex < row.length) {
            data[field] = row[columnIndex]?.value?.toString() ?? '';
          }
        }
        
        // Skip empty rows
        if (data['name']?.isEmpty != false) continue;
        
        final participant = ParticipantDataModel.fromMap(data);
        participants.add(participant);
      }
      
      setState(() {
        _participants = participants;
        _isProcessing = false;
      });
      
      // Switch to participants tab
      _tabController.animateTo(1);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${participants.length}명의 참가자 데이터를 가져왔습니다')),
      );
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog('데이터 처리 중 오류가 발생했습니다: $e');
    }
  }

  void _addParticipant() {
    // TODO: Show add participant dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('참가자 추가 기능 구현 예정')),
    );
  }

  void _validateAllData() {
    for (final participant in _participants) {
      participant.validate();
    }
    
    setState(() {});
    
    final totalErrors = _participants.fold<int>(
      0,
      (sum, p) => sum + p.validationErrors.length,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(totalErrors == 0 
            ? '모든 데이터가 유효합니다'
            : '$totalErrors개의 오류가 발견되었습니다'),
        backgroundColor: totalErrors == 0 ? Colors.green : Colors.orange,
      ),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: const Text('모든 참가자 데이터를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _participants.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
              );
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // TODO: Export participant data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('데이터 내보내기 기능 구현 예정')),
    );
  }

  void _editParticipant(ParticipantDataModel participant) {
    // TODO: Show edit participant dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('참가자 수정 기능 구현 예정')),
    );
  }

  void _duplicateParticipant(ParticipantDataModel participant) {
    final duplicated = participant.copyWith(name: '${participant.name} (복사본)');
    setState(() {
      _participants.add(duplicated);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('참가자가 복제되었습니다')),
    );
  }

  void _deleteParticipant(ParticipantDataModel participant) {
    setState(() {
      _participants.remove(participant);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('참가자가 삭제되었습니다'),
        action: SnackBarAction(
          label: '실행 취소',
          onPressed: () {
            setState(() {
              _participants.add(participant);
            });
          },
        ),
      ),
    );
  }

  void _showDocumentDetails(ParticipantDataModel participant) {
    // TODO: Show document details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('문서 상세 기능 구현 예정')),
    );
  }

  void _exportDocumentsReport() {
    // TODO: Export documents report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('문서 보고서 내보내기 기능 구현 예정')),
    );
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isProcessing = true);
    
    try {
      // TODO: Save participant data to backend
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pop(context, {
          'participants': _participants,
          'customizationData': widget.customizationData,
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('저장 중 오류가 발생했습니다: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
      departmentIds: ['dept_1', 'dept_2'],
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      createdBy: 'admin',
    );
  }

  List<DepartmentModel> _createMockDepartments() {
    return [
      const DepartmentModel(
        id: 'dept_1',
        groupId: 'group_1',
        name: '경영지원팀',
        description: '경영지원 업무 총괄',
        memberIds: [],
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
        memberIds: [],
        settings: {},
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
        createdBy: 'admin',
      ),
    ];
  }
}

// Data model for participant information
class ParticipantDataModel {
  final String name;
  final String email;
  final String phone;
  final String department;
  final String position;
  final String birthDate;
  final String gender;
  final String passportNumber;
  final String passportExpiry;
  final String emergencyContact;
  final String emergencyPhone;
  final String dietaryRestrictions;
  final String medicalInfo;
  final String roomPreference;
  final String specialRequests;
  final List<String> validationErrors;

  ParticipantDataModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    this.position = '',
    this.birthDate = '',
    this.gender = '',
    this.passportNumber = '',
    this.passportExpiry = '',
    this.emergencyContact = '',
    this.emergencyPhone = '',
    this.dietaryRestrictions = '',
    this.medicalInfo = '',
    this.roomPreference = '',
    this.specialRequests = '',
    this.validationErrors = const [],
  });

  factory ParticipantDataModel.fromMap(Map<String, String> data) {
    return ParticipantDataModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      department: data['department'] ?? '',
      position: data['position'] ?? '',
      birthDate: data['birthDate'] ?? '',
      gender: data['gender'] ?? '',
      passportNumber: data['passportNumber'] ?? '',
      passportExpiry: data['passportExpiry'] ?? '',
      emergencyContact: data['emergencyContact'] ?? '',
      emergencyPhone: data['emergencyPhone'] ?? '',
      dietaryRestrictions: data['dietaryRestrictions'] ?? '',
      medicalInfo: data['medicalInfo'] ?? '',
      roomPreference: data['roomPreference'] ?? '',
      specialRequests: data['specialRequests'] ?? '',
    );
  }

  ParticipantDataModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? department,
    String? position,
    String? birthDate,
    String? gender,
    String? passportNumber,
    String? passportExpiry,
    String? emergencyContact,
    String? emergencyPhone,
    String? dietaryRestrictions,
    String? medicalInfo,
    String? roomPreference,
    String? specialRequests,
    List<String>? validationErrors,
  }) {
    return ParticipantDataModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExpiry: passportExpiry ?? this.passportExpiry,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      roomPreference: roomPreference ?? this.roomPreference,
      specialRequests: specialRequests ?? this.specialRequests,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  void validate() {
    final errors = <String>[];
    
    if (name.isEmpty) errors.add('이름 필수');
    if (email.isEmpty) errors.add('이메일 필수');
    if (phone.isEmpty) errors.add('전화번호 필수');
    if (department.isEmpty) errors.add('부서 필수');
    
    if (email.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors.add('잘못된 이메일');
    }
    
    if (phone.isNotEmpty && !RegExp(r'^[0-9-]+$').hasMatch(phone)) {
      errors.add('잘못된 전화번호');
    }
    
    validationErrors.clear();
    validationErrors.addAll(errors);
  }
}