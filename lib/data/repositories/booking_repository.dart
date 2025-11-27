import '../../domain/entities/booking.dart';
import '../local/hive_service.dart';
import 'base_repository.dart';

// 예약 Repository 구현
class BookingRepository implements BaseRepository<Booking> {
  static const String _cacheKey = 'bookings';

  @override
  Future<Booking?> getById(String id) async {
    try {
      final bookings = await getAll();
      return bookings.cast<Booking?>().firstWhere(
        (booking) => booking?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      print('Get booking by id error: $e');
      return null;
    }
  }

  @override
  Future<List<Booking>> getAll() async {
    try {
      return HiveService.getSetting('all_bookings', defaultValue: <Booking>[]);
    } catch (e) {
      print('Get all bookings error: $e');
      return [];
    }
  }

  @override
  Future<Booking> create(Booking entity) async {
    try {
      await HiveService.addBooking(entity);
      return entity;
    } catch (e) {
      print('Create booking error: $e');
      rethrow;
    }
  }

  @override
  Future<Booking> update(String id, Booking entity) async {
    try {
      await HiveService.updateBooking(id, entity);
      return entity;
    } catch (e) {
      print('Update booking error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await HiveService.deleteBooking(id);
      return true;
    } catch (e) {
      print('Delete booking error: $e');
      return false;
    }
  }

  @override
  Future<List<Booking>> query({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
    int? offset,
  }) async {
    try {
      List<Booking> bookings = await getAll();

      // 필터링 적용
      if (filters != null) {
        bookings = _applyFilters(bookings, filters);
      }

      // 정렬 적용
      if (orderBy != null) {
        bookings = _applySorting(bookings, orderBy, descending);
      }

      // 페이지네이션 적용
      if (offset != null && offset > 0) {
        bookings = bookings.skip(offset).toList();
      }

      if (limit != null && limit > 0) {
        bookings = bookings.take(limit).toList();
      }

      return bookings;
    } catch (e) {
      print('Query bookings error: $e');
      return [];
    }
  }

  @override
  Future<List<Booking>> createMany(List<Booking> entities) async {
    try {
      for (final entity in entities) {
        await create(entity);
      }
      return entities;
    } catch (e) {
      print('Create many bookings error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Booking>> updateMany(List<Booking> entities) async {
    try {
      for (final entity in entities) {
        await update(entity.id, entity);
      }
      return entities;
    } catch (e) {
      print('Update many bookings error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteMany(List<String> ids) async {
    try {
      for (final id in ids) {
        await delete(id);
      }
      return true;
    } catch (e) {
      print('Delete many bookings error: $e');
      return false;
    }
  }

  @override
  Future<bool> exists(String id) async {
    final booking = await getById(id);
    return booking != null;
  }

  @override
  Future<int> count({Map<String, dynamic>? filters}) async {
    final bookings = await query(filters: filters);
    return bookings.length;
  }

  @override
  Future<void> clear() async {
    await HiveService.saveSetting('all_bookings', <Booking>[]);
  }

  // 예약별 쿼리 메서드들
  Future<List<Booking>> getBookingsByStatus(BookingStatus status) async {
    return await query(filters: {'status': status});
  }

  Future<List<Booking>> getUpcomingBookings() async {
    final now = DateTime.now();
    return await query(
      filters: {'checkInDate': {'\$gte': now}},
      orderBy: 'checkInDate',
      descending: false,
    );
  }

  Future<List<Booking>> getOngoingBookings() async {
    final now = DateTime.now();
    return await query(
      filters: {
        'checkInDate': {'\$lte': now},
        'checkOutDate': {'\$gte': now},
      },
    );
  }

  Future<List<Booking>> getCompletedBookings() async {
    final now = DateTime.now();
    return await query(
      filters: {'checkOutDate': {'\$lt': now}},
      orderBy: 'checkOutDate',
      descending: true,
    );
  }

  Future<List<Booking>> getBookingsByType(BookingType type) async {
    return await query(filters: {'type': type});
  }

  Future<List<Booking>> getBookingsByDateRange(DateTime startDate, DateTime endDate) async {
    return await query(
      filters: {
        'checkInDate': {'\$gte': startDate, '\$lte': endDate},
      },
      orderBy: 'checkInDate',
    );
  }

  Future<List<Booking>> getRecentBookings({int limit = 10}) async {
    return await query(
      orderBy: 'createdAt',
      descending: true,
      limit: limit,
    );
  }

  Future<double> getTotalSpent() async {
    try {
      final bookings = await getCompletedBookings();
      return bookings.fold(0.0, (sum, booking) => sum + booking.totalAmount);
    } catch (e) {
      print('Get total spent error: $e');
      return 0.0;
    }
  }

  Future<Map<String, int>> getBookingStats() async {
    try {
      final allBookings = await getAll();
      final upcoming = await getUpcomingBookings();
      final ongoing = await getOngoingBookings();
      final completed = await getCompletedBookings();

      return {
        'total': allBookings.length,
        'upcoming': upcoming.length,
        'ongoing': ongoing.length,
        'completed': completed.length,
      };
    } catch (e) {
      print('Get booking stats error: $e');
      return {
        'total': 0,
        'upcoming': 0,
        'ongoing': 0,
        'completed': 0,
      };
    }
  }

  Future<List<Booking>> getBookingsByUser(String userId) async {
    return await query(filters: {'userId': userId});
  }

  Future<bool> cancelBooking(String bookingId, {String? reason}) async {
    try {
      final booking = await getById(bookingId);
      if (booking == null) return false;

      // 취소 가능 여부 확인 (체크인 전까지만 취소 가능)
      final now = DateTime.now();
      if (booking.checkInDate.isBefore(now)) {
        return false; // 이미 체크인했거나 체크인일이 지남
      }

      final cancelledBooking = booking.copyWith(
        status: BookingStatus.cancelled,
        updatedAt: now,
      );

      await update(bookingId, cancelledBooking);
      return true;
    } catch (e) {
      print('Cancel booking error: $e');
      return false;
    }
  }

  Future<List<Booking>> searchBookings(String query) async {
    final allBookings = await getAll();
    return allBookings.where((booking) {
      final searchText = '${booking.item.name} ${booking.contactPerson.fullName}'.toLowerCase();
      return searchText.contains(query.toLowerCase());
    }).toList();
  }

  // 필터링 헬퍼 메서드
  List<Booking> _applyFilters(List<Booking> bookings, Map<String, dynamic> filters) {
    return bookings.where((booking) {
      for (final entry in filters.entries) {
        final field = entry.key;
        final value = entry.value;

        switch (field) {
          case 'status':
            if (booking.status != value) return false;
            break;
          case 'type':
            if (booking.type != value) return false;
            break;
          case 'userId':
            if (booking.userId != value) return false;
            break;
          case 'checkInDate':
            if (value is Map) {
              for (final condition in value.entries) {
                final op = condition.key;
                final val = condition.value as DateTime;
                switch (op) {
                  case '\$gte':
                    if (booking.checkInDate.isBefore(val)) return false;
                    break;
                  case '\$lte':
                    if (booking.checkInDate.isAfter(val)) return false;
                    break;
                  case '\$lt':
                    if (!booking.checkInDate.isBefore(val)) return false;
                    break;
                  case '\$gt':
                    if (!booking.checkInDate.isAfter(val)) return false;
                    break;
                }
              }
            } else if (booking.checkInDate != value) {
              return false;
            }
            break;
          case 'checkOutDate':
            if (value is Map) {
              for (final condition in value.entries) {
                final op = condition.key;
                final val = condition.value as DateTime;
                switch (op) {
                  case '\$gte':
                    if (booking.checkOutDate.isBefore(val)) return false;
                    break;
                  case '\$lte':
                    if (booking.checkOutDate.isAfter(val)) return false;
                    break;
                  case '\$lt':
                    if (!booking.checkOutDate.isBefore(val)) return false;
                    break;
                  case '\$gt':
                    if (!booking.checkOutDate.isAfter(val)) return false;
                    break;
                }
              }
            }
            break;
        }
      }
      return true;
    }).toList();
  }

  // 정렬 헬퍼 메서드
  List<Booking> _applySorting(List<Booking> bookings, String orderBy, bool descending) {
    bookings.sort((a, b) {
      dynamic aValue, bValue;

      switch (orderBy) {
        case 'createdAt':
          aValue = a.createdAt;
          bValue = b.createdAt;
          break;
        case 'checkInDate':
          aValue = a.checkInDate;
          bValue = b.checkInDate;
          break;
        case 'checkOutDate':
          aValue = a.checkOutDate;
          bValue = b.checkOutDate;
          break;
        case 'totalAmount':
          aValue = a.totalAmount;
          bValue = b.totalAmount;
          break;
        default:
          aValue = a.createdAt;
          bValue = b.createdAt;
      }

      if (descending) {
        return bValue.compareTo(aValue);
      } else {
        return aValue.compareTo(bValue);
      }
    });

    return bookings;
  }
}

// 싱글톤 인스턴스
final bookingRepository = BookingRepository();
