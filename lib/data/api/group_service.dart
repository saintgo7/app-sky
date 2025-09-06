import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/group_travel_model.dart';

part 'group_service.g.dart';

@RestApi()
abstract class GroupService {
  factory GroupService(Dio dio, {String? baseUrl}) = _GroupService;

  // Group Travel Management
  @POST('/groups')
  Future<GroupTravelModel> createGroup(@Header('Authorization') String token, @Body() CreateGroupRequest request);

  @GET('/groups/{id}')
  Future<GroupTravelModel> getGroup(@Header('Authorization') String token, @Path('id') String id);

  @PUT('/groups/{id}')
  Future<GroupTravelModel> updateGroup(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateGroupRequest request,
  );

  @DELETE('/groups/{id}')
  Future<void> deleteGroup(@Header('Authorization') String token, @Path('id') String id);

  @GET('/groups')
  Future<GroupListResponse> getGroups(@Header('Authorization') String token, @Queries() GroupQuery query);

  // Participant Management
  @POST('/groups/{id}/participants/invite')
  Future<InvitationResponse> inviteParticipants(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() InviteParticipantsRequest request,
  );

  @POST('/groups/{id}/participants/join')
  Future<GroupParticipant> joinGroup(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() JoinGroupRequest request,
  );

  @PUT('/groups/{id}/participants/{participantId}')
  Future<GroupParticipant> updateParticipant(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('participantId') String participantId,
    @Body() UpdateParticipantRequest request,
  );

  @DELETE('/groups/{id}/participants/{participantId}')
  Future<void> removeParticipant(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('participantId') String participantId,
  );

  @POST('/groups/{id}/participants/{participantId}/approve')
  Future<GroupParticipant> approveParticipant(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('participantId') String participantId,
  );

  @POST('/groups/{id}/participants/{participantId}/decline')
  Future<void> declineParticipant(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('participantId') String participantId,
    @Body() DeclineParticipantRequest request,
  );

  // Group Booking
  @POST('/groups/{id}/bookings')
  Future<GroupBookingResponse> createGroupBooking(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() CreateGroupBookingRequest request,
  );

  @GET('/groups/{id}/bookings')
  Future<List<GroupBooking>> getGroupBookings(@Header('Authorization') String token, @Path('id') String groupId);

  @PUT('/groups/{id}/bookings/{bookingId}')
  Future<GroupBooking> updateGroupBooking(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('bookingId') String bookingId,
    @Body() UpdateGroupBookingRequest request,
  );

  // Quote and Proposal Management
  @POST('/groups/{id}/quotes/request')
  Future<QuoteRequest> requestQuote(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() QuoteRequestData request,
  );

  @GET('/groups/{id}/quotes')
  Future<List<QuoteProposal>> getQuotes(@Header('Authorization') String token, @Path('id') String groupId);

  @PUT('/groups/{id}/quotes/{quoteId}/accept')
  Future<QuoteProposal> acceptQuote(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('quoteId') String quoteId,
  );

  @PUT('/groups/{id}/quotes/{quoteId}/decline')
  Future<void> declineQuote(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('quoteId') String quoteId,
    @Body() DeclineQuoteRequest request,
  );

  // Itinerary Sharing
  @POST('/groups/{id}/itinerary')
  Future<GroupItinerary> createItinerary(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() CreateItineraryRequest request,
  );

  @GET('/groups/{id}/itinerary')
  Future<GroupItinerary> getItinerary(@Header('Authorization') String token, @Path('id') String groupId);

  @PUT('/groups/{id}/itinerary')
  Future<GroupItinerary> updateItinerary(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() UpdateItineraryRequest request,
  );

  @POST('/groups/{id}/itinerary/vote')
  Future<ItineraryVote> voteOnItinerary(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() ItineraryVoteRequest request,
  );

  @GET('/groups/{id}/itinerary/votes')
  Future<List<ItineraryVote>> getItineraryVotes(@Header('Authorization') String token, @Path('id') String groupId);

  // Communication
  @POST('/groups/{id}/messages')
  Future<GroupMessage> sendMessage(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() SendMessageRequest request,
  );

