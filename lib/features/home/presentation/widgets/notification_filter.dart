import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class NotificationFilter extends StatelessWidget {
  final Set<String> selectedModules;
  final Set<String> selectedMonths;
  final Set<String> selectedStatus;
  final Function(String, String) onFilterChanged;
  final VoidCallback onApplyFilter;
  final VoidCallback onCloseFilter;

  const NotificationFilter({
    super.key,
    required this.selectedModules,
    required this.selectedMonths,
    required this.selectedStatus,
    required this.onFilterChanged,
    required this.onApplyFilter,
    required this.onCloseFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHandleBar(),
        _buildHeader(),
        _buildFilterOptions(),
        _buildApplyButton(),
      ],
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCloseFilter,
            child: Icon(Icons.close, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Filter',
                style: AppTextStyles.bodyExtraLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24), // Spacer untuk balance
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterSection(
            'Notifikasi',
            [
              {'label': 'Belum dibaca', 'value': 'unread'},
            ],
            'notifikasi',
          ),
          const SizedBox(height: 24),
          _buildFilterSection(
            'Bulan',
            [
              {'label': 'September', 'value': 'september'},
              {'label': 'Agustus', 'value': 'agustus'},
              {'label': 'Juli', 'value': 'juli'},
            ],
            'month',
          ),
          const SizedBox(height: 24),
          _buildModuleFilterSection(),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Map<String, String>> options, String type) {
    Set<String> selectedSet = _getSelectedSet(type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) => _buildFilterOption(option, selectedSet, type)),
      ],
    );
  }

  Widget _buildFilterOption(Map<String, String> option, Set<String> selectedSet, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              option['label']!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
          _buildSelectButton(option, selectedSet, type),
        ],
      ),
    );
  }

  Widget _buildSelectButton(Map<String, String> option, Set<String> selectedSet, String type) {
    return GestureDetector(
      onTap: () => onFilterChanged(option['value']!, type),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selectedSet.contains(option['value']) 
              ? Colors.blue.shade600 
              : Colors.transparent,
          border: Border.all(
            color: selectedSet.contains(option['value']) 
                ? Colors.blue.shade600 
                : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: selectedSet.contains(option['value'])
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget _buildModuleFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modul',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ..._getModuleOptions().map((option) => _buildModuleOption(option)),
      ],
    );
  }

  Widget _buildModuleOption(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildModuleIcon(option),
                const SizedBox(width: 12),
                Text(
                  option['label']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          _buildSelectButton(Map<String, String>.from(option), selectedModules, 'module'),
        ],
      ),
    );
  }

  Widget _buildModuleIcon(Map<String, dynamic> option) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _getModuleColor(option['value']).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          option['icon'] as String,
          width: 16,
          height: 16,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onApplyFilter,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Atur Filter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Set<String> _getSelectedSet(String type) {
    switch (type) {
      case 'notifikasi':
        return selectedStatus;
      case 'month':
        return selectedMonths;
      default:
        return selectedModules;
    }
  }

  List<Map<String, dynamic>> _getModuleOptions() {
    return [
      {'label': 'NUSARISET', 'value': 'NUSARISET', 'icon': 'assets/images/icon-nusariset.png'},
      {'label': 'NUSAHUMA', 'value': 'NUSAHUMA', 'icon': 'assets/images/icon-nusahuma.png'},
      {'label': 'NUSAREKA', 'value': 'NUSAREKA', 'icon': 'assets/images/icon-nusareka.png'},
      {'label': 'NUSAPROC', 'value': 'NUSAPROC', 'icon': 'assets/images/icon-nusaproc.png'},
      {'label': 'NUSAFINA', 'value': 'NUSAFINA', 'icon': 'assets/images/icon-nusafina.png'},
    ];
  }

  Color _getModuleColor(String moduleName) {
    switch (moduleName) {
      case 'NUSARISET':
        return Colors.blue;
      case 'NUSAHUMA':
        return Colors.green;
      case 'NUSAREKA':
        return Colors.orange;
      case 'NUSAPROC':
        return Colors.purple;
      case 'NUSAFINA':
        return Colors.red;
      default:
        return Colors.blue.shade600;
    }
  }
}
