class CaregiverUserModel {
  final String id;
  final String fullName;
  final String staffRegNo; // e.g. PLC-NVQ4-018
  final String qualification; // e.g. NVQ Level 4 Elderly Care Assistant
  final String phone;
  final String email;
  final String assignedZone; // e.g. Chilaw - Marawila Zone
  final double rating;
  final int completedShiftsThisMonth;
  final double totalEarningsThisMonth;
  final bool isCertifiedFirstAid;
  final String avatarInitials;

  const CaregiverUserModel({
    required this.id,
    required this.fullName,
    required this.staffRegNo,
    required this.qualification,
    required this.phone,
    required this.email,
    required this.assignedZone,
    required this.rating,
    required this.completedShiftsThisMonth,
    required this.totalEarningsThisMonth,
    this.isCertifiedFirstAid = true,
    required this.avatarInitials,
  });
}