  @GET('/groups/{id}/messages')
  Future<MessageListResponse> getMessages(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Queries() MessageQuery query,
  );

  @DELETE('/groups/{id}/messages/{messageId}')
  Future<void> deleteMessage(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('messageId') String messageId,
  );

  @POST('/groups/{id}/announcements')
  Future<GroupAnnouncement> createAnnouncement(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() CreateAnnouncementRequest request,
  );

  @GET('/groups/{id}/announcements')
  Future<List<GroupAnnouncement>> getAnnouncements(@Header('Authorization') String token, @Path('id') String groupId);

  // Expense Management
  @POST('/groups/{id}/expenses')
  Future<GroupExpense> addExpense(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() AddExpenseRequest request,
  );

  @GET('/groups/{id}/expenses')
  Future<ExpenseListResponse> getExpenses(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Queries() ExpenseQuery query,
  );

  @PUT('/groups/{id}/expenses/{expenseId}')
  Future<GroupExpense> updateExpense(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('expenseId') String expenseId,
    @Body() UpdateExpenseRequest request,
  );

  @DELETE('/groups/{id}/expenses/{expenseId}')
  Future<void> deleteExpense(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('expenseId') String expenseId,
  );

  @POST('/groups/{id}/expenses/{expenseId}/approve')
  Future<GroupExpense> approveExpense(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('expenseId') String expenseId,
  );

  @GET('/groups/{id}/expenses/summary')
  Future<ExpenseSummary> getExpenseSummary(@Header('Authorization') String token, @Path('id') String groupId);

  // Document Management
  @POST('/groups/{id}/documents')
  Future<SharedDocument> uploadDocument(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() UploadDocumentRequest request,
  );

  @GET('/groups/{id}/documents')
  Future<List<SharedDocument>> getDocuments(@Header('Authorization') String token, @Path('id') String groupId);

  @DELETE('/groups/{id}/documents/{documentId}')
  Future<void> deleteDocument(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Path('documentId') String documentId,
  );

  // Group Settings and Administration
  @PUT('/groups/{id}/settings')
  Future<GroupSettings> updateGroupSettings(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() UpdateGroupSettingsRequest request,
  );

  @POST('/groups/{id}/admin/promote')
  Future<GroupParticipant> promoteToAdmin(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() PromoteAdminRequest request,
  );

  @POST('/groups/{id}/admin/demote')
  Future<GroupParticipant> demoteFromAdmin(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() DemoteAdminRequest request,
  );

  @POST('/groups/{id}/transfer-ownership')
  Future<GroupTravelModel> transferOwnership(
    @Header('Authorization') String token,
    @Path('id') String groupId,
    @Body() TransferOwnershipRequest request,
  );

  // Search and Discovery
  @GET('/groups/search')
  Future<GroupSearchResponse> searchGroups(@Queries() GroupSearchQuery query);

  @GET('/groups/public')
  Future<List<GroupTravelModel>> getPublicGroups(@Queries() PublicGroupQuery query);

  @POST('/groups/join-by-code')
  Future<GroupParticipant> joinByCode(@Header('Authorization') String token, @Body() JoinByCodeRequest request);
}

// Request Models
@JsonSerializable()
class CreateGroupRequest {
  final String name;
  final String description;
  final GroupType groupType;
  final String? destination;
  final DateTime? travelStartDate;
  final DateTime? travelEndDate;
  final int maxParticipants;
  final int minParticipants;
  final GroupSettings settings;
  final GroupBudget? budget;
  final PaymentSettings paymentSettings;

  const CreateGroupRequest({
    required this.name,
    required this.description,
    required this.groupType,
    this.destination,
    this.travelStartDate,
    this.travelEndDate,
    required this.maxParticipants,
    required this.minParticipants,
    required this.settings,
    this.budget,
    required this.paymentSettings,
  });

  factory CreateGroupRequest.fromJson(Map<String, dynamic> json) => _$CreateGroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGroupRequestToJson(this);
}

@JsonSerializable()
class UpdateGroupRequest {
  final String? name;
  final String? description;
  final String? destination;
  final DateTime? travelStartDate;
  final DateTime? travelEndDate;
  final int? maxParticipants;
  final int? minParticipants;
  final GroupBudget? budget;
  final DateTime? deadlineDate;

