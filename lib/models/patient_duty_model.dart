class PatientDutyModel {
  final String id;
  final String fullName;
  final int age;
  final String gender;
  final String diagnosis; // e.g. "Post-CVA Left Hemiparesis, Type 2 Diabetes"
  final String careCategory; // "Bedridden Senior", "Post-Stroke Recovery", "Palliative"
  final String mobilityStatus; // "Bedridden (Needs 2h Turning)", "Partial Mobility", "Wheelchair"
  final String roomNumber; // e.g. "Ground Floor - Master Bedroom"
  final String address;
  final String city;
  final String guardianName;
  final String guardianRelationship;
  final String guardianPhone;
  final String emergencyContact;
  final String supervisorName;
  final String supervisorPhone;
  final List<String> dietaryNotes;
  final List<String> criticalAlerts;
  final String bloodGroup;

  const PatientDutyModel({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.diagnosis,
    required this.careCategory,
    required this.mobilityStatus,
    required this.roomNumber,
    required this.address,
    required this.city,
    required this.guardianName,
    required this.guardianRelationship,
    required this.guardianPhone,
    required this.emergencyContact,
    required this.supervisorName,
    required this.supervisorPhone,
    required this.dietaryNotes,
    required this.criticalAlerts,
    required this.bloodGroup,
  });
}
