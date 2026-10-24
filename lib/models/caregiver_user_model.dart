import '../l10n/app_language.dart';

class LanguageProficiency {
  final String languageName;
  final String languageCode; // 'si', 'en', 'ta'
  int speakingPercent; // 0 - 100
  int writingPercent; // 0 - 100
  int understandingPercent; // 0 - 100

  LanguageProficiency({
    required this.languageName,
    required this.languageCode,
    required this.speakingPercent,
    required this.writingPercent,
    required this.understandingPercent,
  });

  String localizedName(AppLanguage currentLanguage) {
    switch (languageCode) {
      case 'si':
        return currentLanguage == AppLanguage.si
            ? 'සිංහල'
            : currentLanguage == AppLanguage.ta
                ? 'சிங்களம்'
                : 'Sinhala';
      case 'en':
        return currentLanguage == AppLanguage.si
            ? 'ඉංග්‍රීසි'
            : currentLanguage == AppLanguage.ta
                ? 'ஆங்கிலம்'
                : 'English';
      case 'ta':
        return currentLanguage == AppLanguage.si
            ? 'දෙමළ'
            : currentLanguage == AppLanguage.ta
                ? 'தமிழ்'
                : 'Tamil';
      default:
        return languageName;
    }
  }

  LanguageProficiency copyWith({
    String? languageName,
    String? languageCode,
    int? speakingPercent,
    int? writingPercent,
    int? understandingPercent,
  }) {
    return LanguageProficiency(
      languageName: languageName ?? this.languageName,
      languageCode: languageCode ?? this.languageCode,
      speakingPercent: speakingPercent ?? this.speakingPercent,
      writingPercent: writingPercent ?? this.writingPercent,
      understandingPercent: understandingPercent ?? this.understandingPercent,
    );
  }
}

class BankAccountDetails {
  final String bankName;
  final String branchName;
  final String accountNumber;
  final String accountHolderName;
  final String payoutCycle;
  final bool isVerified;

  BankAccountDetails({
    required this.bankName,
    required this.branchName,
    required this.accountNumber,
    required this.accountHolderName,
    this.payoutCycle = 'Weekly Every Monday',
    this.isVerified = false,
  });

  String get maskedAccountNumber {
    final clean = accountNumber.trim();
    if (clean.length <= 4) return clean;
    final last4 = clean.substring(clean.length - 4);
    final prefix = clean.substring(0, clean.length >= 8 ? 4 : 2);
    return '$prefix **** **** $last4';
  }

