import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TravelSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;
  final Widget? leading;
  final List<Widget>? trailing;

  const TravelSearchBar({
    super.key,
    this.hintText = '여행지, 호텔, 항공편 검색',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
    this.leading,
    this.trailing,
  });

  @override
  State<TravelSearchBar> createState() => _TravelSearchBarState();
}

class _TravelSearchBarState extends State<TravelSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: widget.leading ??
              const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
          suffixIcon: widget.trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.trailing!,
                )
              : _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                      },
                    )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
    );
  }
}

class TravelFilterBar extends StatelessWidget {
  final List<String> filters;
  final String? selectedFilter;
  final ValueChanged<String>? onFilterSelected;
  final VoidCallback? onFilterTap;

  const TravelFilterBar({
    super.key,
    required this.filters,
    this.selectedFilter,
    this.onFilterSelected,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterSelected?.call(filter);
                }
              },
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.primaryLight,
              checkmarkColor: AppColors.textLight,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.textLight : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuickSearchChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String>? onChipSelected;

  const QuickSearchChips({
    super.key,
    required this.suggestions,
    this.onChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((suggestion) {
          return InkWell(
            onTap: () => onChipSelected?.call(suggestion),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: Text(
                suggestion,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
