import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrivacyPolicySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final strings = lang.strings;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        22,
        14,
        22,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SafeArea(
        top: false,
        child: Column(
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
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    strings.privacyPolicyFullTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.slate900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.splashCoopSociety,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primaryDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${strings.privacyPolicySection1Header}\n${strings.privacyPolicySection1Body}',
                      style: const TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${strings.privacyPolicySection2Header}\n${strings.privacyPolicySection2Body}',
                      style: const TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${strings.privacyPolicySection3Header}\n${strings.privacyPolicySection3Body}',
                      style: const TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${strings.privacyPolicySection4Header}\n${strings.privacyPolicySection4Body}',
                      style: const TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(strings.iUnderstandBtn, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
