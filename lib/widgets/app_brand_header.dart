import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class AppBrandHeader extends StatelessWidget {
  final String? pageTitle;
  final String? subtitle;
  final bool showPageTitle;
  final bool showBack;
  final VoidCallback? onBack;
  final bool compact;

  const AppBrandHeader({
    super.key,
    this.pageTitle,
    this.subtitle,
    this.showPageTitle = true,
    this.showBack = false,
    this.onBack,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final logoSize = compact ? 62.0 : 74.0;
    final iconSize = compact ? 30.0 : 36.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBack)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.slate700, size: 20),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              tooltip: lang.strings.backBtn,
            ),
          )
        else
          SizedBox(height: compact ? 4 : 10),

        // Brand Logo Emblem (Official Logo)
        Center(
          child: Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.20),
                  blurRadius: compact ? 12 : 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/app_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_hospital_rounded, color: Colors.white, size: iconSize),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: compact ? 8 : 10),

        // Society Name (Permanent Brand Identity)
        Text(
          'PRIME LIFE CARE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 18 : 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: AppTheme.slate900,
          ),
        ),
        Text(
          lang.strings.societyFullName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
            letterSpacing: 0.2,
          ),
        ),

        // Distinct Page Name Banner (Rendered only when showPageTitle == true and pageTitle is given)
        if (showPageTitle && pageTitle != null) ...[
          SizedBox(height: compact ? 12 : 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.blueLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  pageTitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryDark,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.slate600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
