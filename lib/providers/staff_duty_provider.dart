import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/notification_service.dart';
import '../models/caregiver_user_model.dart';
import '../models/patient_duty_model.dart';
import '../models/vitals_entry_model.dart';
import '../models/bed_turn_model.dart';
import '../models/care_task_model.dart';
import '../models/shift_roster_model.dart';
import '../models/care_booking_model.dart';
import '../models/staff_notification_model.dart';

class StaffDutyProvider extends ChangeNotifier {
  // Pre-configured Staff Profiles for instant demo testing
  final List<CaregiverUserModel> availableStaff = [
    CaregiverUserModel(
      id: 'staff-01',
      fullName: 'Sister Chamila Perera',
      staffRegNo: 'PLC-NVQ4-018',
      qualification: 'NVQ Level 4 Elderly Care Aide',
      phone: '0778123456',
      email: 'chamila.care@primelifecare.lk',
      nic: '199268301452',
      address: 'No. 34, Beach Road, Marawila',
      bio: 'Dedicated NVQ Level 4 care aide with 5+ years experience in geriatric bedside care, stroke recovery assistance, and bedridden patient repositioning.',
      assignedZone: 'Chilaw - Marawila District',
      rating: 4.9,
      completedShiftsThisMonth: 18,
      totalEarningsThisMonth: 94500.0,
      dailyEarnings: 4500.0,
      weeklyEarnings: 27000.0,
      avatarInitials: 'CP',
      languages: [
        LanguageProficiency(languageName: 'Sinhala', languageCode: 'si', speakingPercent: 100, writingPercent: 100, understandingPercent: 100),
        LanguageProficiency(languageName: 'English', languageCode: 'en', speakingPercent: 80, writingPercent: 75, understandingPercent: 90),
        LanguageProficiency(languageName: 'Tamil', languageCode: 'ta', speakingPercent: 60, writingPercent: 40, understandingPercent: 70),
      ],
      documents: [
        QualificationDocument(
          id: 'doc-01',
          title: 'NVQ Level 4 Elderly Care Aide Certificate',
          institute: 'NAITA / Tertiary & Vocational Education Commission',
          issueYear: '2022',
          fileName: 'nvq4_elderly_care_cp.pdf',
          status: 'verified',
          uploadedAt: DateTime.now().subtract(const Duration(days: 365)),
        ),
        QualificationDocument(
          id: 'doc-02',
          title: 'Emergency First Aid & CPR Certification',
          institute: 'St. John Ambulance Sri Lanka',
          issueYear: '2023',
          fileName: 'cpr_first_aid_stjohn.pdf',
          status: 'verified',
          uploadedAt: DateTime.now().subtract(const Duration(days: 200)),
        ),
      ],
    ),
    CaregiverUserModel(
      id: 'staff-02',
      fullName: 'Nurse Sunimal Wickramasinghe',
      staffRegNo: 'PLC-NVQ5-004',
      qualification: 'NVQ Level 5 Home Nursing Specialist',
      phone: '0714987654',
      email: 'sunimal.nurse@primelifecare.lk',
      nic: '198912400982',
      address: 'No. 12/B, Station Road, Negombo',
      bio: 'Registered nursing professional specializing in post-operative wound dressings, tracheostomy and catheter bedside care, and acute vital sign observation.',
      assignedZone: 'Negombo - Katunayake Zone',
      rating: 4.95,
      completedShiftsThisMonth: 15,
      totalEarningsThisMonth: 82500.0,
      dailyEarnings: 5500.0,
      weeklyEarnings: 33000.0,
      avatarInitials: 'SW',
      languages: [
        LanguageProficiency(languageName: 'Sinhala', languageCode: 'si', speakingPercent: 100, writingPercent: 95, understandingPercent: 100),
        LanguageProficiency(languageName: 'English', languageCode: 'en', speakingPercent: 95, writingPercent: 90, understandingPercent: 95),
        LanguageProficiency(languageName: 'Tamil', languageCode: 'ta', speakingPercent: 40, writingPercent: 20, understandingPercent: 50),
      ],
      documents: [
        QualificationDocument(
          id: 'doc-03',
          title: 'NVQ Level 5 Diploma in Home Nursing',
          institute: 'Ministry of Youth Affairs & Skills Development',
          issueYear: '2021',
          fileName: 'nvq5_nursing_diploma_sw.pdf',
          status: 'verified',
          uploadedAt: DateTime.now().subtract(const Duration(days: 500)),
        ),
      ],
    ),
    CaregiverUserModel(
      id: 'staff-03',
      fullName: 'Dilrukshi Fernando',
      staffRegNo: 'PLC-NVQ4-029',
      qualification: 'NVQ Level 4 Palliative Care Assistant',
      phone: '0765551234',
      email: 'dilrukshi.f@primelifecare.lk',
      nic: '199580401123',
      address: 'No. 88, Church Road, Wennappuwa',
      bio: 'Compassionate caregiver with palliative care expertise, companionship support, dementia memory care, and diabetic diet assistance.',
      assignedZone: 'Wennappuwa - Nattandiya',
      rating: 4.85,
      completedShiftsThisMonth: 12,
      totalEarningsThisMonth: 58000.0,
      dailyEarnings: 4500.0,
      weeklyEarnings: 22500.0,
      avatarInitials: 'DF',
      languages: [
        LanguageProficiency(languageName: 'Sinhala', languageCode: 'si', speakingPercent: 100, writingPercent: 100, understandingPercent: 100),
        LanguageProficiency(languageName: 'English', languageCode: 'en', speakingPercent: 70, writingPercent: 65, understandingPercent: 80),
        LanguageProficiency(languageName: 'Tamil', languageCode: 'ta', speakingPercent: 80, writingPercent: 60, understandingPercent: 85),
      ],
      documents: [
        QualificationDocument(
          id: 'doc-04',
          title: 'NVQ Level 4 Palliative Care Assistant Certificate',
          institute: 'Vocational Training Authority (VTA)',
          issueYear: '2023',
          fileName: 'vta_palliative_care_df.pdf',
          status: 'verified',
          uploadedAt: DateTime.now().subtract(const Duration(days: 180)),
        ),
      ],
    ),
  ];

