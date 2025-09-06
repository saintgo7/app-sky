// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDashboardData _$AdminDashboardDataFromJson(Map<String, dynamic> json) =>
    AdminDashboardData(
      bookingStats: BookingStatistics.fromJson(
          json['bookingStats'] as Map<String, dynamic>),
      revenueStats: RevenueStatistics.fromJson(
          json['revenueStats'] as Map<String, dynamic>),
      customerStats: CustomerStatistics.fromJson(
          json['customerStats'] as Map<String, dynamic>),
      aiStats: AIRecommendationStats.fromJson(
          json['aiStats'] as Map<String, dynamic>),
      recentBookings: (json['recentBookings'] as List<dynamic>)
          .map((e) => RecentBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingInquiries: (json['pendingInquiries'] as List<dynamic>)
          .map((e) => CustomerInquiry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminDashboardDataToJson(AdminDashboardData instance) =>
    <String, dynamic>{
      'bookingStats': instance.bookingStats,
      'revenueStats': instance.revenueStats,
      'customerStats': instance.customerStats,
      'aiStats': instance.aiStats,
      'recentBookings': instance.recentBookings,
      'pendingInquiries': instance.pendingInquiries,
    };

BookingStatistics _$BookingStatisticsFromJson(Map<String, dynamic> json) =>
    BookingStatistics(
      todayBookings: (json['todayBookings'] as num).toInt(),
      weekBookings: (json['weekBookings'] as num).toInt(),
      monthBookings: (json['monthBookings'] as num).toInt(),
      pendingBookings: (json['pendingBookings'] as num).toInt(),
      confirmedBookings: (json['confirmedBookings'] as num).toInt(),
      cancelledBookings: (json['cancelledBookings'] as num).toInt(),
      bookingGrowthRate: (json['bookingGrowthRate'] as num).toDouble(),
    );

Map<String, dynamic> _$BookingStatisticsToJson(BookingStatistics instance) =>
    <String, dynamic>{
      'todayBookings': instance.todayBookings,
      'weekBookings': instance.weekBookings,
      'monthBookings': instance.monthBookings,
      'pendingBookings': instance.pendingBookings,
      'confirmedBookings': instance.confirmedBookings,
      'cancelledBookings': instance.cancelledBookings,
      'bookingGrowthRate': instance.bookingGrowthRate,
    };

RevenueStatistics _$RevenueStatisticsFromJson(Map<String, dynamic> json) =>
    RevenueStatistics(
      todayRevenue: (json['todayRevenue'] as num).toDouble(),
      weekRevenue: (json['weekRevenue'] as num).toDouble(),
      monthRevenue: (json['monthRevenue'] as num).toDouble(),
      yearRevenue: (json['yearRevenue'] as num).toDouble(),
      revenueGrowthRate: (json['revenueGrowthRate'] as num).toDouble(),
      revenueByCategory:
          (json['revenueByCategory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      dailyRevenue: (json['dailyRevenue'] as List<dynamic>)
          .map((e) => DailyRevenue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RevenueStatisticsToJson(RevenueStatistics instance) =>
    <String, dynamic>{
      'todayRevenue': instance.todayRevenue,
      'weekRevenue': instance.weekRevenue,
      'monthRevenue': instance.monthRevenue,
      'yearRevenue': instance.yearRevenue,
      'revenueGrowthRate': instance.revenueGrowthRate,
      'revenueByCategory': instance.revenueByCategory,
      'dailyRevenue': instance.dailyRevenue,
    };

CustomerStatistics _$CustomerStatisticsFromJson(Map<String, dynamic> json) =>
    CustomerStatistics(
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      newCustomersToday: (json['newCustomersToday'] as num).toInt(),
      newCustomersWeek: (json['newCustomersWeek'] as num).toInt(),
      newCustomersMonth: (json['newCustomersMonth'] as num).toInt(),
      vipCustomers: (json['vipCustomers'] as num).toInt(),
      customerGrowthRate: (json['customerGrowthRate'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerStatisticsToJson(CustomerStatistics instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'newCustomersToday': instance.newCustomersToday,
      'newCustomersWeek': instance.newCustomersWeek,
      'newCustomersMonth': instance.newCustomersMonth,
      'vipCustomers': instance.vipCustomers,
      'customerGrowthRate': instance.customerGrowthRate,
    };

AIRecommendationStats _$AIRecommendationStatsFromJson(
        Map<String, dynamic> json) =>
    AIRecommendationStats(
      totalRecommendations: (json['totalRecommendations'] as num).toInt(),
      acceptedRecommendations: (json['acceptedRecommendations'] as num).toInt(),
      conversionRate: (json['conversionRate'] as num).toDouble(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      recommendationsByCategory:
          Map<String, int>.from(json['recommendationsByCategory'] as Map),
    );

Map<String, dynamic> _$AIRecommendationStatsToJson(
        AIRecommendationStats instance) =>
    <String, dynamic>{
      'totalRecommendations': instance.totalRecommendations,
      'acceptedRecommendations': instance.acceptedRecommendations,
      'conversionRate': instance.conversionRate,
      'averageOrderValue': instance.averageOrderValue,
      'recommendationsByCategory': instance.recommendationsByCategory,
    };

RecentBooking _$RecentBookingFromJson(Map<String, dynamic> json) =>
    RecentBooking(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      productName: json['productName'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecentBookingToJson(RecentBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'productName': instance.productName,
      'amount': instance.amount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };

CustomerInquiry _$CustomerInquiryFromJson(Map<String, dynamic> json) =>
    CustomerInquiry(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      subject: json['subject'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isResolved: json['isResolved'] as bool,
    );

Map<String, dynamic> _$CustomerInquiryToJson(CustomerInquiry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'subject': instance.subject,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'isResolved': instance.isResolved,
    };

DailyRevenue _$DailyRevenueFromJson(Map<String, dynamic> json) => DailyRevenue(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyRevenueToJson(DailyRevenue instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
    };
