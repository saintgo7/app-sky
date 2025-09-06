import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_auth_provider.dart';
import '../../widgets/admin/admin_navigation_layout.dart';
import '../../widgets/admin/permission_guard.dart';
import '../../../data/models/package_model.dart';
import '../../providers/product_management_provider.dart';

class ProductManagementScreen extends ConsumerStatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends ConsumerState<ProductManagementScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminNavigationLayout(
      selectedRoute: '/admin/products',
      child: PermissionGuard(
        permission: AdminPermissions.manageProducts,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('상품 관리'),
            actions: [
              FilledButton.icon(
                onPressed: () => _showProductDialog(context, null),
                icon: const Icon(Icons.add),
                label: const Text('새 상품 등록'),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: ref.watch(productsProvider).when(
                  data: (products) => _buildProductsList(context, products),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text('오류: $error'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => ref.refresh(productsProvider),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '상품명, 카테고리로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                ref.read(productSearchProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('전체')),
                const DropdownMenuItem(value: 'package', child: Text('패키지')),
                const DropdownMenuItem(value: 'flight', child: Text('항공')),
                const DropdownMenuItem(value: 'hotel', child: Text('호텔')),
                const DropdownMenuItem(value: 'activity', child: Text('액티비티')),
              ],
              onChanged: (value) {
                setState(() => _selectedCategory = value);
                ref.read(productCategoryFilterProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: '상태',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('전체')),
                const DropdownMenuItem(value: 'active', child: Text('활성')),
                const DropdownMenuItem(value: 'inactive', child: Text('비활성')),
                const DropdownMenuItem(value: 'soldout', child: Text('품절')),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
                ref.read(productStatusFilterProvider.notifier).state = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<PackageModel> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '등록된 상품이 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _showProductDialog(context, null),
              icon: const Icon(Icons.add),
              label: const Text('첫 상품 등록하기'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.images.isNotEmpty
                  ? Image.network(
                      product.images.first,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.image),
                    ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _buildStatusBadge(context, product.status ?? 'active'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                        locale: 'ko_KR',
                        symbol: '₩',
                      ).format(product.price),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.discountPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        NumberFormat.currency(
                          locale: 'ko_KR',
                          symbol: '₩',
                        ).format(product.discountPrice),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showProductDialog(context, product),
                  tooltip: '수정',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, product),
                  tooltip: '삭제',
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection(
                      context,
                      '상품 정보',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('여행 기간', '${product.duration}일'),
                          if (product.destination != null)
                            _buildDetailRow('목적지', product.destination!),
                          _buildDetailRow('재고', '${product.stock ?? 0}개'),
                          _buildDetailRow(
                            '등록일',
                            DateFormat('yyyy-MM-dd').format(product.createdAt),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      context,
                      '가격 정책',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            '기본 가격',
                            NumberFormat.currency(
                              locale: 'ko_KR',
                              symbol: '₩',
                            ).format(product.price),
                          ),
                          if (product.discountPrice != null)
                            _buildDetailRow(
                              '할인 가격',
                              NumberFormat.currency(
                                locale: 'ko_KR',
                                symbol: '₩',
                              ).format(product.discountPrice),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showPriceDialog(context, product),
                          icon: const Icon(Icons.attach_money),
                          label: const Text('가격 수정'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _showPromotionDialog(context, product),
                          icon: const Icon(Icons.local_offer),
                          label: const Text('프로모션 설정'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () => _toggleProductStatus(context, product),
                          icon: Icon(
                            product.status == 'active'
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            product.status == 'active' ? '비활성화' : '활성화',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'active':
        color = Colors.green;
        label = '활성';
        icon = Icons.check_circle;
        break;
      case 'inactive':
        color = Colors.grey;
        label = '비활성';
        icon = Icons.cancel;
        break;
      case 'soldout':
        color = Colors.red;
        label = '품절';
        icon = Icons.remove_circle;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showProductDialog(BuildContext context, PackageModel? product) async {
    // Implementation for product create/edit dialog
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }

  Future<void> _showPriceDialog(BuildContext context, PackageModel product) async {
    // Implementation for price update dialog
    showDialog(
      context: context,
      builder: (context) => PriceUpdateDialog(product: product),
    );
  }

  Future<void> _showPromotionDialog(BuildContext context, PackageModel product) async {
    // Implementation for promotion dialog
    showDialog(
      context: context,
      builder: (context) => PromotionDialog(product: product),
    );
  }

  Future<void> _toggleProductStatus(BuildContext context, PackageModel product) async {
    final newStatus = product.status == 'active' ? 'inactive' : 'active';
    
    try {
      if (newStatus == 'active') {
        await ref.read(productManagementProvider.notifier).activateProduct(product.id);
      } else {
        await ref.read(productManagementProvider.notifier).deactivateProduct(product.id);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상품이 ${newStatus == 'active' ? '활성화' : '비활성화'}되었습니다'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, PackageModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상품 삭제'),
        content: Text('${product.name}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(productManagementProvider.notifier).deleteProduct(product.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('상품이 삭제되었습니다')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('삭제 실패: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

// Dialog widgets would be implemented separately
class ProductFormDialog extends StatelessWidget {
  final PackageModel? product;
  
  const ProductFormDialog({Key? key, this.product}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implementation for product form dialog
    return AlertDialog(
      title: Text(product == null ? '새 상품 등록' : '상품 수정'),
      content: const Text('상품 폼 구현 예정'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class PriceUpdateDialog extends StatelessWidget {
  final PackageModel product;
  
  const PriceUpdateDialog({Key? key, required this.product}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('가격 수정'),
      content: const Text('가격 수정 폼 구현 예정'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('수정'),
        ),
      ],
    );
  }
}

class PromotionDialog extends StatelessWidget {
  final PackageModel product;
  
  const PromotionDialog({Key? key, required this.product}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('프로모션 설정'),
      content: const Text('프로모션 설정 폼 구현 예정'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('설정'),
        ),
      ],
    );
  }
}