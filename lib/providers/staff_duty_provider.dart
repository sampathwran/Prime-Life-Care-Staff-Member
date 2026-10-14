import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/caregiver_user_model.dart';
import '../models/patient_duty_model.dart';
import '../models/vitals_entry_model.dart';
import '../models/bed_turn_model.dart';
import '../models/care_task_model.dart';
import '../models/shift_roster_model.dart';

class StaffDutyProvider extends ChangeNotifier {
  // Pre-configured Staff Profiles for instant demo testing
  final List<CaregiverUserModel> availableStaff = [
    const CaregiverUserModel(
      id: 'staff-01',
      fullName: 'Sister Chamila Perera',
      staffRegNo: 'PLC-NVQ4-018',
      qualification: 'NVQ Level 4 Elderly Care Aide',
      phone: '0778123456',
      email: 'chamila.care@primelifecare.lk',
      assignedZone: 'Chilaw - Marawila District',
      rating: 4.9,
      completedShiftsThisMonth: 18,
      totalEarningsThisMonth: 94500.0,
      avatarInitials: 'CP',
    ),
    const CaregiverUserModel(
      id: 'staff-02',
      fullName: 'Nurse Sunimal Wickramasinghe',
      staffRegNo: 'PLC-NVQ5-004',
      qualification: 'NVQ Level 5 Home Nursing Specialist',
      phone: '0714987654',
      email: 'sunimal.nurse@primelifecare.lk',
      assignedZone: 'Negombo - Katunayake Zone',
      rating: 4.95,
      completedShiftsThisMonth: 15,
      totalEarningsThisMonth: 82500.0,
      avatarInitials: 'SW',
    ),
    const CaregiverUserModel(
      id: 'staff-03',
      fullName: 'Dilrukshi Fernando',
      staffRegNo: 'PLC-NVQ4-029',
      qualification: 'NVQ Level 4 Palliative Care Assistant',
      phone: '0765551234',
      email: 'dilrukshi.f@primelifecare.lk',
      assignedZone: 'Wennappuwa - Nattandiya',
      rating: 4.85,
      completedShiftsThisMonth: 12,
      totalEarningsThisMonth: 58000.0,
      avatarInitials: 'DF',
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

  StaffDutyProvider() {
    _currentStaff = availableStaff[0];
    _currentPatient = availablePatients[0];
    _clockInTime = DateTime.now().subtract(_elapsedShiftDuration);

    _initSampleData();
    _startLiveTicker();
  }

  // Getters
  CaregiverUserModel get currentStaff => _currentStaff;
  PatientDutyModel get currentPatient => _currentPatient;
  bool get isClockedIn => _isClockedIn;
  DateTime? get clockInTime => _clockInTime;
  Duration get elapsedShiftDuration => _elapsedShiftDuration;
  List<BedTurnModel> get bedTurns => List.unmodifiable(_bedTurns);
  List<VitalsEntryModel> get vitalsLog => List.unmodifiable(_vitalsLog);
  List<CareTaskModel> get todayTasks => List.unmodifiable(_todayTasks);
  List<ShiftRosterModel> get shiftRoster => List.unmodifiable(_shiftRoster);

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

  // Clock In / Clock Out
  void toggleClockIn() {
    if (_isClockedIn) {
      _isClockedIn = false;
      _clockInTime = null;
    } else {
      _isClockedIn = true;
      _clockInTime = DateTime.now();
      _elapsedShiftDuration = Duration.zero;
    }
    notifyListeners();
  }

  // Add Vitals
  void addVitalsEntry(VitalsEntryModel entry) {
    _vitalsLog.insert(0, entry);
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
    notifyListeners();
  }

  // Toggle Care Task
  void toggleCareTask(String taskId) {
    final index = _todayTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _todayTasks[index];
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      notifyListeners();
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

  // Initialize realistic mock data for bedside care
  void _initSampleData() {
    final now = DateTime.now();

    // 1. Vitals History
    _vitalsLog.addAll([
      VitalsEntryModel(
        id: 'vit-03',
        patientId: 'pat-001',
        recordedAt: now.subtract(const Duration(minutes: 45)),
        systolicBP: 132,
        diastolicBP: 84,
        bloodSugar: 142.0,
        sugarTiming: '2h Post-Prandial',
        heartRate: 74,
        spO2: 98,
        temperatureC: 36.8,
        respiratoryRate: 18,
        notes: 'Patient calm after morning sponge bath. Ingested 150ml water without coughing.',
        recordedBy: _currentStaff.fullName,
        severity: VitalsSeverity.normal,
      ),
      VitalsEntryModel(
        id: 'vit-02',
        patientId: 'pat-001',
        recordedAt: now.subtract(const Duration(hours: 3, minutes: 30)),
        systolicBP: 146,
        diastolicBP: 92,
        bloodSugar: 178.0,
        sugarTiming: 'Fasting (Morning)',
        heartRate: 82,
        spO2: 96,
        temperatureC: 37.1,
        respiratoryRate: 19,
        notes: 'Morning fasting sugar slightly elevated. Morning Amlodipine & Metformin administered.',
        recordedBy: _currentStaff.fullName,
        severity: VitalsSeverity.warning,
      ),
      VitalsEntryModel(
        id: 'vit-01',
        patientId: 'pat-001',
        recordedAt: now.subtract(const Duration(hours: 12)),
        systolicBP: 128,
        diastolicBP: 80,
        bloodSugar: 135.0,
        sugarTiming: 'Night Check',
        heartRate: 70,
        spO2: 97,
        temperatureC: 36.6,
        respiratoryRate: 16,
        notes: 'Night shift vitals stable, slept peacefully without respiratory distress.',
        recordedBy: 'Nurse Dilrukshi',
        severity: VitalsSeverity.normal,
      ),
    ]);

    // 2. Bed Turning History
    _bedTurns.addAll([
      BedTurnModel(
        id: 'turn-02',
        patientId: 'pat-001',
        turnedAt: _lastBedTurnTime,
        posture: BedPosture.leftLateral,
        skinStatus: SkinStatus.intact,
        diaperChanged: true,
        barrierCreamApplied: true,
        heelsElevated: true,
        notes: 'Repositioned to left side with 30° lumbar wedge. Sacrum checked - no redness observed.',
        performedBy: _currentStaff.fullName,
      ),
      BedTurnModel(
        id: 'turn-01',
        patientId: 'pat-001',
        turnedAt: _lastBedTurnTime.subtract(const Duration(hours: 2)),
        posture: BedPosture.supine,
        skinStatus: SkinStatus.intact,
        diaperChanged: false,
        barrierCreamApplied: true,
        heelsElevated: true,
        notes: 'Pillows placed under calves to float heels. Gentle passive ankle pumps done.',
        performedBy: _currentStaff.fullName,
      ),
    ]);

    // 3. Care Routine Tasks
    _todayTasks.addAll([
      CareTaskModel(
        id: 'tsk-01',
        title: 'Morning Oral Medications',
        timeSlot: '07:30 AM',
        category: TaskCategory.medication,
        instructions: 'Amlodipine 5mg + Metformin 500mg with 50ml warm water after meal',
        isCompleted: true,
        completedAt: now.subtract(const Duration(hours: 3)),
        notes: 'Administered in semi-fowler upright posture safely.',
      ),
      CareTaskModel(
        id: 'tsk-02',
        title: 'Morning Sponge Bath & Linen Change',
        timeSlot: '08:30 AM',
        category: TaskCategory.hygiene,
        instructions: 'Warm water bed bath, antiseptic mouth swab, clean bed sheet & draw-sheet change',
        isCompleted: true,
        completedAt: now.subtract(const Duration(hours: 2)),
        notes: 'Completed. Skin moisturized with sorbolene lotion.',
      ),
      CareTaskModel(
        id: 'tsk-03',
        title: 'Midday Nutritious Porridge & Fluids',
        timeSlot: '12:00 PM',
        category: TaskCategory.nutrition,
        instructions: '250ml pureed oats & veg blend. Check swallowing reflex before each spoonful.',
        isCompleted: false,
      ),
      CareTaskModel(
        id: 'tsk-04',
        title: '2-Hour Pressure Ulcer Turn & Skin Check',
        timeSlot: '01:00 PM',
        category: TaskCategory.physiotherapy,
        instructions: 'Turn to Right Lateral position. Check sacrum, trochanter, and heels for blanching.',
        isCompleted: false,
      ),
      CareTaskModel(
        id: 'tsk-05',
        title: 'Midday Blood Glucose & BP Check',
        timeSlot: '02:00 PM',
        category: TaskCategory.hydration,
        instructions: 'Post-prandial glucometer test + record sitting BP.',
        isCompleted: false,
      ),
      CareTaskModel(
        id: 'tsk-06',
        title: 'Passive Limb Physiotherapy (ROM)',
        timeSlot: '04:00 PM',
        category: TaskCategory.physiotherapy,
        instructions: 'Gentle 15-min passive range of motion on left hemiplegic arm and leg.',
        isCompleted: false,
      ),
      CareTaskModel(
        id: 'tsk-07',
        title: 'Evening Meal & Hydration Record',
        timeSlot: '06:30 PM',
        category: TaskCategory.nutrition,
        instructions: 'Soft dinner, verify total fluid intake is at least 1,200ml for the shift.',
        isCompleted: false,
      ),
      CareTaskModel(
        id: 'tsk-08',
        title: 'Night Medications & Bedside Handover',
        timeSlot: '07:00 PM',
        category: TaskCategory.medication,
        instructions: 'Atorvastatin 20mg at bedtime. Prepare clinical shift report for night caregiver.',
        isCompleted: false,
      ),
    ]);

    // 4. Shift Roster
    _shiftRoster.addAll([
      ShiftRosterModel(
        id: 'sft-01',
        date: now,
        shiftType: ShiftType.day12h,
        status: ShiftStatus.active,
        patientName: 'Mr. Dharmadasa Silva',
        patientLocation: 'Kurunegala Road, Chilaw',
        patientPhone: '0772345678',
        careNotes: 'Bedridden elderly stroke care (Day 12h duty)',
        paymentAmount: 4500.0,
      ),
      ShiftRosterModel(
        id: 'sft-02',
        date: now.add(const Duration(days: 1)),
        shiftType: ShiftType.day12h,
        status: ShiftStatus.upcoming,
        patientName: 'Mr. Dharmadasa Silva',
        patientLocation: 'Kurunegala Road, Chilaw',
        patientPhone: '0772345678',
        careNotes: 'Bedridden elderly stroke care (Day 12h duty)',
        paymentAmount: 4500.0,
      ),
      ShiftRosterModel(
        id: 'sft-03',
        date: now.add(const Duration(days: 2)),
        shiftType: ShiftType.night12h,
        status: ShiftStatus.upcoming,
        patientName: 'Mrs. Mallika Jayasuriya',
        patientLocation: 'Temple Road, Marawila',
        patientPhone: '0719876543',
        careNotes: 'Parkinsonism fall supervision & nighttime assistance',
        paymentAmount: 5500.0,
      ),
      ShiftRosterModel(
        id: 'sft-04',
        date: now.subtract(const Duration(days: 1)),
        shiftType: ShiftType.day12h,
        status: ShiftStatus.completed,
        patientName: 'Mr. Dharmadasa Silva',
        patientLocation: 'Kurunegala Road, Chilaw',
        patientPhone: '0772345678',
        careNotes: 'Completed with 0 pressure sores reported. Family signed duty sheet.',
        paymentAmount: 4500.0,
        isPaid: true,
      ),
      ShiftRosterModel(
        id: 'sft-05',
        date: now.subtract(const Duration(days: 2)),
        shiftType: ShiftType.day12h,
        status: ShiftStatus.completed,
        patientName: 'Mr. Dharmadasa Silva',
        patientLocation: 'Kurunegala Road, Chilaw',
        patientPhone: '0772345678',
        careNotes: 'Completed 12h day shift. Vitals normal throughout.',
        paymentAmount: 4500.0,
        isPaid: true,
      ),
    ]);
  }
}