  const UpdateGroupRequest({
    this.name,
    this.description,
    this.destination,
    this.travelStartDate,
    this.travelEndDate,
    this.maxParticipants,
    this.minParticipants,
    this.budget,
    this.deadlineDate,
  });

  factory UpdateGroupRequest.fromJson(Map<String, dynamic> json) => _$UpdateGroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateGroupRequestToJson(this);
}

@JsonSerializable()
class GroupQuery {
  final GroupType? type;
  final GroupStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? destination;
  final int? page;
  final int? limit;
  final String? sortBy;
  final String? sortOrder;

  const GroupQuery({
    this.type,
    this.status,
    this.startDate,
    this.endDate,
    this.destination,
    this.page,
    this.limit,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() => _$GroupQueryToJson(this);
}

@JsonSerializable()
class InviteParticipantsRequest {
  final List<ParticipantInvite> invitations;
  final String? personalMessage;

  const InviteParticipantsRequest({
    required this.invitations,
    this.personalMessage,
  });

  factory InviteParticipantsRequest.fromJson(Map<String, dynamic> json) => _$InviteParticipantsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InviteParticipantsRequestToJson(this);
}

@JsonSerializable()
class ParticipantInvite {
  final String? email;
  final String? phone;
  final String name;
  final String? role;

  const ParticipantInvite({
    this.email,
    this.phone,
    required this.name,
    this.role,
  });

  factory ParticipantInvite.fromJson(Map<String, dynamic> json) => _$ParticipantInviteFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantInviteToJson(this);
}

@JsonSerializable()
class JoinGroupRequest {
  final String? inviteCode;
  final String? message;

  const JoinGroupRequest({
    this.inviteCode,
    this.message,
  });

  factory JoinGroupRequest.fromJson(Map<String, dynamic> json) => _$JoinGroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinGroupRequestToJson(this);
}

@JsonSerializable()
class UpdateParticipantRequest {
  final String? role;
  final bool? canInviteOthers;
  final bool? canModifyItinerary;
  final List<String>? permissions;

  const UpdateParticipantRequest({
    this.role,
    this.canInviteOthers,
    this.canModifyItinerary,
    this.permissions,
  });

  factory UpdateParticipantRequest.fromJson(Map<String, dynamic> json) => _$UpdateParticipantRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateParticipantRequestToJson(this);
}

@JsonSerializable()
class DeclineParticipantRequest {
  final String reason;

  const DeclineParticipantRequest({required this.reason});

  factory DeclineParticipantRequest.fromJson(Map<String, dynamic> json) => _$DeclineParticipantRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeclineParticipantRequestToJson(this);
}

// Response Models
@JsonSerializable()
class GroupListResponse {
  final List<GroupTravelModel> groups;
  final int totalCount;
  final int page;
  final int totalPages;

  const GroupListResponse({
    required this.groups,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });

  factory GroupListResponse.fromJson(Map<String, dynamic> json) => _$GroupListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupListResponseToJson(this);
}

@JsonSerializable()
class InvitationResponse {
  final List<InvitationResult> results;
  final int successCount;
  final int failureCount;

  const InvitationResponse({
    required this.results,
    required this.successCount,
    required this.failureCount,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) => _$InvitationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationResponseToJson(this);
}

@JsonSerializable()
class InvitationResult {
  final String email;
  final bool success;
  final String? error;
  final String? inviteId;

  const InvitationResult({
    required this.email,
    required this.success,
    this.error,
    this.inviteId,
  });

  factory InvitationResult.fromJson(Map<String, dynamic> json) => _$InvitationResultFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationResultToJson(this);
}

// Additional models for remaining functionality...

@JsonSerializable()
class CreateGroupBookingRequest {
  final String packageId;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final List<String> participantIds;
  final Map<String, dynamic>? groupSettings;

  const CreateGroupBookingRequest({
    required this.packageId,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.participantIds,
    this.groupSettings,
  });

  factory CreateGroupBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateGroupBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGroupBookingRequestToJson(this);
}

@JsonSerializable()
class GroupBookingResponse {
  final String bookingId;
  final String groupId;
  final List<String> individualBookingIds;
  final double totalAmount;
  final String currency;

  const GroupBookingResponse({
    required this.bookingId,
    required this.groupId,
    required this.individualBookingIds,
    required this.totalAmount,
    required this.currency,
  });

  factory GroupBookingResponse.fromJson(Map<String, dynamic> json) => _$GroupBookingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBookingResponseToJson(this);
}

@JsonSerializable()
class GroupBooking {
  final String id;
  final String groupId;
  final String packageId;
  final String status;
  final double totalAmount;
  final String currency;
  final DateTime createdAt;
  final List<String> participantBookingIds;

  const GroupBooking({
    required this.id,
    required this.groupId,
    required this.packageId,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
    required this.participantBookingIds,
  });

  factory GroupBooking.fromJson(Map<String, dynamic> json) => _$GroupBookingFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBookingToJson(this);
}

@JsonSerializable()
class UpdateGroupBookingRequest {
  final DateTime? travelStartDate;
  final DateTime? travelEndDate;
  final List<String>? participantIds;

  const UpdateGroupBookingRequest({
    this.travelStartDate,
    this.travelEndDate,
    this.participantIds,
  });

  factory UpdateGroupBookingRequest.fromJson(Map<String, dynamic> json) => _$UpdateGroupBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateGroupBookingRequestToJson(this);
}

@JsonSerializable()
class QuoteRequestData {
  final String packageId;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final int numberOfTravelers;
  final List<String>? specialRequests;
  final String? notes;

  const QuoteRequestData({
    required this.packageId,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.numberOfTravelers,
    this.specialRequests,
    this.notes,
  });

  factory QuoteRequestData.fromJson(Map<String, dynamic> json) => _$QuoteRequestDataFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteRequestDataToJson(this);
}

@JsonSerializable()
class QuoteRequest {
  final String id;
  final String groupId;
  final String status;
  final QuoteRequestData data;
  final DateTime requestedAt;
  final DateTime? respondedAt;

  const QuoteRequest({
    required this.id,
    required this.groupId,
    required this.status,
    required this.data,
    required this.requestedAt,
    this.respondedAt,
  });

  factory QuoteRequest.fromJson(Map<String, dynamic> json) => _$QuoteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteRequestToJson(this);
}

@JsonSerializable()
class QuoteProposal {
  final String id;
  final String quoteRequestId;
  final double totalPrice;
  final String currency;
  final List<QuoteLineItem> lineItems;
  final String terms;
  final DateTime validUntil;
  final String status;
  final DateTime createdAt;

  const QuoteProposal({
    required this.id,
    required this.quoteRequestId,
    required this.totalPrice,
    required this.currency,
    required this.lineItems,
    required this.terms,
    required this.validUntil,
    required this.status,
    required this.createdAt,
  });

  factory QuoteProposal.fromJson(Map<String, dynamic> json) => _$QuoteProposalFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteProposalToJson(this);
}

@JsonSerializable()
class QuoteLineItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String category;

  const QuoteLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.category,
  });

