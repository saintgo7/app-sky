import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

enum GroupType { corporate, government, school, university, ngo }
enum GroupRole { admin, manager, coordinator, member, viewer }
enum MemberStatus { pending, active, inactive, suspended }
enum GroupStatus { draft, active, archived, suspended }

@JsonSerializable()
class GroupModel {
  final String id;
  final String name;
  final String description;
  final GroupType type;
  final GroupStatus status;
  final String organizationNumber; // 사업자등록번호/고유번호
  final String address;
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;
  final Map<String, dynamic> settings;
  final List<String> departmentIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.organizationNumber,
    required this.address,
    required this.contactPerson,
    required this.contactPhone,
    required this.contactEmail,
    required this.settings,
    required this.departmentIds,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}

@JsonSerializable()
class GroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final String departmentId;
  final GroupRole role;
  final MemberStatus status;
  final String name;
  final String email;
  final String phone;
  final String position;
  final Map<String, dynamic> permissions;
  final Map<String, dynamic> personalInfo;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;
  final String invitedBy;

  const GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.departmentId,
    required this.role,
    required this.status,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.permissions,
    required this.personalInfo,
    required this.joinedAt,
    this.lastActiveAt,
    required this.invitedBy,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  bool hasPermission(String permission) {
    return permissions[permission] == true;
  }

  bool canManageMembers() {
    return role == GroupRole.admin || role == GroupRole.manager;
  }

  bool canCreateBookings() {
    return role == GroupRole.admin || 
           role == GroupRole.manager || 
           role == GroupRole.coordinator ||
           hasPermission('create_bookings');
  }

  bool canViewFinancials() {
    return role == GroupRole.admin || 
           role == GroupRole.manager ||
           hasPermission('view_financials');
  }
}

