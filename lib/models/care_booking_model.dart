import 'package:cloud_firestore/cloud_firestore.dart';

enum EligibilityStatus {
  eligibleForActive,
  eligibleForUpcoming,
  blockedMoreThan2Days,
  blockedStartsBeforeCurrentEnds,
  blockedAlreadyQueued,
  blockedTierMismatch,
  blockedNotApproved,
  blockedQueueFull,
}

class BookingEligibility {
  final bool canAccept;
  final bool isUpcoming;
  final EligibilityStatus status;
  final String reasonSinhala;
  final String reasonEnglish;
  final String reasonTamil;

  const BookingEligibility({
    required this.canAccept,
    required this.isUpcoming,
    required this.status,
    required this.reasonSinhala,
    required this.reasonEnglish,
    required this.reasonTamil,
  });

  String localizedReason(String lang) {
    if (lang == 'si') return reasonSinhala;
    if (lang == 'ta') return reasonTamil;
    return reasonEnglish;
  }
}

class CareBookingModel {
  final String id;
  final String bookingCode;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String diagnosis;
  final String careCategory;
  final String district;
  final String city;
  final String address;
  final String guardianName;
  final String guardianRelationship;
  final String guardianPhone;
  final String shiftType; // 12h_day, 12h_night, 24h_full
  final int durationDays;
  final String startDate;
  final DateTime scheduledStartDate;
  final DateTime scheduledEndDate;
  final double dailyRateLKR;
  final double totalEarningsLKR;
  final String requiredTier; // nvq4_aide, nvq5_nurse
  final String requiredTierName;
  final bool isEmergencyUrgent;
  String status; // 'broadcasted', 'caregiver_assigned', 'assigned', 'in_progress', 'upcoming', 'completed'
  int? customRemainingDays;
  final List<Map<String, dynamic>> candidateQueue;
  final int maxCandidates;
  final int acceptedCandidateCount;
  final String? assignedCaregiverId;
  final String? assignedCaregiverName;
  final String? assignedCaregiverPhone;
  final double? latitude;
  final double? longitude;
  final String? googleMapsUrl;

  CareBookingModel({
    required this.id,
    required this.bookingCode,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.diagnosis,
    required this.careCategory,
    required this.district,
    required this.city,
    required this.address,
    required this.guardianName,
    required this.guardianRelationship,
    required this.guardianPhone,
    required this.shiftType,
    required this.durationDays,
    required this.startDate,
    DateTime? scheduledStartDate,
    DateTime? scheduledEndDate,
    required this.dailyRateLKR,
    required this.totalEarningsLKR,
    required this.requiredTier,
    required this.requiredTierName,
    this.isEmergencyUrgent = false,
    this.status = 'broadcasted',
    this.customRemainingDays,
    this.candidateQueue = const [],
    this.maxCandidates = 10,
    this.acceptedCandidateCount = 0,
    this.assignedCaregiverId,
    this.assignedCaregiverName,
    this.assignedCaregiverPhone,
    this.latitude,
    this.longitude,
    this.googleMapsUrl,
  })  : scheduledStartDate = scheduledStartDate ?? DateTime.now(),
        scheduledEndDate = scheduledEndDate ?? DateTime.now().add(Duration(days: durationDays));

  bool get hasLocation => (latitude != null && longitude != null) || (googleMapsUrl != null && googleMapsUrl!.isNotEmpty);

  String get navigationMapsUrl {
    if (latitude != null && longitude != null) {
      return 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    }
    if (googleMapsUrl != null && googleMapsUrl!.isNotEmpty) {
      return googleMapsUrl!;
    }
    final query = Uri.encodeComponent('$address, $city, $district, Sri Lanka');
    return 'https://www.google.com/maps/search/?api=1&query=$query';
  }

  bool get isOpen => status == 'broadcasted' || status == 'published_open';
  bool get isAssigned => status == 'caregiver_assigned' || status == 'assigned';
  bool get isInProgress => status == 'in_progress';
  bool get isAccepted => isAssigned || isInProgress;
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';

  bool get isQueueFull => acceptedCandidateCount >= maxCandidates || candidateQueue.length >= maxCandidates;
  int get queueSlotsLeft => maxCandidates - candidateQueue.length;

