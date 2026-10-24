enum TaskCategory {
  medication('Medication', 'බෙහෙත් දීම', 'மருந்து வழங்கல்'),
  nutrition('Nutrition & Diet', 'ආහාර සහ කැඳ/බීම', 'ஊட்டச்சத்து & உணவு'),
  hygiene('Hygiene & Bath', 'ස්නානය සහ පිරිසිදු කිරීම', 'சுத்தம் & குளியல்'),
  physiotherapy('Mobility / PT', 'ව්‍යායාම සහ ඇවිද්දවීම', 'உடற்பயிற்சி / இயக்கம்'),
  hydration('Hydration Check', 'ජලය සහ දියර ලබා දීම', 'நீரேற்றம் சரிபார்ப்பு');

  final String titleEn;
  final String titleSi;
  final String titleTa;
  const TaskCategory(this.titleEn, this.titleSi, this.titleTa);

  String localizedTitle(String lang) {
    if (lang == 'si') return titleSi;
    if (lang == 'ta') return titleTa;
    return titleEn;
  }
}

class CareTaskModel {
  final String id;
  final String title;
  final String timeSlot; // e.g. "08:00 AM"
  final TaskCategory category;
  final String instructions;
  bool isCompleted;
  DateTime? completedAt;
  String? notes;
  bool isConfirmed;
  DateTime? confirmedAt;
  String? confirmedBy;

  CareTaskModel({
    required this.id,
    required this.title,
    required this.timeSlot,
    required this.category,
    required this.instructions,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    this.isConfirmed = false,
    this.confirmedAt,
    this.confirmedBy,
  });

  CareTaskModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    bool? isConfirmed,
    DateTime? confirmedAt,
    String? confirmedBy,
  }) {
    return CareTaskModel(
      id: id,
      title: title,
      timeSlot: timeSlot,
      category: category,
      instructions: instructions,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmedBy: confirmedBy ?? this.confirmedBy,
    );
  }
}
