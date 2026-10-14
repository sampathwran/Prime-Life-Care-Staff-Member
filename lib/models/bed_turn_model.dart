enum BedPosture {
  leftLateral('Left Lateral (වම් ඇලයට)', 'Bed tilted 30° left with pillow support'),
  supine('Supine (උඩුබැලි අතට)', 'Back position with heel relief pillows'),
  rightLateral('Right Lateral (දකුණු ඇලයට)', 'Bed tilted 30° right with knee cushion'),
  semiFowler('Semi-Fowler (හිස ඔසවා 30°)', 'Head elevated 30° for aspiration prevention');

  final String label;
  final String description;
  const BedPosture(this.label, this.description);
}

enum SkinStatus {
  intact('Healthy / Intact (පැහැදිලි)', false),
  rednessStage1('Mild Redness / Erythema (රතු පැහැ වීම)', true),
  pressureSoreAlert('Pressure Sore Alert (තුවාලයක් / බිබිලි)', true);

  final String label;
  final bool requiresAlert;
  const SkinStatus(this.label, this.requiresAlert);
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