  factory QuoteLineItem.fromJson(Map<String, dynamic> json) => _$QuoteLineItemFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteLineItemToJson(this);
}

@JsonSerializable()
class DeclineQuoteRequest {
  final String reason;
  final String? counterProposal;

  const DeclineQuoteRequest({
    required this.reason,
    this.counterProposal,
  });

  factory DeclineQuoteRequest.fromJson(Map<String, dynamic> json) => _$DeclineQuoteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeclineQuoteRequestToJson(this);
}

@JsonSerializable()
class CreateItineraryRequest {
  final String title;
  final String description;
  final List<ItineraryDay> days;

  const CreateItineraryRequest({
    required this.title,
    required this.description,
    required this.days,
  });

  factory CreateItineraryRequest.fromJson(Map<String, dynamic> json) => _$CreateItineraryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateItineraryRequestToJson(this);
}

@JsonSerializable()
class UpdateItineraryRequest {
  final String? title;
  final String? description;
  final List<ItineraryDay>? days;

  const UpdateItineraryRequest({
    this.title,
    this.description,
    this.days,
  });

  factory UpdateItineraryRequest.fromJson(Map<String, dynamic> json) => _$UpdateItineraryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateItineraryRequestToJson(this);
}

@JsonSerializable()
class GroupItinerary {
  final String id;
  final String groupId;
  final String title;
  final String description;
  final List<ItineraryDay> days;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int votesFor;
  final int votesAgainst;
  final bool isApproved;