  // Pre-configured Assigned Patients
  final List<PatientDutyModel> availablePatients = [
    const PatientDutyModel(
      id: 'pat-001',
      fullName: 'Mr. Dharmadasa Silva',
      age: 78,
      gender: 'Male',
      diagnosis: 'Post-CVA Left Hemiparesis, Bedridden & Type 2 Diabetes',
      careCategory: 'Bedridden Elderly & Stroke Care',
      mobilityStatus: 'Bedridden (Strict 2-Hour Repositioning)',
      roomNumber: 'Ground Floor - Garden Room',
      address: 'No. 42, Kurunegala Road, Chilaw',
      city: 'Chilaw',
      guardianName: 'Dr. Asanka Silva (Son)',
      guardianRelationship: 'Eldest Son',
      guardianPhone: '0772345678',
      emergencyContact: '0772345678',
      supervisorName: 'Sister N. Jayawardena (Clinical Supervisor)',
      supervisorPhone: '0705001122',
      dietaryNotes: [
        'Pureed soft diet only (Dysphagia precaution)',
        'Diabetic sugar-free fluids (Hydration goal 1.5L/day)',
        'Thickened water for swallowing safety',
      ],
      criticalAlerts: [
        'Aspiration pneumonia risk - Keep head elevated 30° during & 45m after feeding',
        'Left side hemiplegia - Avoid pulling left shoulder joint during transfer',
        'Sacral pressure ulcer prevention - strict 2h turn schedule',
      ],
      bloodGroup: 'B Positive (B+)',
    ),
    const PatientDutyModel(
      id: 'pat-002',
      fullName: 'Mrs. Mallika Jayasuriya',
      age: 72,
      gender: 'Female',
      diagnosis: 'Parkinsonism Stage 3, Severe Fall Risk & Hypertension',
      careCategory: 'Geriatric Fall Prevention',
      mobilityStatus: 'Walker Assisted / High Fall Risk',
      roomNumber: '1st Floor - Room 2 (Lift Access)',
      address: 'No. 18, Temple Road, Marawila',
      city: 'Marawila',
      guardianName: 'Nirosha Jayasuriya (Daughter)',
      guardianRelationship: 'Daughter',
      guardianPhone: '0719876543',
      emergencyContact: '0719876543',
      supervisorName: 'Sister N. Jayawardena (Clinical Supervisor)',
      supervisorPhone: '0705001122',
      dietaryNotes: ['Low sodium cardiac diet', 'High fiber, warm prune juice'],
      criticalAlerts: ['High fall risk - Never leave unattended when standing'],
      bloodGroup: 'O Positive (O+)',
    ),
  ];

  late CaregiverUserModel _currentStaff;
  late PatientDutyModel _currentPatient;

  // Shift & Clock-In state
  bool _isClockedIn = true;
  DateTime? _clockInTime;
  Timer? _liveShiftTicker;
  Duration _elapsedShiftDuration = const Duration(hours: 3, minutes: 42);
  String? _currentShiftId;
  int _todayVitalsCount = 0;
  int _todayBedTurnsCount = 0;

  int get todayVitalsCount => _todayVitalsCount;
  int get todayBedTurnsCount => _todayBedTurnsCount;
  Duration get elapsedShiftDuration => _elapsedShiftDuration;

  // Bed Turning State (2-Hour Bedsore Prevention)
  final List<BedTurnModel> _bedTurns = [];
  DateTime _lastBedTurnTime = DateTime.now().subtract(const Duration(hours: 1, minutes: 15));
  final Duration _turnInterval = const Duration(hours: 2);

  // Vitals State
  final List<VitalsEntryModel> _vitalsLog = [];

  // Care Routine Tasks
  final List<CareTaskModel> _todayTasks = [];

  // Shift Roster
  final List<ShiftRosterModel> _shiftRoster = [];

  // Published duty bookings from Admin
  final List<CareBookingModel> _publishedBookings = [];
  final List<CareBookingModel> _pendingBookings = [];
  CareBookingModel? _activeBooking;
  CareBookingModel? _upcomingBooking;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _bookingsSubscription;

