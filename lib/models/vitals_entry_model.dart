enum VitalsSeverity {
  normal,
  warning,
  critical,
}

class VitalsEntryModel {
  final String id;
  final String patientId;
  final DateTime recordedAt;
  final int systolicBP; // mmHg
  final int diastolicBP; // mmHg
  final double bloodSugar; // mg/dL
  final String sugarTiming; // "Fasting", "2h Post-Prandial", "Random"
  final int heartRate; // bpm
  final int spO2; // %
  final double temperatureC; // Celsius
  final int respiratoryRate; // breaths/min
  final String notes;
  final String recordedBy;
  final VitalsSeverity severity;

  const VitalsEntryModel({
    required this.id,
    required this.patientId,
    required this.recordedAt,
    required this.systolicBP,
    required this.diastolicBP,
    required this.bloodSugar,
    required this.sugarTiming,
    required this.heartRate,
    required this.spO2,
    required this.temperatureC,
    required this.respiratoryRate,
    required this.notes,
    required this.recordedBy,
    required this.severity,
  });

  // Automatic clinical evaluation of severity
  static VitalsSeverity evaluateSeverity({
    required int systolic,
    required int diastolic,
    required double sugar,
    required int spO2,
    required double tempC,
    required int hr,
  }) {
    if (systolic >= 170 ||
        diastolic >= 110 ||
        systolic < 85 ||
        spO2 < 90 ||
        sugar > 280 ||
        sugar < 65 ||
        tempC >= 39.0 ||
        hr > 125 ||
        hr < 45) {
      return VitalsSeverity.critical;
    }
    if (systolic >= 140 ||
        diastolic >= 90 ||
        systolic < 95 ||
        spO2 < 95 ||
        sugar > 180 ||
        sugar < 75 ||
        tempC >= 37.8 ||
        hr > 100 ||
        hr < 55) {
      return VitalsSeverity.warning;
    }
    return VitalsSeverity.normal;
  }
}
