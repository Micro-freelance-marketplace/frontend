import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SearchBar extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool showClearButton;
  final bool autoFocus;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const SearchBar({
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.enabled = true,
    this.focusNode,
    this.controller,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  void _onSubmitted(String value) {
    widget.onSubmitted?.call(value);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNode.hasFocus 
              ? AppTheme.primaryColor
              : AppTheme.surfaceColor,
          width: _focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autoFocus,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onSubmitted: _onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
          ),
          suffixIcon: widget.showClearButton && _hasText
              ? IconButton(
                  onPressed: _onClear,
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class AdvancedSearchBar extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;
  final bool showClearButton;
  final bool autoFocus;
  final int maxLines;

  const AdvancedSearchBar({
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilterTap,
    this.showFilterButton = true,
    this.showClearButton = true,
    this.autoFocus = false,
    this.maxLines = 1,
  });

  @override
  State<AdvancedSearchBar> createState() => _AdvancedSearchBarState();
}

class _AdvancedSearchBarState extends State<AdvancedSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;
    
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  void _onSubmitted(String value) {
    widget.onSubmitted?.call(value);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNode.hasFocus 
              ? AppTheme.primaryColor
              : AppTheme.surfaceColor,
          width: _focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autoFocus,
        maxLines: widget.maxLines,
        onSubmitted: _onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search gigs, skills, or users...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showClearButton && _hasText)
                IconButton(
                  onPressed: _onClear,
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              if (widget.showFilterButton)
                IconButton(
                  onPressed: widget.onFilterTap,
                  icon: Icon(
                    Icons.tune,
                    color: _focusNode.hasFocus 
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final String query;
  final ValueChanged<String>? onSuggestionSelected;
  final VoidCallback? onClearHistory;
  final bool showHistory;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.query,
    this.onSuggestionSelected,
    this.onClearHistory,
    this.showHistory = true,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty && showHistory) {
      return _buildHistorySuggestions();
    } else if (suggestions.isNotEmpty) {
      return _buildSearchSuggestions();
    } else if (query.isNotEmpty) {
      return _buildNoResults();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildHistorySuggestions() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onClearHistory != null)
                  TextButton(
                    onPressed: onClearHistory,
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.surfaceColor),
          ...suggestions.map((suggestion) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.history,
                size: 20,
                color: AppTheme.textSecondary,
              ),
              title: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => onSuggestionSelected?.call(suggestion),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Suggestions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.surfaceColor),
          ...suggestions.map((suggestion) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.search,
                size: 20,
                color: AppTheme.textSecondary,
              ),
              title: Text(
                _highlightQuery(suggestion),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => onSuggestionSelected?.call(suggestion),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _highlightQuery(String suggestion) {
    if (query.isEmpty) return suggestion;
    
    final lowerQuery = query.toLowerCase();
    final lowerSuggestion = suggestion.toLowerCase();
    final index = lowerSuggestion.indexOf(lowerQuery);
    
    if (index == -1) return suggestion;
    
    return suggestion.substring(0, index) +
           suggestion.substring(index, index + query.length) +
           suggestion.substring(index + query.length);
  }
}
