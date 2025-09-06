import 'package:json_annotation/json_annotation.dart';

part 'admin_dashboard_model.g.dart';

@JsonSerializable()
class AdminDashboardData {
  final BookingStatistics bookingStats;
  final RevenueStatistics revenueStats;
  final CustomerStatistics customerStats;
  final AIRecommendationStats aiStats;
  final List<RecentBooking> recentBookings;
  final List<CustomerInquiry> pendingInquiries;

  AdminDashboardData({
    required this.bookingStats,
    required this.revenueStats,
    required this.customerStats,
    required this.aiStats,
    required this.recentBookings,
    required this.pendingInquiries,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardDataFromJson(json);
  Map<String, dynamic> toJson() => _$AdminDashboardDataToJson(this);
}

@JsonSerializable()
class BookingStatistics {
  final int todayBookings;
  final int weekBookings;
  final int monthBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int cancelledBookings;
  final double bookingGrowthRate;

  BookingStatistics({
    required this.todayBookings,
    required this.weekBookings,
    required this.monthBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.cancelledBookings,
    required this.bookingGrowthRate,
  });

  factory BookingStatistics.fromJson(Map<String, dynamic> json) =>
      _$BookingStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$BookingStatisticsToJson(this);
}

@JsonSerializable()
class RevenueStatistics {
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final double yearRevenue;
  final double revenueGrowthRate;
  final Map<String, double> revenueByCategory;
  final List<DailyRevenue> dailyRevenue;

  RevenueStatistics({
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.yearRevenue,
    required this.revenueGrowthRate,
    required this.revenueByCategory,
    required this.dailyRevenue,
  });

  factory RevenueStatistics.fromJson(Map<String, dynamic> json) =>
      _$RevenueStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$RevenueStatisticsToJson(this);
}

@JsonSerializable()
class CustomerStatistics {
  final int totalCustomers;
  final int newCustomersToday;
  final int newCustomersWeek;
  final int newCustomersMonth;
  final int vipCustomers;
  final double customerGrowthRate;

  CustomerStatistics({
    required this.totalCustomers,
    required this.newCustomersToday,
    required this.newCustomersWeek,
    required this.newCustomersMonth,
    required this.vipCustomers,
    required this.customerGrowthRate,
  });

  factory CustomerStatistics.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerStatisticsToJson(this);
}

@JsonSerializable()
class AIRecommendationStats {
  final int totalRecommendations;
  final int acceptedRecommendations;
  final double conversionRate;
  final double averageOrderValue;
  final Map<String, int> recommendationsByCategory;

  AIRecommendationStats({
    required this.totalRecommendations,
    required this.acceptedRecommendations,
    required this.conversionRate,
    required this.averageOrderValue,
    required this.recommendationsByCategory,
  });

  factory AIRecommendationStats.fromJson(Map<String, dynamic> json) =>
      _$AIRecommendationStatsFromJson(json);
  Map<String, dynamic> toJson() => _$AIRecommendationStatsToJson(this);
}

@JsonSerializable()
class RecentBooking {
  final String id;
  final String customerName;
  final String productName;
  final double amount;
  final String status;
  final DateTime createdAt;

  RecentBooking({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory RecentBooking.fromJson(Map<String, dynamic> json) =>
      _$RecentBookingFromJson(json);
  Map<String, dynamic> toJson() => _$RecentBookingToJson(this);
}

@JsonSerializable()
class CustomerInquiry {
  final String id;
  final String customerName;
  final String subject;
  final String priority;
  final DateTime createdAt;
  final bool isResolved;

  CustomerInquiry({
    required this.id,
    required this.customerName,
    required this.subject,
    required this.priority,
    required this.createdAt,
    required this.isResolved,
  });

  factory CustomerInquiry.fromJson(Map<String, dynamic> json) =>
      _$CustomerInquiryFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerInquiryToJson(this);
}

@JsonSerializable()
class DailyRevenue {
  final DateTime date;
  final double revenue;

  DailyRevenue({
    required this.date,
    required this.revenue,
  });

  factory DailyRevenue.fromJson(Map<String, dynamic> json) =>
      _$DailyRevenueFromJson(json);
  Map<String, dynamic> toJson() => _$DailyRevenueToJson(this);
}