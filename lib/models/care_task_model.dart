enum TaskCategory {
  medication('Medication', 'බෙහෙත් දීම'),
  nutrition('Nutrition & Diet', 'ආහාර සහ කැඳ/බීම'),
  hygiene('Hygiene & Bath', 'ස්නානය සහ පිරිසිදු කිරීම'),
  physiotherapy('Mobility / PT', 'ව්‍යායාම සහ ඇවිද්දවීම'),
  hydration('Hydration Check', 'ජලය සහ දියර ලබා දීම');

  final String titleEn;
  final String titleSi;
  const TaskCategory(this.titleEn, this.titleSi);
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

  CareTaskModel({
    required this.id,
    required this.title,
    required this.timeSlot,
    required this.category,
    required this.instructions,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
  });

  CareTaskModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
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
    );
  }
}
