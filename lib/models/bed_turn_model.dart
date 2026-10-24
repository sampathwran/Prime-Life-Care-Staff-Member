enum BedPosture {
  leftLateral('Left Lateral', 'වම් ඇලයට', 'இடது பக்கமாக', 'Bed tilted 30° left with pillow support'),
  supine('Supine', 'උඩුබැලි අතට', 'மல்லாந்து படுத்த நிலை', 'Back position with heel relief pillows'),
  rightLateral('Right Lateral', 'දකුණු ඇලයට', 'வலது பக்கமாக', 'Bed tilted 30° right with knee cushion'),
  semiFowler('Semi-Fowler (30°)', 'හිස ඔසවා (30°)', 'தலை உயர்த்தப்பட்ட நிலை (30°)', 'Head elevated 30° for aspiration prevention');

  final String labelEn;
  final String labelSi;
  final String labelTa;
  final String description;
  const BedPosture(this.labelEn, this.labelSi, this.labelTa, this.description);

  String get label => labelEn;

  String localizedLabel(String lang) {
    if (lang == 'si') return labelSi;
    if (lang == 'ta') return labelTa;
    return labelEn;
  }
}

enum SkinStatus {
  intact('Healthy / Intact', 'නිරෝගී / පැහැදිලි', 'ஆரோக்கியமானது', false),
  rednessStage1('Mild Redness / Erythema', 'මඳක් රතු පැහැ වීම', 'லேசான சிவத்தல்', true),
  pressureSoreAlert('Pressure Sore Alert', 'තුවාලයක් / බිබිලි අවදානමක්', 'படுக்கைப் புண் எச்சரிக்கை', true);

  final String labelEn;
  final String labelSi;
  final String labelTa;
  final bool requiresAlert;
  const SkinStatus(this.labelEn, this.labelSi, this.labelTa, this.requiresAlert);

  String get label => labelEn;

  String localizedLabel(String lang) {
    if (lang == 'si') return labelSi;
    if (lang == 'ta') return labelTa;
    return labelEn;
  }
}

class BedTurnModel {
  final String id;
  final String patientId;
  final DateTime turnedAt;
  final BedPosture posture;
  final SkinStatus skinStatus;
  final bool diaperChanged;
  final bool barrierCreamApplied;
  final bool heelsElevated;
  final String notes;
  final String performedBy;

  const BedTurnModel({
    required this.id,
    required this.patientId,
    required this.turnedAt,
    required this.posture,
    required this.skinStatus,
    required this.diaperChanged,
    required this.barrierCreamApplied,
    required this.heelsElevated,
    required this.notes,
    required this.performedBy,
  });
}
