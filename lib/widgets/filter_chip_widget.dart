import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String? value;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool showClearButton;
  final bool compact;
  final IconData? icon;
  final Color? selectedColor;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.value,
    this.isSelected = false,
    this.onTap,
    this.onClear,
    this.showClearButton = true,
    this.compact = false,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = selectedColor ?? AppTheme.primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected 
            ? chipColor.withOpacity(0.1)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: isSelected 
              ? chipColor
              : AppTheme.surfaceColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Padding(
              padding: EdgeInsets.only(
                left: compact ? 8 : 12,
                right: compact ? 4 : 8,
                top: compact ? 4 : 6,
                bottom: compact ? 4 : 6,
              ),
              child: Icon(
                icon!,
                size: compact ? 14 : 16,
                color: isSelected 
                    ? chipColor
                    : AppTheme.textSecondary,
              ),
            ),
          ] else if (!compact) ...[
            const SizedBox(width: 12),
          ],
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 12,
                vertical: compact ? 4 : 6,
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected 
                      ? chipColor
                      : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: compact ? 12 : 14,
                ),
              ),
            ),
          ),
          if (isSelected && showClearButton && onClear != null) ...[
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.close,
                  size: compact ? 14 : 16,
                  color: chipColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FilterChipList extends StatelessWidget {
  final List<FilterOption> filters;
  final Function(String)? onFilterSelected;
  final Function(String)? onFilterCleared;
  final String? selectedFilter;
  final bool compact;
  final ScrollDirection scrollDirection;
  final bool showClearButton;

  const FilterChipList({
    super.key,
    required this.filters,
    this.onFilterSelected,
    this.onFilterCleared,
    this.selectedFilter,
    this.compact = false,
    this.scrollDirection = Axis.horizontal,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChipWidget(
                label: filter.label,
                value: filter.value,
                isSelected: selectedFilter == filter.value,
                onTap: () => onFilterSelected?.call(filter.value ?? filter.label),
                onClear: selectedFilter == filter.value && showClearButton
                    ? () => onFilterCleared?.call(filter.value ?? filter.label)
                    : null,
                compact: compact,
                icon: filter.icon,
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: filters.map((filter) {
          return FilterChipWidget(
            label: filter.label,
            value: filter.value,
            isSelected: selectedFilter == filter.value,
            onTap: () => onFilterSelected?.call(filter.value ?? filter.label),
            onClear: selectedFilter == filter.value && showClearButton
                ? () => onFilterCleared?.call(filter.value ?? filter.label)
                : null,
            compact: compact,
            icon: filter.icon,
          );
        }).toList(),
      );
    }
  }
}

class MultiSelectFilterChipList extends StatefulWidget {
  final List<FilterOption> filters;
  final Function(List<String>)? onFiltersChanged;
  final List<String> initiallySelected;
  final bool compact;
  final ScrollDirection scrollDirection;

  const MultiSelectFilterChipList({
    super.key,
    required this.filters,
    this.onFiltersChanged,
    this.initiallySelected = const [],
    this.compact = false,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  State<MultiSelectFilterChipList> createState() => _MultiSelectFilterChipListState();
}

class _MultiSelectFilterChipListState extends State<MultiSelectFilterChipList> {
  late Set<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = Set.from(widget.initiallySelected);
  }

  void _onFilterTap(String value) {
    setState(() {
      if (_selectedFilters.contains(value)) {
        _selectedFilters.remove(value);
      } else {
        _selectedFilters.add(value);
      }
    });
    widget.onFiltersChanged?.call(_selectedFilters.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollDirection == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.filters.map((filter) {
            final value = filter.value ?? filter.label;
            final isSelected = _selectedFilters.contains(value);
            
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChipWidget(
                label: filter.label,
                value: value,
                isSelected: isSelected,
                onTap: () => _onFilterTap(value),
                compact: widget.compact,
                icon: filter.icon,
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.filters.map((filter) {
          final value = filter.value ?? filter.label;
          final isSelected = _selectedFilters.contains(value);
          
          return FilterChipWidget(
            label: filter.label,
            value: value,
            isSelected: isSelected,
            onTap: () => _onFilterTap(value),
            compact: widget.compact,
            icon: filter.icon,
          );
        }).toList(),
      );
    }
  }
}

class PriceRangeFilter extends StatefulWidget {
  final double? minPrice;
  final double? maxPrice;
  final ValueChanged<(double?, double?)>? onPriceRangeChanged;
  final double minPossible;
  final double maxPossible;

  const PriceRangeFilter({
    super.key,
    this.minPrice,
    this.maxPrice,
    this.onPriceRangeChanged,
    this.minPossible = 0,
    this.maxPossible = 1000,
  });

  @override
  State<PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<PriceRangeFilter> {
  late RangeValues _rangeValues;

  @override
  void initState() {
    super.initState();
    _rangeValues = RangeValues(
      widget.minPrice ?? widget.minPossible,
      widget.maxPrice ?? widget.maxPossible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: _rangeValues,
            min: widget.minPossible,
            max: widget.maxPossible,
            divisions: 20,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.surfaceColor,
            onChanged: (values) {
              setState(() {
                _rangeValues = values;
              });
              widget.onPriceRangeChanged?.call(
                values.start == widget.minPossible ? null : values.start,
                values.end == widget.maxPossible ? null : values.end,
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_rangeValues.start.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '\$${_rangeValues.end.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FilterOption {
  final String label;
  final String? value;
  final IconData? icon;
  final Color? color;

  const FilterOption({
    required this.label,
    this.value,
    this.icon,
    this.color,
  });
}

class FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const FilterSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      initiallyExpanded: initiallyExpanded,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      backgroundColor: AppTheme.surfaceColor,
      collapsedBackgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      children: [child],
    );
  }
}
