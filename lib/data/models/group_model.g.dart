// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$GroupTypeEnumMap, json['type']),
      status: $enumDecode(_$GroupStatusEnumMap, json['status']),
      organizationNumber: json['organizationNumber'] as String,
      address: json['address'] as String,
      contactPerson: json['contactPerson'] as String,
      contactPhone: json['contactPhone'] as String,
      contactEmail: json['contactEmail'] as String,
      settings: json['settings'] as Map<String, dynamic>,
      departmentIds: (json['departmentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$GroupTypeEnumMap[instance.type]!,
      'status': _$GroupStatusEnumMap[instance.status]!,
      'organizationNumber': instance.organizationNumber,
      'address': instance.address,
      'contactPerson': instance.contactPerson,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'settings': instance.settings,
      'departmentIds': instance.departmentIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$GroupTypeEnumMap = {
  GroupType.corporate: 'corporate',
  GroupType.government: 'government',
  GroupType.school: 'school',
  GroupType.university: 'university',
  GroupType.ngo: 'ngo',
};

const _$GroupStatusEnumMap = {
  GroupStatus.draft: 'draft',
  GroupStatus.active: 'active',
  GroupStatus.archived: 'archived',
  GroupStatus.suspended: 'suspended',
};

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      departmentId: json['departmentId'] as String,
      role: $enumDecode(_$GroupRoleEnumMap, json['role']),
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      position: json['position'] as String,
      permissions: json['permissions'] as Map<String, dynamic>,
      personalInfo: json['personalInfo'] as Map<String, dynamic>,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      invitedBy: json['invitedBy'] as String,
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'departmentId': instance.departmentId,
      'role': _$GroupRoleEnumMap[instance.role]!,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'position': instance.position,
      'permissions': instance.permissions,
      'personalInfo': instance.personalInfo,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'invitedBy': instance.invitedBy,
    };

const _$GroupRoleEnumMap = {
  GroupRole.admin: 'admin',
  GroupRole.manager: 'manager',
  GroupRole.coordinator: 'coordinator',
  GroupRole.member: 'member',
  GroupRole.viewer: 'viewer',
};

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.active: 'active',
  MemberStatus.inactive: 'inactive',
  MemberStatus.suspended: 'suspended',
};

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      parentDepartmentId: json['parentDepartmentId'] as String?,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      settings: json['settings'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'name': instance.name,
      'description': instance.description,
      'parentDepartmentId': instance.parentDepartmentId,
      'memberIds': instance.memberIds,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

GroupInvitationModel _$GroupInvitationModelFromJson(
        Map<String, dynamic> json) =>
    GroupInvitationModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      departmentId: json['departmentId'] as String,
      role: $enumDecode(_$GroupRoleEnumMap, json['role']),
      invitedBy: json['invitedBy'] as String,
      invitedAt: DateTime.parse(json['invitedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      acceptedBy: json['acceptedBy'] as String?,
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      rejectedReason: json['rejectedReason'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$GroupInvitationModelToJson(
        GroupInvitationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'email': instance.email,
      'name': instance.name,
      'departmentId': instance.departmentId,
      'role': _$GroupRoleEnumMap[instance.role]!,
      'invitedBy': instance.invitedBy,
      'invitedAt': instance.invitedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'acceptedBy': instance.acceptedBy,
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'rejectedReason': instance.rejectedReason,
      'status': instance.status,
    };

GroupBookingModel _$GroupBookingModelFromJson(Map<String, dynamic> json) =>
    GroupBookingModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      packageId: json['packageId'] as String,
      packageTitle: json['packageTitle'] as String,
      travelStartDate: DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: DateTime.parse(json['travelEndDate'] as String),
      totalParticipants: (json['totalParticipants'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => GroupParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pricing:
          GroupPricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
      customizations: json['customizations'] as Map<String, dynamic>,
      requirements: json['requirements'] as Map<String, dynamic>,
      status: json['status'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$GroupBookingModelToJson(GroupBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'packageId': instance.packageId,
      'packageTitle': instance.packageTitle,
      'travelStartDate': instance.travelStartDate.toIso8601String(),
      'travelEndDate': instance.travelEndDate.toIso8601String(),
      'totalParticipants': instance.totalParticipants,
      'participants': instance.participants,
      'pricing': instance.pricing,
      'customizations': instance.customizations,
      'requirements': instance.requirements,
      'status': instance.status,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

GroupParticipantModel _$GroupParticipantModelFromJson(
        Map<String, dynamic> json) =>
    GroupParticipantModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      memberId: json['memberId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      personalInfo: json['personalInfo'] as Map<String, dynamic>,
      preferences: json['preferences'] as Map<String, dynamic>,
      requirements: json['requirements'] as Map<String, dynamic>,
      roomAssignment: json['roomAssignment'] as String,
      status: json['status'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      checkedInAt: json['checkedInAt'] == null
          ? null
          : DateTime.parse(json['checkedInAt'] as String),
    );

Map<String, dynamic> _$GroupParticipantModelToJson(
        GroupParticipantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'memberId': instance.memberId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'personalInfo': instance.personalInfo,
      'preferences': instance.preferences,
      'requirements': instance.requirements,
      'roomAssignment': instance.roomAssignment,
      'status': instance.status,
      'registeredAt': instance.registeredAt.toIso8601String(),
      'checkedInAt': instance.checkedInAt?.toIso8601String(),
    };

GroupPricingModel _$GroupPricingModelFromJson(Map<String, dynamic> json) =>
    GroupPricingModel(
      basePrice: (json['basePrice'] as num).toDouble(),
      groupDiscount: (json['groupDiscount'] as num).toDouble(),
      totalDiscount: (json['totalDiscount'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      breakdown: (json['breakdown'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      appliedDiscounts: (json['appliedDiscounts'] as List<dynamic>)
          .map((e) => GroupDiscountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupPricingModelToJson(GroupPricingModel instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'groupDiscount': instance.groupDiscount,
      'totalDiscount': instance.totalDiscount,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'breakdown': instance.breakdown,
      'appliedDiscounts': instance.appliedDiscounts,
    };

GroupDiscountModel _$GroupDiscountModelFromJson(Map<String, dynamic> json) =>
    GroupDiscountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      description: json['description'] as String,
      conditions: json['conditions'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$GroupDiscountModelToJson(GroupDiscountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'description': instance.description,
      'conditions': instance.conditions,
    };

GroupCommunicationModel _$GroupCommunicationModelFromJson(
        Map<String, dynamic> json) =>
    GroupCommunicationModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      bookingId: json['bookingId'] as String?,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      recipientIds: (json['recipientIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      readByIds:
          (json['readByIds'] as List<dynamic>).map((e) => e as String).toList(),
      responses: (json['responses'] as List<dynamic>)
          .map((e) => GroupCommunicationResponseModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupCommunicationModelToJson(
        GroupCommunicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'bookingId': instance.bookingId,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'senderId': instance.senderId,
      'recipientIds': instance.recipientIds,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'readByIds': instance.readByIds,
      'responses': instance.responses,
    };

GroupCommunicationResponseModel _$GroupCommunicationResponseModelFromJson(
        Map<String, dynamic> json) =>
    GroupCommunicationResponseModel(
      id: json['id'] as String,
      communicationId: json['communicationId'] as String,
      responderId: json['responderId'] as String,
      response: json['response'] as String,
      data: json['data'] as Map<String, dynamic>,
      respondedAt: DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$GroupCommunicationResponseModelToJson(
        GroupCommunicationResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'communicationId': instance.communicationId,
      'responderId': instance.responderId,
      'response': instance.response,
      'data': instance.data,
      'respondedAt': instance.respondedAt.toIso8601String(),
    };

GroupExpenseModel _$GroupExpenseModelFromJson(Map<String, dynamic> json) =>
    GroupExpenseModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      bookingId: json['bookingId'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paidBy: json['paidBy'] as String,
      sharedWith: (json['sharedWith'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      splits: (json['splits'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      receiptUrl: json['receiptUrl'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expenseDate: DateTime.parse(json['expenseDate'] as String),
    );

Map<String, dynamic> _$GroupExpenseModelToJson(GroupExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'bookingId': instance.bookingId,
      'type': instance.type,
      'category': instance.category,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'paidBy': instance.paidBy,
      'sharedWith': instance.sharedWith,
      'splits': instance.splits,
      'receiptUrl': instance.receiptUrl,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'expenseDate': instance.expenseDate.toIso8601String(),
    };
