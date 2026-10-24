class StaffNotificationModel {
  final String id;
  final String titleSinhala;
  final String titleEnglish;
  final String titleTamil;
  final String messageSinhala;
  final String messageEnglish;
  final String messageTamil;
  final DateTime timestamp;
  final String category; // 'duty', 'qualification', 'payment', 'system'
  bool isRead;

  StaffNotificationModel({
    required this.id,
    String? title,
    String? message,
    String? titleSinhala,
    String? titleEnglish,
    String? titleTamil,
    String? messageSinhala,
    String? messageEnglish,
    String? messageTamil,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  })  : titleSinhala = titleSinhala ?? title ?? '',
        titleEnglish = titleEnglish ?? title ?? '',
        titleTamil = titleTamil ?? title ?? '',
        messageSinhala = messageSinhala ?? message ?? '',
        messageEnglish = messageEnglish ?? message ?? '',
        messageTamil = messageTamil ?? message ?? '';

  String get title => titleSinhala;
  String get message => messageSinhala;

  String localizedTitle(String lang) {
    if (lang == 'si') return titleSinhala;
    if (lang == 'ta') return titleTamil;
    return titleEnglish;
  }

  String localizedMessage(String lang) {
    if (lang == 'si') return messageSinhala;
    if (lang == 'ta') return messageTamil;
    return messageEnglish;
  }

  factory StaffNotificationModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    DateTime date = DateTime.now();
    if (map['timestamp'] != null) {
      date = DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now();
    }
    return StaffNotificationModel(
      id: docId ?? (map['id'] ?? 'notif-${DateTime.now().millisecondsSinceEpoch}').toString(),
      titleSinhala: (map['titleSinhala'] ?? map['title'] ?? '').toString(),
      titleEnglish: (map['titleEnglish'] ?? map['title'] ?? '').toString(),
      titleTamil: (map['titleTamil'] ?? map['title'] ?? '').toString(),
      messageSinhala: (map['messageSinhala'] ?? map['message'] ?? '').toString(),
      messageEnglish: (map['messageEnglish'] ?? map['message'] ?? '').toString(),
      messageTamil: (map['messageTamil'] ?? map['message'] ?? '').toString(),
      timestamp: date,
      category: (map['category'] ?? 'system').toString(),
      isRead: map['isRead'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleSinhala': titleSinhala,
      'titleEnglish': titleEnglish,
      'titleTamil': titleTamil,
      'messageSinhala': messageSinhala,
      'messageEnglish': messageEnglish,
      'messageTamil': messageTamil,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'isRead': isRead,
    };
  }
}
