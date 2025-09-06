// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupTravelModel _$GroupTravelModelFromJson(Map<String, dynamic> json) =>
    GroupTravelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      groupType: $enumDecode(_$GroupTypeEnumMap, json['groupType']),
      status: $enumDecode(_$GroupStatusEnumMap, json['status']),
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      organizerEmail: json['organizerEmail'] as String,
      adminIds:
          (json['adminIds'] as List<dynamic>).map((e) => e as String).toList(),
      packageId: json['packageId'] as String?,
      customItinerary: json['customItinerary'] as String?,
      travelStartDate: json['travelStartDate'] == null
          ? null
          : DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: json['travelEndDate'] == null
          ? null
          : DateTime.parse(json['travelEndDate'] as String),
      destination: json['destination'] as String?,
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      minParticipants: (json['minParticipants'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => GroupParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings:
          GroupSettings.fromJson(json['settings'] as Map<String, dynamic>),
      budget: json['budget'] == null
          ? null
          : GroupBudget.fromJson(json['budget'] as Map<String, dynamic>),
      paymentSettings: PaymentSettings.fromJson(
          json['paymentSettings'] as Map<String, dynamic>),
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => GroupExpense.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => GroupMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      announcements: (json['announcements'] as List<dynamic>)
          .map((e) => GroupAnnouncement.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowParticipantInvites: json['allowParticipantInvites'] as bool,
      documents: (json['documents'] as List<dynamic>)
          .map((e) => SharedDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      itineraryDocument: json['itineraryDocument'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      deadlineDate: json['deadlineDate'] == null
          ? null
          : DateTime.parse(json['deadlineDate'] as String),
    );

Map<String, dynamic> _$GroupTravelModelToJson(GroupTravelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'groupType': _$GroupTypeEnumMap[instance.groupType]!,
      'status': _$GroupStatusEnumMap[instance.status]!,
      'organizerId': instance.organizerId,
      'organizerName': instance.organizerName,
      'organizerEmail': instance.organizerEmail,
      'adminIds': instance.adminIds,
      'packageId': instance.packageId,
      'customItinerary': instance.customItinerary,
      'travelStartDate': instance.travelStartDate?.toIso8601String(),
      'travelEndDate': instance.travelEndDate?.toIso8601String(),
      'destination': instance.destination,
      'maxParticipants': instance.maxParticipants,
      'minParticipants': instance.minParticipants,
      'participants': instance.participants,
      'settings': instance.settings,
      'budget': instance.budget,
      'paymentSettings': instance.paymentSettings,
      'expenses': instance.expenses,
      'messages': instance.messages,
      'announcements': instance.announcements,
      'allowParticipantInvites': instance.allowParticipantInvites,
      'documents': instance.documents,
      'itineraryDocument': instance.itineraryDocument,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'deadlineDate': instance.deadlineDate?.toIso8601String(),
    };

const _$GroupTypeEnumMap = {
  GroupType.corporate: 'corporate',
  GroupType.family: 'family',
  GroupType.friends: 'friends',
  GroupType.school: 'school',
  GroupType.government: 'government',
  GroupType.tour: 'tour',
};

const _$GroupStatusEnumMap = {
  GroupStatus.draft: 'draft',
  GroupStatus.open: 'open',
  GroupStatus.closed: 'closed',
  GroupStatus.confirmed: 'confirmed',
  GroupStatus.cancelled: 'cancelled',
  GroupStatus.completed: 'completed',
};

GroupParticipant _$GroupParticipantFromJson(Map<String, dynamic> json) =>
    GroupParticipant(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      status: $enumDecode(_$ParticipantStatusEnumMap, json['status']),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      role: json['role'] as String?,
      canInviteOthers: json['canInviteOthers'] as bool,
      canModifyItinerary: json['canModifyItinerary'] as bool,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requiresVisa: json['requiresVisa'] as bool,
      dietaryRestrictions: json['dietaryRestrictions'] as String?,
      specialRequests: json['specialRequests'] as String?,
      emergencyContact: json['emergencyContact'] == null
          ? null
          : EmergencyContact.fromJson(
              json['emergencyContact'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupParticipantToJson(GroupParticipant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'status': _$ParticipantStatusEnumMap[instance.status]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'role': instance.role,
      'canInviteOthers': instance.canInviteOthers,
      'canModifyItinerary': instance.canModifyItinerary,
      'permissions': instance.permissions,
      'requiresVisa': instance.requiresVisa,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'specialRequests': instance.specialRequests,
      'emergencyContact': instance.emergencyContact,
    };

const _$ParticipantStatusEnumMap = {
  ParticipantStatus.invited: 'invited',
  ParticipantStatus.confirmed: 'confirmed',
  ParticipantStatus.declined: 'declined',
  ParticipantStatus.pending: 'pending',
  ParticipantStatus.cancelled: 'cancelled',
};

GroupSettings _$GroupSettingsFromJson(Map<String, dynamic> json) =>
    GroupSettings(
      isPrivate: json['isPrivate'] as bool,
      requiresApproval: json['requiresApproval'] as bool,
      allowGuestInvitation: json['allowGuestInvitation'] as bool,
      shareItinerary: json['shareItinerary'] as bool,
      shareExpenses: json['shareExpenses'] as bool,
      allowParticipantChat: json['allowParticipantChat'] as bool,
      joinCode: json['joinCode'] as String?,
      joinCodeExpiry: json['joinCodeExpiry'] == null
          ? null
          : DateTime.parse(json['joinCodeExpiry'] as String),
    );

Map<String, dynamic> _$GroupSettingsToJson(GroupSettings instance) =>
    <String, dynamic>{
      'isPrivate': instance.isPrivate,
      'requiresApproval': instance.requiresApproval,
      'allowGuestInvitation': instance.allowGuestInvitation,
      'shareItinerary': instance.shareItinerary,
      'shareExpenses': instance.shareExpenses,
      'allowParticipantChat': instance.allowParticipantChat,
      'joinCode': instance.joinCode,
      'joinCodeExpiry': instance.joinCodeExpiry?.toIso8601String(),
    };

GroupBudget _$GroupBudgetFromJson(Map<String, dynamic> json) => GroupBudget(
      totalBudget: (json['totalBudget'] as num).toDouble(),
      currency: json['currency'] as String,
      perPersonBudget: (json['perPersonBudget'] as num).toDouble(),
      breakdown:
          BudgetBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
      flexibleBudget: json['flexibleBudget'] as bool,
    );

Map<String, dynamic> _$GroupBudgetToJson(GroupBudget instance) =>
    <String, dynamic>{
      'totalBudget': instance.totalBudget,
      'currency': instance.currency,
      'perPersonBudget': instance.perPersonBudget,
      'breakdown': instance.breakdown,
      'flexibleBudget': instance.flexibleBudget,
    };

BudgetBreakdown _$BudgetBreakdownFromJson(Map<String, dynamic> json) =>
    BudgetBreakdown(
      accommodation: (json['accommodation'] as num).toDouble(),
      transportation: (json['transportation'] as num).toDouble(),
      meals: (json['meals'] as num).toDouble(),
      activities: (json['activities'] as num).toDouble(),
      miscellaneous: (json['miscellaneous'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetBreakdownToJson(BudgetBreakdown instance) =>
    <String, dynamic>{
      'accommodation': instance.accommodation,
      'transportation': instance.transportation,
      'meals': instance.meals,
      'activities': instance.activities,
      'miscellaneous': instance.miscellaneous,
    };

PaymentSettings _$PaymentSettingsFromJson(Map<String, dynamic> json) =>
    PaymentSettings(
      splitPayments: json['splitPayments'] as bool,
      splitMethod: json['splitMethod'] as String,
      customSplits: (json['customSplits'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      allowInstallments: json['allowInstallments'] as bool,
      paymentDeadline: json['paymentDeadline'] == null
          ? null
          : DateTime.parse(json['paymentDeadline'] as String),
      acceptedPaymentMethods: (json['acceptedPaymentMethods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PaymentSettingsToJson(PaymentSettings instance) =>
    <String, dynamic>{
      'splitPayments': instance.splitPayments,
      'splitMethod': instance.splitMethod,
      'customSplits': instance.customSplits,
      'allowInstallments': instance.allowInstallments,
      'paymentDeadline': instance.paymentDeadline?.toIso8601String(),
      'acceptedPaymentMethods': instance.acceptedPaymentMethods,
    };

GroupExpense _$GroupExpenseFromJson(Map<String, dynamic> json) => GroupExpense(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      category: json['category'] as String,
      paidBy: json['paidBy'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dateIncurred: DateTime.parse(json['dateIncurred'] as String),
      receipt: json['receipt'] as String?,
      isApproved: json['isApproved'] as bool,
    );

Map<String, dynamic> _$GroupExpenseToJson(GroupExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'category': instance.category,
      'paidBy': instance.paidBy,
      'participantIds': instance.participantIds,
      'dateIncurred': instance.dateIncurred.toIso8601String(),
      'receipt': instance.receipt,
      'isApproved': instance.isApproved,
    };

GroupMessage _$GroupMessageFromJson(Map<String, dynamic> json) => GroupMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      replyToId: json['replyToId'] as String?,
    );

Map<String, dynamic> _$GroupMessageToJson(GroupMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'attachments': instance.attachments,
      'replyToId': instance.replyToId,
    };

GroupAnnouncement _$GroupAnnouncementFromJson(Map<String, dynamic> json) =>
    GroupAnnouncement(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPinned: json['isPinned'] as bool,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupAnnouncementToJson(GroupAnnouncement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'isPinned': instance.isPinned,
      'attachments': instance.attachments,
    };

SharedDocument _$SharedDocumentFromJson(Map<String, dynamic> json) =>
    SharedDocument(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      visibleTo:
          (json['visibleTo'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SharedDocumentToJson(SharedDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'fileType': instance.fileType,
      'fileSize': instance.fileSize,
      'uploadedBy': instance.uploadedBy,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'visibleTo': instance.visibleTo,
    };

EmergencyContact _$EmergencyContactFromJson(Map<String, dynamic> json) =>
    EmergencyContact(
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$EmergencyContactToJson(EmergencyContact instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relationship': instance.relationship,
      'phone': instance.phone,
      'email': instance.email,
    };
