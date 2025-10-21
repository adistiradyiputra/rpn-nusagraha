class ApprovalHistoryItem {
  final String id;
  final DateTime approvalTime;
  final String number;
  final String description;
  final String item;
  final double total;
  final List<ApprovalAuthority> authorities;
  final ApprovalStatus status;

  ApprovalHistoryItem({
    required this.id,
    required this.approvalTime,
    required this.number,
    required this.description,
    required this.item,
    required this.total,
    required this.authorities,
    required this.status,
  });
}

class ApprovalAuthority {
  final String role;
  final String name;
  final bool isCompleted;
  final bool isRejected;
  final DateTime? receivedTime;
  final DateTime? actionTime;

  ApprovalAuthority({
    required this.role,
    required this.name,
    this.isCompleted = false,
    this.isRejected = false,
    this.receivedTime,
    this.actionTime,
  });
}

enum ApprovalStatus {
  pending,
  approved,
  rejected,
  inProgress,
}
