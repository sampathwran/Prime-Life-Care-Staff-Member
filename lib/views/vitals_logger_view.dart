import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/vitals_entry_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class VitalsLoggerView extends StatefulWidget {
  const VitalsLoggerView({super.key});

  @override
  State<VitalsLoggerView> createState() => _VitalsLoggerViewState();
}

class _VitalsLoggerViewState extends State<VitalsLoggerView> {
  void _openAddVitalsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _BedsideVitalsEntrySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final vitalsList = provider.vitalsLog;
    final patient = provider.currentPatient;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.bedsideVitalsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppTheme.primaryBlue, size: 28),
            onPressed: () => _openAddVitalsDialog(context),
            tooltip: strings.recordVitalsTooltip,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Info Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.badge_rounded, color: AppTheme.primaryBlue, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${patient.fullName} (${patient.age}y)',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppTheme.slate900,
                          ),
                        ),
                        Text(
                          'Blood Group: ${patient.bloodGroup} • Care: ${patient.careCategory}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Record CTA Button
            ElevatedButton.icon(
              onPressed: () => _openAddVitalsDialog(context),
              icon: const Icon(Icons.add_chart_rounded, size: 20),
              label: Text(
                strings.recordNewVitalsCta,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),

            // Clinical Reference Guide Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.slate200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.slate600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          strings.clinicalReferenceGuideTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _thresholdChip('BP: Normal <130/85', AppTheme.emeraldGreen),
                      _thresholdChip('BP Alert: >140/90', AppTheme.amber500),
                      _thresholdChip('Sugar: 80-140 mg/dL', AppTheme.emeraldGreen),
                      _thresholdChip('SpO2: ≥95%', AppTheme.emeraldGreen),
                      _thresholdChip('Temp: 36.5°C - 37.3°C', AppTheme.emeraldGreen),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vitals History Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    strings.recordedVitalsHistoryTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.slate900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  strings.recordsCount(vitalsList.length),
                  style: const TextStyle(fontSize: 12, color: AppTheme.slate500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (vitalsList.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.slate200),
                ),
                child: Text(strings.noVitalsFound),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vitalsList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = vitalsList[index];
                  return _VitalsHistoryCard(vitals: item);
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _thresholdChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _VitalsHistoryCard extends StatelessWidget {
  final VitalsEntryModel vitals;

  const _VitalsHistoryCard({required this.vitals});

  @override
  Widget build(BuildContext context) {
    final isCritical = vitals.severity == VitalsSeverity.critical;
    final isWarning = vitals.severity == VitalsSeverity.warning;

    final badgeColor = isCritical
        ? AppTheme.rose500
        : (isWarning ? AppTheme.amber500 : AppTheme.emeraldGreen);
    final badgeBg = isCritical
        ? AppTheme.rose50
        : (isWarning ? AppTheme.amber50 : AppTheme.emerald50);
    final statusText = isCritical ? 'CRITICAL' : (isWarning ? 'ATTENTION' : 'NORMAL');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCritical
              ? AppTheme.rose500.withValues(alpha: 0.5)
              : (isWarning ? AppTheme.amber500.withValues(alpha: 0.4) : AppTheme.slate200),
          width: isCritical ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time & Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.slate500),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(vitals.recordedAt),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slate900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vitals grid pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _vitalChip('BP', '${vitals.systolicBP}/${vitals.diastolicBP} mmHg',
                  vitals.systolicBP >= 140 || vitals.diastolicBP >= 90),
              _vitalChip('Sugar', '${vitals.bloodSugar.toStringAsFixed(0)} mg/dL (${vitals.sugarTiming})',
                  vitals.bloodSugar > 180 || vitals.bloodSugar < 70),
              _vitalChip('SpO2', '${vitals.spO2}%', vitals.spO2 < 95),
              _vitalChip('Pulse', '${vitals.heartRate} bpm', vitals.heartRate > 100 || vitals.heartRate < 55),
              _vitalChip('Temp', '${vitals.temperatureC.toStringAsFixed(1)}°C', vitals.temperatureC >= 37.8),
              _vitalChip('Resp', '${vitals.respiratoryRate}/min', false),
            ],
          ),

          if (vitals.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.slate50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_rounded, size: 16, color: AppTheme.slate500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vitals.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.slate700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),

          Text(
            'Recorded by: ${vitals.recordedBy}',
            style: const TextStyle(fontSize: 11, color: AppTheme.slate400),
          ),
        ],
      ),
    );
  }

  Widget _vitalChip(String label, String value, bool isAbnormal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAbnormal ? AppTheme.rose50 : AppTheme.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAbnormal ? AppTheme.rose100 : AppTheme.slate200,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, color: AppTheme.slate700),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isAbnormal ? AppTheme.rose800 : AppTheme.slate500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isAbnormal ? AppTheme.rose800 : AppTheme.slate900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bedside Vitals Entry Bottom Sheet Modal