  int get remainingDays {
    if (customRemainingDays != null) return customRemainingDays!;
    final diff = scheduledEndDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  // Find queue position of a specific caregiver (1-based index, or -1 if not in queue)
  int getQueuePosition(String caregiverId) {
    for (int i = 0; i < candidateQueue.length; i++) {
      final c = candidateQueue[i];
      if (c['caregiverId'] == caregiverId) {
        return (c['queuePosition'] as num?)?.toInt() ?? (i + 1);
      }
    }
    return -1;
  }

  // Privacy-protected title for unaccepted / published bookings
  String get maskedTitle => 'Patient ($patientGender • Age $patientAge)';
  String get maskedTitleEnglish => maskedTitle;

  static String resolveRequiredTier(Map<String, dynamic> map) {
    final raw = (map['requiredTier'] ?? map['targetTier'] ?? map['staffTierId'] ?? map['staffTier'] ?? '').toString().toLowerCase();
    final name = (map['requiredTierName'] ?? map['staffTierName'] ?? map['serviceName'] ?? '').toString().toLowerCase();
    if (raw.contains('5') || raw.contains('nurse') || raw.contains('nurs') || name.contains('5') || name.contains('nurse') || name.contains('nurs') || name.contains('clinical')) {
      return 'nvq5_nurse';
    }
    return 'nvq4_aide';
  }

  factory CareBookingModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is String) {
        try {
          return DateTime.parse(val);
        } catch (_) {}
      }
      return null;
    }

    final duration = (map['durationDays'] as num?)?.toInt() ?? 7;
    final parsedStart = parseDate(map['scheduledStartDate'] ?? map['startDate']) ?? DateTime.now();
    final parsedEnd = parseDate(map['scheduledEndDate'] ?? map['endDate']) ?? parsedStart.add(Duration(days: duration));

    final rawQueue = map['candidateQueue'];
    List<Map<String, dynamic>> queue = [];
    if (rawQueue is List) {
      queue = rawQueue.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }

    final tier = resolveRequiredTier(map);

    return CareBookingModel(
      id: docId,
      bookingCode: map['bookingCode']?.toString() ?? docId,
      patientName: map['patientName']?.toString() ?? 'Patient',
      patientAge: (map['patientAge'] as num?)?.toInt() ?? 75,
      patientGender: map['patientGender']?.toString() ?? 'Male',
      diagnosis: (map['diagnosis'] ?? map['medicalConditions'])?.toString() ?? 'General Elder Care',
      careCategory: (map['careCategory'] ?? map['serviceName'])?.toString() ?? 'Elderly Care',
      district: map['district']?.toString() ?? 'Colombo',
      city: map['city']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      guardianName: (map['guardianName'] ?? map['contactName'])?.toString() ?? 'Family Guardian',
      guardianRelationship: map['guardianRelationship']?.toString() ?? 'Family Member',
      guardianPhone: (map['guardianPhone'] ?? map['contactPhone'])?.toString() ?? '',
      shiftType: map['shiftType']?.toString() ?? '12h_day',
      durationDays: duration,
      startDate: map['startDate']?.toString() ?? 'Immediate',
      scheduledStartDate: parsedStart,
      scheduledEndDate: parsedEnd,
      dailyRateLKR: ((map['staffDailyRateLKR'] ?? map['staffDailyPayoutLKR'] ?? map['dailyRateLKR'] ?? ((map['pricePerDayLKR'] ?? map['priceLKR']) is num ? ((map['pricePerDayLKR'] ?? map['priceLKR']) as num).toDouble() * 0.8 : 4000.0)) as num?)?.toDouble() ?? 4000.0,
      totalEarningsLKR: ((map['staffTotalEarningsLKR'] ?? map['staffTotalPayoutLKR'] ?? map['totalEarningsLKR'] ?? ((map['totalCostLKR'] is num) ? ((map['totalCostLKR'] as num).toDouble() * 0.8) : 28000.0)) as num?)?.toDouble() ?? 28000.0,
      requiredTier: tier,
      requiredTierName: (map['requiredTierName'] ?? map['staffTierName'])?.toString() ??
          (tier == 'nvq5_nurse' ? 'NVQ Level 5 Senior Nursing Officer' : 'NVQ Level 4 Certified Caregiver'),
      isEmergencyUrgent: map['isEmergencyUrgent'] == true,
      status: map['status']?.toString() ?? 'broadcasted',
      customRemainingDays: (map['customRemainingDays'] as num?)?.toInt(),
      candidateQueue: queue,
      maxCandidates: (map['maxCandidates'] as num?)?.toInt() ?? 10,
      acceptedCandidateCount: (map['acceptedCandidateCount'] as num?)?.toInt() ?? queue.length,
      assignedCaregiverId: map['assignedCaregiverId']?.toString(),
      assignedCaregiverName: map['assignedCaregiverName']?.toString(),
      assignedCaregiverPhone: map['assignedCaregiverPhone']?.toString(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      googleMapsUrl: map['googleMapsUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingCode': bookingCode,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'diagnosis': diagnosis,
      'medicalConditions': diagnosis,
      'careCategory': careCategory,
      'serviceName': careCategory,
      'district': district,
      'city': city,
      'address': address,
      'guardianName': guardianName,
      'contactName': guardianName,
      'guardianRelationship': guardianRelationship,
      'guardianPhone': guardianPhone,
      'contactPhone': guardianPhone,
      'shiftType': shiftType,
      'durationDays': durationDays,
      'startDate': startDate,
      'scheduledStartDate': scheduledStartDate.toIso8601String(),
      'scheduledEndDate': scheduledEndDate.toIso8601String(),
      'dailyRateLKR': dailyRateLKR,
      'pricePerDayLKR': dailyRateLKR,
      'priceLKR': dailyRateLKR,
      'totalEarningsLKR': totalEarningsLKR,
      'totalCostLKR': totalEarningsLKR,
      'requiredTier': requiredTier,
      'targetTier': requiredTier,
      'staffTier': requiredTier,
      'requiredTierName': requiredTierName,
      'staffTierName': requiredTierName,
      'isEmergencyUrgent': isEmergencyUrgent,
      'status': status,
      'candidateQueue': candidateQueue,
      'maxCandidates': maxCandidates,
      'acceptedCandidateCount': acceptedCandidateCount,
      'assignedCaregiverId': assignedCaregiverId,
      'assignedCaregiverName': assignedCaregiverName,
      'assignedCaregiverPhone': assignedCaregiverPhone,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsUrl': googleMapsUrl,
    };
  }

  CareBookingModel copyWith({
    String? id,
    String? bookingCode,
    String? patientName,
    int? patientAge,
    String? patientGender,
    String? diagnosis,
    String? careCategory,
    String? district,
    String? city,
    String? address,
    String? guardianName,
    String? guardianRelationship,
    String? guardianPhone,
    String? shiftType,
    int? durationDays,
    String? startDate,
    DateTime? scheduledStartDate,
    DateTime? scheduledEndDate,
    double? dailyRateLKR,
    double? totalEarningsLKR,
    String? requiredTier,
    String? requiredTierName,
    bool? isEmergencyUrgent,
    String? status,
    int? customRemainingDays,
    List<Map<String, dynamic>>? candidateQueue,
    int? maxCandidates,
    int? acceptedCandidateCount,
    String? assignedCaregiverId,
    String? assignedCaregiverName,
    String? assignedCaregiverPhone,
    double? latitude,
    double? longitude,
    String? googleMapsUrl,
  }) {
    return CareBookingModel(
      id: id ?? this.id,
      bookingCode: bookingCode ?? this.bookingCode,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      diagnosis: diagnosis ?? this.diagnosis,
      careCategory: careCategory ?? this.careCategory,
      district: district ?? this.district,
      city: city ?? this.city,
      address: address ?? this.address,
      guardianName: guardianName ?? this.guardianName,
      guardianRelationship: guardianRelationship ?? this.guardianRelationship,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      shiftType: shiftType ?? this.shiftType,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      scheduledStartDate: scheduledStartDate ?? this.scheduledStartDate,
      scheduledEndDate: scheduledEndDate ?? this.scheduledEndDate,
      dailyRateLKR: dailyRateLKR ?? this.dailyRateLKR,
      totalEarningsLKR: totalEarningsLKR ?? this.totalEarningsLKR,
      requiredTier: requiredTier ?? this.requiredTier,
      requiredTierName: requiredTierName ?? this.requiredTierName,
      isEmergencyUrgent: isEmergencyUrgent ?? this.isEmergencyUrgent,
      status: status ?? this.status,
      customRemainingDays: customRemainingDays ?? this.customRemainingDays,
      candidateQueue: candidateQueue ?? this.candidateQueue,
      maxCandidates: maxCandidates ?? this.maxCandidates,
      acceptedCandidateCount: acceptedCandidateCount ?? this.acceptedCandidateCount,
      assignedCaregiverId: assignedCaregiverId ?? this.assignedCaregiverId,
      assignedCaregiverName: assignedCaregiverName ?? this.assignedCaregiverName,
      assignedCaregiverPhone: assignedCaregiverPhone ?? this.assignedCaregiverPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
    );
  }
}
