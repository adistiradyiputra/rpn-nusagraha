import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/approval_list_widget.dart';
import '../widgets/approval_widget.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  List<ApprovalItem> _approvalItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApprovalItems();
  }

  void _loadApprovalItems() {
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _approvalItems = _getDummyData();
        _isLoading = false;
      });
    });
  }

  Future<void> _handleApprovalAction(String approvalId, bool isApproved, String? remarks) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Remove the item from the list
    setState(() {
      _approvalItems.removeWhere((item) => item.id == approvalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientBlue,
                  AppColors.navyBlue,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Perlu Approval',
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ApprovalListWidget(
      approvalItems: _approvalItems,
      onApprovalAction: _handleApprovalAction,
      onRefresh: _loadApprovalItems,
    );
  }

  List<ApprovalItem> _getDummyData() {
    return [
      ApprovalItem(
        id: '38122',
        title: 'Permohonan UM Perjalanan Dinas',
        description: '250628 Test Enhancement untuk perjalanan dinas ke Jakarta',
        creator: 'John Doe',
        date: '28/06/2025',
        amount: 1000000,
        status: 'Pending',
        timeline: [
          ApprovalStep(
            name: 'Tri Aditya Darmadi',
            role: 'Paraf Pemohon',
            receivedTime: '28/6/2025, 08.28.58',
            actionTime: '16/9/2025, 06.02.44',
            status: 'Approved',
            aging: 79,
          ),
          ApprovalStep(
            name: 'Tri Aditya Darmadi',
            role: 'Tandatangan Pemohon',
            receivedTime: '16/9/2025, 06.02.44',
            status: 'Pending',
            aging: 9,
          ),
          ApprovalStep(
            name: 'Zulfikri Dahlan Lubis',
            role: 'Paraf Menyetujui',
            receivedTime: '16/9/2025, 06.02.44',
            status: 'Pending',
            aging: 9,
          ),
          ApprovalStep(
            name: 'Yuni Lestari',
            role: 'Paraf',
            receivedTime: '16/9/2025, 06.02.44',
            status: 'Pending',
            aging: 9,
          ),
          ApprovalStep(
            name: 'Rio Rianto',
            role: 'Tandatangan Menyetujui',
            receivedTime: '16/9/2025, 06.02.44',
            status: 'Pending',
            aging: 9,
          ),
        ],
      ),
      ApprovalItem(
        id: '38123',
        title: 'Permohonan Pembelian Alat',
        description: 'Pembelian laptop untuk keperluan kerja',
        creator: 'Jane Smith',
        date: '25/06/2025',
        amount: 15000000,
        status: 'Pending',
        timeline: [
          ApprovalStep(
            name: 'Jane Smith',
            role: 'Paraf Pemohon',
            receivedTime: '25/6/2025, 10.15.30',
            actionTime: '25/6/2025, 10.16.00',
            status: 'Approved',
            aging: 0,
          ),
          ApprovalStep(
            name: 'Budi Santoso',
            role: 'Tandatangan Menyetujui',
            receivedTime: '25/6/2025, 10.16.00',
            status: 'Pending',
            aging: 12,
          ),
        ],
      ),
      ApprovalItem(
        id: '38124',
        title: 'Permohonan Cuti Tahunan',
        description: 'Cuti tahunan untuk liburan keluarga',
        creator: 'Ahmad Wijaya',
        date: '20/06/2025',
        amount: 0,
        status: 'Pending',
        timeline: [
          ApprovalStep(
            name: 'Ahmad Wijaya',
            role: 'Paraf Pemohon',
            receivedTime: '20/6/2025, 14.30.15',
            actionTime: '20/6/2025, 14.31.00',
            status: 'Approved',
            aging: 0,
          ),
          ApprovalStep(
            name: 'Siti Nurhaliza',
            role: 'Tandatangan Menyetujui',
            receivedTime: '20/6/2025, 14.31.00',
            status: 'Pending',
            aging: 17,
          ),
        ],
      ),
    ];
  }
}
