import '../../domain/entities/base_entity.dart';

// 기본 Repository 인터페이스
abstract class BaseRepository<T extends BaseEntity> {
  // CRUD operations
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<T> create(T entity);
  Future<T> update(String id, T entity);
  Future<bool> delete(String id);

  // Query operations
  Future<List<T>> query({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
    int? offset,
  });

  // Bulk operations
  Future<List<T>> createMany(List<T> entities);
  Future<List<T>> updateMany(List<T> entities);
  Future<bool> deleteMany(List<String> ids);

  // Utility operations
  Future<bool> exists(String id);
  Future<int> count({Map<String, dynamic>? filters});
  Future<void> clear();
}

// 기본 엔티티 클래스
abstract class BaseEntity {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;

  Map<String, dynamic> toJson();
  BaseEntity copyWith({DateTime? updatedAt});
}

// 검색 결과 클래스
class QueryResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int limit;
  final bool hasNextPage;
  final bool hasPreviousPage;

  QueryResult({
    required this.items,
    required this.totalCount,
    this.page = 1,
    this.limit = 20,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  int get totalPages => (totalCount / limit).ceil();
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

// 정렬 옵션
enum SortOrder {
  ascending,
  descending,
}

class SortOption {
  final String field;
  final SortOrder order;

  const SortOption(this.field, {this.order = SortOrder.ascending});

  SortOption.descending(String field) : this(field, order: SortOrder.descending);
}

// 필터 옵션
class FilterOption {
  final String field;
  final dynamic value;
  final FilterOperator operator;

  const FilterOption(
    this.field,
    this.value, {
    this.operator = FilterOperator.equals,
  });
}

enum FilterOperator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  contains,
  startsWith,
  endsWith,
  inList,
  notInList,
  isNull,
  isNotNull,
}

// 페이지네이션 옵션
class PaginationOption {
  final int page;
  final int limit;
  final SortOption? sortBy;

  const PaginationOption({
    this.page = 1,
    this.limit = 20,
    this.sortBy,
  });

  int get offset => (page - 1) * limit;
}