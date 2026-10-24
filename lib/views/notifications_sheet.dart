import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

void showStaffNotificationsSheet(
  BuildContext context,
  StaffDutyProvider provider,
  AppStrings strings,
) {
  final langProvider = context.read<LanguageProvider>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_active_rounded, color: AppTheme.primaryBlue, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            strings.notificationsTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          provider.markAllNotificationsAsRead();
                        },
                        child: Text(strings.markAllAsRead, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTheme.slate200),
                Flexible(
                  child: provider.notifications.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.notifications_none_rounded, size: 40, color: AppTheme.slate400),
                                const SizedBox(height: 8),
                                Text(strings.noNotifications, style: const TextStyle(color: AppTheme.slate500)),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.notifications.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, idx) {
                            final notif = provider.notifications[idx];
                            final isRejected = notif.titleEnglish.toLowerCase().contains('reject') ||
                                notif.titleSinhala.contains('ප්‍රතික්ෂේප');

                            return InkWell(
                              onTap: () => provider.markNotificationAsRead(notif.id),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: notif.isRead
                                      ? Colors.white
                                      : isRejected
                                          ? Colors.red.shade50.withValues(alpha: 0.6)
                                          : AppTheme.blueLight.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: notif.isRead
                                        ? AppTheme.slate200
                                        : isRejected
                                            ? Colors.red.shade300
                                            : AppTheme.primaryBlue.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: isRejected
                                          ? Colors.red.shade100
                                          : notif.category == 'qualification'
                                              ? AppTheme.emerald50
                                              : notif.category == 'duty'
                                                  ? AppTheme.blueLight
                                                  : AppTheme.amber50,
                                      child: Icon(
                                        isRejected
                                            ? Icons.warning_amber_rounded
                                            : notif.category == 'qualification'
                                                ? Icons.verified_rounded
                                                : notif.category == 'duty'
                                                    ? Icons.campaign_rounded
                                                    : Icons.payments_rounded,
                                        size: 16,
                                        color: isRejected
                                            ? Colors.red.shade800
                                            : notif.category == 'qualification'
                                                ? AppTheme.emerald800
                                                : notif.category == 'duty'
                                                    ? AppTheme.primaryBlue
                                                    : AppTheme.amber800,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notif.localizedTitle(langProvider.currentLocale),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: notif.isRead ? FontWeight.w700 : FontWeight.w900,
                                              color: isRejected ? Colors.red.shade900 : AppTheme.slate900,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif.localizedMessage(langProvider.currentLocale),
                                            style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(top: 4, left: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isRejected ? Colors.redAccent : AppTheme.primaryBlue,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