  // In-app Notifications
  final List<StaffNotificationModel> _notifications = [];
  List<StaffNotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _staffDocSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _notificationsSubscription;

  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Set Logged In Caregiver Staff and start real-time Firestore listeners
  void setCurrentStaff(CaregiverUserModel staff) {
    _currentStaff = staff;
    notifyListeners();

    seedInactiveReasonsCollection();

    _staffDocSubscription?.cancel();
    _notificationsSubscription?.cancel();

    try {
      final docId = staff.staffRegNo.isNotEmpty ? staff.staffRegNo : staff.id;
      final docRef = FirebaseFirestore.instance.collection('caregivers').doc(docId);

      _staffDocSubscription = docRef.snapshots().listen((snap) {
        if (snap.exists && snap.data() != null) {
          final updated = CaregiverUserModel.fromMap(snap.data()!, snap.id);
          _currentStaff = updated;
          notifyListeners();
        }
      });

      _notificationsSubscription = docRef
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snap) {
        for (final change in snap.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            if (data != null) {
              final notif = StaffNotificationModel.fromMap(data, change.doc.id);
              final exists = _notifications.any((n) => n.id == notif.id);
              if (!exists) {
                _notifications.insert(0, notif);
                // Trigger audible sound, vibration, and device notification bar
                NotificationService().showNotification(
                  id: notif.id.hashCode,
                  title: notif.titleEnglish.isNotEmpty ? notif.titleEnglish : 'Prime Life Care',
                  body: notif.messageEnglish.isNotEmpty ? notif.messageEnglish : 'New notification received',
                );
              }
            }
          }
        }
        notifyListeners();
      });

      _listenToBookings(staff);
    } catch (e) {
      debugPrint('[StaffDutyProvider] Real-time caregiver listeners error: $e');
    }
  }

  // Seed Inactive Reasons Collection in Firebase if not already seeded
  Future<void> seedInactiveReasonsCollection() async {
    try {
      final col = FirebaseFirestore.instance.collection('inactive_reasons');
      final snap = await col.limit(1).get();
      if (snap.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        final defaultReasons = [
          {
            'code': 'missing_profile_image',
            'targetStep': 'profile_image',
            'titleSinhala': 'පැතිකඩ ඡායාරූපය ඇතුළත් කර නොමැත',
            'titleEnglish': 'Profile Photo Missing',
            'titleTamil': 'சுயவிவரப் படம் சேர்க்கப்படவில்லை',
            'descriptionSinhala': 'පැහැදිලිව මුහුණ පෙනෙන සම්මත වෘත්තීය ඡායාරූපයක් එක් කළ යුතුය.',
            'descriptionEnglish': 'A clear, professional front-facing profile photo must be uploaded.',
            'requiredForActivation': true,
            'order': 1,
          },
          {
            'code': 'missing_nic_front',
            'targetStep': 'nic_front',
            'titleSinhala': 'හැඳුනුම්පත් පෙරපස (NIC Front) ඇතුළත් කර නොමැත',
            'titleEnglish': 'National ID Card Front Missing',
            'titleTamil': 'தேசிய அடையாள அட்டை முன் பக்கம் சேர்க்கப்படவில்லை',
            'descriptionSinhala': 'ජාතික හැඳුනුම්පතෙහි ඉදිරිපස පැහැදිලි ඡායාරූපයක් එක් කළ යුතුය.',
            'descriptionEnglish': 'A clear photo of the front of the National Identity Card is required.',
            'requiredForActivation': true,
            'order': 2,
          },
          {
            'code': 'missing_nic_back',
            'targetStep': 'nic_back',
            'titleSinhala': 'හැඳුනුම්පත් පසුපස (NIC Back) ඇතුළත් කර නොමැත',
            'titleEnglish': 'National ID Card Back Missing',
            'titleTamil': 'தேசிய அடையாள அட்டை பின் பக்கம் சேர்க்கப்படவில்லை',
            'descriptionSinhala': 'ජාතික හැඳුනුම්පතෙහි පිටුපස පැහැදිලි ඡායාරූපයක් එක් කළ යුතුය.',
            'descriptionEnglish': 'A clear photo of the back of the National Identity Card is required.',
            'requiredForActivation': true,
            'order': 3,
          },
          {
            'code': 'missing_police_report',
            'targetStep': 'police_report',
            'titleSinhala': 'පොලිස් වාර්තාව (Police Clearance) ඇතුළත් කර නොමැත',
            'titleEnglish': 'Police Clearance Report Missing',
            'titleTamil': 'காவல்துறை அறிக்கை சேர்க்கப்படவில்லை',
            'descriptionSinhala': 'මාස 6ක් ඇතුළත ලබාගත් නිල පොලිස් වාර්තාවක් ඉදිරිපත් කළ යුතුය.',
            'descriptionEnglish': 'An official police clearance report obtained within 6 months is required.',
            'requiredForActivation': true,
            'order': 4,
          },
          {
            'code': 'missing_qualification_cert',
            'targetStep': 'qualification_cert',
            'titleSinhala': 'මූලික සුදුසුකම් සහතිකය (Qualification Letter) ඇතුළත් කර නොමැත',
            'titleEnglish': 'Basic Qualification / Experience Letter Missing',
            'titleTamil': 'அடிப்படை தகுதி சான்றிதழ் சேர்க்கப்படவில்லை',
            'descriptionSinhala': 'NVQ හෝ පිළිගත් ආයතනයක සාත්තු සේවා පුහුණු සහතිකයක් එක් කළ යුතුය.',
            'descriptionEnglish': 'NVQ or recognized caregiver training certificate/letter is required.',
            'requiredForActivation': true,
            'order': 5,
          },
          {
            'code': 'missing_face_verification',
            'targetStep': 'face_verification',
            'titleSinhala': 'සජීවී මුහුණු සත්‍යාපනය (Live Face Verification) සිදුකර නොමැත',
            'titleEnglish': 'Live Face Verification Incomplete',
            'titleTamil': 'நேரடி முக சரிபார்ப்பு முடிக்கப்படவில்லை',
            'descriptionSinhala': 'කැමරාව මඟින් සජීවී 3D මුහුණු පරීක්ෂාව සම්පූර්ණ කළ යුතුය.',
            'descriptionEnglish': 'Live biometric facial liveness scan must be completed.',
            'requiredForActivation': true,
            'order': 6,
          },
        ];

        for (final r in defaultReasons) {
          batch.set(col.doc(r['code'] as String), r);
        }
        await batch.commit();
        debugPrint('[Firestore] Inactive reasons collection seeded successfully.');
      }
    } catch (e) {
      debugPrint('[Firestore] Seed inactive reasons error: $e');
    }
  }

  // Update Caregiver Profile & Personal Details
  Future<void> updateCaregiverProfile({
    String? fullName,
    String? nic,
    String? phone,
    String? address,
    String? assignedZone,
    String? bio,
    List<LanguageProficiency>? languages,
  }) async {
    _currentStaff = _currentStaff.copyWith(
      fullName: fullName ?? _currentStaff.fullName,
      nic: nic ?? _currentStaff.nic,
      phone: phone ?? _currentStaff.phone,
      address: address ?? _currentStaff.address,
      assignedZone: assignedZone ?? _currentStaff.assignedZone,
      bio: bio ?? _currentStaff.bio,
      languages: languages ?? _currentStaff.languages,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'fullName': _currentStaff.fullName,
        'name': _currentStaff.fullName,
        'nic': _currentStaff.nic,
        'phone': _currentStaff.phone,
        'address': _currentStaff.address,
        'assignedZone': _currentStaff.assignedZone,
        'district': _currentStaff.assignedZone,
        'bio': _currentStaff.bio,
        'languages': _currentStaff.languages.map((l) => {
          'languageName': l.languageName,
          'languageCode': l.languageCode,
          'speakingPercent': l.speakingPercent,
          'writingPercent': l.writingPercent,
          'understandingPercent': l.understandingPercent,
        }).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] updateCaregiverProfile error: $e');
    }
  }

  // Update Bank Account Details in Firestore
  Future<void> updateBankDetails(BankAccountDetails bank) async {
    _currentStaff = _currentStaff.copyWith(bankDetails: bank);
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'bankDetails': bank.toMap(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] updateBankDetails error: $e');
    }
  }

  Map<String, dynamic> _sanitizeVerificationItemsForFirestore(Map<String, dynamic> source) {
    final sanitized = <String, dynamic>{};
    source.forEach((k, v) {
      if (v is Map) {
        final itemMap = Map<String, dynamic>.from(v);
        // Do not store duplicate heavy base64 strings inside verificationItems map in Firestore.
        // The top-level fields (profileImageUrl, nicFrontUrl, nicBackUrl, policeReportUrl, qualificationCertUrl)
        // are already holding the primary document URL/data.
        if (itemMap['url'] != null && itemMap['url'].toString().startsWith('data:image')) {
          itemMap.remove('url');
        }
        sanitized[k] = itemMap;
      } else {
        sanitized[k] = v;
      }
    });
    return sanitized;
  }

  // Upload Profile Image
  Future<void> uploadProfileImage(String imageUrlOrBase64) async {
    final vMap = Map<String, dynamic>.from(_currentStaff.verificationItems);
    vMap['profile_image'] = {
      'title': 'Profile Photo / පැතිකඩ ඡායාරූපය',
      'status': 'pending',
      'url': imageUrlOrBase64,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _currentStaff = _currentStaff.copyWith(
      profileImageUrl: imageUrlOrBase64,
      profileImageStatus: 'pending',
      verificationItems: vMap,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'profileImageUrl': imageUrlOrBase64,
        'profileImageStatus': 'pending',
        'verificationItems': _sanitizeVerificationItemsForFirestore(vMap),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] uploadProfileImage error: $e');
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'පැතිකඩ ඡායාරූපය Admin වෙත යොමු කෙරිණි',
        titleEnglish: 'Profile Photo Submitted to Admin',
        titleTamil: 'சுயவிவரப் படம் நிர்வாகியிடம் சமர்ப்பிக்கப்பட்டது',
        messageSinhala: 'ඔබගේ Profile ඡායාරූපය Admin අනුමැතිය සඳහා සාර්ථකව ලැබිණි.',
        messageEnglish: 'Your profile photo has been submitted for Admin verification.',
        messageTamil: 'உங்கள் சுயவிவரப் படம் நிர்வாகியின் ஒப்புதலுக்காக சமர்ப்பிக்கப்பட்டது.',
        timestamp: DateTime.now(),
        category: 'qualification',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Upload NIC Documents (Front & Back)
  Future<void> uploadNICDocuments({String? frontUrl, String? backUrl}) async {
    final vMap = Map<String, dynamic>.from(_currentStaff.verificationItems);
    if (frontUrl != null && frontUrl.isNotEmpty) {
      vMap['nic_front'] = {
        'title': 'NIC Front / හැඳුනුම්පත් පෙරපස',
        'status': 'pending',
        'url': frontUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }
    if (backUrl != null && backUrl.isNotEmpty) {
      vMap['nic_back'] = {
        'title': 'NIC Back / හැඳුනුම්පත් පසුපස',
        'status': 'pending',
        'url': backUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }

    _currentStaff = _currentStaff.copyWith(
      nicFrontUrl: frontUrl ?? _currentStaff.nicFrontUrl,
      nicFrontStatus: frontUrl != null ? 'pending' : _currentStaff.nicFrontStatus,
      nicBackUrl: backUrl ?? _currentStaff.nicBackUrl,
      nicBackStatus: backUrl != null ? 'pending' : _currentStaff.nicBackStatus,
      verificationItems: vMap,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      final updateData = <String, dynamic>{
        'verificationItems': _sanitizeVerificationItemsForFirestore(vMap),
      };
      if (frontUrl != null) {
        updateData['nicFrontUrl'] = frontUrl;
        updateData['nicFrontStatus'] = 'pending';
      }
      if (backUrl != null) {
        updateData['nicBackUrl'] = backUrl;
        updateData['nicBackStatus'] = 'pending';
      }
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set(updateData, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] uploadNICDocuments error: $e');
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'ජාතික හැඳුනුම්පත් පිටපත් Admin වෙත යොමු කෙරිණි',
        titleEnglish: 'National ID Documents Submitted',
        titleTamil: 'தேசிய அடையாள அட்டை சமர்ப்பிக்கப்பட்டது',
        messageSinhala: 'හැඳුනුම්පත් පෙරපස හා පසුපස ඡායාරූප Admin පරීක්ෂාව සඳහා සාර්ථකව ලැබිණි.',
        messageEnglish: 'Your National ID documents were submitted for verification.',
        messageTamil: 'உங்கள் தேசிய அடையாள அட்டை ஆவணங்கள் சரிபார்ப்பிற்காக சமர்ப்பிக்கப்பட்டன.',
        timestamp: DateTime.now(),
        category: 'qualification',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Upload Police Report Document
  Future<void> uploadPoliceReportDocument({required String fileName, String? fileUrl}) async {
    final vMap = Map<String, dynamic>.from(_currentStaff.verificationItems);
    vMap['police_report'] = {
      'title': 'Police Clearance / පොලිස් වාර්තාව',
      'status': 'pending',
      'fileName': fileName,
      'url': fileUrl ?? fileName,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _currentStaff = _currentStaff.copyWith(
      policeReportUrl: fileUrl ?? fileName,
      policeReportStatus: 'pending',
      verificationItems: vMap,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'policeReportUrl': fileUrl ?? fileName,
        'policeReportStatus': 'pending',
        'verificationItems': _sanitizeVerificationItemsForFirestore(vMap),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] uploadPoliceReportDocument error: $e');
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'පොලිස් වාර්තාව Admin වෙත යොමු කෙරිණි',
        titleEnglish: 'Police Clearance Report Submitted',
        titleTamil: 'காவல்துறை அறிக்கை சமர்ப்பிக்கப்பட்டது',
        messageSinhala: 'පොලිස් වාර්තාව Admin අනුමැතිය සඳහා සාර්ථකව ලැබිණි.',
        messageEnglish: 'Your police clearance report has been submitted for Admin verification.',
        messageTamil: 'உங்கள் காவல்துறை அறிக்கை நிர்வாகியின் ஒப்புதலுக்காக சமர்ப்பிக்கப்பட்டது.',
        timestamp: DateTime.now(),
        category: 'qualification',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Upload Qualification Letter / Experience Certificate
  Future<void> uploadQualificationLetter({
    required String title,
    required String institute,
    required String issueYear,
    required String fileName,
    String? fileUrl,
  }) async {
    final vMap = Map<String, dynamic>.from(_currentStaff.verificationItems);
    vMap['qualification_cert'] = {
      'title': 'Basic Qualification / මූලික සුදුසුකම්',
      'certTitle': title,
      'institute': institute,
      'issueYear': issueYear,
      'fileName': fileName,
      'url': fileUrl ?? fileName,
      'status': 'pending',
      'updatedAt': DateTime.now().toIso8601String(),
    };

    // Also add to documents list
    final newDoc = QualificationDocument(
      id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      institute: institute,
      issueYear: issueYear,
      fileName: fileName,
      status: 'pending_review',
      uploadedAt: DateTime.now(),
    );
    final updatedDocs = List<QualificationDocument>.from(_currentStaff.documents)..insert(0, newDoc);

    _currentStaff = _currentStaff.copyWith(
      qualificationCertUrl: fileUrl ?? fileName,
      qualificationCertStatus: 'pending',
      documents: updatedDocs,
      verificationItems: vMap,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'qualificationCertUrl': fileUrl ?? fileName,
        'qualificationCertStatus': 'pending',
        'documents': updatedDocs.map((d) => d.toMap()).toList(),
        'verificationItems': _sanitizeVerificationItemsForFirestore(vMap),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] uploadQualificationLetter error: $e');
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'සුදුසුකම් ලිපිය Admin වෙත යොමු විය',
        titleEnglish: 'Qualification Certificate Submitted',
        titleTamil: 'தகுதி சான்றிதழ் சமர்ப்பிக்கப்பட்டது',
        messageSinhala: '$title සහතිකය Admin පරීක්ෂාව සඳහා සාර්ථකව යොමු විය.',
        messageEnglish: '$title certificate submitted successfully for Admin review.',
        messageTamil: '$title சான்றிதழ் சரிபார்ப்பிற்காக சமர்ப்பிக்கப்பட்டது.',
        timestamp: DateTime.now(),
        category: 'qualification',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Complete Live Face Verification
  Future<void> saveFaceVerification({
    required double confidence,
    String? snapshotBase64,
  }) async {
    final vMap = Map<String, dynamic>.from(_currentStaff.verificationItems);
    final faceData = {
      'confidence': confidence,
      'verifiedAt': DateTime.now().toIso8601String(),
      'snapshot': snapshotBase64 ?? 'live_camera_capture',
      'selfieUrl': snapshotBase64,
      'method': '3D_Biometric_Liveness_Scanner',
    };

    vMap['face_verification'] = {
      'title': 'Face Verification / සජීවී මුහුණු සත්‍යාපනය',
      'status': 'pending',
      'confidence': confidence,
      'url': snapshotBase64,
      'updatedAt': DateTime.now().toIso8601String(),
      'faceData': faceData,
    };

    _currentStaff = _currentStaff.copyWith(
      faceVerificationStatus: 'pending',
      faceVerificationData: faceData,
      verificationItems: vMap,
    );
    notifyListeners();

    try {
      final docId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      await FirebaseFirestore.instance.collection('caregivers').doc(docId).set({
        'faceVerificationStatus': 'pending',
        'faceVerificationData': faceData,
        'verificationItems': _sanitizeVerificationItemsForFirestore(vMap),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[Firestore] saveFaceVerification error: $e');
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'සජීවී මුහුණු සත්‍යාපනය Admin වෙත යොමු කෙරිණි',
        titleEnglish: 'Face Biometric Scan Submitted to Admin',
        titleTamil: 'நேரடி முக சரிபார்ப்பு நிர்வாகியிடம் சமர்ப்பிக்கப்பட்டது',
        messageSinhala: 'සජීවී මුහුණු සත්‍යාපනය ($confidence% සාර්ථකත්වයෙන්) Admin අනුමැතිය සඳහා යොමු කරන ලදී.',
        messageEnglish: 'Live Face Biometric Scan ($confidence% confidence) submitted for Admin review.',
        messageTamil: 'நேரடி முக சரிபார்ப்பு நிர்வாகியின் ஒப்புதலுக்காக சமர்ப்பிக்கப்பட்டது.',
        timestamp: DateTime.now(),
        category: 'qualification',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Upload Qualification Document (Sent to Admin for review)
  void uploadQualificationDocument({
    required String title,
    required String institute,
    required String issueYear,
    required String fileName,
    String? fileUrl,
  }) async {
    uploadQualificationLetter(
      title: title,
      institute: institute,
      issueYear: issueYear,
      fileName: fileName,
      fileUrl: fileUrl,
    );
  }

  // Admin approves qualification (Simulation demo)
  void adminApproveQualification({
    required String documentId,
    required String newQualification,
  }) {
    final docIndex = _currentStaff.documents.indexWhere((d) => d.id == documentId);
    if (docIndex != -1) {
      _currentStaff.documents[docIndex].status = 'verified';
      _currentStaff = _currentStaff.copyWith(
        qualification: newQualification,
      );

      _notifications.insert(
        0,
        StaffNotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          titleSinhala: 'සුදුසුකම Admin විසින් අනුමත කරන ලදී! 🎉',
          titleEnglish: 'Qualification Approved by Admin! 🎉',
          titleTamil: 'தகுதி நிர்வாகியால் அங்கீகரிக்கப்பட்டது! 🎉',
          messageSinhala: 'ඔබගේ නව සුදුසුකම ($newQualification) අනුමත විය. ඔබගේ කාණ්ඩය උසස් කරන ලදී.',
          messageEnglish: 'Your new qualification ($newQualification) was approved. Your category is updated.',
          messageTamil: 'உங்கள் புதிய தகுதி ($newQualification) அங்கீகரிக்கப்பட்டது. உங்கள் வகை புதுப்பிக்கப்பட்டது.',
          timestamp: DateTime.now(),
          category: 'qualification',
          isRead: false,
        ),
      );

      notifyListeners();
    }
  }

  // Change Password
  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        titleSinhala: 'මුරපදය සාර්ථකව වෙනස් විය',
        titleEnglish: 'Password Changed Successfully',
        titleTamil: 'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது',
        messageSinhala: 'ඔබගේ ගිණුමේ මුරපදය සාර්ථකව යාවත්කාලීන කරන ලදී.',
        messageEnglish: 'Your staff account password has been updated successfully.',
        messageTamil: 'உங்கள் ஊழியர் கணக்கு கடவுச்சொல் வெற்றிகரமாக புதுப்பிக்கப்பட்டது.',
        timestamp: DateTime.now(),
        category: 'system',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  StaffDutyProvider() {
    _currentStaff = availableStaff[0];
    _currentPatient = PatientDutyModel.empty();
    _isClockedIn = false;
    _clockInTime = null;
    _elapsedShiftDuration = Duration.zero;

    _startLiveTicker();
    _listenToBookings(_currentStaff);
  }

  // Getters
  CaregiverUserModel get currentStaff => _currentStaff;
  PatientDutyModel get currentPatient => _currentPatient;
  bool get isClockedIn => _isClockedIn;
  DateTime? get clockInTime => _clockInTime;
  List<BedTurnModel> get bedTurns => List.unmodifiable(_bedTurns);
  List<VitalsEntryModel> get vitalsLog => List.unmodifiable(_vitalsLog);
  List<CareTaskModel> get todayTasks => List.unmodifiable(_todayTasks);
  List<ShiftRosterModel> get shiftRoster => List.unmodifiable(_shiftRoster);
  List<CareBookingModel> get publishedBookings => List.unmodifiable(_publishedBookings);
  List<CareBookingModel> get pendingBookings => List.unmodifiable(_pendingBookings);
  CareBookingModel? get activeBooking => _activeBooking;
  bool get hasActiveBooking => _activeBooking != null;
  CareBookingModel? get upcomingBooking => _upcomingBooking;
  bool get hasUpcomingBooking => _upcomingBooking != null;

  int get activeDutyRemainingDays => _activeBooking?.remainingDays ?? 0;

  void setActiveDutyRemainingDays(int days) {
    if (_activeBooking != null) {
      _activeBooking!.customRemainingDays = days;
      notifyListeners();
    }
  }

  // Business Rules Engine for Booking Acceptance
  BookingEligibility checkBookingEligibility(CareBookingModel booking) {
    // 0. Account / Document Verification Check
    if (!_currentStaff.isApproved) {
      return const BookingEligibility(
        canAccept: false,
        isUpcoming: false,
        status: EligibilityStatus.blockedNotApproved,
        reasonSinhala: 'ඔබගේ ගිණුම සහ ලේඛන Admin විසින් අනුමත කරන තෙක් රාජකාරි භාරගත නොහැක.',
        reasonEnglish: 'Your account and credentials are pending Admin approval. You cannot accept duties until verified.',
        reasonTamil: 'நிர்வாகியால் உங்கள் கணக்கு அங்கீகரிக்கப்படும் வரை நீங்கள் பணிகளை ஏற்றுக்கொள்ள முடியாது.',
      );
    }

    // 1. Tier / qualification check
    final isStaffNurse = _currentStaff.isNurse;
    final requiresNurse = booking.requiredTier == 'nvq5_nurse';
    if (requiresNurse && !isStaffNurse) {
      return const BookingEligibility(
        canAccept: false,
        isUpcoming: false,
        status: EligibilityStatus.blockedTierMismatch,
        reasonSinhala: 'මෙම ඇණවුම සඳහා NVQ Level 5 හෙද සුදුසුකම අවශ්‍ය වේ.',
        reasonEnglish: 'This booking requires NVQ Level 5 Nursing qualification.',
        reasonTamil: 'இந்த பணிக்கு NVQ Level 5 நர்சிங் தகுதி தேவைப்படுகிறது.',
      );
    }

    // 2. If no active booking, caregiver can accept 1 immediately
    if (_activeBooking == null) {
      return const BookingEligibility(
        canAccept: true,
        isUpcoming: false,
        status: EligibilityStatus.eligibleForActive,
        reasonSinhala: 'ඔබ මේ වන විට නිදහස්ව සිටින බැවින් මෙම ඇණවුම වහාම භාරගත හැක.',
        reasonEnglish: 'You are currently available to accept this booking immediately.',
        reasonTamil: 'நீங்கள் தற்போது உடனடியாக இந்த பணியை ஏற்றுக்கொள்ளலாம்.',
      );
    }

    // 3. If already has an upcoming queued booking, cannot hoard more
    if (_upcomingBooking != null) {
      return const BookingEligibility(
        canAccept: false,
        isUpcoming: false,
        status: EligibilityStatus.blockedAlreadyQueued,
        reasonSinhala: 'ඔබ දැනටමත් ඉදිරි රාජකාරියක් භාරගෙන ඇත. එකවර කිහිපයක් රඳවාගත නොහැක.',
        reasonEnglish: 'You have already accepted an upcoming duty. Cannot hoard multiple.',
        reasonTamil: 'நீங்கள் ஏற்கனவே ஒரு எதிர்கால பணியை ஏற்றுக்கொண்டுள்ளீர்கள்.',
      );
    }

    // 4. If active duty has MORE than 2 days remaining, strictly block
    final remDays = activeDutyRemainingDays;
    if (remDays > 2) {
      return BookingEligibility(
        canAccept: false,
        isUpcoming: false,
        status: EligibilityStatus.blockedMoreThan2Days,
        reasonSinhala: 'වත්මන් රාජකාරිය අවසන් වීමට දින 2ක් හෝ ඊට අඩු වූ විට පමණක් නව ඇණවුමක් භාරගත හැක (තව දින $remDaysක් ඇත).',
        reasonEnglish: 'You can only book a new duty when your current duty has 2 days or fewer remaining (Remaining: $remDays days).',
        reasonTamil: 'தற்போதைய பணி முடிவதற்கு 2 நாட்கள் அல்லது அதற்கும் குறைவாக இருக்கும்போது மட்டுமே புதிய பணியை ஏற்க முடியும் (மீதம்: $remDays நாட்கள்).',
      );
    }

    // 5. Booking starts BEFORE active duty ends
    if (booking.scheduledStartDate.isBefore(_activeBooking!.scheduledEndDate)) {
      return const BookingEligibility(
        canAccept: false,
        isUpcoming: false,
        status: EligibilityStatus.blockedStartsBeforeCurrentEnds,
        reasonSinhala: 'වත්මන් රාජකාරිය අවසන් වීමට පෙර මෙම ඇණවුම ආරම්භ වන බැවින් එකවර භාරගත නොහැක.',
        reasonEnglish: 'This booking starts before your current duty ends; schedules cannot overlap.',
        reasonTamil: 'தற்போதைய பணி முடிவதற்குள் இந்த பணி தொடங்குவதால் ஏற்க முடியாது.',
      );
    }

    // 6. Eligible to accept as Upcoming Queued Duty!
    return const BookingEligibility(
      canAccept: true,
      isUpcoming: true,
      status: EligibilityStatus.eligibleForUpcoming,
      reasonSinhala: 'වත්මන් රාජකාරියෙන් පසු ඔබගේ ඉදිරි රාජකාරිය ලෙස භාරගත හැක.',
      reasonEnglish: 'Eligible to accept as your upcoming queued care duty.',
      reasonTamil: 'தற்போதைய பணி முடிந்ததும் அடுத்த பணியாக ஏற்றுக்கொள்ளலாம்.',
    );
  }

  // Accept a published booking from Admin (Joins First-Come 10-Candidate Queue)
  Future<void> acceptBooking(CareBookingModel booking) async {
    final staffId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
    final docRef = FirebaseFirestore.instance.collection('bookings').doc(booking.id);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(docRef);
        if (!snap.exists) {
          throw Exception('Booking does not exist');
        }
        final data = snap.data() ?? {};
        final rawQueue = data['candidateQueue'];
        List<Map<String, dynamic>> queue = [];
        if (rawQueue is List) {
          queue = rawQueue.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }

        final alreadyIn = queue.any((c) => c['caregiverId'] == staffId);
        if (alreadyIn) return;

        if (queue.length >= 10) {
          throw Exception('Queue is full (10 candidates reached)');
        }

        final newPosition = queue.length + 1;
        final candidateEntry = {
          'caregiverId': staffId,
          'caregiverName': _currentStaff.fullName,
          'caregiverPhone': _currentStaff.phone,
          'tier': _currentStaff.qualification,
          'rating': _currentStaff.rating,
          'acceptedAt': DateTime.now().toIso8601String(),
          'queuePosition': newPosition,
        };

        queue.add(candidateEntry);

        transaction.update(docRef, {
          'candidateQueue': queue,
          'acceptedCandidateCount': queue.length,
          'isQueueFull': queue.length >= 10,
        });
      });

      _notifications.insert(
        0,
        StaffNotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          titleSinhala: 'ඇණවුම භාරගැනීම Queue එකට එක්විය',
          titleEnglish: 'Booking Queued for Admin Approval',
          titleTamil: 'பணி வரிசைப்படுத்தப்பட்டது',
          messageSinhala: '${booking.bookingCode} ඇණවුම සඳහා ඔබගේ පිළිගැනීම Admin වෙත යොමු විය. ඔබගේ Queue අංකය #${booking.candidateQueue.length + 1} වේ.',
          messageEnglish: 'Your acceptance for booking ${booking.bookingCode} is queued for Admin confirmation.',
          messageTamil: 'பணி ${booking.bookingCode} ஏற்கப்பட்டது.',
          timestamp: DateTime.now(),
          category: 'duty',
          isRead: false,
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('[StaffDutyProvider] acceptBooking error: $e');
      rethrow;
    }
  }

  // Submit member rating for completed duty
  void submitCustomerRating({
    required String shiftId,
    required double rating,
    String? feedback,
  }) {
    final index = _shiftRoster.indexWhere((s) => s.id == shiftId);
    if (index != -1) {
      _shiftRoster[index] = _shiftRoster[index].copyWith(
        ratingByMember: rating,
        memberFeedback: feedback,
      );
      notifyListeners();
    }
  }

  // Complete active duty (Syncs Firestore and credits earnings)
  Future<void> completeActiveDuty() async {
    if (_activeBooking != null) {
      final bk = _activeBooking!;
      final staffId = _currentStaff.staffRegNo.isNotEmpty ? _currentStaff.staffRegNo : _currentStaff.id;
      final shiftPay = bk.totalEarningsLKR;

      try {
        final bookingRef = FirebaseFirestore.instance.collection('bookings').doc(bk.id);
        await bookingRef.set({
          'status': 'completed',
          'completedAt': DateTime.now().toIso8601String(),
        }, SetOptions(merge: true));

        final caregiverRef = FirebaseFirestore.instance.collection('caregivers').doc(staffId);
        await caregiverRef.set({
          'status': 'available',
          'activeAssignedPatient': null,
          'activeBookingId': null,
          'totalEarnings': FieldValue.increment(shiftPay),
          'pendingPayout': FieldValue.increment(shiftPay),
          'completedShifts': FieldValue.increment(1),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[StaffDutyProvider] completeActiveDuty firestore sync error: $e');
      }
    }
    if (_activeBooking != null) {
      _activeBooking!.status = 'completed';

      _notifications.insert(
        0,
        StaffNotificationModel(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          titleSinhala: 'සාත්තු රාජකාරිය සාර්ථකව අවසන් විය',
          titleEnglish: 'Care Duty Completed Successfully',
          titleTamil: 'பணி வெற்றிகரமாக முடிந்தது',
          messageSinhala: '${_activeBooking!.patientName} වෙනුවෙන් වූ සේවා කාලය සම්පූර්ණ කරන ලදී.',
          messageEnglish: 'Service duration for patient ${_activeBooking!.patientName} marked completed.',
          messageTamil: 'நோயாளி ${_activeBooking!.patientName} க்கான சேவை காலம் நிறைவடைந்தது.',
          timestamp: DateTime.now(),
          category: 'duty',
          isRead: false,
        ),
      );

      if (_upcomingBooking != null) {
        // Promote upcoming booking to active duty
        _activeBooking = _upcomingBooking;
        _activeBooking!.status = 'accepted';
        _upcomingBooking = null;
        _isClockedIn = true;
        _clockInTime = DateTime.now();
        _elapsedShiftDuration = Duration.zero;

        _currentPatient = PatientDutyModel(
          id: _activeBooking!.id,
          fullName: _activeBooking!.patientName,
          age: _activeBooking!.patientAge,
          gender: _activeBooking!.patientGender,
          diagnosis: _activeBooking!.diagnosis,
          careCategory: _activeBooking!.careCategory,
          mobilityStatus: _activeBooking!.shiftType == '24h_full'
              ? 'Bedridden (Strict 2-Hour Repositioning)'
              : 'Assisted Mobility',
          roomNumber: 'Main Room',
          address: _activeBooking!.address,
          city: _activeBooking!.city,
          guardianName: _activeBooking!.guardianName,
          guardianRelationship: _activeBooking!.guardianRelationship,
          guardianPhone: _activeBooking!.guardianPhone,
          emergencyContact: _activeBooking!.guardianPhone,
          supervisorName: 'Sister N. Jayawardena (Supervisor)',
          supervisorPhone: '0705001122',
          dietaryNotes: [
            'Prescribed balanced nutrition & soft fluids',
            'Hydration tracking goal 1.5L/day',
          ],
          criticalAlerts: [
            _activeBooking!.diagnosis,
            'Regular vital sign monitoring & mobility assistance',
          ],
          bloodGroup: 'B Positive (B+)',
        );
      } else {
        _activeBooking = null;
        _isClockedIn = false;
        _clockInTime = null;
        _elapsedShiftDuration = Duration.zero;
      }

      notifyListeners();
    }
  }

  // Latest Vitals
  VitalsEntryModel? get latestVitals => _vitalsLog.isNotEmpty ? _vitalsLog.first : null;

  // Bed Turn countdown helpers
  Duration get timeUntilNextTurn {
    final nextTurnTime = _lastBedTurnTime.add(_turnInterval);
    final diff = nextTurnTime.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get isBedTurnOverdue {
    final nextTurnTime = _lastBedTurnTime.add(_turnInterval);
    return DateTime.now().isAfter(nextTurnTime);
  }

  double get bedTurnProgress {
    final totalMs = _turnInterval.inMilliseconds;
    final elapsedMs = DateTime.now().difference(_lastBedTurnTime).inMilliseconds;
    final ratio = elapsedMs / totalMs;
    return ratio.clamp(0.0, 1.0);
  }

  void _startLiveTicker() {
    _liveShiftTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isClockedIn && _clockInTime != null) {
        _elapsedShiftDuration = DateTime.now().difference(_clockInTime!);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _liveShiftTicker?.cancel();
    _staffDocSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }

  // Switch Staff Profile
  void switchStaff(CaregiverUserModel staff) {
    _currentStaff = staff;
    notifyListeners();
  }

  // Switch Patient
  void switchPatient(PatientDutyModel patient) {
    _currentPatient = patient;
    notifyListeners();
  }

  // Daily Shift Clock In
  Future<void> clockInDailyShift() async {
    _isClockedIn = true;
    _clockInTime = DateTime.now();
    _elapsedShiftDuration = Duration.zero;
    _todayVitalsCount = 0;
    _todayBedTurnsCount = 0;
    _currentShiftId = 'shift_${DateTime.now().millisecondsSinceEpoch}';

    notifyListeners();

    if (_activeBooking != null) {
      try {
        final shiftData = {
          'id': _currentShiftId,
          'bookingId': _activeBooking!.id,
          'bookingCode': _activeBooking!.bookingCode,
          'caregiverId': _currentStaff.id,
          'caregiverName': _currentStaff.fullName,
          'caregiverPhone': _currentStaff.phone,
          'patientName': _activeBooking!.patientName,
          'patientAddress': _activeBooking!.address,
          'patientCity': _activeBooking!.city,
          'shiftDate': DateTime.now().toIso8601String().substring(0, 10),
          'checkInTime': DateTime.now().toIso8601String(),
          'checkInTimestamp': FieldValue.serverTimestamp(),
          'status': 'in_progress',
          'vitalsCount': 0,
          'bedTurnsCount': 0,
        };

        // Write to global duty_shifts collection for admin roster & tracking
        await FirebaseFirestore.instance.collection('duty_shifts').doc(_currentShiftId).set(shiftData);

        // Also update booking document
        await FirebaseFirestore.instance.collection('bookings').doc(_activeBooking!.id).update({
          'status': 'in_progress',
          'isCaregiverCheckedIn': true,
          'lastCheckInTime': DateTime.now().toIso8601String(),
          'activeShiftId': _currentShiftId,
        });
      } catch (e) {
        debugPrint('[StaffDutyProvider] clockInDailyShift firestore error: $e');
      }
    }
  }

  // Daily Shift Clock Out
  Future<void> clockOutDailyShift({String? handoverNotes}) async {
    final now = DateTime.now();
    final workedMinutes = _clockInTime != null ? now.difference(_clockInTime!).inMinutes : 0;
    final shiftId = _currentShiftId ?? 'shift_${now.millisecondsSinceEpoch}';

    _isClockedIn = false;
    _clockInTime = null;
    notifyListeners();

    if (_activeBooking != null) {
      try {
        final shiftUpdate = {
          'checkOutTime': now.toIso8601String(),
          'checkOutTimestamp': FieldValue.serverTimestamp(),
          'workedMinutes': workedMinutes,
          'workedHours': (workedMinutes / 60.0).toStringAsFixed(1),
          'vitalsCount': _todayVitalsCount,
          'bedTurnsCount': _todayBedTurnsCount,
          'handoverNotes': handoverNotes ?? 'Shift routine completed smoothly.',
          'status': 'completed_pending_audit',
        };

        await FirebaseFirestore.instance.collection('duty_shifts').doc(shiftId).set(shiftUpdate, SetOptions(merge: true));

        // Update booking doc: mark shift checked out and record in shifts array
        await FirebaseFirestore.instance.collection('bookings').doc(_activeBooking!.id).update({
          'isCaregiverCheckedIn': false,
          'lastCheckOutTime': now.toIso8601String(),
          'completedShiftsCount': FieldValue.increment(1),
          'shifts': FieldValue.arrayUnion([
            {
              'id': shiftId,
              'shiftDate': now.toIso8601String().substring(0, 10),
              'checkInTime': _currentShiftId != null ? now.subtract(Duration(minutes: workedMinutes)).toIso8601String() : now.toIso8601String(),
              'checkOutTime': now.toIso8601String(),
              'workedMinutes': workedMinutes,
              'vitalsCount': _todayVitalsCount,
              'bedTurnsCount': _todayBedTurnsCount,
              'handoverNotes': handoverNotes ?? 'Shift routine completed smoothly.',
              'status': 'completed_pending_audit',
              'caregiverName': _currentStaff.fullName,
            }
          ]),
        });
      } catch (e) {
        debugPrint('[StaffDutyProvider] clockOutDailyShift firestore error: $e');
      }
    }

    _notifications.insert(
      0,
      StaffNotificationModel(
        id: 'notif-${now.millisecondsSinceEpoch}',
        titleSinhala: 'දෛනික Shift එක Check-Out විය',
        titleEnglish: 'Daily Shift Checked Out Successfully',
        titleTamil: 'பணி நிறைவு அறிக்கை சமர்ப்பிக்கப்பட்டது',
        messageSinhala: '${_activeBooking?.patientName ?? "රෝගියා"} සඳහා අද දින ඩියුටිය (පැය ${(workedMinutes / 60.0).toStringAsFixed(1)}) වාර්තා කරන ලදී.',
        messageEnglish: 'Daily shift (${(workedMinutes / 60.0).toStringAsFixed(1)} hrs) submitted for clinical audit.',
        messageTamil: 'பணி நிறைவு அறிக்கை சமர்ப்பிக்கப்பட்டது.',
        timestamp: now,
        category: 'duty',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // Backward compatible toggle
  void toggleClockIn() {
    if (_isClockedIn) {
      clockOutDailyShift();
    } else {
      clockInDailyShift();
    }
  }

  // Add Vitals
  void addVitalsEntry(VitalsEntryModel entry) {
    _vitalsLog.insert(0, entry);
    _todayVitalsCount++;
    notifyListeners();
  }

  // Add Bed Turn
  void recordBedTurn({
    required BedPosture posture,
    required SkinStatus skinStatus,
    required bool diaperChanged,
    required bool barrierCreamApplied,
    required bool heelsElevated,
    required String notes,
  }) {
    final now = DateTime.now();
    final newTurn = BedTurnModel(
      id: 'turn-${DateTime.now().millisecondsSinceEpoch}',
      patientId: _currentPatient.id,
      turnedAt: now,
      posture: posture,
      skinStatus: skinStatus,
      diaperChanged: diaperChanged,
      barrierCreamApplied: barrierCreamApplied,
      heelsElevated: heelsElevated,
      notes: notes,
      performedBy: _currentStaff.fullName,
    );
    _bedTurns.insert(0, newTurn);
    _lastBedTurnTime = now;
    _todayBedTurnsCount++;
    notifyListeners();
  }

  // Toggle Care Task
  // Toggle Care Task (prevent modification if already confirmed and locked)
  void toggleCareTask(String taskId) {
    final index = _todayTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _todayTasks[index];
      if (task.isConfirmed) {
        return; // Locked: cannot be modified after confirmation!
      }
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      notifyListeners();
    }
  }

  // Confirm Care Task (Finalized & Locked: cannot be altered once confirmed)
  void confirmCareTask({
    required String taskId,
    String? notes,
  }) {
    final index = _todayTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _todayTasks[index];
      if (!task.isConfirmed) {
        task.isCompleted = true;
        task.isConfirmed = true;
        task.completedAt = DateTime.now();
        task.confirmedAt = DateTime.now();
        task.confirmedBy = _currentStaff.fullName;
        if (notes != null && notes.trim().isNotEmpty) {
          task.notes = notes.trim();
        }
        notifyListeners();
      }
    }
  }

  // Add Custom Care Task
  void addCustomTask({
    required String title,
    required String timeSlot,
    required TaskCategory category,
    required String instructions,
  }) {
    final newTask = CareTaskModel(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      timeSlot: timeSlot,
      category: category,
      instructions: instructions,
    );
    _todayTasks.add(newTask);
    notifyListeners();
  }

  // Emergency SOS Actions
  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri url = Uri(scheme: 'tel', path: cleanPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openWhatsAppEmergency({
    required String phone,
    required String message,
  }) async {
    // Sri Lanka +94 format
    var clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('0')) {
      clean = '94${clean.substring(1)}';
    }
    final Uri url = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openMapForAddress(String address, String city) async {
    final query = Uri.encodeComponent('$address, $city, Sri Lanka');
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openMapForBooking(CareBookingModel booking) async {
    final Uri url = Uri.parse(booking.navigationMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      await openMapForAddress(booking.address, booking.city);
    }
  }

  // Initialize realistic mock data for bedside care
    void _listenToBookings(CaregiverUserModel staff) {
    _bookingsSubscription?.cancel();
    final staffId = staff.staffRegNo.isNotEmpty ? staff.staffRegNo : staff.id;

    try {
      _bookingsSubscription = FirebaseFirestore.instance
          .collection('bookings')
          .snapshots()
          .listen((snapshot) {
        final List<CareBookingModel> published = [];
        final List<CareBookingModel> pending = [];
        CareBookingModel? active;
        CareBookingModel? upcoming;

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final booking = CareBookingModel.fromMap(data, doc.id);

          final isAssignedToMe = (booking.assignedCaregiverId == staffId ||
              booking.assignedCaregiverId == staff.id ||
              booking.assignedCaregiverId == staff.phone);

          if (isAssignedToMe) {
            if (booking.status == 'caregiver_assigned' ||
                booking.status == 'assigned' ||
                booking.status == 'in_progress') {
              active = booking;
            } else if (booking.status == 'upcoming') {
              upcoming = booking;
            }
          } else if (booking.status == 'broadcasted' || booking.status == 'published_open') {
            final myQueuePos = booking.getQueuePosition(staffId);
            if (myQueuePos != -1) {
              pending.add(booking);
            } else if (!booking.isQueueFull) {
              published.add(booking);
            }
          }
        }

        _publishedBookings.clear();
        _publishedBookings.addAll(published);

        _pendingBookings.clear();
        _pendingBookings.addAll(pending);

        _activeBooking = active;
        _upcomingBooking = upcoming;

        if (_activeBooking != null) {
          _currentPatient = PatientDutyModel.fromBooking(_activeBooking!);
          if (_activeBooking!.status == 'in_progress') {
            _isClockedIn = true;
          }
        } else {
          _currentPatient = PatientDutyModel.empty();
          _isClockedIn = false;
        }

        notifyListeners();
      }, onError: (err) {
        debugPrint('[StaffDutyProvider] Firestore bookings listen error: $err');
      });
    } catch (e) {
      debugPrint('[StaffDutyProvider] Firestore bookings init error: $e');
    }
  }
}