  factory BankAccountDetails.fromMap(Map<String, dynamic> map) {
    return BankAccountDetails(
      bankName: (map['bankName'] ?? '').toString(),
      branchName: (map['branchName'] ?? '').toString(),
      accountNumber: (map['accountNumber'] ?? '').toString(),
      accountHolderName: (map['accountHolderName'] ?? '').toString(),
      payoutCycle: (map['payoutCycle'] ?? 'Weekly Every Monday').toString(),
      isVerified: map['isVerified'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'branchName': branchName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'payoutCycle': payoutCycle,
      'isVerified': isVerified,
    };
  }

  BankAccountDetails copyWith({
    String? bankName,
    String? branchName,
    String? accountNumber,
    String? accountHolderName,
    String? payoutCycle,
    bool? isVerified,
  }) {
    return BankAccountDetails(
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      payoutCycle: payoutCycle ?? this.payoutCycle,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class QualificationDocument {
  final String id;
  final String title;
  final String institute;
  final String issueYear;
  final String fileName;
  String status; // 'verified', 'pending_review', 'rejected'
  final DateTime uploadedAt;
  final String? rejectionReason;

  QualificationDocument({
    required this.id,
    required this.title,
    required this.institute,
    required this.issueYear,
    required this.fileName,
    this.status = 'verified',
    required this.uploadedAt,
    this.rejectionReason,
  });

  bool get isVerified => status == 'verified';
  bool get isPending => status == 'pending_review';
  bool get isRejected => status == 'rejected';

  factory QualificationDocument.fromMap(Map<String, dynamic> map) {
    DateTime date = DateTime.now();
    if (map['uploadedAt'] != null) {
      date = DateTime.tryParse(map['uploadedAt'].toString()) ?? DateTime.now();
    }
    return QualificationDocument(
      id: (map['id'] ?? 'doc-${DateTime.now().millisecondsSinceEpoch}').toString(),
      title: (map['title'] ?? 'Document').toString(),
      institute: (map['institute'] ?? '').toString(),
      issueYear: (map['issueYear'] ?? '').toString(),
      fileName: (map['fileName'] ?? 'document.pdf').toString(),
      status: (map['status'] ?? 'pending_review').toString(),
      uploadedAt: date,
      rejectionReason: map['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'institute': institute,
      'issueYear': issueYear,
      'fileName': fileName,
      'status': status,
      'uploadedAt': uploadedAt.toIso8601String(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }
}

class CaregiverUserModel {
  final String id;
  final String fullName;
  final String staffRegNo; // e.g. PLC-1001
  final String qualification; // e.g. NVQ Level 4 Elderly Care Assistant
  final String phone;
  final String email;
  final String nic;
  final String address;
  final String bio;
  final String assignedZone; // e.g. Chilaw - Marawila District
  final double rating;
  final int completedShiftsThisMonth;
  final double totalEarningsThisMonth;
  final double dailyEarnings;
  final double weeklyEarnings;
  final bool isCertifiedFirstAid;
  final String avatarInitials;
  final String verificationStatus; // 'verified', 'pending'
  final String approvalStatus; // 'pending_approval', 'approved', 'rejected'
  final String? rejectionReason;
  final List<LanguageProficiency> languages;
  final List<QualificationDocument> documents;
  final BankAccountDetails? bankDetails;
  final List<String> clinicalSkills;
  final double dailyRateLKR;
  final double hourlyRateLKR;
  final double pendingPayout;

  // New Verification & Document Pipeline Fields
  final String? profileImageUrl;
  final String profileImageStatus; // 'missing', 'pending', 'approved', 'rejected'
  final String? profileImageRejectionReason;
  final String? nicFrontUrl;
  final String nicFrontStatus;
  final String? nicBackUrl;
  final String nicBackStatus;
  final String? policeReportUrl;
  final String policeReportStatus;
  final String? qualificationCertUrl;
  final String qualificationCertStatus;
  final String faceVerificationStatus; // 'missing', 'pending', 'approved', 'rejected'
  final Map<String, dynamic>? faceVerificationData;
  final Map<String, dynamic> verificationItems;
  final bool isVerifiedMember;

  bool get isApproved => approvalStatus == 'approved';
  bool get isPendingApproval => approvalStatus == 'pending_approval';
  bool get isRejected => approvalStatus == 'rejected';
  bool get isNurse =>
      qualification.toLowerCase().contains('5') ||
      qualification.toLowerCase().contains('nurse') ||
      qualification.toLowerCase().contains('nurs');

  bool get isProfileImageApproved => profileImageStatus == 'approved';
  bool get isNicFrontApproved => nicFrontStatus == 'approved';
  bool get isNicBackApproved => nicBackStatus == 'approved';
  bool get isPersonalDetailsApproved => isNicFrontApproved && isNicBackApproved;
  bool get isPoliceReportApproved => policeReportStatus == 'approved';
  bool get isQualificationCertApproved => qualificationCertStatus == 'approved';
  bool get isFaceVerificationApproved => faceVerificationStatus == 'approved';

  String get personalDetailsStatus {
    if (nicFrontStatus == 'rejected' || nicBackStatus == 'rejected') return 'rejected';
    if (nicFrontStatus == 'approved' && nicBackStatus == 'approved') return 'approved';
    if (nicFrontStatus == 'pending' || nicBackStatus == 'pending') return 'pending';
    return 'missing';
  }

  int get approvedVerificationCount {
    int count = 0;
    if (isProfileImageApproved) count++;
    if (isPersonalDetailsApproved) count++;
    if (isPoliceReportApproved) count++;
    if (isQualificationCertApproved) count++;
    if (isFaceVerificationApproved) count++;
    return count;
  }

  int get totalVerificationCount => 5;
  double get verificationProgress => approvedVerificationCount / 5.0;

  String? get nextRequiredStepKey {
    // Check in priority order for missing or rejected items
    if (profileImageStatus != 'approved' && profileImageStatus != 'pending') return 'profile_image';
    if (!isPersonalDetailsApproved && personalDetailsStatus != 'pending') return 'personal_details';
    if (policeReportStatus != 'approved' && policeReportStatus != 'pending') return 'police_report';
    if (qualificationCertStatus != 'approved' && qualificationCertStatus != 'pending') return 'qualification_cert';
    if (faceVerificationStatus != 'approved' && faceVerificationStatus != 'pending') return 'face_verification';

    // If all are at least submitted (pending), check for pending items
    if (profileImageStatus == 'pending') return 'profile_image';
    if (personalDetailsStatus == 'pending') return 'personal_details';
    if (policeReportStatus == 'pending') return 'police_report';
    if (qualificationCertStatus == 'pending') return 'qualification_cert';
    if (faceVerificationStatus == 'pending') return 'face_verification';

    return null; // All 5 approved!
  }

  CaregiverUserModel({
    required this.id,
    required this.fullName,
    required this.staffRegNo,
    required this.qualification,
    required this.phone,
    required this.email,
    required this.nic,
    required this.address,
    required this.bio,
    required this.assignedZone,
    required this.rating,
    required this.completedShiftsThisMonth,
    required this.totalEarningsThisMonth,
    this.dailyEarnings = 4500.0,
    this.weeklyEarnings = 27000.0,
    this.dailyRateLKR = 4500.0,
    this.hourlyRateLKR = 500.0,
    this.pendingPayout = 0.0,
    this.isCertifiedFirstAid = true,
    required this.avatarInitials,
    this.verificationStatus = 'inactive',
    this.approvalStatus = 'pending_approval',
    this.rejectionReason,
    List<LanguageProficiency>? languages,
    List<QualificationDocument>? documents,
    this.bankDetails,
    List<String>? clinicalSkills,
    this.profileImageUrl,
    this.profileImageStatus = 'missing',
    this.profileImageRejectionReason,
    this.nicFrontUrl,
    this.nicFrontStatus = 'missing',
    this.nicBackUrl,
    this.nicBackStatus = 'missing',
    this.policeReportUrl,
    this.policeReportStatus = 'missing',
    this.qualificationCertUrl,
    this.qualificationCertStatus = 'missing',
    this.faceVerificationStatus = 'missing',
    this.faceVerificationData,
    Map<String, dynamic>? verificationItems,
    this.isVerifiedMember = false,
  })  : languages = languages ?? [],
        documents = documents ?? [],
        clinicalSkills = clinicalSkills ?? [],
        verificationItems = verificationItems ?? {};

  factory CaregiverUserModel.fromMap(Map<String, dynamic> data, [String? docId]) {
    final regNo = (data['membershipNumber'] ?? data['staffRegNo'] ?? data['id'] ?? docId ?? 'PLC-1001').toString();
    final name = (data['fullName'] ?? data['name'] ?? 'Caregiver').toString();
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final initials = words.isNotEmpty
        ? words.map((w) => w[0].toUpperCase()).take(2).join()
        : 'PL';

    final approval = (data['approvalStatus'] ?? (data['isPoliceVerified'] == true ? 'approved' : 'pending_approval')).toString();

    final docsList = <QualificationDocument>[];
    if (data['documents'] is List) {
      for (final item in data['documents']) {
        if (item is Map) {
          docsList.add(QualificationDocument.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    final vItems = (data['verificationItems'] is Map)
        ? Map<String, dynamic>.from(data['verificationItems'] as Map)
        : <String, dynamic>{};

    String getVStatus(String key, String fallbackField) {
      if (vItems[key] is Map && vItems[key]['status'] != null) {
        return vItems[key]['status'].toString();
      }
      return (data[fallbackField] ?? 'missing').toString();
    }

    String? getVUrl(String key, String fallbackField) {
      if (vItems[key] is Map && vItems[key]['url'] != null) {
        return vItems[key]['url'] as String?;
      }
      return data[fallbackField] as String?;
    }

    final pImgStatus = getVStatus('profile_image', 'profileImageStatus');
    final nFrontStatus = getVStatus('nic_front', 'nicFrontStatus');
    final nBackStatus = getVStatus('nic_back', 'nicBackStatus');
    final pRepStatus = getVStatus('police_report', 'policeReportStatus');
    final qCertStatus = getVStatus('qualification_cert', 'qualificationCertStatus');
    final fVerStatus = getVStatus('face_verification', 'faceVerificationStatus');

    final bool allApproved = pImgStatus == 'approved' &&
        nFrontStatus == 'approved' &&
        nBackStatus == 'approved' &&
        pRepStatus == 'approved' &&
        qCertStatus == 'approved' &&
        fVerStatus == 'approved';

    final bool isVerified = (data['isVerifiedMember'] == true) || allApproved;

    final langsList = <LanguageProficiency>[];
    if (data['languages'] is List && (data['languages'] as List).isNotEmpty) {
      for (final item in data['languages']) {
        if (item is Map) {
          langsList.add(LanguageProficiency(
            languageName: (item['languageName'] ?? 'Sinhala').toString(),
            languageCode: (item['languageCode'] ?? 'si').toString(),
            speakingPercent: (item['speakingPercent'] as num?)?.toInt() ?? 100,
            writingPercent: (item['writingPercent'] as num?)?.toInt() ?? 80,
            understandingPercent: (item['understandingPercent'] as num?)?.toInt() ?? 90,
          ));
        }
      }
    } else {
      langsList.addAll([
        LanguageProficiency(languageName: 'Sinhala', languageCode: 'si', speakingPercent: 100, writingPercent: 100, understandingPercent: 100),
        LanguageProficiency(languageName: 'English', languageCode: 'en', speakingPercent: 80, writingPercent: 70, understandingPercent: 85),
        LanguageProficiency(languageName: 'Tamil', languageCode: 'ta', speakingPercent: 50, writingPercent: 30, understandingPercent: 60),
      ]);
    }

    final skillsList = <String>[];
    if (data['clinicalSkills'] is List && (data['clinicalSkills'] as List).isNotEmpty) {
      for (final s in data['clinicalSkills']) {
        skillsList.add(s.toString());
      }
    }

    BankAccountDetails? bDetails;
    if (data['bankDetails'] is Map) {
      final bMap = Map<String, dynamic>.from(data['bankDetails'] as Map);
      if (bMap['bankName'] != null && bMap['bankName'].toString().isNotEmpty) {
        bDetails = BankAccountDetails.fromMap(bMap);
      }
    }

    final dailyRate = (data['dailyRateLKR'] as num?)?.toDouble() ??
        (data['dailyEarnings'] as num?)?.toDouble() ??
        4500.0;
    final hourlyRate = (data['hourlyRateLKR'] as num?)?.toDouble() ?? 500.0;
    final totalEarned = (data['totalEarnings'] as num?)?.toDouble() ??
        (data['totalEarningsThisMonth'] as num?)?.toDouble() ??
        0.0;
    final pendingPayout = (data['pendingPayout'] as num?)?.toDouble() ?? 0.0;
    final weeklyEarned = (data['weeklyEarnings'] as num?)?.toDouble() ?? (dailyRate * 6);

    return CaregiverUserModel(
      id: docId ?? regNo,
      fullName: name,
      staffRegNo: regNo,
      qualification: (data['qualification'] ?? data['tierLabel'] ?? 'NVQ Level 4 Elderly Care Aide').toString(),
      phone: (data['phone'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      nic: (data['nic'] ?? '').toString(),
      address: (data['address'] ?? '').toString(),
      bio: (data['bio'] ?? 'Dedicated and certified professional caregiver registered with Prime Life Care.').toString(),
      assignedZone: (data['assignedZone'] ?? data['district'] ?? data['city'] ?? 'Colombo District').toString(),
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      completedShiftsThisMonth: (data['completedShifts'] as num?)?.toInt() ?? 0,
      totalEarningsThisMonth: totalEarned,
      dailyEarnings: dailyRate,
      weeklyEarnings: weeklyEarned,
      dailyRateLKR: dailyRate,
      hourlyRateLKR: hourlyRate,
      pendingPayout: pendingPayout,
      isCertifiedFirstAid: data['isCprCertified'] == true || data['isCertifiedFirstAid'] == true,
      avatarInitials: initials,
      verificationStatus: isVerified ? 'verified' : 'inactive',
      approvalStatus: approval,
      rejectionReason: data['rejectionReason'] as String?,
      documents: docsList,
      bankDetails: bDetails,
      clinicalSkills: skillsList,
      profileImageUrl: getVUrl('profile_image', 'profileImageUrl'),
      profileImageStatus: pImgStatus,
      profileImageRejectionReason: vItems['profile_image'] is Map ? vItems['profile_image']['rejectionReason'] as String? : null,
      nicFrontUrl: getVUrl('nic_front', 'nicFrontUrl'),
      nicFrontStatus: nFrontStatus,
      nicBackUrl: getVUrl('nic_back', 'nicBackUrl'),
      nicBackStatus: nBackStatus,
      policeReportUrl: getVUrl('police_report', 'policeReportUrl'),
      policeReportStatus: pRepStatus,
      qualificationCertUrl: getVUrl('qualification_cert', 'qualificationCertUrl'),
      qualificationCertStatus: qCertStatus,
      faceVerificationStatus: fVerStatus,
      faceVerificationData: (data['faceVerificationData'] is Map)
          ? Map<String, dynamic>.from(data['faceVerificationData'] as Map)
          : null,
      verificationItems: vItems,
      isVerifiedMember: isVerified,
      languages: langsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'membershipNumber': staffRegNo,
      'staffRegNo': staffRegNo,
      'fullName': fullName,
      'name': fullName,
      'qualification': qualification,
      'tierLabel': qualification,
      'phone': phone,
      'email': email,
      'nic': nic,
      'address': address,
      'bio': bio,
      'assignedZone': assignedZone,
      'district': assignedZone,
      'rating': rating,
      'completedShifts': completedShiftsThisMonth,
      'totalEarnings': totalEarningsThisMonth,
      'dailyEarnings': dailyEarnings,
      'dailyRateLKR': dailyRateLKR,
      'hourlyRateLKR': hourlyRateLKR,
      'pendingPayout': pendingPayout,
      'weeklyEarnings': weeklyEarnings,
      'isCertifiedFirstAid': isCertifiedFirstAid,
      'isCprCertified': isCertifiedFirstAid,
      'verificationStatus': isVerifiedMember ? 'verified' : 'inactive',
      'isPoliceVerified': approvalStatus == 'approved',
      'approvalStatus': approvalStatus,
      'isApproved': isApproved,
      'isVerifiedMember': isVerifiedMember,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      'documents': documents.map((d) => d.toMap()).toList(),
      if (bankDetails != null) 'bankDetails': bankDetails!.toMap(),
      'languages': languages.map((l) => {
        'languageName': l.languageName,
        'languageCode': l.languageCode,
        'speakingPercent': l.speakingPercent,
        'writingPercent': l.writingPercent,
        'understandingPercent': l.understandingPercent,
      }).toList(),
      'clinicalSkills': clinicalSkills,
      'isMedicalCleared': true,
      'status': 'available',
      // Verification Items
      'profileImageUrl': profileImageUrl,
      'profileImageStatus': profileImageStatus,
      'nicFrontUrl': nicFrontUrl,
      'nicFrontStatus': nicFrontStatus,
      'nicBackUrl': nicBackUrl,
      'nicBackStatus': nicBackStatus,
      'policeReportUrl': policeReportUrl,
      'policeReportStatus': policeReportStatus,
      'qualificationCertUrl': qualificationCertUrl,
      'qualificationCertStatus': qualificationCertStatus,
      'faceVerificationStatus': faceVerificationStatus,
      if (faceVerificationData != null) 'faceVerificationData': faceVerificationData,
      'verificationItems': verificationItems,
    };
  }

  CaregiverUserModel copyWith({
    String? id,
    String? fullName,
    String? staffRegNo,
    String? qualification,
    String? phone,
    String? email,
    String? nic,
    String? address,
    String? bio,
    String? assignedZone,
    double? rating,
    int? completedShiftsThisMonth,
    double? totalEarningsThisMonth,
    double? dailyEarnings,
    double? weeklyEarnings,
    double? dailyRateLKR,
    double? hourlyRateLKR,
    double? pendingPayout,
    bool? isCertifiedFirstAid,
    String? avatarInitials,
    String? verificationStatus,
    String? approvalStatus,
    String? rejectionReason,
    List<LanguageProficiency>? languages,
    List<QualificationDocument>? documents,
    BankAccountDetails? bankDetails,
    List<String>? clinicalSkills,
    String? profileImageUrl,
    String? profileImageStatus,
    String? profileImageRejectionReason,
    String? nicFrontUrl,
    String? nicFrontStatus,
    String? nicBackUrl,
    String? nicBackStatus,
    String? policeReportUrl,
    String? policeReportStatus,
    String? qualificationCertUrl,
    String? qualificationCertStatus,
    String? faceVerificationStatus,
    Map<String, dynamic>? faceVerificationData,
    Map<String, dynamic>? verificationItems,
    bool? isVerifiedMember,
  }) {
    return CaregiverUserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      staffRegNo: staffRegNo ?? this.staffRegNo,
      qualification: qualification ?? this.qualification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nic: nic ?? this.nic,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      assignedZone: assignedZone ?? this.assignedZone,
      rating: rating ?? this.rating,
      completedShiftsThisMonth: completedShiftsThisMonth ?? this.completedShiftsThisMonth,
      totalEarningsThisMonth: totalEarningsThisMonth ?? this.totalEarningsThisMonth,
      dailyEarnings: dailyEarnings ?? this.dailyEarnings,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      dailyRateLKR: dailyRateLKR ?? this.dailyRateLKR,
      hourlyRateLKR: hourlyRateLKR ?? this.hourlyRateLKR,
      pendingPayout: pendingPayout ?? this.pendingPayout,
      isCertifiedFirstAid: isCertifiedFirstAid ?? this.isCertifiedFirstAid,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      languages: languages ?? this.languages,
      documents: documents ?? this.documents,
      bankDetails: bankDetails ?? this.bankDetails,
      clinicalSkills: clinicalSkills ?? this.clinicalSkills,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageStatus: profileImageStatus ?? this.profileImageStatus,
      profileImageRejectionReason: profileImageRejectionReason ?? this.profileImageRejectionReason,
      nicFrontUrl: nicFrontUrl ?? this.nicFrontUrl,
      nicFrontStatus: nicFrontStatus ?? this.nicFrontStatus,
      nicBackUrl: nicBackUrl ?? this.nicBackUrl,
      nicBackStatus: nicBackStatus ?? this.nicBackStatus,
      policeReportUrl: policeReportUrl ?? this.policeReportUrl,
      policeReportStatus: policeReportStatus ?? this.policeReportStatus,
      qualificationCertUrl: qualificationCertUrl ?? this.qualificationCertUrl,
      qualificationCertStatus: qualificationCertStatus ?? this.qualificationCertStatus,
      faceVerificationStatus: faceVerificationStatus ?? this.faceVerificationStatus,
      faceVerificationData: faceVerificationData ?? this.faceVerificationData,
      verificationItems: verificationItems ?? this.verificationItems,
      isVerifiedMember: isVerifiedMember ?? this.isVerifiedMember,
    );
  }
}
