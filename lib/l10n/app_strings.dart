import 'app_language.dart';

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  static AppStrings of(AppLanguage lang) => AppStrings(lang);

  // App & Organization
  String get appTitle {
    switch (language) {
      case AppLanguage.si:
        return 'Prime Life Care';
      case AppLanguage.ta:
        return 'பிரைம் லைஃப் கேர்';
      case AppLanguage.en:
        return 'Prime Life Care';
    }
  }

  String get societyFullName {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රයිම් ලයිෆ් කෙයාර් සමූපකාර සමිතිය';
      case AppLanguage.ta:
        return 'பிரைம் லைஃப் கேர் கூட்டுறவு சங்கம்';
      case AppLanguage.en:
        return 'Prime Life Care Co-operative Society Ltd.';
    }
  }

  String get appMotto {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රජා මූලික සුව සාත්තු සේවාව';
      case AppLanguage.ta:
        return 'சமூக அடிப்படையிலான சுகாதார பராமரிப்பு சேவை';
      case AppLanguage.en:
        return 'Community-Based Healthcare & Nursing';
    }
  }

  // Splash Screen
  String get splashSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'වැඩිහිටි, මාතෘ සහ විශේෂ අවශ්‍යතා සුව සාත්තු ජාලය';
      case AppLanguage.ta:
        return 'முதியோர், தாய் மற்றும் சிறப்பு பராமரிப்பு வலையமைப்பு';
      case AppLanguage.en:
        return 'Elderly, Maternal & Special Care Network';
    }
  }

  String get continueBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පිවිසෙන්න';
      case AppLanguage.ta:
        return 'தொடரவும்';
      case AppLanguage.en:
        return 'Continue to Login';
    }
  }

  // Login Page
  String get loginSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ සාමාජික ගිණුමට පිවිසෙන්න';
      case AppLanguage.ta:
        return 'உங்கள் உறுப்பினர் கணக்கில் உள்நுழையவும்';
      case AppLanguage.en:
        return 'Sign in to your member account';
    }
  }

  String get membershipNumberLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික අංකය';
      case AppLanguage.ta:
        return 'உறுப்பினர் எண்';
      case AppLanguage.en:
        return 'Membership Number';
    }
  }

  String get membershipNumberHint {
    switch (language) {
      case AppLanguage.si:
        return 'උදා: PLC-MEM-1001';
      case AppLanguage.ta:
        return 'உதா: PLC-MEM-1001';
      case AppLanguage.en:
        return 'e.g. PLC-MEM-1001';
    }
  }

  String get membershipNumberError {
    switch (language) {
      case AppLanguage.si:
        return 'කරුණාකර සාමාජික අංකය ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'தயவுசெய்து உறுப்பினர் எண்ணை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Please enter your membership number';
    }
  }

  String get passwordLabel {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය';
      case AppLanguage.ta:
        return 'கடவுச்சொல்';
      case AppLanguage.en:
        return 'Password';
    }
  }

  String get passwordHint {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'கடவுச்சொல்லை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Enter your password';
    }
  }

  String get passwordError {
    switch (language) {
      case AppLanguage.si:
        return 'කරුණාකර මුරපදය ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'தயவுசெய்து கடவுச்சொல்லை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Please enter your password';
    }
  }

  String get privacyPolicyAgreementPrefix {
    switch (language) {
      case AppLanguage.si:
        return 'මම ';
      case AppLanguage.ta:
        return 'நான் ';
      case AppLanguage.en:
        return 'I agree to the ';
    }
  }

  String get privacyPolicyTitle {
    switch (language) {
      case AppLanguage.si:
        return 'රහස්‍යතා ප්‍රතිපත්තිය';
      case AppLanguage.ta:
        return 'தனியுரிமைக் கொள்கை';
      case AppLanguage.en:
        return 'Privacy Policy';
    }
  }

  String get privacyPolicyAgreementSuffix {
    switch (language) {
      case AppLanguage.si:
        return ' කියවා එකඟ වෙමි.';
      case AppLanguage.ta:
        return ' படித்து ஒப்புக்கொள்கிறேன்.';
      case AppLanguage.en:
        return ' & Rules.';
    }
  }

  String get loginBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ඇතුල් වන්න';
      case AppLanguage.ta:
        return 'உள்நுழைக';
      case AppLanguage.en:
        return 'Sign In';
    }
  }

  String get forgotPasswordBtn {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය අමතකද?';
      case AppLanguage.ta:
        return 'கடவுச்சொல் மறந்துவிட்டதா?';
      case AppLanguage.en:
        return 'Forgot Password?';
    }
  }

  String get noAccountPrompt {
    switch (language) {
      case AppLanguage.si:
        return 'තවමත් ගිණුමක් නැද්ද?';
      case AppLanguage.ta:
        return 'இன்னும் கணக்கு இல்லையா?';
      case AppLanguage.en:
        return "Don't have an account?";
    }
  }

  String get registerNowBtn {
    switch (language) {
      case AppLanguage.si:
        return 'අලුතින් ලියාපදිංචි වන්න';
      case AppLanguage.ta:
        return 'புதிதாக பதிவுசெய்க';
      case AppLanguage.en:
        return 'Register Now';
    }
  }

  String get selectLanguage {
    switch (language) {
      case AppLanguage.si:
        return 'භාෂාව තෝරන්න';
      case AppLanguage.ta:
        return 'மொழியை தேர்வு செய்க';
      case AppLanguage.en:
        return 'Select Language';
    }
  }

  String get societyFooter {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රයිම් ලයිෆ් කෙයාර් සමූපකාර සමිතිය\nසමූපකාර සංවර්ධන දෙපාර්තමේන්තුව • 0705001122';
      case AppLanguage.ta:
        return 'பிரைம் லைஃப் கேர் கூட்டுறவு சங்கம்\nகூட்டுறவு அபிவிருத்தி திணைக்களம் • 0705001122';
      case AppLanguage.en:
        return 'Prime Life Care Co-operative Society Ltd.\nDept. of Co-operative Development • 0705001122';
    }
  }

  // Register Page
  String get registerPageTitle {
    switch (language) {
      case AppLanguage.si:
        return 'නව සාමාජික ලියාපදිංචිය';
      case AppLanguage.ta:
        return 'புதிய உறுப்பினர் பதிவு';
      case AppLanguage.en:
        return 'Member Registration';
    }
  }

  String get registerSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'සමූපකාර සුව සාත්තු ජාලයේ සාමාජිකයෙකු වන්න';
      case AppLanguage.ta:
        return 'கூட்டுறவு சுகாதார பராமரிப்பு நெட்வொர்க்கில் சேரவும்';
      case AppLanguage.en:
        return 'Join the Co-operative Healthcare Network';
    }
  }

  String get fullNameLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ නම';
      case AppLanguage.ta:
        return 'முழு பெயர்';
      case AppLanguage.en:
        return 'Full Name';
    }
  }

  String get fullNameHint {
    switch (language) {
      case AppLanguage.si:
        return 'මුලකුරු සමඟ නම';
      case AppLanguage.ta:
        return 'ஆரம்ப எழுத்துக்களுடன் பெயர்';
      case AppLanguage.en:
        return 'Name with initials';
    }
  }

  String get nicLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ජාතික හැඳුනුම්පත් අංකය (NIC)';
      case AppLanguage.ta:
        return 'தேசிய அடையாள அட்டை (NIC)';
      case AppLanguage.en:
        return 'National Identity Card (NIC)';
    }
  }

  String get phoneLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දුරකථන අංකය';
      case AppLanguage.ta:
        return 'தொலைபேசி எண்';
      case AppLanguage.en:
        return 'Mobile Phone Number';
    }
  }

  String get addressLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ස්ථිර ලිපිනය';
      case AppLanguage.ta:
        return 'நிரந்தர முகவரி';
      case AppLanguage.en:
        return 'Residential Address';
    }
  }

  String get cityDistrictLabel {
    switch (language) {
      case AppLanguage.si:
        return 'නගරය / දිස්ත්‍රික්කය';
      case AppLanguage.ta:
        return 'நகரம் / மாவட்டம்';
      case AppLanguage.en:
        return 'City / District';
    }
  }

  String get membershipTypeLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජිකත්ව කාණ්ඩය';
      case AppLanguage.ta:
        return 'உறுப்பினர் பிரிவு';
      case AppLanguage.en:
        return 'Membership Category';
    }
  }

  String get catBeneficiary {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු සේවාලාභී පවුලක් (Patient Family)';
      case AppLanguage.ta:
        return 'பராமரிப்பு பெறும் குடும்பம் (Patient Family)';
      case AppLanguage.en:
        return 'Care Beneficiary Family';
    }
  }

  String get catGeneral {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාන්‍ය සමූපකාර සාමාජික (General Member)';
      case AppLanguage.ta:
        return 'பொது கூட்டுறவு உறுப்பினர் (General Member)';
      case AppLanguage.en:
        return 'General Co-operative Member';
    }
  }

  String get catCaregiver {
    switch (language) {
      case AppLanguage.si:
        return 'වෘත්තීය සාත්තු සේවක/හෙද (Caregiver/Nurse)';
      case AppLanguage.ta:
        return 'தொழில்முறை பராமரிப்பாளர்/நர்ஸ் (Caregiver)';
      case AppLanguage.en:
        return 'Professional Caregiver / Nurse';
    }
  }

  String get confirmPasswordLabel {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය නැවත තහවුරු කරන්න';
      case AppLanguage.ta:
        return 'கடவுச்சொல்லை மீண்டும் உறுதிப்படுத்தவும்';
      case AppLanguage.en:
        return 'Confirm Password';
    }
  }

  String get submitRegisterBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ලියාපදිංචි වන්න';
      case AppLanguage.ta:
        return 'பதிவு செய்யவும்';
      case AppLanguage.en:
        return 'Complete Registration';
    }
  }

  String get alreadyHaveAccount {
    switch (language) {
      case AppLanguage.si:
        return 'දැනටමත් ගිණුමක් තිබේද?';
      case AppLanguage.ta:
        return 'ஏற்கனவே கணக்கு உள்ளதா?';
      case AppLanguage.en:
        return 'Already have an account?';
    }
  }

  // Forgot Password Page
  String get forgotPasswordPageTitle {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය නැවත සකසන්න';
      case AppLanguage.ta:
        return 'கடவுச்சொல்லை மீட்டமைக்க';
      case AppLanguage.en:
        return 'Reset Password';
    }
  }

  String get forgotPasswordInstructions {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ සාමාජික අංකය හෝ ලියාපදිංචි දුරකථන අංකය ඇතුළත් කරන්න.';
      case AppLanguage.ta:
        return 'உங்கள் உறுப்பினர் எண் அல்லது பதிவுசெய்த தொலைபேசி எண்ணை உள்ளிடவும்.';
      case AppLanguage.en:
        return 'Enter your Membership ID or registered mobile phone number.';
    }
  }

  String get memberIdOrPhone {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික අංකය හෝ දුරකථන අංකය';
      case AppLanguage.ta:
        return 'உறுப்பினர் எண் அல்லது தொலைபேசி';
      case AppLanguage.en:
        return 'Membership ID or Mobile Phone';
    }
  }

  String get sendOtpBtn {
    switch (language) {
      case AppLanguage.si:
        return 'OTP කේතය ලබා ගන්න';
      case AppLanguage.ta:
        return 'OTP பெறுக';
      case AppLanguage.en:
        return 'Send Verification Code (OTP)';
    }
  }

  String get backBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ආපසු';
      case AppLanguage.ta:
        return 'பின்செல்க';
      case AppLanguage.en:
        return 'Back';
    }
  }

  String get registrationSuccessTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ලියාපදිංචිය සාර්ථකයි!';
      case AppLanguage.ta:
        return 'பதிவு வெற்றிகரமாக முடிந்தது!';
      case AppLanguage.en:
        return 'Registration Successful!';
    }
  }

  String get yourMemberId {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ නව සාමාජික අංකය';
      case AppLanguage.ta:
        return 'உங்கள் புதிய உறுப்பினர் எண்';
      case AppLanguage.en:
        return 'Your New Membership Number';
    }
  }

  String get proceedToLogin {
    switch (language) {
      case AppLanguage.si:
        return 'Login පිටුවට පිවිසෙන්න';
      case AppLanguage.ta:
        return 'உள்நுழைவுப் பக்கத்திற்குச் செல்க';
      case AppLanguage.en:
        return 'Proceed to Login';
    }
  }
}
