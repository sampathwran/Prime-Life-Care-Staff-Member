import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class ProfileEarningsView extends StatelessWidget {
  const ProfileEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final staff = provider.currentStaff;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Profile & Credentials'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.slate200),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.primaryBlue,
                    child: Text(
                      staff.avatarInitials,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    staff.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.blueLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      staff.qualification,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reg No: ${staff.staffRegNo} • ${staff.assignedZone}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.slate500),
                  ),
                  const SizedBox(height: 16),

                  // Rating & Certified Badges
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.amber50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppTheme.amber500),
                            const SizedBox(width: 4),
                            Text(
                              '${staff.rating} / 5.0 Rating',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.amber800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.emerald50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 16, color: AppTheme.emeraldGreen),
                            SizedBox(width: 4),
                            Text(
                              'First-Aid Certified',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.emerald800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Earnings Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.slate200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This Month\'s Allowance Breakdown',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _earningsRow(
                    'Completed Care Shifts',
                    '${staff.completedShiftsThisMonth} Shifts',
                  ),
                  const Divider(color: AppTheme.slate100, height: 16),
                  _earningsRow(
                    'Base Shift Allowance',
                    'LKR ${NumberFormat('#,###').format(staff.totalEarningsThisMonth - 4500)}',
                  ),
                  const Divider(color: AppTheme.slate100, height: 16),
                  _earningsRow(
                    'Clinical Incentive & Punctuality Bonus',
                    'LKR 4,500',
                  ),
                  const Divider(color: AppTheme.slate200, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Accrued Allowance',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.slate900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LKR ${NumberFormat('#,###').format(staff.totalEarningsThisMonth)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Demo Persona Switcher Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.switch_account_rounded, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo: Switch Caregiver Role',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Test different staff qualifications and patient duties:',
                    style: TextStyle(fontSize: 12, color: AppTheme.slate600),
                  ),
                  const SizedBox(height: 12),
                  ...provider.availableStaff.map((s) {
                    final isSelected = s.id == staff.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => provider.switchStaff(s),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isSelected ? AppTheme.primaryBlue : AppTheme.slate200,
                                radius: 18,
                                child: Text(
                                  s.avatarInitials,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.slate700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.fullName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: AppTheme.slate900,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s.qualification,
                                      style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: AppTheme.primaryBlue, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _earningsRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppTheme.slate600),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.slate800,
          ),
        ),
      ],
    );
  }
}