@JsonSerializable()
class DepartmentModel {
  final String id;
  final String groupId;
  final String name;
  final String description;
  final String? parentDepartmentId;
  final List<String> memberIds;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const DepartmentModel({
    required this.id,
    required this.groupId,
    required this.name,
    required this.description,
    this.parentDepartmentId,
    required this.memberIds,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}

@JsonSerializable()
class GroupInvitationModel {
  final String id;
  final String groupId;
  final String email;
  final String name;
  final String departmentId;
  final GroupRole role;
  final String invitedBy;
  final DateTime invitedAt;
  final DateTime expiresAt;
  final String? acceptedBy;
  final DateTime? acceptedAt;
  final String? rejectedReason;
  final String status; // pending, accepted, rejected, expired

  const GroupInvitationModel({
    required this.id,
    required this.groupId,
    required this.email,
    required this.name,
    required this.departmentId,
    required this.role,
    required this.invitedBy,
    required this.invitedAt,
    required this.expiresAt,
    this.acceptedBy,
    this.acceptedAt,
    this.rejectedReason,
    required this.status,
  });

  factory GroupInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$GroupInvitationModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInvitationModelToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isPending => status == 'pending' && !isExpired;
}

@JsonSerializable()
class GroupBookingModel {
  final String id;
  final String groupId;
  final String packageId;
  final String packageTitle;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final int totalParticipants;
  final List<GroupParticipantModel> participants;
  final GroupPricingModel pricing;
  final Map<String, dynamic> customizations;
  final Map<String, dynamic> requirements;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupBookingModel({
    required this.id,
    required this.groupId,
    required this.packageId,
    required this.packageTitle,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.totalParticipants,
    required this.participants,
    required this.pricing,
    required this.customizations,
    required this.requirements,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBookingModel.fromJson(Map<String, dynamic> json) =>
      _$GroupBookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBookingModelToJson(this);
}

@JsonSerializable()
class GroupParticipantModel {
  final String id;
  final String bookingId;
  final String memberId;
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic> personalInfo;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> requirements;
  final String roomAssignment;
  final String status;
  final DateTime registeredAt;
  final DateTime? checkedInAt;

  const GroupParticipantModel({
    required this.id,
    required this.bookingId,
    required this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.personalInfo,
    required this.preferences,
    required this.requirements,
    required this.roomAssignment,
    required this.status,
    required this.registeredAt,
    this.checkedInAt,
  });

  factory GroupParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$GroupParticipantModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupParticipantModelToJson(this);
}

@JsonSerializable()
class GroupPricingModel {
  final double basePrice;
  final double groupDiscount;
  final double totalDiscount;
  final double subtotal;
  final double taxes;
  final double totalPrice;
  final String currency;
  final Map<String, double> breakdown;
  final List<GroupDiscountModel> appliedDiscounts;

  const GroupPricingModel({
    required this.basePrice,
    required this.groupDiscount,
    required this.totalDiscount,
    required this.subtotal,
    required this.taxes,
    required this.totalPrice,
    required this.currency,
    required this.breakdown,
    required this.appliedDiscounts,
  });

  factory GroupPricingModel.fromJson(Map<String, dynamic> json) =>
      _$GroupPricingModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupPricingModelToJson(this);
}

@JsonSerializable()
class GroupDiscountModel {
  final String id;
  final String name;
  final String type; // percentage, fixed
  final double value;
  final String description;
  final Map<String, dynamic> conditions;

  const GroupDiscountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.description,
    required this.conditions,
  });

  factory GroupDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$GroupDiscountModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupDiscountModelToJson(this);
}

@JsonSerializable()
class GroupCommunicationModel {
  final String id;
  final String groupId;
  final String? bookingId;
  final String type; // announcement, chat, survey, vote
  final String title;
  final String content;
  final String senderId;
  final List<String> recipientIds;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final List<String> readByIds;
  final List<GroupCommunicationResponseModel> responses;

  const GroupCommunicationModel({
    required this.id,
    required this.groupId,
    this.bookingId,
    required this.type,
    required this.title,
    required this.content,
    required this.senderId,
    required this.recipientIds,
    required this.metadata,
    required this.createdAt,
    this.scheduledAt,
    required this.readByIds,
    required this.responses,
  });

  factory GroupCommunicationModel.fromJson(Map<String, dynamic> json) =>
      _$GroupCommunicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupCommunicationModelToJson(this);
}

@JsonSerializable()
class GroupCommunicationResponseModel {
  final String id;
  final String communicationId;
  final String responderId;
  final String response;
  final Map<String, dynamic> data;
  final DateTime respondedAt;

  const GroupCommunicationResponseModel({
    required this.id,
    required this.communicationId,
    required this.responderId,
    required this.response,
    required this.data,
    required this.respondedAt,
  });

  factory GroupCommunicationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupCommunicationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupCommunicationResponseModelToJson(this);
}

@JsonSerializable()
class GroupExpenseModel {
  final String id;
  final String groupId;
  final String bookingId;
  final String type; // shared, individual, reimbursement
  final String category;
  final String description;
  final double amount;
  final String currency;
  final String paidBy;
  final List<String> sharedWith;
  final Map<String, double> splits;
  final String? receiptUrl;
  final String status;
  final DateTime createdAt;
  final DateTime expenseDate;

  const GroupExpenseModel({
    required this.id,
    required this.groupId,
    required this.bookingId,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.sharedWith,
    required this.splits,
    this.receiptUrl,
    required this.status,
    required this.createdAt,
    required this.expenseDate,
  });

  factory GroupExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupExpenseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupExpenseModelToJson(this);
}

// RBAC Permission System
class GroupPermissions {
  static const String viewGroup = 'view_group';
  static const String editGroup = 'edit_group';
  static const String manageMembers = 'manage_members';
  static const String createBookings = 'create_bookings';
  static const String editBookings = 'edit_bookings';
  static const String viewBookings = 'view_bookings';
  static const String manageFinancials = 'manage_financials';
  static const String viewFinancials = 'view_financials';
  static const String sendCommunications = 'send_communications';
  static const String viewCommunications = 'view_communications';
  static const String manageSettings = 'manage_settings';
  static const String exportData = 'export_data';
  static const String viewReports = 'view_reports';

  static Map<GroupRole, List<String>> get rolePermissions => {
    GroupRole.admin: [
      viewGroup, editGroup, manageMembers, createBookings, editBookings,
      viewBookings, manageFinancials, viewFinancials, sendCommunications,
      viewCommunications, manageSettings, exportData, viewReports,
    ],
    GroupRole.manager: [
      viewGroup, editGroup, manageMembers, createBookings, editBookings,
      viewBookings, viewFinancials, sendCommunications, viewCommunications,
      exportData, viewReports,
    ],
    GroupRole.coordinator: [
      viewGroup, createBookings, editBookings, viewBookings, sendCommunications,
      viewCommunications, viewReports,
    ],
    GroupRole.member: [
      viewGroup, viewBookings, viewCommunications,
    ],
    GroupRole.viewer: [
      viewGroup, viewBookings,
    ],
  };

  static bool hasPermission(GroupRole role, String permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }

  static List<String> getPermissionsForRole(GroupRole role) {
    return rolePermissions[role] ?? [];
  }
}