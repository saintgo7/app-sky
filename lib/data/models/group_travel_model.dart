import 'package:json_annotation/json_annotation.dart';

part 'group_travel_model.g.dart';

enum GroupType { corporate, family, friends, school, government, tour }
enum GroupStatus { draft, open, closed, confirmed, cancelled, completed }
enum ParticipantStatus { invited, confirmed, declined, pending, cancelled }

@JsonSerializable()
class GroupTravelModel {
  final String id;
  final String name;
  final String description;
  final GroupType groupType;
  final GroupStatus status;
  
  // Organizer Information
  final String organizerId;
  final String organizerName;
  final String organizerEmail;
  final List<String> adminIds;
  
  // Travel Details
  final String? packageId;
  final String? customItinerary;
  final DateTime? travelStartDate;
  final DateTime? travelEndDate;
  final String? destination;
  
  // Group Management
  final int maxParticipants;
  final int minParticipants;
  final List<GroupParticipant> participants;
  final GroupSettings settings;
  
  // Financial
  final GroupBudget? budget;
  final PaymentSettings paymentSettings;
  final List<GroupExpense> expenses;
  
  // Communication
  final List<GroupMessage> messages;
  final List<GroupAnnouncement> announcements;
  final bool allowParticipantInvites;
  
  // Documents and Files
  final List<SharedDocument> documents;
  final String? itineraryDocument;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? deadlineDate;

  const GroupTravelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.groupType,
    required this.status,
    required this.organizerId,
    required this.organizerName,
    required this.organizerEmail,
    required this.adminIds,
    this.packageId,
    this.customItinerary,
    this.travelStartDate,
    this.travelEndDate,
    this.destination,
    required this.maxParticipants,
    required this.minParticipants,
    required this.participants,
    required this.settings,
    this.budget,
    required this.paymentSettings,
    required this.expenses,
    required this.messages,
    required this.announcements,
    required this.allowParticipantInvites,
    required this.documents,
    this.itineraryDocument,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
    this.deadlineDate,
  });

  factory GroupTravelModel.fromJson(Map<String, dynamic> json) => _$GroupTravelModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupTravelModelToJson(this);
}

@JsonSerializable()
class GroupParticipant {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final ParticipantStatus status;
  final DateTime joinedAt;
  final String? role; // 'admin', 'member', 'guest'
  final bool canInviteOthers;
  final bool canModifyItinerary;
  final List<String> permissions;
  
  // Travel-specific information
  final bool requiresVisa;
  final String? dietaryRestrictions;
  final String? specialRequests;
  final EmergencyContact? emergencyContact;

  const GroupParticipant({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    required this.joinedAt,
    this.role,
    required this.canInviteOthers,
    required this.canModifyItinerary,
    required this.permissions,
    required this.requiresVisa,
    this.dietaryRestrictions,
    this.specialRequests,
    this.emergencyContact,
  });

  factory GroupParticipant.fromJson(Map<String, dynamic> json) => _$GroupParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$GroupParticipantToJson(this);
}

@JsonSerializable()
class GroupSettings {
  final bool isPrivate;
  final bool requiresApproval;
  final bool allowGuestInvitation;
  final bool shareItinerary;
  final bool shareExpenses;
  final bool allowParticipantChat;
  final String? joinCode;
  final DateTime? joinCodeExpiry;

  const GroupSettings({
    required this.isPrivate,
    required this.requiresApproval,
    required this.allowGuestInvitation,
    required this.shareItinerary,
    required this.shareExpenses,
    required this.allowParticipantChat,
    this.joinCode,
    this.joinCodeExpiry,
  });

  factory GroupSettings.fromJson(Map<String, dynamic> json) => _$GroupSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$GroupSettingsToJson(this);
}

@JsonSerializable()
class GroupBudget {
  final double totalBudget;
  final String currency;
  final double perPersonBudget;
  final BudgetBreakdown breakdown;
  final bool flexibleBudget;

  const GroupBudget({
    required this.totalBudget,
    required this.currency,
    required this.perPersonBudget,
    required this.breakdown,
    required this.flexibleBudget,
  });

  factory GroupBudget.fromJson(Map<String, dynamic> json) => _$GroupBudgetFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBudgetToJson(this);
}

@JsonSerializable()
class BudgetBreakdown {
  final double accommodation;
  final double transportation;
  final double meals;
  final double activities;
  final double miscellaneous;

  const BudgetBreakdown({
    required this.accommodation,
    required this.transportation,
    required this.meals,
    required this.activities,
    required this.miscellaneous,
  });

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) => _$BudgetBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetBreakdownToJson(this);
}

@JsonSerializable()
class PaymentSettings {
  final bool splitPayments;
  final String splitMethod; // 'equal', 'percentage', 'amount'
  final Map<String, double>? customSplits; // userId -> amount/percentage
  final bool allowInstallments;
  final DateTime? paymentDeadline;
  final List<String> acceptedPaymentMethods;

  const PaymentSettings({
    required this.splitPayments,
    required this.splitMethod,
    this.customSplits,
    required this.allowInstallments,
    this.paymentDeadline,
    required this.acceptedPaymentMethods,
  });

  factory PaymentSettings.fromJson(Map<String, dynamic> json) => _$PaymentSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentSettingsToJson(this);
}

@JsonSerializable()
class GroupExpense {
  final String id;
  final String description;
  final double amount;
  final String currency;
  final String category;
  final String paidBy;
  final List<String> participantIds;
  final DateTime dateIncurred;
  final String? receipt;
  final bool isApproved;

  const GroupExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.currency,
    required this.category,
    required this.paidBy,
    required this.participantIds,
    required this.dateIncurred,
    this.receipt,
    required this.isApproved,
  });

  factory GroupExpense.fromJson(Map<String, dynamic> json) => _$GroupExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupExpenseToJson(this);
}

@JsonSerializable()
class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final List<String>? attachments;
  final String? replyToId;

  const GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.attachments,
    this.replyToId,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) => _$GroupMessageFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMessageToJson(this);
}

@JsonSerializable()
class GroupAnnouncement {
  final String id;
  final String title;
  final String message;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final bool isPinned;
  final List<String>? attachments;

  const GroupAnnouncement({
    required this.id,
    required this.title,
    required this.message,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.isPinned,
    this.attachments,
  });

  factory GroupAnnouncement.fromJson(Map<String, dynamic> json) => _$GroupAnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$GroupAnnouncementToJson(this);
}

@JsonSerializable()
class SharedDocument {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final String uploadedBy;
  final DateTime uploadedAt;
  final List<String> visibleTo;

  const SharedDocument({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.visibleTo,
  });

  factory SharedDocument.fromJson(Map<String, dynamic> json) => _$SharedDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$SharedDocumentToJson(this);
}

@JsonSerializable()
class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;
  final String? email;

  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
    this.email,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);
  Map<String, dynamic> toJson() => _$EmergencyContactToJson(this);
}