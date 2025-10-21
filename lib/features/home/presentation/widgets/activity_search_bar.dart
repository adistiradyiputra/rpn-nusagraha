import 'package:flutter/material.dart';
import 'dart:async';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class ActivitySearchBar extends StatefulWidget {
  final String? initialValue;
  final Function(String) onSearchChanged;
  final Function()? onClear;
  final String hintText;
  final bool isLoading;

  const ActivitySearchBar({
    super.key,
    this.initialValue,
    required this.onSearchChanged,
    this.onClear,
    this.hintText = 'Cari kegiatan...',
    this.isLoading = false,
  });

  @override
  State<ActivitySearchBar> createState() => _ActivitySearchBarState();
}

class _ActivitySearchBarState extends State<ActivitySearchBar> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Set new timer for debouncing (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: AppColors.inputBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search Icon Skeleton
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.md),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              // Search Input Skeleton
              Expanded(
                child: Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.md,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              
              // Clear Button Skeleton
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: AppSizes.md),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.inputBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.md),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          
          // Search Input
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.md,
                ),
              ),
            ),
          ),
          
          // Clear Button
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: Icon(
                Icons.clear,
                color: AppColors.textSecondary,
                size: 20,
              ),
              padding: const EdgeInsets.only(right: AppSizes.sm),
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
        ],
      ),
    );
  }
}