  const GroupItinerary({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.days,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.votesFor,
    required this.votesAgainst,
    required this.isApproved,
  });

  factory GroupItinerary.fromJson(Map<String, dynamic> json) => _$GroupItineraryFromJson(json);
  Map<String, dynamic> toJson() => _$GroupItineraryToJson(this);
}

@JsonSerializable()
class ItineraryVoteRequest {
  final bool vote; // true for approve, false for reject
  final String? comment;

  const ItineraryVoteRequest({
    required this.vote,
    this.comment,
  });

  factory ItineraryVoteRequest.fromJson(Map<String, dynamic> json) => _$ItineraryVoteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryVoteRequestToJson(this);
}

@JsonSerializable()
class ItineraryVote {
  final String id;
  final String itineraryId;
  final String participantId;
  final String participantName;
  final bool vote;
  final String? comment;
  final DateTime votedAt;

  const ItineraryVote({
    required this.id,
    required this.itineraryId,
    required this.participantId,
    required this.participantName,
    required this.vote,
    this.comment,
    required this.votedAt,
  });

  factory ItineraryVote.fromJson(Map<String, dynamic> json) => _$ItineraryVoteFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryVoteToJson(this);
}

@JsonSerializable()
class SendMessageRequest {
  final String message;
  final String? messageType;
  final List<String>? attachments;
  final String? replyToId;

  const SendMessageRequest({
    required this.message,
    this.messageType,
    this.attachments,
    this.replyToId,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) => _$SendMessageRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}

@JsonSerializable()
class MessageQuery {
  final int? limit;
  final DateTime? before;
  final DateTime? after;
  final String? type;

  const MessageQuery({
    this.limit,
    this.before,
    this.after,
    this.type,
  });

  Map<String, dynamic> toJson() => _$MessageQueryToJson(this);
}

@JsonSerializable()
class MessageListResponse {
  final List<GroupMessage> messages;
  final int totalCount;
  final bool hasMore;

  const MessageListResponse({
    required this.messages,
    required this.totalCount,
    required this.hasMore,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) => _$MessageListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MessageListResponseToJson(this);
}

@JsonSerializable()
class CreateAnnouncementRequest {
  final String title;
  final String message;
  final bool isPinned;
  final List<String>? attachments;

  const CreateAnnouncementRequest({
    required this.title,
    required this.message,
    this.isPinned = false,
    this.attachments,
  });

  factory CreateAnnouncementRequest.fromJson(Map<String, dynamic> json) => _$CreateAnnouncementRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateAnnouncementRequestToJson(this);
}

@JsonSerializable()
class AddExpenseRequest {
  final String description;
  final double amount;
  final String currency;
  final String category;
  final List<String> participantIds;
  final DateTime dateIncurred;
  final String? receipt;

  const AddExpenseRequest({
    required this.description,
    required this.amount,
    required this.currency,
    required this.category,
    required this.participantIds,
    required this.dateIncurred,
    this.receipt,
  });

  factory AddExpenseRequest.fromJson(Map<String, dynamic> json) => _$AddExpenseRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddExpenseRequestToJson(this);
}

@JsonSerializable()
class UpdateExpenseRequest {
  final String? description;
  final double? amount;
  final String? category;
  final List<String>? participantIds;
  final DateTime? dateIncurred;
  final String? receipt;

  const UpdateExpenseRequest({
    this.description,
    this.amount,
    this.category,
    this.participantIds,
    this.dateIncurred,
    this.receipt,
  });

  factory UpdateExpenseRequest.fromJson(Map<String, dynamic> json) => _$UpdateExpenseRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateExpenseRequestToJson(this);
}

@JsonSerializable()
class ExpenseQuery {
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? paidBy;
  final bool? isApproved;
  final int? page;
  final int? limit;

