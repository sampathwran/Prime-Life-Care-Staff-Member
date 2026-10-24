import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/bed_turn_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class BedTurningView extends StatefulWidget {
  const BedTurningView({super.key});

  @override
  State<BedTurningView> createState() => _BedTurningViewState();
}

class _BedTurningViewState extends State<BedTurningView> {
  BedPosture _selectedPosture = BedPosture.rightLateral;
  SkinStatus _selectedSkinStatus = SkinStatus.intact;
  bool _diaperChanged = true;
  bool _barrierCreamApplied = true;
  bool _heelsElevated = true;
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _recordTurn(BuildContext context) {
    final provider = context.read<StaffDutyProvider>();

    provider.recordBedTurn(
      posture: _selectedPosture,
      skinStatus: _selectedSkinStatus,
      diaperChanged: _diaperChanged,
      barrierCreamApplied: _barrierCreamApplied,
      heelsElevated: _heelsElevated,
      notes: _notesCtrl.text.trim().isEmpty
          ? 'Patient repositioned safely to ${_selectedPosture.label}.'
          : _notesCtrl.text.trim(),
    );

    _notesCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedSkinStatus.requiresAlert
              ? 'WARNING: Skin redness recorded! Ensure continuous offloading.'
              : 'Bed repositioning logged! Next 2-hour timer started.',
        ),
        backgroundColor: _selectedSkinStatus.requiresAlert ? AppTheme.amber500 : AppTheme.emeraldGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final isOverdue = provider.isBedTurnOverdue;
    final timeRemaining = provider.timeUntilNextTurn;
    final turns = provider.bedTurns;
    final patient = provider.currentPatient;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.bedTurningLogTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isOverdue ? AppTheme.rose50 : AppTheme.blueLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOverdue ? AppTheme.rose500.withValues(alpha: 0.4) : AppTheme.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isOverdue ? Icons.timer_off_rounded : Icons.timer_rounded,
                    color: isOverdue ? AppTheme.rose800 : AppTheme.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOverdue ? strings.bedTurnRepositioningOverdue : strings.bedTurnNextIn(timeRemaining.inMinutes),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: isOverdue ? AppTheme.rose800 : AppTheme.primaryBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Patient: ${patient.fullName} • ${patient.mobilityStatus}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.slate700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Form Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.slate200),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select New Patient Posture',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Posture Selector Grid
                  ...BedPosture.values.map((posture) {
                    final isSelected = _selectedPosture == posture;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedPosture = posture),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.blueLight : AppTheme.slate50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryBlue : AppTheme.slate200,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: isSelected ? AppTheme.primaryBlue : AppTheme.slate400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      posture.localizedLabel(langProvider.currentLocale),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: isSelected ? AppTheme.primaryBlue : AppTheme.slate800,
                                      ),
                                    ),
                                    Text(
                                      posture.description,
                                      style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 14),

                  // Skin Status Selector
                  const Text(
                    'Sacrum & Heel Skin Inspection',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<SkinStatus>(
                    initialValue: _selectedSkinStatus,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                    ),
                    items: SkinStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(
                          s.localizedLabel(langProvider.currentLocale),
                          style: TextStyle(
                            fontSize: 13,
                            color: s.requiresAlert ? AppTheme.rose800 : AppTheme.slate900,
                            fontWeight: s.requiresAlert ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSkinStatus = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Bedside checklists
                  const Text(
                    'Bedside Care Checklist',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _checklistTile(
                    'Adult Diaper checked / replaced',
                    _diaperChanged,
                    (val) => setState(() => _diaperChanged = val ?? false),
                  ),
                  _checklistTile(
                    'Moisturizer / Zinc barrier cream applied to pressure points',
                    _barrierCreamApplied,
                    (val) => setState(() => _barrierCreamApplied = val ?? false),
                  ),
                  _checklistTile(
                    'Heels floated off bed surface using pillow elevation',
                    _heelsElevated,
                    (val) => setState(() => _heelsElevated = val ?? false),
                  ),
                  const SizedBox(height: 12),

                  // Caregiver Bedside Note
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Caregiver Observation Note',
                      hintText: 'e.g. Skin intact, patient settled comfortably',
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Save & Start Timer Button
                  ElevatedButton.icon(
                    onPressed: () => _recordTurn(context),
                    icon: const Icon(Icons.check_circle_rounded, size: 20),
                    label: const Text(
                      'Log Repositioning & Reset 2h Timer',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // History Timeline
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Position Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slate900,
                  ),
                ),
                Text(
                  '${turns.length} Turns Completed',
                  style: const TextStyle(fontSize: 12, color: AppTheme.slate500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: turns.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final turn = turns[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.slate200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.blueLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.airline_seat_flat_rounded, color: AppTheme.primaryBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  turn.posture.localizedLabel(langProvider.currentLocale),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.slate900,
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(turn.turnedAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              turn.notes,
                              style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: [
                                if (turn.diaperChanged) _miniBadge('Diaper Changed', AppTheme.emeraldGreen),
                                if (turn.barrierCreamApplied) _miniBadge('Barrier Cream', AppTheme.primaryBlue),
                                if (turn.heelsElevated) _miniBadge('Heels Floating', AppTheme.amber800),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _checklistTile(String title, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppTheme.slate800, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
