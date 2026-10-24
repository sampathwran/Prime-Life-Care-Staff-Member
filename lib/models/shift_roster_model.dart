enum ShiftType {
  day12h('Day Shift (12 Hours)', '07:00 AM - 07:00 PM', 4500.0),
  night12h('Night Shift (12 Hours)', '07:00 PM - 07:00 AM', 5500.0),
  liveIn24h('Live-In Shift (24 Hours)', '24 Hours Residential', 9000.0);

  final String label;
  final String timing;
  final double baseAllowanceLkr;
  const ShiftType(this.label, this.timing, this.baseAllowanceLkr);
}

enum ShiftStatus {
  active,
  upcoming,
  completed,
  canceled,
}

class ShiftRosterModel {
  final String id;
  final DateTime date;
  final ShiftType shiftType;
  final ShiftStatus status;
  final String patientName;
  final String patientLocation;
  final String patientPhone;
  final String careNotes;
  final double paymentAmount;
  final bool isPaid;
  final String? cancellationReason;
  final double? ratingByMember;
  final String? memberFeedback;

  const ShiftRosterModel({
    required this.id,
    required this.date,
    required this.shiftType,
    required this.status,
    required this.patientName,
    required this.patientLocation,
    required this.patientPhone,
    required this.careNotes,
    required this.paymentAmount,
    this.isPaid = false,
    this.cancellationReason,
    this.ratingByMember,
    this.memberFeedback,
  });

  ShiftRosterModel copyWith({
    String? id,
    DateTime? date,
    ShiftType? shiftType,
    ShiftStatus? status,
    String? patientName,
    String? patientLocation,
    String? patientPhone,
    String? careNotes,
    double? paymentAmount,
    bool? isPaid,
    String? cancellationReason,
    double? ratingByMember,
    String? memberFeedback,
  }) {
    return ShiftRosterModel(
      id: id ?? this.id,
      date: date ?? this.date,
      shiftType: shiftType ?? this.shiftType,
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      patientLocation: patientLocation ?? this.patientLocation,
      patientPhone: patientPhone ?? this.patientPhone,
      careNotes: careNotes ?? this.careNotes,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      isPaid: isPaid ?? this.isPaid,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      ratingByMember: ratingByMember ?? this.ratingByMember,
      memberFeedback: memberFeedback ?? this.memberFeedback,
    );
  }
}