  const ExpenseQuery({
    this.category,
    this.startDate,
    this.endDate,
    this.paidBy,
    this.isApproved,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$ExpenseQueryToJson(this);
}

@JsonSerializable()
class ExpenseListResponse {
  final List<GroupExpense> expenses;
  final int totalCount;
  final int page;
  final int totalPages;
  final ExpenseSummary summary;

  const ExpenseListResponse({
    required this.expenses,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.summary,
  });

  factory ExpenseListResponse.fromJson(Map<String, dynamic> json) => _$ExpenseListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseListResponseToJson(this);
}

@JsonSerializable()
class ExpenseSummary {
  final double totalExpenses;
  final String currency;
  final Map<String, double> expensesByCategory;
  final Map<String, double> expensesByParticipant;
  final double averageExpensePerPerson;

  const ExpenseSummary({
    required this.totalExpenses,
    required this.currency,
    required this.expensesByCategory,
    required this.expensesByParticipant,
    required this.averageExpensePerPerson,
  });

  factory ExpenseSummary.fromJson(Map<String, dynamic> json) => _$ExpenseSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseSummaryToJson(this);
}

@JsonSerializable()
class UploadDocumentRequest {
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final List<String> visibleTo;

  const UploadDocumentRequest({
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.visibleTo,
  });

  factory UploadDocumentRequest.fromJson(Map<String, dynamic> json) => _$UploadDocumentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UploadDocumentRequestToJson(this);
}

@JsonSerializable()
class UpdateGroupSettingsRequest {
  final bool? isPrivate;
  final bool? requiresApproval;
  final bool? allowGuestInvitation;
  final bool? shareItinerary;
  final bool? shareExpenses;
  final bool? allowParticipantChat;

  const UpdateGroupSettingsRequest({
    this.isPrivate,
    this.requiresApproval,
    this.allowGuestInvitation,
    this.shareItinerary,
    this.shareExpenses,
    this.allowParticipantChat,
  });

  factory UpdateGroupSettingsRequest.fromJson(Map<String, dynamic> json) => _$UpdateGroupSettingsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateGroupSettingsRequestToJson(this);
}

@JsonSerializable()
class PromoteAdminRequest {
  final String participantId;

  const PromoteAdminRequest({required this.participantId});

  factory PromoteAdminRequest.fromJson(Map<String, dynamic> json) => _$PromoteAdminRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PromoteAdminRequestToJson(this);
}

@JsonSerializable()
class DemoteAdminRequest {
  final String participantId;

  const DemoteAdminRequest({required this.participantId});

  factory DemoteAdminRequest.fromJson(Map<String, dynamic> json) => _$DemoteAdminRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DemoteAdminRequestToJson(this);
}

@JsonSerializable()
class TransferOwnershipRequest {
  final String newOwnerId;
  final String? reason;

  const TransferOwnershipRequest({
    required this.newOwnerId,
    this.reason,
  });

  factory TransferOwnershipRequest.fromJson(Map<String, dynamic> json) => _$TransferOwnershipRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TransferOwnershipRequestToJson(this);
}

@JsonSerializable()
class GroupSearchQuery {
  final String? query;
  final GroupType? type;
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? page;
  final int? limit;

  const GroupSearchQuery({
    this.query,
    this.type,
    this.destination,
    this.startDate,
    this.endDate,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$GroupSearchQueryToJson(this);
}

@JsonSerializable()
class GroupSearchResponse {
  final List<GroupTravelModel> groups;
  final int totalCount;
  final int page;
  final int totalPages;

  const GroupSearchResponse({
    required this.groups,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });

  factory GroupSearchResponse.fromJson(Map<String, dynamic> json) => _$GroupSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupSearchResponseToJson(this);
}

@JsonSerializable()
class PublicGroupQuery {
  final String? destination;
  final GroupType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  const PublicGroupQuery({
    this.destination,
    this.type,
    this.startDate,
    this.endDate,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$PublicGroupQueryToJson(this);
}

@JsonSerializable()
class JoinByCodeRequest {
  final String joinCode;
  final String? message;

  const JoinByCodeRequest({
    required this.joinCode,
    this.message,
  });

  factory JoinByCodeRequest.fromJson(Map<String, dynamic> json) => _$JoinByCodeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinByCodeRequestToJson(this);
}