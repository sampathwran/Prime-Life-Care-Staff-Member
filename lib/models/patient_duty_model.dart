import 'care_booking_model.dart';

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

  factory PatientDutyModel.fromBooking(CareBookingModel b) {
    return PatientDutyModel(
      id: b.id,
      fullName: b.patientName,
      age: b.patientAge,
      gender: b.patientGender,
      diagnosis: b.diagnosis,
      careCategory: b.careCategory,
      mobilityStatus: 'Assisted Care & Vitals Monitor',
      roomNumber: 'Residence Bedroom',
      address: b.address.isNotEmpty ? b.address : '${b.city}, ${b.district}',
      city: b.city.isNotEmpty ? b.city : b.district,
      guardianName: b.guardianName,
      guardianRelationship: b.guardianRelationship,
      guardianPhone: b.guardianPhone,
      emergencyContact: b.guardianPhone,
      supervisorName: 'PLC Operations Center',
      supervisorPhone: '+94 11 234 5678',
      dietaryNotes: const ['Medication compliance', 'Hydration & nutrition monitoring'],
      criticalAlerts: [b.diagnosis],
      bloodGroup: 'Reported upon arrival',
    );
  }

  factory PatientDutyModel.empty() {
    return const PatientDutyModel(
      id: 'none',
      fullName: 'No Patient Assigned',
      age: 0,
      gender: 'N/A',
      diagnosis: 'Currently on standby / available for duty',
      careCategory: 'Standby',
      mobilityStatus: 'N/A',
      roomNumber: 'N/A',
      address: 'N/A',
      city: 'N/A',
      guardianName: 'N/A',
      guardianRelationship: 'N/A',
      guardianPhone: '',
      emergencyContact: '',
      supervisorName: 'PLC Operations Center',
      supervisorPhone: '+94 11 234 5678',
      dietaryNotes: [],
      criticalAlerts: [],
      bloodGroup: 'N/A',
    );
  }
}
