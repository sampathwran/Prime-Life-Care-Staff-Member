import 'package:flutter/material.dart';
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
            const Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'රහස්‍යතා ප්‍රතිපත්තිය සහ කොන්දේසි\n(Privacy Policy & Terms)',
                    style: TextStyle(
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
                  children: const [
                    Text(
                      'Prime Life Care Co-operative Society Ltd.',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primaryDark),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. දත්ත එකතු කිරීම (Data Collection):\n'
                      'අපගේ සමූපකාර සමිතිය විසින් ඔබගේ සාමාජික අංකය, ජාතික හැඳුනුම්පත් අංකය (NIC), දුරකථන අංකය සහ ලිපිනය ආරක්ෂිතව තබා ගන්නා අතර, සෞඛ්‍ය හා සාත්තු සේවා සැපයීමේ අරමුණින් පමණක් භාවිතා කරනු ලැබේ.',
                      style: TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2. රහස්‍යභාවය (Confidentiality):\n'
                      'සාමාජිකයින්ගේ හෝ රෝගීන්ගේ පුද්ගලික හෝ සායනික තොරතුරු කිසිදු තෙවන පාර්ශ්වයකට ලබා නොදේ.',
                      style: TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '3. සාමාජික වගකීම් (Member Responsibilities):\n'
                      'ඔබගේ මුරපදය (Password) කිසිවෙකු සමඟ බෙදා නොගැනීමට වගබලා ගන්න. අනවසර පිවිසීමක් සිදුවුවහොත් වහාම අප කාර්යාලය දැනුවත් කරන්න.',
                      style: TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '4. සමූපකාර විධිවිධාන (Co-operative Compliance):\n'
                      'මෙම යෙදුම පළාත් සමූපකාර සංවර්ධන දෙපාර්තමේන්තුවේ නීති රීති හා විධිවිධාන වලට අනුකූලව පාලනය වේ.',
                      style: TextStyle(fontSize: 12, height: 1.5, color: AppTheme.slate700),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('මම කියවා තේරුම් ගතිමි (I Understand)', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