class _BedsideVitalsEntrySheet extends StatefulWidget {
  const _BedsideVitalsEntrySheet();

  @override
  State<_BedsideVitalsEntrySheet> createState() => _BedsideVitalsEntrySheetState();
}

class _BedsideVitalsEntrySheetState extends State<_BedsideVitalsEntrySheet> {
  final _formKey = GlobalKey<FormState>();

  final _systolicCtrl = TextEditingController(text: '128');
  final _diastolicCtrl = TextEditingController(text: '82');
  final _sugarCtrl = TextEditingController(text: '135');
  final _spO2Ctrl = TextEditingController(text: '98');
  final _heartRateCtrl = TextEditingController(text: '72');
  final _tempCtrl = TextEditingController(text: '36.8');
  final _respRateCtrl = TextEditingController(text: '18');
  final _notesCtrl = TextEditingController();

  String _sugarTiming = '2h Post-Prandial';

  @override
  void dispose() {
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    _sugarCtrl.dispose();
    _spO2Ctrl.dispose();
    _heartRateCtrl.dispose();
    _tempCtrl.dispose();
    _respRateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<StaffDutyProvider>();

      final systolic = int.tryParse(_systolicCtrl.text.trim()) ?? 120;
      final diastolic = int.tryParse(_diastolicCtrl.text.trim()) ?? 80;
      final sugar = double.tryParse(_sugarCtrl.text.trim()) ?? 120.0;
      final spO2 = int.tryParse(_spO2Ctrl.text.trim()) ?? 98;
      final hr = int.tryParse(_heartRateCtrl.text.trim()) ?? 72;
      final tempC = double.tryParse(_tempCtrl.text.trim()) ?? 36.8;
      final resp = int.tryParse(_respRateCtrl.text.trim()) ?? 18;

      final severity = VitalsEntryModel.evaluateSeverity(
        systolic: systolic,
        diastolic: diastolic,
        sugar: sugar,
        spO2: spO2,
        tempC: tempC,
        hr: hr,
      );

      final newEntry = VitalsEntryModel(
        id: 'vit-${DateTime.now().millisecondsSinceEpoch}',
        patientId: provider.currentPatient.id,
        recordedAt: DateTime.now(),
        systolicBP: systolic,
        diastolicBP: diastolic,
        bloodSugar: sugar,
        sugarTiming: _sugarTiming,
        heartRate: hr,
        spO2: spO2,
        temperatureC: tempC,
        respiratoryRate: resp,
        notes: _notesCtrl.text.trim().isEmpty ? 'Bedside vitals recorded successfully.' : _notesCtrl.text.trim(),
        recordedBy: provider.currentStaff.fullName,
        severity: severity,
      );

      provider.addVitalsEntry(newEntry);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            severity == VitalsSeverity.critical
                ? 'CRITICAL ALERT: Vitals outside safe range! Consider notifying supervisor.'
                : 'Bedside vitals logged successfully!',
          ),
          backgroundColor: severity == VitalsSeverity.critical
              ? AppTheme.rose500
              : (severity == VitalsSeverity.warning ? AppTheme.amber500 : AppTheme.emeraldGreen),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.slate200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(Icons.monitor_heart_rounded, color: AppTheme.primaryBlue, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Record Bedside Vitals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.slate900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // BP Row (Systolic / Diastolic)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _systolicCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Systolic BP',
                          suffixText: 'mmHg',
                          prefixIcon: Icon(Icons.favorite_outline_rounded, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _diastolicCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Diastolic BP',
                          suffixText: 'mmHg',
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Blood Sugar & Timing
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _sugarCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Blood Sugar',
                          suffixText: 'mg/dL',
                          prefixIcon: Icon(Icons.bloodtype_outlined, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField<String>(
                        initialValue: _sugarTiming,
                        decoration: const InputDecoration(
                          labelText: 'Timing',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Fasting (Morning)', child: Text('Fasting')),
                          DropdownMenuItem(value: '2h Post-Prandial', child: Text('Post-Meal')),
                          DropdownMenuItem(value: 'Random Check', child: Text('Random')),
                          DropdownMenuItem(value: 'Pre-Bedtime', child: Text('Bedtime')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _sugarTiming = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // SpO2 & Heart Rate
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _spO2Ctrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Oxygen SpO2',
                          suffixText: '%',
                          prefixIcon: Icon(Icons.air_rounded, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _heartRateCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pulse / Heart',
                          suffixText: 'bpm',
                          prefixIcon: Icon(Icons.speed_rounded, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Temperature & Respiratory Rate
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tempCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Temperature',
                          suffixText: '°C',
                          prefixIcon: Icon(Icons.thermostat_outlined, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _respRateCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Respiratory',
                          suffixText: '/min',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Caregiver Bedside Note
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Bedside Observation / Notes',
                    hintText: 'e.g. Ingested fluids safely, conscious & responsive',
                    prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 18),

                // Submit Button
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Vitals Check & Notify System',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
