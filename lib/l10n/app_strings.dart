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

  String get firstNameLabel {
    switch (language) {
      case AppLanguage.si:
        return 'මුල් නම (First Name)';
      case AppLanguage.ta:
        return 'முதல் பெயர் (First Name)';
      case AppLanguage.en:
        return 'First Name';
    }
  }

  String get firstNameHint {
    switch (language) {
      case AppLanguage.si:
        return 'මුල් නම ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'முதல் பெயரை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Enter first name';
    }
  }

  String get lastNameLabel {
    switch (language) {
      case AppLanguage.si:
        return 'අවසන් නම / වාසගම (Last Name)';
      case AppLanguage.ta:
        return 'கடைசி பெயர் (Last Name)';
      case AppLanguage.en:
        return 'Last Name';
    }
  }

  String get lastNameHint {
    switch (language) {
      case AppLanguage.si:
        return 'වාසගම ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'கடைசி பெயரை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Enter last name';
    }
  }

  String get emailLabel {
    switch (language) {
      case AppLanguage.si:
        return 'විද්‍යුත් තැපෑල (Email Address)';
      case AppLanguage.ta:
        return 'மின்னஞ்சல் முகவரி (Email Address)';
      case AppLanguage.en:
        return 'Email Address';
    }
  }

  String get emailHint {
    return 'name@example.com';
  }

  String get emailError {
    switch (language) {
      case AppLanguage.si:
        return 'කරුණාකර වලංගු විද්‍යුත් තැපැල් ලිපිනයක් ඇතුළත් කරන්න';
      case AppLanguage.ta:
        return 'செல்லுபடியாகும் மின்னஞ்சல் முகவரியை உள்ளிடவும்';
      case AppLanguage.en:
        return 'Please enter a valid email address';
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

  // Duty Hub & Bookings Flow
  String get availableBookingsTab {
    switch (language) {
      case AppLanguage.si:
        return 'විවෘත ඇණවුම්';
      case AppLanguage.ta:
        return 'கிடைக்கக்கூடிய கோரிக்கைகள்';
      case AppLanguage.en:
        return 'Available Duties';
    }
  }

  String get activeDutyTab {
    switch (language) {
      case AppLanguage.si:
        return 'ක්‍රියාකාරී සාත්තුව';
      case AppLanguage.ta:
        return 'செயலில் உள்ள கடமை';
      case AppLanguage.en:
        return 'Active Duty';
    }
  }

  String get publishedByAdmin {
    switch (language) {
      case AppLanguage.si:
        return 'Admin පළකළ නව සාත්තු ඇණවුම්';
      case AppLanguage.ta:
        return 'நிர்வாகியால் வெளியிடப்பட்ட புதிய கோரிக்கைகள்';
      case AppLanguage.en:
        return 'New Duties Published by Admin';
    }
  }

  String get availableBookingsSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබේ සුදුසුකම් හා පළාතට ගැළපෙන ඇණවුම් මෙතැනින් භාරගන්න';
      case AppLanguage.ta:
        return 'உங்கள் தகுதிக்கு ஏற்ற பணிகளை இங்கிருந்து ஏற்கவும்';
      case AppLanguage.en:
        return 'Accept duty shifts matching your qualification & zone';
    }
  }

  String get acceptBookingBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු සේවය භාරගන්න';
      case AppLanguage.ta:
        return 'பணியை ஏற்கவும்';
      case AppLanguage.en:
        return 'Accept Duty Shift';
    }
  }

  String get bookingAcceptedBadge {
    switch (language) {
      case AppLanguage.si:
        return 'භාරගෙන ඇත';
      case AppLanguage.ta:
        return 'ஏற்கப்பட்டது';
      case AppLanguage.en:
        return 'Accepted';
    }
  }

  String get urgentBookingBadge {
    switch (language) {
      case AppLanguage.si:
        return 'හදිසි අවශ්‍යතාවයක්';
      case AppLanguage.ta:
        return 'அவசர தேவை';
      case AppLanguage.en:
        return 'Urgent Request';
    }
  }

  String get durationDaysLabel {
    switch (language) {
      case AppLanguage.si:
        return 'කාලසීමාව';
      case AppLanguage.ta:
        return 'கால அளவு';
      case AppLanguage.en:
        return 'Duration';
    }
  }

  String get dailyRateLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දිනක ගෙවීම';
      case AppLanguage.ta:
        return 'தினசரி கட்டணம்';
      case AppLanguage.en:
        return 'Daily Rate';
    }
  }

  String get totalEarningsLabel {
    switch (language) {
      case AppLanguage.si:
        return 'මුළු ආදායම';
      case AppLanguage.ta:
        return 'மொத்த வருவாய்';
      case AppLanguage.en:
        return 'Total Pay';
    }
  }

  String get acceptBookingConfirmTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු ඇණවුම භාරගැනීම';
      case AppLanguage.ta:
        return 'பணியை ஏற்றுக்கொள்வது';
      case AppLanguage.en:
        return 'Accept Care Duty';
    }
  }

  String get acceptBookingConfirmDesc {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ මෙම සාත්තු සේවය භාරගැනීමට සූදානම්ද? භාරගත් පසු රෝගියාගේ නිවසට ගොස් සාත්තුව ආරම්භ කළ හැක.';
      case AppLanguage.ta:
        return 'இந்த பராமரிப்பு பணியை ஏற்கத் தயாரா? ஏற்றுக்கொண்ட பிறகு நோயாளியின் இடத்திற்குச் சென்று பணியைத் தொடங்கலாம்.';
      case AppLanguage.en:
        return 'Are you ready to accept this duty? Once accepted, you can proceed to the patient location and begin care.';
    }
  }

  String get confirmAccept {
    switch (language) {
      case AppLanguage.si:
        return 'ඔව්, භාරගන්න';
      case AppLanguage.ta:
        return 'ஆம், ஏற்கவும்';
      case AppLanguage.en:
        return 'Yes, Accept Duty';
    }
  }

  String get noActiveDutyTitle {
    switch (language) {
      case AppLanguage.si:
        return 'දැනට ක්‍රියාකාරී සාත්තුවක් නොමැත';
      case AppLanguage.ta:
        return 'செயலில் உள்ள கடமை எதுவும் இல்லை';
      case AppLanguage.en:
        return 'No Active Duty Currently';
    }
  }

  String get noActiveDutyDesc {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ දැනට කිසිදු සාත්තුවක් භාරගෙන නොමැත. විවෘත ඇණවුම් ලැයිස්තුවෙන් ඔබට ගැළපෙන ඇණවුමක් තෝරාගන්න.';
      case AppLanguage.ta:
        return 'நீங்கள் தற்போது எந்தப் பணியையும் ஏற்கவில்லை. கிடைக்கக்கூடிய கோரிக்கைகளில் இருந்து பொருத்தமான ஒன்றை ஏற்கவும்.';
      case AppLanguage.en:
        return 'You have no active duty. Please select and accept an available booking from the list.';
    }
  }

  String get viewAvailableBookingsBtn {
    switch (language) {
      case AppLanguage.si:
        return 'විවෘත ඇණවුම් බලන්න';
      case AppLanguage.ta:
        return 'கோரிக்கைகளைக் காண்க';
      case AppLanguage.en:
        return 'Browse Available Bookings';
    }
  }

  String get completeDutyBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු මුරය සාර්ථකව අවසන් කරන්න';
      case AppLanguage.ta:
        return 'பணியை வெற்றிகரமாக முடிக்கவும்';
      case AppLanguage.en:
        return 'Complete Duty Shift';
    }
  }

  String get completeDutyConfirmTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු කාලය අවසන් කිරීම';
      case AppLanguage.ta:
        return 'பணி முடிவை உறுதிப்படுத்தவும்';
      case AppLanguage.en:
        return 'Complete Duty Shift';
    }
  }

  String get completeDutyConfirmDesc {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම සාත්තු කාලයේ සියලු කාර්යයන් සහ Vitals සටහන් කර ඇති බව තහවුරු කරන්න. සටහන Admin පද්ධතියට යවනු ලැබේ.';
      case AppLanguage.ta:
        return 'அனைத்து பணிகளும் முக்கிய குறிப்புகளும் பதிவு செய்யப்பட்டுள்ளதை உறுதிப்படுத்தவும். அறிக்கை நிர்வாகிக்கு அனுப்பப்படும்.';
      case AppLanguage.en:
        return 'Confirm that all daily tasks and vitals have been logged. The shift summary will be sent to the Admin Panel.';
    }
  }

  String get dutyCompletedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු මුරය සාර්ථකව අවසන් විය! ගෙවීම ඔබගේ ගිණුමට එකතු කරන ලදී.';
      case AppLanguage.ta:
        return 'பணி வெற்றிகரமாக முடிந்தது! கொடுப்பனவு கணக்கில் சேர்க்கப்பட்டது.';
      case AppLanguage.en:
        return 'Duty completed successfully! Earnings added to your account.';
    }
  }

  // Caregiver Profile & Credentials
  String get profileTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික පැතිකඩ';
      case AppLanguage.ta:
        return 'உறுப்பினர் சுயவிவரம்';
      case AppLanguage.en:
        return 'Member Profile';
    }
  }

  String get editProfile {
    switch (language) {
      case AppLanguage.si:
        return 'තොරතුරු සංස්කරණය';
      case AppLanguage.ta:
        return 'சுயவிவரம் திருத்து';
      case AppLanguage.en:
        return 'Edit Profile';
    }
  }

  String get verifiedMember {
    switch (language) {
      case AppLanguage.si:
        return 'තහවුරු කළ සාමාජික';
      case AppLanguage.ta:
        return 'சரிபார்க்கப்பட்ட உறுப்பினர்';
      case AppLanguage.en:
        return 'Verified Member';
    }
  }

  String get inactiveMember {
    switch (language) {
      case AppLanguage.si:
        return 'අක්‍රීය සාමාජික';
      case AppLanguage.ta:
        return 'செயலற்ற உறுப்பினர்';
      case AppLanguage.en:
        return 'Inactive Member';
    }
  }

  String get verificationPipelineTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික සත්‍යාපනය සහ ලේඛන';
      case AppLanguage.ta:
        return 'உறுப்பினர் சரிபார்ப்பு மற்றும் ஆவணங்கள்';
      case AppLanguage.en:
        return 'Member Verification & Documents';
    }
  }

  String get profilePhotoTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පැතිකඩ ඡායාරූපය';
      case AppLanguage.ta:
        return 'சுயவிவரப் படம்';
      case AppLanguage.en:
        return 'Profile Photo';
    }
  }

  String get nicFrontTitle {
    switch (language) {
      case AppLanguage.si:
        return 'හැඳුනුම්පත් පෙරපස';
      case AppLanguage.ta:
        return 'அடையாள அட்டை முன் பக்கம்';
      case AppLanguage.en:
        return 'National ID Front';
    }
  }

  String get nicBackTitle {
    switch (language) {
      case AppLanguage.si:
        return 'හැඳුනුම්පත් පසුපස';
      case AppLanguage.ta:
        return 'அடையாள அட்டை பின் பக்கம்';
      case AppLanguage.en:
        return 'National ID Back';
    }
  }

  String get policeReportTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පොලිස් වාර්තාව';
      case AppLanguage.ta:
        return 'காவல்துறை அறிக்கை';
      case AppLanguage.en:
        return 'Police Clearance Report';
    }
  }

  String get qualificationCertTitle {
    switch (language) {
      case AppLanguage.si:
        return 'මූලික සුදුසුකම් සහතිකය';
      case AppLanguage.ta:
        return 'அடிப்படை தகுதி சான்றிதழ்';
      case AppLanguage.en:
        return 'Qualification Certificate';
    }
  }

  String get faceVerificationTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සජීවී මුහුණු සත්‍යාපනය';
      case AppLanguage.ta:
        return 'நேரடி முக சரிபார்ப்பு';
      case AppLanguage.en:
        return 'Live Face Verification';
    }
  }

  String get statusApproved {
    switch (language) {
      case AppLanguage.si:
        return 'අනුමතයි ✓';
      case AppLanguage.ta:
        return 'அங்கீகரிக்கப்பட்டது ✓';
      case AppLanguage.en:
        return 'Approved ✓';
    }
  }

  String get statusPending {
    switch (language) {
      case AppLanguage.si:
        return 'සලකා බලමින් ⏳';
      case AppLanguage.ta:
        return 'பரிசீலனையில் ⏳';
      case AppLanguage.en:
        return 'Under Review ⏳';
    }
  }

  String get statusRejected {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රතික්ෂේපිතයි ⚠️';
      case AppLanguage.ta:
        return 'நிராகரிக்கப்பட்டது ⚠️';
      case AppLanguage.en:
        return 'Rejected ⚠️';
    }
  }

  String get statusMissing {
    switch (language) {
      case AppLanguage.si:
        return 'අවශ්‍යයි ✕';
      case AppLanguage.ta:
        return 'தேவை ✕';
      case AppLanguage.en:
        return 'Required ✕';
    }
  }

  String get cameraBtn {
    switch (language) {
      case AppLanguage.si:
        return 'කැමරාව';
      case AppLanguage.ta:
        return 'கேமரா';
      case AppLanguage.en:
        return 'Camera';
    }
  }

  String get galleryBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ගැලරිය';
      case AppLanguage.ta:
        return 'தொகுப்பு';
      case AppLanguage.en:
        return 'Gallery';
    }
  }

  String get nextStepRequired {
    switch (language) {
      case AppLanguage.si:
        return 'ඊළඟට සම්පූර්ණ කළ යුතු පියවර:';
      case AppLanguage.ta:
        return 'அடுத்து முடிக்க வேண்டிய படி:';
      case AppLanguage.en:
        return 'Next Step Required:';
    }
  }

  String get bioLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු පළපුරුද්ද පිළිබඳ විස්තරය';
      case AppLanguage.ta:
        return 'பராமரிப்பு பற்றிய சுயவிவரம்';
      case AppLanguage.en:
        return 'Caregiver Bio & Experience';
    }
  }

  String get ratingLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ශ්‍රේණිගත කිරීම';
      case AppLanguage.ta:
        return 'மதிப்பீடு';
      case AppLanguage.en:
        return 'Rating';
    }
  }


  String get languageProficiencyTitle {
    switch (language) {
      case AppLanguage.si:
        return 'භාෂා ප්‍රවීණතාවය';
      case AppLanguage.ta:
        return 'மொழித் திறன்';
      case AppLanguage.en:
        return 'Language Proficiency';
    }
  }

  String get speaking {
    switch (language) {
      case AppLanguage.si:
        return 'කථා කිරීම';
      case AppLanguage.ta:
        return 'பேசுதல்';
      case AppLanguage.en:
        return 'Speaking';
    }
  }

  String get writing {
    switch (language) {
      case AppLanguage.si:
        return 'ලිවීම';
      case AppLanguage.ta:
        return 'எழுதுதல்';
      case AppLanguage.en:
        return 'Writing';
    }
  }

  String get understanding {
    switch (language) {
      case AppLanguage.si:
        return 'තේරුම් ගැනීම';
      case AppLanguage.ta:
        return 'புரிதல்';
      case AppLanguage.en:
        return 'Understanding';
    }
  }

  String get documentsTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පාඨමාලා සහ වෘත්තීය සහතික';
      case AppLanguage.ta:
        return 'கல்வி மற்றும் தொழில் சான்றிதழ்கள்';
      case AppLanguage.en:
        return 'Certifications & Training Documents';
    }
  }

  String get uploadNewDocument {
    switch (language) {
      case AppLanguage.si:
        return 'නව සහතිකයක් Upload කරන්න';
      case AppLanguage.ta:
        return 'புதிய சான்றிதழைப் பதிவேற்றவும்';
      case AppLanguage.en:
        return 'Upload New Certificate';
    }
  }

  String get verifiedByAdmin {
    switch (language) {
      case AppLanguage.si:
        return 'Admin අනුමතයි';
      case AppLanguage.ta:
        return 'நிர்வாகியால் அங்கீகரிக்கப்பட்டது';
      case AppLanguage.en:
        return 'Verified by Admin';
    }
  }

  String get pendingAdminReview {
    switch (language) {
      case AppLanguage.si:
        return 'Admin පරීක්ෂාව යටතේ';
      case AppLanguage.ta:
        return 'நிர்வாகி பரிசீலனையில்';
      case AppLanguage.en:
        return 'Pending Admin Review';
    }
  }

  String get financialOverview {
    switch (language) {
      case AppLanguage.si:
        return 'මූල්‍ය හා සාත්තු දීමනා සාරාංශය';
      case AppLanguage.ta:
        return 'நிதி மற்றும் கொடுப்பனவு கண்ணோட்டம்';
      case AppLanguage.en:
        return 'Earnings & Financial Overview';
    }
  }

  String get dailyEarnings {
    switch (language) {
      case AppLanguage.si:
        return 'දෛනික දීමනාව';
      case AppLanguage.ta:
        return 'தினசரி கொடுப்பனவு';
      case AppLanguage.en:
        return 'Daily Allowance';
    }
  }

  String get weeklyEarnings {
    switch (language) {
      case AppLanguage.si:
        return 'සතිපතා උපැයීම';
      case AppLanguage.ta:
        return 'வாராந்திர வருவாய்';
      case AppLanguage.en:
        return 'Weekly Earnings';
    }
  }

  String get monthlyEarnings {
    switch (language) {
      case AppLanguage.si:
        return 'මාසික මුළු ආදායම';
      case AppLanguage.ta:
        return 'மாதாந்திர மொத்த வருவாய்';
      case AppLanguage.en:
        return 'Monthly Total';
    }
  }

  String get completedShifts {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ වැඩ';
      case AppLanguage.ta:
        return 'முடிக்கப்பட்ட பணிகள்';
      case AppLanguage.en:
        return 'Completed Shifts';
    }
  }

  String get upcomingDuties {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරියට භාරගෙන ඇති වැඩ';
      case AppLanguage.ta:
        return 'வரவிருக்கும் பணிகள்';
      case AppLanguage.en:
        return 'Upcoming Booked Duties';
    }
  }

  String get pastDuties {
    switch (language) {
      case AppLanguage.si:
        return 'කලින් අවසන් කළ වැඩ';
      case AppLanguage.ta:
        return 'கடந்த கால பணிகள்';
      case AppLanguage.en:
        return 'Past Completed Shifts';
    }
  }

  String get securityAndSettings {
    switch (language) {
      case AppLanguage.si:
        return 'ආරක්ෂාව සහ සැකසුම්';
      case AppLanguage.ta:
        return 'பாதுகாப்பு & அமைப்புகள்';
      case AppLanguage.en:
        return 'Security & Account Settings';
    }
  }

  String get changePassword {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය වෙනස් කරන්න';
      case AppLanguage.ta:
        return 'கடவுச்சொல்லை மாற்றவும்';
      case AppLanguage.en:
        return 'Change Password';
    }
  }

  String get helpAndSupport {
    switch (language) {
      case AppLanguage.si:
        return 'පරිපාලන සහය සහ සජීවී විමසීම්';
      case AppLanguage.ta:
        return 'நிர்வாகி உதவி & நேரடி ஆதரவு';
      case AppLanguage.en:
        return 'Admin Helpline & Live Support';
    }
  }

  String get logout {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුමෙන් ඉවත් වන්න';
      case AppLanguage.ta:
        return 'வெளியேறு';
      case AppLanguage.en:
        return 'Sign Out / Logout';
    }
  }

  String get logoutConfirmTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුමෙන් ඉවත් වීම තහවුරු කරන්න';
      case AppLanguage.ta:
        return 'வெளியேறுவதை உறுதிப்படுத்தவும்';
      case AppLanguage.en:
        return 'Confirm Sign Out';
    }
  }

  String get logoutConfirmDesc {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබට Prime Life Care ගිණුමෙන් ඉවත් වීමට අවශ්‍ය බව තහවුරු කරන්නද?';
      case AppLanguage.ta:
        return 'பிரைம் லைஃப் கேர் கணக்கிலிருந்து வெளியேற விரும்புகிறீர்களா?';
      case AppLanguage.en:
        return 'Are you sure you want to sign out of Prime Life Care?';
    }
  }

  String get notificationsTitle {
    switch (language) {
      case AppLanguage.si:
        return 'දැනුම්දීම්';
      case AppLanguage.ta:
        return 'அறிவிப்புகள்';
      case AppLanguage.en:
        return 'Notifications';
    }
  }

  String get noNotifications {
    switch (language) {
      case AppLanguage.si:
        return 'දැනට නව දැනුම්දීම් නොමැත';
      case AppLanguage.ta:
        return 'புதிய அறிவிப்புகள் எதுவும் இல்லை';
      case AppLanguage.en:
        return 'No notifications at this time';
    }
  }

  String get nonEditableNote {
    switch (language) {
      case AppLanguage.si:
        return 'ආරක්ෂිත හේතූන් මත නම, ඡායාරූපය, ජාතික හැඳුනුම්පත් අංකය සහ ස්ථීර ලිපිනය සංස්කරණය කළ නොහැක.';
      case AppLanguage.ta:
        return 'பாதுகாப்பு காரணங்களுக்காக பெயர், புகைப்படம், அடையாள அட்டை மற்றும் முகவரியை மாற்ற முடியாது.';
      case AppLanguage.en:
        return 'For verification security, Name, Photo, National ID, and Address cannot be edited.';
    }
  }

  // --- PROFILE MENU CATEGORIES & ITEMS ---
  String get professionalSection {
    switch (language) {
      case AppLanguage.si:
        return 'වෘත්තීය තොරතුරු';
      case AppLanguage.ta:
        return 'தொழில்முறை சுயவிவரம்';
      case AppLanguage.en:
        return 'Professional Profile';
    }
  }

  String get earningsAndShiftsSection {
    switch (language) {
      case AppLanguage.si:
        return 'මූල්‍ය සහ වැඩ සටහන';
      case AppLanguage.ta:
        return 'வருவாய் & பணிகள்';
      case AppLanguage.en:
        return 'Earnings & Shifts';
    }
  }

  String get supportAndSecuritySection {
    switch (language) {
      case AppLanguage.si:
        return 'සහය සහ ආරක්ෂාව';
      case AppLanguage.ta:
        return 'ஆதரவு & பாதுகாப்பு';
      case AppLanguage.en:
        return 'Support & Security';
    }
  }

  String get accountActionSection {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුමේ ක්‍රියාකාරකම්';
      case AppLanguage.ta:
        return 'கணக்கு நடவடிக்கைகள்';
      case AppLanguage.en:
        return 'Account Action';
    }
  }

  String get staffIdLabel {
    switch (language) {
      case AppLanguage.si:
        return 'හැඳුනුම් අංකය';
      case AppLanguage.ta:
        return 'பணியாளர் ஐடி';
      case AppLanguage.en:
        return 'Staff ID';
    }
  }

  String get assignedZoneLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සේවා කලාපය';
      case AppLanguage.ta:
        return 'ஒதுக்கப்பட்ட பகுதி';
      case AppLanguage.en:
        return 'Assigned Zone';
    }
  }

  String get certificatesCountLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සහතික පත්‍ර';
      case AppLanguage.ta:
        return 'சான்றிதழ்கள்';
      case AppLanguage.en:
        return 'Certificates';
    }
  }

  String get verifiedBadge {
    switch (language) {
      case AppLanguage.si:
        return 'අනුමතයි';
      case AppLanguage.ta:
        return 'சரிபார்க்கப்பட்டது';
      case AppLanguage.en:
        return 'Verified';
    }
  }

  String get personalDetailsMenuTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පුද්ගලික හා සම්බන්ධතා තොරතුරු';
      case AppLanguage.ta:
        return 'தனிப்பட்ட & தொடர்பு விவரங்கள்';
      case AppLanguage.en:
        return 'Personal & Contact Details';
    }
  }

  String get personalDetailsMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'දුරකථන, ලිපිනය, හැඳුනුම්පත සහ කෙටි විස්තරය';
      case AppLanguage.ta:
        return 'தொலைபேசி, முகவரி, அடையாள அட்டை மற்றும் சுயவிவரம்';
      case AppLanguage.en:
        return 'Phone, Address, NIC, and Bio';
    }
  }

  String get registeredCategoryLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ලියාපදිංචි සුදුසුකම් කාණ්ඩය';
      case AppLanguage.ta:
        return 'பதிவு செய்யப்பட்ட தகுதிப் பிரிவு';
      case AppLanguage.en:
        return 'Registered Category';
    }
  }

  String get editableSectionTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සංස්කරණය කළ හැකි තොරතුරු';
      case AppLanguage.ta:
        return 'திருத்தக்கூடிய தகவல்கள்';
      case AppLanguage.en:
        return 'Editable Information';
    }
  }

  String get bioEmptyHint {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ සාත්තු සේවා පළපුරුද්ද සහ විශේෂඥතා මෙහි සටහන් කරන්න...';
      case AppLanguage.ta:
        return 'உங்கள் பராமரிப்பு அனுபவத்தை உள்ளிடவும்...';
      case AppLanguage.en:
        return 'Enter your care experience and background...';
    }
  }

  String get profileUpdatedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'තොරතුරු සාර්ථකව යාවත්කාලීන විය!';
      case AppLanguage.ta:
        return 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது!';
      case AppLanguage.en:
        return 'Profile updated successfully!';
    }
  }

  String get languageSkillsMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'සිංහල, ඉංග්‍රීසි, දෙමළ භාෂා හැසිරවීම';
      case AppLanguage.ta:
        return 'சிங்களம், ஆங்கிலம், தமிழ் மொழி அறிவு';
      case AppLanguage.en:
        return 'Sinhala, English, Tamil speaking & comprehension';
    }
  }

  String get languageSkillsDesc {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබට කථා කළ හැකි, ලිවිය හැකි සහ තේරුම් ගත හැකි මට්ටම් ප්‍රතිශත (%) ලෙස සකසන්න:';
      case AppLanguage.ta:
        return 'உங்கள் பேசும், எழுதும், மற்றும் புரிந்துகொள்ளும் அளவை அமைக்கவும் (%):';
      case AppLanguage.en:
        return 'Adjust your speaking, writing, and understanding levels (%):';
    }
  }

  String get languagesCountBadge {
    switch (language) {
      case AppLanguage.si:
        return 'භාෂා';
      case AppLanguage.ta:
        return 'மொழிகள்';
      case AppLanguage.en:
        return 'Languages';
    }
  }

  String get languagesSavedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'භාෂා ප්‍රවීණතාවය සාර්ථකව සුරකින ලදී!';
      case AppLanguage.ta:
        return 'மொழித் திறன்கள் வெற்றிகரமாக சேமிக்கப்பட்டன!';
      case AppLanguage.en:
        return 'Language proficiencies saved successfully!';
    }
  }

  String get documentsMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'සුදුසුකම් සහතික පත්‍ර සහ පරිපාලන අනුමැතිය';
      case AppLanguage.ta:
        return 'தகுதிச் சான்றிதழ்கள் மற்றும் நிர்வாக ஒப்புதல்';
      case AppLanguage.en:
        return 'Qualification certificates & verification';
    }
  }

  String get documentsBannerDesc {
    switch (language) {
      case AppLanguage.si:
        return 'පාඨමාලා සහතික පරිපාලනය වෙත යොමු කර ඔබගේ සුදුසුකම් කාණ්ඩය සහ වැටුප් දීමනා උසස් කරගන්න.';
      case AppLanguage.ta:
        return 'உங்கள் தகுதிப் பிரிவு மற்றும் கொடுப்பனவை உயர்த்த சான்றிதழ்களைப் பதிவேற்றவும்.';
      case AppLanguage.en:
        return 'Submit training certificates to upgrade your staff qualification tier.';
    }
  }

  String get verifiedStatusBadge {
    switch (language) {
      case AppLanguage.si:
        return 'අනුමතයි';
      case AppLanguage.ta:
        return 'சரிபார்க்கப்பட்டது';
      case AppLanguage.en:
        return 'Verified';
    }
  }

  String get reviewingStatusBadge {
    switch (language) {
      case AppLanguage.si:
        return 'පරීක්ෂාව යටතේ';
      case AppLanguage.ta:
        return 'பரிசீலனையில்';
      case AppLanguage.en:
        return 'In Review';
    }
  }

  String get demoApproveBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පරිපාලන අනුමැතිය ලබාදීම (නිරූපණය)';
      case AppLanguage.ta:
        return 'நிர்வாக ஒப்புதல் (மாதிரி)';
      case AppLanguage.en:
        return 'Admin Approve & Upgrade (Demo)';
    }
  }

  String get demoApprovedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'සහතිකය අනුමත කර සාමාජික කාණ්ඩය උසස් කරන ලදී!';
      case AppLanguage.ta:
        return 'சான்றிதழ் அங்கீகரிக்கப்பட்டு பிரிவு உயர்த்தப்பட்டது!';
      case AppLanguage.en:
        return 'Document approved and caregiver tier upgraded!';
    }
  }

  String get certTitleLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සහතිකයේ නම හෝ පාඨමාලාව';
      case AppLanguage.ta:
        return 'சான்றிதழ் அல்லது படிப்பு பெயர்';
      case AppLanguage.en:
        return 'Certificate or Course Title';
    }
  }

  String get certInstituteLabel {
    switch (language) {
      case AppLanguage.si:
        return 'හැදෑරූ ආයතනය';
      case AppLanguage.ta:
        return 'பயிற்சி நிறுவனம்';
      case AppLanguage.en:
        return 'Training Institute';
    }
  }

  String get certYearLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ වර්ෂය';
      case AppLanguage.ta:
        return 'முடிக்கப்பட்ட ஆண்டு';
      case AppLanguage.en:
        return 'Year Completed';
    }
  }

  String get changeFileBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ගොනුව මාරු කරන්න';
      case AppLanguage.ta:
        return 'கோப்பை மாற்றவும்';
      case AppLanguage.en:
        return 'Change File';
    }
  }

  String get submitForReviewBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පරීක්ෂාව සඳහා යොමු කරන්න';
      case AppLanguage.ta:
        return 'பரிசீலனைக்கு அனுப்பவும்';
      case AppLanguage.en:
        return 'Submit for Admin Review';
    }
  }

  String get fillAllFieldsAlert {
    switch (language) {
      case AppLanguage.si:
        return 'කරුණාකර සියලු විස්තර සම්පූර්ණ කරන්න.';
      case AppLanguage.ta:
        return 'தயவுசெய்து அனைத்து விவரங்களையும் நிரப்பவும்.';
      case AppLanguage.en:
        return 'Please complete all required fields.';
    }
  }

  String get uploadDocSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'සහතිකය සාර්ථකව පරිපාලනය වෙත යොමු කරන ලදී! පරීක්ෂාවෙන් පසු අනුමත කරනු ලැබේ.';
      case AppLanguage.ta:
        return 'சான்றிதழ் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!';
      case AppLanguage.en:
        return 'Certificate submitted for review! It will be verified shortly.';
    }
  }

  String get financialMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'දෛනික, සතිපතා සහ මාසික උපැයීම් වාර්තාව';
      case AppLanguage.ta:
        return 'தினசரி, வாராந்திர மற்றும் மாதாந்திர வருவாய் அறிக்கை';
      case AppLanguage.en:
        return 'Daily, weekly, and monthly earnings breakdown';
    }
  }

  String get bankAccountDetailsTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ගෙවීම් බැංකු ගිණුම් විස්තර';
      case AppLanguage.ta:
        return 'வங்கிக் கணக்கு விவரங்கள்';
      case AppLanguage.en:
        return 'Direct Deposit Account Details';
    }
  }

  String get bankNameLabel {
    switch (language) {
      case AppLanguage.si:
        return 'බැංකුව';
      case AppLanguage.ta:
        return 'வங்கி';
      case AppLanguage.en:
        return 'Bank';
    }
  }

  String get bankBranchLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ශාඛාව';
      case AppLanguage.ta:
        return 'கிளை';
      case AppLanguage.en:
        return 'Branch';
    }
  }

  String get bankAccountNumberLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුම් අංකය';
      case AppLanguage.ta:
        return 'கணக்கு எண்';
      case AppLanguage.en:
        return 'Account Number';
    }
  }

  String get payoutCycleLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ගෙවීම් චක්‍රය';
      case AppLanguage.ta:
        return 'கொடுப்பனவு அட்டவணை';
      case AppLanguage.en:
        return 'Payout Schedule';
    }
  }

  String get payoutCycleValue {
    switch (language) {
      case AppLanguage.si:
        return 'සෑම සඳුදා දිනකම සෘජු බැංකු තැන්පතු';
      case AppLanguage.ta:
        return 'ஒவ்வொரு திங்கட்கிழமையும் நேரடி வங்கி வைப்பு';
      case AppLanguage.en:
        return 'Every Monday direct bank transfer';
    }
  }

  String get accountStatusLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුම් තත්ත්වය';
      case AppLanguage.ta:
        return 'கணக்கு நிலை';
      case AppLanguage.en:
        return 'Account Status';
    }
  }

  String get accountActiveValue {
    switch (language) {
      case AppLanguage.si:
        return 'සක්‍රීය සහ තහවුරු කළ ගිණුමකි';
      case AppLanguage.ta:
        return 'செயலில் & சரிபார்க்கப்பட்டது';
      case AppLanguage.en:
        return 'Active & Verified';
    }
  }

  String get payoutNotice {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ සියලු සාත්තු දීමනා සෘජුවම බැංකු ගිණුමට බැරවන අතර පරිපාලනය විසින් සතිපතා ගෙවීම් පත්‍රිකා ලබාදේ.';
      case AppLanguage.ta:
        return 'அனைத்து கொடுப்பனவுகளும் நேரடியாக வங்கிக் கணக்கில் வரவு வைக்கப்படும்.';
      case AppLanguage.en:
        return 'All allowances are directly deposited into your bank account with weekly settlement slips.';
    }
  }

  String get dutiesMenuTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු මුර ලේඛනය';
      case AppLanguage.ta:
        return 'பராமரிப்பு பணிப் பட்டியல்';
      case AppLanguage.en:
        return 'Care Duty Shifts & Roster';
    }
  }

  String get dutiesMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරියට ඇති වැඩ සහ සම්පූර්ණ කළ වැඩ ඉතිහාසය';
      case AppLanguage.ta:
        return 'வரவிருக்கும் பணிகள் மற்றும் முடிக்கப்பட்ட பணிகள்';
      case AppLanguage.en:
        return 'Upcoming booked duties and completed shift history';
    }
  }

  String get completedStatusBadge {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණයි';
      case AppLanguage.ta:
        return 'முடிந்தது';
      case AppLanguage.en:
        return 'Completed';
    }
  }

  String get upcomingStatusBadge {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරියට';
      case AppLanguage.ta:
        return 'வரவிருப்பது';
      case AppLanguage.en:
        return 'Upcoming';
    }
  }

  String get noShiftsAvailable {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම කොටසේ සාත්තු මුර වාර්තා නොමැත.';
      case AppLanguage.ta:
        return 'இப்பிரிவில் பணிகள் எதுவும் இல்லை.';
      case AppLanguage.en:
        return 'No shifts recorded in this section.';
    }
  }

  String get notificationsMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'නව සාත්තු මුර, සහතික අනුමැතිය සහ දීමනා';
      case AppLanguage.ta:
        return 'புதிய பணிகள், சான்றிதழ் ஒப்புதல் & கொடுப்பனவுகள்';
      case AppLanguage.en:
        return 'New shift alerts, certificate approvals & payouts';
    }
  }

  String get markAllAsRead {
    switch (language) {
      case AppLanguage.si:
        return 'සියල්ල කියවූ බව සලකුණු කරන්න';
      case AppLanguage.ta:
        return 'அனைத்தையும் படித்ததாகக் குறிக்கவும்';
      case AppLanguage.en:
        return 'Mark all as read';
    }
  }

  String get newBadgeText {
    switch (language) {
      case AppLanguage.si:
        return 'අලුත්';
      case AppLanguage.ta:
        return 'புதிய';
      case AppLanguage.en:
        return 'New';
    }
  }

  String get activeShiftsBadgeText {
    switch (language) {
      case AppLanguage.si:
        return 'ක්‍රියාකාරී';
      case AppLanguage.ta:
        return 'செயலில்';
      case AppLanguage.en:
        return 'Active';
    }
  }

  String get helpSupportMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'සායනික අධීක්ෂකවරියන් හා පරිපාලන සේවය';
      case AppLanguage.ta:
        return 'மருத்துவ மேற்பார்வையாளர்கள் & ஆதரவு';
      case AppLanguage.en:
        return 'Clinical supervisors & administrative helpline';
    }
  }

  String get helpSupportDesc {
    switch (language) {
      case AppLanguage.si:
        return 'Prime Life Care පරිපාලන කණ්ඩායම හා සායනික අධීක්ෂකවරියන් සමග ක්ෂණිකව සම්බන්ධ වන්න:';
      case AppLanguage.ta:
        return 'நிர்வாகக் குழு மற்றும் மேற்பார்வையாளர்களுடன் நேரடியாக இணைக்கவும்:';
      case AppLanguage.en:
        return 'Connect directly with Prime Life Care administrators and clinical supervisors:';
    }
  }

  String get callAdminBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පරිපාලනය අමතන්න';
      case AppLanguage.ta:
        return 'நிர்வாகத்தை அழைக்கவும்';
      case AppLanguage.en:
        return 'Call Helpline';
    }
  }

  String get whatsappAdminBtn {
    switch (language) {
      case AppLanguage.si:
        return 'වට්ස්ඇප් සජීවී සහය';
      case AppLanguage.ta:
        return 'வாட்ஸ்அப் உதவி';
      case AppLanguage.en:
        return 'WhatsApp Support';
    }
  }

  String get sendInquiryTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පණිවිඩයක් යොමු කරන්න';
      case AppLanguage.ta:
        return 'விசாரணை அனுப்பவும்';
      case AppLanguage.en:
        return 'Send an Inquiry';
    }
  }

  String get inquiryHint {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබට ඇති ගැටලුව හෝ විමසීම මෙහි සටහන් කරන්න...';
      case AppLanguage.ta:
        return 'உங்கள் ஆதரவு கோரிக்கையை இங்கே உள்ளிடவும்...';
      case AppLanguage.en:
        return 'Type your message or inquiry here...';
    }
  }

  String get sendInquiryBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පණිවිඩය යවන්න';
      case AppLanguage.ta:
        return 'செய்தியை அனுப்பவும்';
      case AppLanguage.en:
        return 'Send Message';
    }
  }

  String get inquirySentSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ පණිවිඩය පරිපාලනය වෙත සාර්ථකව යොමු විය!';
      case AppLanguage.ta:
        return 'உங்கள் செய்தி வெற்றிகரமாக அனுப்பப்பட்டது!';
      case AppLanguage.en:
        return 'Your message has been sent to the admin team!';
    }
  }

  String get changePasswordMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'ගිණුමේ මුරපදය වෙනස් කර ආරක්ෂා කරගන්න';
      case AppLanguage.ta:
        return 'கணக்கு கடவுச்சொல்லைப் புதுப்பிக்கவும்';
      case AppLanguage.en:
        return 'Update and protect your account password';
    }
  }

  String get appLanguageMenuTitle {
    switch (language) {
      case AppLanguage.si:
        return 'යෙදුමේ භාෂාව';
      case AppLanguage.ta:
        return 'பயன்பாட்டு மொழி';
      case AppLanguage.en:
        return 'App Language';
    }
  }

  String get appLanguageMenuSub {
    switch (language) {
      case AppLanguage.si:
        return 'සිංහල, ඉංග්‍රීසි හෝ දෙමළ භාෂාව තෝරන්න';
      case AppLanguage.ta:
        return 'சிங்களம், ஆங்கிலம் அல்லது தமிழைத் தேர்ந்தெடுக்கவும்';
      case AppLanguage.en:
        return 'Select preferred app language';
    }
  }

  String get sinhalaLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සිංහල';
      case AppLanguage.ta:
        return 'சிங்களம்';
      case AppLanguage.en:
        return 'Sinhala';
    }
  }

  String get englishLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ඉංග්‍රීසි';
      case AppLanguage.ta:
        return 'ஆங்கிலம்';
      case AppLanguage.en:
        return 'English';
    }
  }

  String get tamilLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දෙමළ';
      case AppLanguage.ta:
        return 'தமிழ்';
      case AppLanguage.en:
        return 'Tamil';
    }
  }

  String get currentPasswordLabel {
    switch (language) {
      case AppLanguage.si:
        return 'වත්මන් මුරපදය';
      case AppLanguage.ta:
        return 'தற்போதைய கடவுச்சொல்';
      case AppLanguage.en:
        return 'Current Password';
    }
  }

  String get newPasswordLabel {
    switch (language) {
      case AppLanguage.si:
        return 'නව මුරපදය';
      case AppLanguage.ta:
        return 'புதிய கடவுச்சொல்';
      case AppLanguage.en:
        return 'New Password';
    }
  }

  String get confirmNewPasswordLabel {
    switch (language) {
      case AppLanguage.si:
        return 'නව මුරපදය තහවුරු කරන්න';
      case AppLanguage.ta:
        return 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';
      case AppLanguage.en:
        return 'Confirm New Password';
    }
  }

  String get passwordMismatchAlert {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපද එකිනෙකට නොගැළපේ.';
      case AppLanguage.ta:
        return 'கடவுச்சொற்கள் பொருந்தவில்லை.';
      case AppLanguage.en:
        return 'Passwords do not match.';
    }
  }

  String get passwordChangedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය සාර්ථකව වෙනස් කරන ලදී!';
      case AppLanguage.ta:
        return 'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது!';
      case AppLanguage.en:
        return 'Password changed successfully!';
    }
  }

  String get savePasswordBtn {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය සුරකින්න';
      case AppLanguage.ta:
        return 'கடவுச்சொல்லைச் சேமிக்கவும்';
      case AppLanguage.en:
        return 'Save Password';
    }
  }

  String get logoutSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'පද්ධතියෙන් ආරක්ෂිතව නික්ම යන්න';
      case AppLanguage.ta:
        return 'பாதுகாப்பாக வெளியேறவும்';
      case AppLanguage.en:
        return 'Safely exit the staff caregiver portal';
    }
  }

  String get shiftsCountLabel {
    switch (language) {
      case AppLanguage.si:
        return 'මුර';
      case AppLanguage.ta:
        return 'பணிகள்';
      case AppLanguage.en:
        return 'Shifts';
    }
  }

  String get docsCountLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ලේඛන';
      case AppLanguage.ta:
        return 'ஆவணங்கள்';
      case AppLanguage.en:
        return 'Documents';
    }
  }

  String get saveChanges {
    switch (language) {
      case AppLanguage.si:
        return 'වෙනස්කම් සුරකින්න';
      case AppLanguage.ta:
        return 'மாற்றங்களைச் சேமிக்கவும்';
      case AppLanguage.en:
        return 'Save Changes';
    }
  }

  // Privacy & Booking Acceptance Rules
  String get privacyShieldNote {
    switch (language) {
      case AppLanguage.si:
        return 'රෝගියාගේ නම, දුරකථන අංක සහ නිශ්චිත ලිපිනය ආරක්ෂිත හේතූන් මත ඇණවුම භාරගත් පසු පමණක් හෙළිවේ.';
      case AppLanguage.ta:
        return 'பாதுகாப்பு காரணங்களுக்காக நோயாளியின் பெயர், தொலைபேசி மற்றும் முகவரி கடமையை ஏற்றுக்கொண்ட பின்னரே காண்பிக்கப்படும்.';
      case AppLanguage.en:
        return 'Patient name, phone number, and address are protected and revealed only after accepting duty.';
    }
  }

  String get expandDetailsLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ තොරතුරු බලන්න';
      case AppLanguage.ta:
        return 'முழு விவரங்களையும் பார்க்க';
      case AppLanguage.en:
        return 'View Full Details';
    }
  }

  String get collapseDetailsLabel {
    switch (language) {
      case AppLanguage.si:
        return 'විස්තර සඟවන්න';
      case AppLanguage.ta:
        return 'விவரங்களை மறைக்க';
      case AppLanguage.en:
        return 'Collapse Details';
    }
  }

  String get activeDutyCardTitle {
    switch (language) {
      case AppLanguage.si:
        return 'වත්මන් සක්‍රීය සාත්තු රාජකාරිය';
      case AppLanguage.ta:
        return 'தற்போதைய செயலில் உள்ள பணி';
      case AppLanguage.en:
        return 'Current Active Care Duty';
    }
  }

  String get daysRemainingLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ඉතිරි කාලය';
      case AppLanguage.ta:
        return 'மீதமுள்ள காலம்';
      case AppLanguage.en:
        return 'Remaining Time';
    }
  }

  String get daysUnitLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දින';
      case AppLanguage.ta:
        return 'நாட்கள்';
      case AppLanguage.en:
        return 'Days';
    }
  }

  String get greetingGoodDay {
    switch (language) {
      case AppLanguage.si:
        return 'ආයුබෝවන්,';
      case AppLanguage.ta:
        return 'வணக்கம்,';
      case AppLanguage.en:
        return 'Hello,';
    }
  }

  String get switchPersonaDemoLabel {
    switch (language) {
      case AppLanguage.si:
        return 'කාර්ය මණ්ඩල පැතිකඩ මාරු කිරීම (Demo):';
      case AppLanguage.ta:
        return 'பணியாளர் சுயவிவரத்தை மாற்றவும் (Demo):';
      case AppLanguage.en:
        return 'Switch Staff Profile (Demo):';
    }
  }

  String get readyForDutyBannerTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ මේ වන විට නිදහස්ව ඇත';
      case AppLanguage.ta:
        return 'நீங்கள் இப்போது தயாராக உள்ளீர்கள்';
      case AppLanguage.en:
        return 'You are Currently Available';
    }
  }

  String get readyForDutyBannerSub {
    switch (language) {
      case AppLanguage.si:
        return 'පහතින් ඇති ඔබගේ සුදුසුකම් කාණ්ඩයට ගැළපෙන නව සාත්තු ඇණවුමක් භාරගන්න.';
      case AppLanguage.ta:
        return 'உங்கள் தகுதிக்கு பொருந்தும் புதிய பணியை கீழே ஏற்றுக்கொள்ளவும்.';
      case AppLanguage.en:
        return 'Accept a new care booking matching your qualification category below.';
    }
  }

  String get acceptAsNextDutyBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරි රාජකාරිය ලෙස භාරගන්න';
      case AppLanguage.ta:
        return 'அடுத்த பணியாக ஏற்கவும்';
      case AppLanguage.en:
        return 'Accept as Next Duty';
    }
  }

  String get blockedStartsBeforeEndNote {
    switch (language) {
      case AppLanguage.si:
        return 'වත්මන් රාජකාරිය අවසන් වීමට පෙර මෙම ඇණවුම ආරම්භ වන බැවින් භාරගත නොහැක.';
      case AppLanguage.ta:
        return 'தற்போதைய பணி முடிவதற்குள் இந்த பணி தொடங்குவதால் ஏற்க முடியாது.';
      case AppLanguage.en:
        return 'This booking starts before your current duty ends, cannot overlap.';
    }
  }

  String get blockedAlreadyQueuedNote {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ දැනටමත් ඉදිරි රාජකාරියක් භාරගෙන ඇත. එකවර කිහිපයක් රඳවාගත නොහැක.';
      case AppLanguage.ta:
        return 'நீங்கள் ஏற்கனவே ஒரு எதிர்கால பணியை ஏற்றுக்கொண்டுள்ளீர்கள்.';
      case AppLanguage.en:
        return 'You have already accepted an upcoming duty.';
    }
  }

  String get openMapBtn {
    switch (language) {
      case AppLanguage.si:
        return 'Google සිතියම';
      case AppLanguage.ta:
        return 'கூகுள் வரைபடம்';
      case AppLanguage.en:
        return 'Google Maps';
    }
  }

  String get callGuardianBtn {
    switch (language) {
      case AppLanguage.si:
        return 'භාරකරුට අමතන්න';
      case AppLanguage.ta:
        return 'பாதுகாவலரை அழைக்கவும்';
      case AppLanguage.en:
        return 'Call Guardian';
    }
  }

  String get whatsappGuardianBtn {
    switch (language) {
      case AppLanguage.si:
        return 'WhatsApp පණිවිඩයක්';
      case AppLanguage.ta:
        return 'WhatsApp செய்தி';
      case AppLanguage.en:
        return 'WhatsApp';
    }
  }

  String get guardianContactLabel {
    switch (language) {
      case AppLanguage.si:
        return 'භාරකරුගේ සම්බන්ධතා';
      case AppLanguage.ta:
        return 'பாதுகாவலர் தொடர்பு';
      case AppLanguage.en:
        return 'Family Guardian Contact';
    }
  }

  String get supervisorContactLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සායනික අධීක්ෂකවරිය';
      case AppLanguage.ta:
        return 'மருத்துவ மேற்பார்வையாளர்';
      case AppLanguage.en:
        return 'Clinical Supervisor';
    }
  }

  String get matchingCategoryBadge {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ කාණ්ඩයට ගැළපේ';
      case AppLanguage.ta:
        return 'உங்கள் தகுதிக்கு பொருந்தும்';
      case AppLanguage.en:
        return 'Matches Your Category';
    }
  }

  String get upcomingDutyCardTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරියට භාරගත් සාත්තු රාජකාරිය';
      case AppLanguage.ta:
        return 'எதிர்கால ஏற்றுக்கொள்ளப்பட்ட பணி';
      case AppLanguage.en:
        return 'Upcoming Queued Care Duty';
    }
  }

  // Currency Symbol
  String get currencySymbol {
    switch (language) {
      case AppLanguage.si:
        return 'රු.';
      case AppLanguage.ta:
        return 'ரூ.';
      case AppLanguage.en:
        return 'LKR';
    }
  }

  // Navigation Bar Destinations
  String get navDutyHub {
    switch (language) {
      case AppLanguage.si:
        return 'රාජකාරි';
      case AppLanguage.ta:
        return 'பணி மையம்';
      case AppLanguage.en:
        return 'Duty Hub';
    }
  }

  String get navVitals {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත';
      case AppLanguage.ta:
        return 'உயிர் அறிகுறிகள்';
      case AppLanguage.en:
        return 'Vitals';
    }
  }

  String get navRoutine {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු සැලැස්ම';
      case AppLanguage.ta:
        return 'பராமரிப்பு திட்டம்';
      case AppLanguage.en:
        return 'Care Plan';
    }
  }

  String get navShifts {
    switch (language) {
      case AppLanguage.si:
        return 'මුර';
      case AppLanguage.ta:
        return 'பணி மாற்றங்கள்';
      case AppLanguage.en:
        return 'Shifts';
    }
  }

  // Clinical Views Titles
  String get bedsideVitalsTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත සහ සෞඛ්‍යය';
      case AppLanguage.ta:
        return 'படுக்கை உயிர் அறிகுறிகள்';
      case AppLanguage.en:
        return 'Bedside Vitals & Health';
    }
  }

  String get recordVitalsTooltip {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත සටහන් කරන්න';
      case AppLanguage.ta:
        return 'உயிர் அறிகுறிகளைப் பதிவுசெய்க';
      case AppLanguage.en:
        return 'Record Vitals';
    }
  }

  String get routineCareTitle {
    switch (language) {
      case AppLanguage.si:
        return 'දෛනික සාත්තු සැලැස්ම';
      case AppLanguage.ta:
        return 'தினசரி பராமரிப்பு திட்டம்';
      case AppLanguage.en:
        return 'Daily Care Plan';
    }
  }

  String get careTasksTab {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු කාර්යයන්';
      case AppLanguage.ta:
        return 'பராமரிப்பு பணிகள்';
      case AppLanguage.en:
        return 'Care Tasks';
    }
  }

  String get bedTurningTab {
    switch (language) {
      case AppLanguage.si:
        return 'පැය 2 පැත්ත මාරු කිරීම';
      case AppLanguage.ta:
        return '2 மணி நேர படுக்கை திருப்பம்';
      case AppLanguage.en:
        return '2h Bed Turning';
    }
  }

  String get addCareTaskTooltip {
    switch (language) {
      case AppLanguage.si:
        return 'නව සාත්තු කාර්යයක් එක් කරන්න';
      case AppLanguage.ta:
        return 'புதிய பணியைச் சேர்க்கவும்';
      case AppLanguage.en:
        return 'Add Care Task';
    }
  }

  String get allTasksFilter {
    switch (language) {
      case AppLanguage.si:
        return 'සියල්ල';
      case AppLanguage.ta:
        return 'அனைத்தும்';
      case AppLanguage.en:
        return 'All Tasks';
    }
  }

  String get pendingTasksFilter {
    switch (language) {
      case AppLanguage.si:
        return 'ඉතිරිව ඇති';
      case AppLanguage.ta:
        return 'நிலுவையில் உள்ளவை';
      case AppLanguage.en:
        return 'Pending';
    }
  }

  String get completedTasksFilter {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ';
      case AppLanguage.ta:
        return 'முடிந்தவை';
      case AppLanguage.en:
        return 'Completed';
    }
  }

  String get todayScheduleProgress {
    switch (language) {
      case AppLanguage.si:
        return 'අද දවසේ ප්‍රගතිය';
      case AppLanguage.ta:
        return 'இன்றைய முன்னேற்றம்';
      case AppLanguage.en:
        return 'Today\'s Progress';
    }
  }

  String get noTasksFound {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම කාණ්ඩයේ කාර්යයන් නොමැත';
      case AppLanguage.ta:
        return 'பணிகள் எதுவும் இல்லை';
      case AppLanguage.en:
        return 'No tasks in this list';
    }
  }

  String get markTaskDoneBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ බව සලකුණු කරන්න';
      case AppLanguage.ta:
        return 'முடிந்ததாகக் குறிக்கவும்';
      case AppLanguage.en:
        return 'Mark as Done';
    }
  }

  String get shiftHistoryTitle {
    switch (language) {
      case AppLanguage.si:
        return 'මුර ඉතිහාසය සහ කාලසටහන';
      case AppLanguage.ta:
        return 'பணி வரலாறு மற்றும் அட்டவணை';
      case AppLanguage.en:
        return 'Shift History & Rosters';
    }
  }

  String get bedTurningLogTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පැය 2 පැත්ත මාරු කිරීමේ සටහන';
      case AppLanguage.ta:
        return '2 மணி நேர படுக்கை திருப்பப் பதிவு';
      case AppLanguage.en:
        return '2-Hour Bed Turning Log';
    }
  }

  // Splash Screen
  String get splashWelcome {
    switch (language) {
      case AppLanguage.si:
        return 'සාදරයෙන් පිළිගනිමු';
      case AppLanguage.ta:
        return 'நல்வரவு';
      case AppLanguage.en:
        return 'WELCOME';
    }
  }

  String get splashCoopSociety {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රයිම් ලයිෆ් කෙයාර් සමූපකාර සමිතිය';
      case AppLanguage.ta:
        return 'பிரைம் லைஃப் கேர் கூட்டுறவு சங்கம்';
      case AppLanguage.en:
        return 'Prime Life Care Co-operative Society Ltd.';
    }
  }

  String get splashFooter {
    switch (language) {
      case AppLanguage.si:
        return 'අනුවාදය 1.0.0 • සමූපකාර සංවර්ධන දෙපාර්තමේන්තුව';
      case AppLanguage.ta:
        return 'பதிப்பு 1.0.0 • கூட்டுறவு அபிவிருத்தி திணைக்களம்';
      case AppLanguage.en:
        return 'Version 1.0.0 • Department of Co-operative Development';
    }
  }

  String get splashPortalSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'ප්‍රජාපාදක ජ්‍යෙෂ්ඨ පුරවැසි සහ සාත්තු සේවා පියස';
      case AppLanguage.ta:
        return 'சமூக முதியோர் மற்றும் படுக்கை பராமரிப்பு தளம்';
      case AppLanguage.en:
        return 'Community Elder & Bedside Care Staff Portal';
    }
  }

  // Privacy Policy Sheet
  String get privacyPolicyFullTitle {
    switch (language) {
      case AppLanguage.si:
        return 'රහස්‍යතා ප්‍රතිපත්තිය සහ කොන්දේසි';
      case AppLanguage.ta:
        return 'தனியுரிமைக் கொள்கை மற்றும் விதிமுறைகள்';
      case AppLanguage.en:
        return 'Privacy Policy & Terms';
    }
  }

  String get privacyPolicySection1Header {
    switch (language) {
      case AppLanguage.si:
        return '1. දත්ත එකතු කිරීම (Data Collection):';
      case AppLanguage.ta:
        return '1. தரவு சேகரிப்பு:';
      case AppLanguage.en:
        return '1. Data Collection:';
    }
  }

  String get privacyPolicySection1Body {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික පැතිකඩ සත්‍යාපනය සඳහා ඔබගේ නම, ජාතික හැඳුනුම්පත් අංකය (NIC), දුරකථන අංක සහ සහතිකපත් පමණක් ලබා ගන්නා අතර, කිසිදු තෙවන පාර්ශවයකට වාණිජමය අවශ්‍යතා සඳහා ලබා නොදේ.';
      case AppLanguage.ta:
        return 'உறுப்பினர் சுயவிவர சரிபார்ப்பிற்காக உங்கள் பெயர், தேசிய அடையாள அட்டை எண் (NIC), தொலைபேசி எண் மற்றும் சான்றிதழ்கள் மட்டுமே பெறப்படுகின்றன, மேலும் அவை எந்த மூன்றாம் தரப்பினருடனும் பகிரப்படாது.';
      case AppLanguage.en:
        return 'Only your name, NIC, phone number, and qualification certificates are collected for staff verification and duty allocation. Your data is strictly protected and never shared with commercial third parties.';
    }
  }

  String get privacyPolicySection2Header {
    switch (language) {
      case AppLanguage.si:
        return '2. රහස්‍යභාවය (Confidentiality):';
      case AppLanguage.ta:
        return '2. இரகசியத்தன்மை:';
      case AppLanguage.en:
        return '2. Confidentiality:';
    }
  }

  String get privacyPolicySection2Body {
    switch (language) {
      case AppLanguage.si:
        return 'රෝගීන්ගේ සහ පවුල්වල සෞඛ්‍ය තොරතුරු හා ලිපිනවල රහස්‍යභාවය සුරැකීමට සියලු සාමාජිකයින් බැඳී සිටී.';
      case AppLanguage.ta:
        return 'நோயாளிகள் மற்றும் குடும்பங்களின் சுகாதாரத் தகவல்கள் மற்றும் முகவரிகளின் இரகசியத்தன்மையைப் பாதுகாக்க அனைத்து உறுப்பினர்களும் கடமைப்பட்டுள்ளனர்.';
      case AppLanguage.en:
        return 'Caregivers must strictly protect patient clinical data, home addresses, and family contact information with absolute medical confidentiality.';
    }
  }

  String get privacyPolicySection3Header {
    switch (language) {
      case AppLanguage.si:
        return '3. සාමාජික වගකීම් (Member Responsibilities):';
      case AppLanguage.ta:
        return '3. உறுப்பினர் பொறுப்புகள்:';
      case AppLanguage.en:
        return '3. Member Responsibilities:';
    }
  }

  String get privacyPolicySection3Body {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ මුරපදය (Password) ආරක්ෂිතව තබා ගැනීම සාමාජිකයාගේ වගකීමක් වේ. කිසිදු හේතුවක් මත වෙනත් අයෙකුට ඔබගේ ගිණුම භාවිතා කිරීමට ඉඩ නොදෙන්න.';
      case AppLanguage.ta:
        return 'உங்கள் கடவுச்சொல்லைப் பாதுகாப்பாக வைத்திருப்பது உறுப்பினரின் பொறுப்பாகும். வேறு எவரும் உங்கள் கணக்கைப் பயன்படுத்த அனுமதிக்காதீர்கள்.';
      case AppLanguage.en:
        return 'Keep your login credentials secure. Never share your caregiver portal access or perform duties under another member account.';
    }
  }

  String get privacyPolicySection4Header {
    switch (language) {
      case AppLanguage.si:
        return '4. සමූපකාර අනුකූලතාව (Co-operative Compliance):';
      case AppLanguage.ta:
        return '4. கூட்டுறவு இணக்கம்:';
      case AppLanguage.en:
        return '4. Co-operative Compliance:';
    }
  }

  String get privacyPolicySection4Body {
    switch (language) {
      case AppLanguage.si:
        return 'සමූපකාර සදාචාර සම්පන්න ප්‍රතිපත්තිවලට අනුකූලව ගුණාත්මක සේවාවක් සැපයීම සහ පැමිණීම් වාර්තා නිසිලෙස යාවත්කාලීන කිරීම අනිවාර්ය වේ.';
      case AppLanguage.ta:
        return 'கூட்டுறவு நெறிமுறைக் கொள்கைகளுக்கு இணங்க தரமான சேவையை வழங்குவதும் வருகைப் பதிவுகளை முறையாகப் புதுப்பிப்பதும் கட்டாயமாகும்.';
      case AppLanguage.en:
        return 'Caregivers are expected to maintain professional healthcare ethics, punctuality, and accurate real-time bedside shift logging.';
    }
  }

  String get iUnderstandBtn {
    switch (language) {
      case AppLanguage.si:
        return 'අවබෝධ විය';
      case AppLanguage.ta:
        return 'புரிந்துகொண்டேன்';
      case AppLanguage.en:
        return 'I Understand';
    }
  }

  // Home Duty View Sections & Dialogs
  String get medicalConditionSectionHeader {
    switch (language) {
      case AppLanguage.si:
        return '🩺 වෛද්‍ය තත්ත්වය සහ සාත්තු අවශ්‍යතා';
      case AppLanguage.ta:
        return '🩺 மருத்துவ நிலை மற்றும் தேவைகள்';
      case AppLanguage.en:
        return '🩺 Medical Condition & Care Needs';
    }
  }

  String get exactLocationSectionHeader {
    switch (language) {
      case AppLanguage.si:
        return '📍 නිශ්චිත ස්ථානය සහ ලිපිනය';
      case AppLanguage.ta:
        return '📍 சரியான இடம் மற்றும் முகவரி';
      case AppLanguage.en:
        return '📍 Exact Location & Address';
    }
  }

  String get diagnosisLabel {
    switch (language) {
      case AppLanguage.si:
        return 'රෝග විනිශ්චය';
      case AppLanguage.ta:
        return 'நோய் கண்டறிதல்';
      case AppLanguage.en:
        return 'Diagnosis';
    }
  }

  String get mobilityStatusLabel {
    switch (language) {
      case AppLanguage.si:
        return 'චලන තත්ත්වය';
      case AppLanguage.ta:
        return 'இயக்கம் நிலை';
      case AppLanguage.en:
        return 'Mobility Status';
    }
  }

  String get clinicalSupervisorRole {
    switch (language) {
      case AppLanguage.si:
        return 'හෙද අධීක්ෂක';
      case AppLanguage.ta:
        return 'மருத்துவ மேற்பார்வையாளர்';
      case AppLanguage.en:
        return 'Clinical Supervisor';
    }
  }

  String get whatsappNurseIntro {
    switch (language) {
      case AppLanguage.si:
        return 'ආයුබෝවන්, මම Prime Life Care සාත්තු සේවිකාව/සේවකයා වෙමි.';
      case AppLanguage.ta:
        return 'வணக்கம், நான் Prime Life Care நோயாளி பராமரிப்பாளர்.';
      case AppLanguage.en:
        return 'Hello, I am the Prime Life Care nurse/caregiver for the patient.';
    }
  }

  String get vitalsQuickBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත';
      case AppLanguage.ta:
        return 'உயிர் அறிகுறிகள்';
      case AppLanguage.en:
        return 'Vitals';
    }
  }

  String get routineQuickBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු සැලැස්ම';
      case AppLanguage.ta:
        return 'பராமரிப்பு திட்டம்';
      case AppLanguage.en:
        return 'Care Plan';
    }
  }

  String get emergencySosBtn {
    switch (language) {
      case AppLanguage.si:
        return 'හදිසි ඇමතුම්';
      case AppLanguage.ta:
        return 'அவசர உதவி';
      case AppLanguage.en:
        return 'Emergency SOS';
    }
  }

  String get demoRuleSimulatorTitle {
    switch (language) {
      case AppLanguage.si:
        return 'Demo Rule Simulator (ඉතිරි දින ගණන පරීක්ෂාව):';
      case AppLanguage.ta:
        return 'Demo விதி உருவகப்படுத்துதல் (மீதமுள்ள நாட்கள்):';
      case AppLanguage.en:
        return 'Demo Rule Simulator (Remaining Days Test):';
    }
  }

  String get sim1DayEligible {
    switch (language) {
      case AppLanguage.si:
        return 'දින 1 (<= 2 දින - Eligible)';
      case AppLanguage.ta:
        return '1 நாள் (<= 2 நாட்கள் - Eligible)';
      case AppLanguage.en:
        return '1 Day (<= 2 Days - Eligible)';
    }
  }

  String get sim5DaysBlocked {
    switch (language) {
      case AppLanguage.si:
        return 'දින 5 (> 2 දින - Blocked)';
      case AppLanguage.ta:
        return '5 நாட்கள் (> 2 நாட்கள் - Blocked)';
      case AppLanguage.en:
        return '5 Days (> 2 Days - Blocked)';
    }
  }

  String get acceptAsNextDutyConfirmDesc {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම ඇණවුම ඔබගේ වත්මන් රාජකාරියෙන් පසු ක්‍රියාත්මක වන ඉදිරි රාජකාරිය ලෙස භාරගැනීමට තහවුරු කරන්න. භාරගත් පසු රෝගියාගේ නම සහ දුරකථන අංක හෙළිවේ.';
      case AppLanguage.ta:
        return 'தற்போதைய பணி முடிந்ததும் அடுத்த பணியாக இதை ஏற்க உறுதிப்படுத்தவும். ஏற்ற பிறகு நோயாளியின் விவரங்கள் காண்பிக்கப்படும்.';
      case AppLanguage.en:
        return 'Confirm accepting this care booking as your upcoming queued duty. Patient name and guardian contact details will be revealed after acceptance.';
    }
  }

  String get completeDutyConfirmDescText {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ මෙම රෝගියා වෙනුවෙන් නියමිත සාත්තු සේවා කාලය සම්පූර්ණ කළ බව තහවුරු කරන්නද? අවසන් කිරීමෙන් පසු ඔබගේ ගිණුමේ ඉපැයීම් යාවත්කාලීන වේ.';
      case AppLanguage.ta:
        return 'இந்த நோயாளிக்கான கடமையை முடித்ததை உறுதிப்படுத்துகிறீர்களா? முடிந்ததும் உங்கள் வருவாய் புதுப்பிக்கப்படும்.';
      case AppLanguage.en:
        return 'Are you sure you want to mark this care duty as completed? Your staff earnings will be updated immediately.';
    }
  }

  String upcomingDutyAcceptedSnackbar(String city) {
    switch (language) {
      case AppLanguage.si:
        return '$city සාත්තු ඇණවුම ඉදිරි රාජකාරිය ලෙස සාර්ථකව භාරගන්නා ලදී!';
      case AppLanguage.ta:
        return '$city பணி அடுத்த கடமையாக வெற்றிகரமாக ஏற்றுக்கொள்ளப்பட்டது!';
      case AppLanguage.en:
        return '$city care booking accepted as upcoming queued duty!';
    }
  }

  String activeDutyAcceptedSnackbar(String code) {
    switch (language) {
      case AppLanguage.si:
        return '$code සාත්තු සේවය සාර්ථකව භාරගන්නා ලදී!';
      case AppLanguage.ta:
        return '$code பணி வெற்றிகரமாக ஏற்றுக்கொள்ளப்பட்டது!';
      case AppLanguage.en:
        return '$code duty accepted successfully!';
    }
  }

  String noBookingsForCategory(String category) {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ $category කාණ්ඩයට ගැළපෙන නව ඇණවුම් නොමැත.';
      case AppLanguage.ta:
        return 'உங்கள் $category தகுதி வகைக்கு புதிய பணிகள் எதுவும் இல்லை.';
      case AppLanguage.en:
        return 'No new bookings available for your category ($category).';
    }
  }

  // Auth & Form Errors & Hints
  String get agreePrivacyPolicyAlert {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරියට යාමට රහස්‍යතා ප්‍රතිපත්තියට එකඟ වන්න';
      case AppLanguage.ta:
        return 'தொடர தனியுரிமைக் கொள்கையை ஏற்றுக்கொள்ளுங்கள்';
      case AppLanguage.en:
        return 'Please agree to the privacy policy to continue';
    }
  }

  String get passwordsMismatchError {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපද එකිනෙකට නොගැළපේ';
      case AppLanguage.ta:
        return 'கடவுச்சொற்கள் பொருந்தவில்லை';
      case AppLanguage.en:
        return 'Passwords do not match';
    }
  }

  String get registrationSuccessSnackbar {
    switch (language) {
      case AppLanguage.si:
        return 'ලියාපදිංචිය සාර්ථකයි! කරුණාකර ඔබගේ තොරතුරු යොදා Login වන්න.';
      case AppLanguage.ta:
        return 'பதிவு வெற்றிகரமானது! உள்நுழைக.';
      case AppLanguage.en:
        return 'Registration successful! Please sign in with your credentials.';
    }
  }

  String get otpSentSuccessTitle {
    switch (language) {
      case AppLanguage.si:
        return 'OTP කේතය සාර්ථකව යවන ලදී!';
      case AppLanguage.ta:
        return 'OTP வெற்றிகரமாக அனுப்பப்பட்டது!';
      case AppLanguage.en:
        return 'OTP Code Sent Successfully!';
    }
  }

  String get otpSentSuccessDesc {
    switch (language) {
      case AppLanguage.si:
        return 'මුරපදය නැවත සකසන OTP කේතය SMS මගින් යවන ලදී. කරුණාකර SMS පණිවිඩ පරීක්ෂා කරන්න.';
      case AppLanguage.ta:
        return 'கடவுச்சொல் மீட்டமைப்பு OTP SMS மூலம் அனுப்பப்பட்டது. SMS ஐப் பார்க்கவும்.';
      case AppLanguage.en:
        return 'Password reset OTP has been sent via SMS. Please check your SMS messages.';
    }
  }

  String get addressHintText {
    switch (language) {
      case AppLanguage.si:
        return 'නො. 25, ප්‍රධාන පාර';
      case AppLanguage.ta:
        return 'எண் 25, பிரதான வீதி';
      case AppLanguage.en:
        return 'No. 25, Main Road';
    }
  }

  String get cityDistrictHintText {
    switch (language) {
      case AppLanguage.si:
        return 'හලාවත / පුත්තලම';
      case AppLanguage.ta:
        return 'சிலாபம் / புத்தளம்';
      case AppLanguage.en:
        return 'Chilaw / Puttalam';
    }
  }

  String memberIdFilledPrompt(String id) {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික අංකය $id ඇතුළත් විය. මුරපදය යොදා Login වන්න.';
      case AppLanguage.ta:
        return 'உறுப்பினர் எண் $id நிரப்பப்பட்டது. கடவுச்சொல்லைப் பயன்படுத்தி உள்நுழையவும்.';
      case AppLanguage.en:
        return 'Member ID $id filled. Please sign in with your password.';
    }
  }

  String get membershipCredentialsLoginPrompt {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම සාමාජික අංකය සහ මුරපදය භාවිතා කර ඔබට Login විය හැක.';
      case AppLanguage.ta:
        return 'இந்த உறுப்பினர் எண் மற்றும் கடவுச்சொல்லைப் பயன்படுத்தி உள்நுழையலாம்.';
      case AppLanguage.en:
        return 'You can now sign in using this membership number and password.';
    }
  }

  String get otpInfoNote {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ ලියාපදිංචි දුරකථන අංකයට මුරපදය නැවත සැකසීමේ OTP කේතයක් SMS මඟින් ලැබෙනු ඇත.';
      case AppLanguage.ta:
        return 'உங்கள் பதிவுசெய்த தொலைபேசி எண்ணிற்கு SMS மூலம் OTP அனுப்பப்படும்.';
      case AppLanguage.en:
        return 'A password reset OTP code will be sent to your registered mobile phone via SMS.';
    }
  }

  String get bedTurnRepositioningOverdue {
    switch (language) {
      case AppLanguage.si:
        return 'පැත්ත මාරු කිරීම ප්‍රමාදයි: රෝගියා වහාම මාරු කරන්න!';
      case AppLanguage.ta:
        return 'படுக்கை திருப்பம் தாமதமாகிறது: நோயாளியை உடனே திருப்புக!';
      case AppLanguage.en:
        return 'BED REPOSITIONING OVERDUE: Reposition Patient Now!';
    }
  }

  String bedTurnNextIn(int minutes) {
    switch (language) {
      case AppLanguage.si:
        return 'ඊළඟ පැත්ත මාරුව විනාඩි $minutes කින්';
      case AppLanguage.ta:
        return 'அடுத்த திருப்பம் $minutes நிமிடங்களில்';
      case AppLanguage.en:
        return 'Next turn in $minutes mins';
    }
  }

  String get actionDueBadge {
    switch (language) {
      case AppLanguage.si:
        return 'ක්‍රියාමාර්ගය අවශ්‍යයි';
      case AppLanguage.ta:
        return 'நடவடிக்கை தேவை';
      case AppLanguage.en:
        return 'ACTION DUE';
    }
  }

  String get onScheduleBadge {
    switch (language) {
      case AppLanguage.si:
        return 'නියමිත වේලාවට';
      case AppLanguage.ta:
        return 'சரியான நேரத்தில்';
      case AppLanguage.en:
        return 'ON SCHEDULE';
    }
  }

  String get timeLeftBadge {
    switch (language) {
      case AppLanguage.si:
        return 'ඉතිරි';
      case AppLanguage.ta:
        return 'மீதம்';
      case AppLanguage.en:
        return 'LEFT';
    }
  }

  String get currentPostureLabel {
    switch (language) {
      case AppLanguage.si:
        return 'වත්මන් ඉරියව්ව:';
      case AppLanguage.ta:
        return 'தற்போதைய நிலை:';
      case AppLanguage.en:
        return 'CURRENT POSTURE:';
    }
  }

  String get notYetRepositioned {
    switch (language) {
      case AppLanguage.si:
        return 'තවම මාරු කර නොමැත';
      case AppLanguage.ta:
        return 'இன்னும் மாற்றப்படவில்லை';
      case AppLanguage.en:
        return 'Not yet repositioned';
    }
  }

  String get logBedTurnBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පැත්ත මාරු කිරීම සහ සම පරීක්ෂාව සටහන් කරන්න';
      case AppLanguage.ta:
        return 'படுக்கை திருப்பம் & தோல் பரிசோதனை பதிவு';
      case AppLanguage.en:
        return 'Log Bed Turn & Skin Check';
    }
  }

  String get bedsorePreventionTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පැය 2ක තුවාල වැළැක්වීම';
      case AppLanguage.ta:
        return '2 மணி நேர படுக்கைப் புண் தடுப்பு';
      case AppLanguage.en:
        return '2-Hour Bedsore Prevention';
    }
  }

  String get activeOnDutyBadge {
    switch (language) {
      case AppLanguage.si:
        return 'ක්‍රියාකාරී රාජකාරියේ';
      case AppLanguage.ta:
        return 'செயலில் உள்ள பணி';
      case AppLanguage.en:
        return 'ACTIVE ON DUTY';
    }
  }

  String get offDutyBadge {
    switch (language) {
      case AppLanguage.si:
        return 'රාජකාරි විවේකයේ';
      case AppLanguage.ta:
        return 'பணியில் இல்லை';
      case AppLanguage.en:
        return 'OFF DUTY';
    }
  }

  String get shiftDurationElapsed {
    switch (language) {
      case AppLanguage.si:
        return 'ගතවූ මුර කාලය';
      case AppLanguage.ta:
        return 'கடந்த பணி நேரம்';
      case AppLanguage.en:
        return 'SHIFT DURATION ELAPSED';
    }
  }

  String get readyToStartShift {
    switch (language) {
      case AppLanguage.si:
        return 'මුරය ආරම්භ කිරීමට සූදානම්';
      case AppLanguage.ta:
        return 'பணியைத் தொடங்க தயார்';
      case AppLanguage.en:
        return 'READY TO START SHIFT';
    }
  }

  String get clockInBtn {
    switch (language) {
      case AppLanguage.si:
        return 'Clock In';
      case AppLanguage.ta:
        return 'Clock In';
      case AppLanguage.en:
        return 'Clock In';
    }
  }

  String get clockOutBtn {
    switch (language) {
      case AppLanguage.si:
        return 'Clock Out';
      case AppLanguage.ta:
        return 'Clock Out';
      case AppLanguage.en:
        return 'Clock Out';
    }
  }

  String get staffLabel {
    switch (language) {
      case AppLanguage.si:
        return 'කාර්ය මණ්ඩලය';
      case AppLanguage.ta:
        return 'ஊழியர்';
      case AppLanguage.en:
        return 'Staff';
    }
  }

  String get bedsideVitalsMonitor {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත නිරීක්ෂකය';
      case AppLanguage.ta:
        return 'உயிர் அறிகுறிகள் மானிட்டர்';
      case AppLanguage.en:
        return 'Bedside Vitals Monitor';
    }
  }

  String recordedAtTime(String time) {
    switch (language) {
      case AppLanguage.si:
        return 'සටහන් කළේ $time';
      case AppLanguage.ta:
        return 'பதிவு செய்யப்பட்டது $time';
      case AppLanguage.en:
        return 'Recorded $time';
    }
  }

  String get noVitalsRecordedToday {
    switch (language) {
      case AppLanguage.si:
        return 'අද දින ජීව දත්ත සටහන් කර නොමැත';
      case AppLanguage.ta:
        return 'இன்று உயிர் அறிகுறிகள் பதிவு செய்யப்படவில்லை';
      case AppLanguage.en:
        return 'No vitals recorded today';
    }
  }

  String get recordNewVitalsCta {
    switch (language) {
      case AppLanguage.si:
        return 'නව ජීව දත්ත දැන්ම සටහන් කරන්න';
      case AppLanguage.ta:
        return 'புதிய உயிர் அறிகுறிகளைப் பதிவுசெய்க';
      case AppLanguage.en:
        return 'Record New Vitals Check Now';
    }
  }

  String get clinicalReferenceGuideTitle {
    switch (language) {
      case AppLanguage.si:
        return 'ජ්‍යෙෂ්ඨ සායනික යොමු සීමාවන්';
      case AppLanguage.ta:
        return 'முதியோர் மருத்துவ குறிப்பு வரம்புகள்';
      case AppLanguage.en:
        return 'Elderly Clinical Reference Thresholds';
    }
  }

  String get recordedVitalsHistoryTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සටහන් කළ ජීව දත්ත ඉතිහාසය';
      case AppLanguage.ta:
        return 'பதிவு செய்யப்பட்ட வரலாறு';
      case AppLanguage.en:
        return 'Recorded Vitals History';
    }
  }

  String recordsCount(int count) {
    switch (language) {
      case AppLanguage.si:
        return 'වාර්තා $count ක්';
      case AppLanguage.ta:
        return '$count பதிவுகள்';
      case AppLanguage.en:
        return '$count Records';
    }
  }

  String get noVitalsFound {
    switch (language) {
      case AppLanguage.si:
        return 'ජීව දත්ත වාර්තා කිසිවක් හමු නොවීය.';
      case AppLanguage.ta:
        return 'உயிர் அறிகுறிகள் பதிவுகள் எதுவும் கிடைக்கவில்லை.';
      case AppLanguage.en:
        return 'No vitals records found.';
    }
  }

  // Shift History & 4-Tab Roster Strings
  String get tabActive {
    switch (language) {
      case AppLanguage.si:
        return 'ක්‍රියාකාරී';
      case AppLanguage.ta:
        return 'செயலில்';
      case AppLanguage.en:
        return 'Active';
    }
  }

  String get tabUpcoming {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරි';
      case AppLanguage.ta:
        return 'வரவிருக்கும்';
      case AppLanguage.en:
        return 'Upcoming';
    }
  }

  String get tabCanceled {
    switch (language) {
      case AppLanguage.si:
        return 'අවලංගු කළ';
      case AppLanguage.ta:
        return 'ரத்து செய்யப்பட்டது';
      case AppLanguage.en:
        return 'Canceled';
    }
  }

  String get tabCompleted {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ';
      case AppLanguage.ta:
        return 'நிறைவடைந்தது';
      case AppLanguage.en:
        return 'Completed';
    }
  }

  String get monthlyDutySummary {
    switch (language) {
      case AppLanguage.si:
        return 'මාසික රාජකාරි සාරාංශය';
      case AppLanguage.ta:
        return 'மாதாந்திர பணி சுருக்கம்';
      case AppLanguage.en:
        return 'MONTHLY DUTY SUMMARY';
    }
  }

  String shiftsCompletedCount(int count) {
    switch (language) {
      case AppLanguage.si:
        return 'මුර $count ක් අවසන්';
      case AppLanguage.ta:
        return '$count பணிகள் முடிந்தது';
      case AppLanguage.en:
        return '$count Shifts Completed';
    }
  }

  String get allowanceDirectDepositNote {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු දීමනා සමූපකාර වැටුප් පද්ධතිය හරහා සෘජුව ගිණුමට බැර වේ';
      case AppLanguage.ta:
        return 'கூட்டுறவு சம்பள முறை மூலம் கொடுப்பனவு நேரடியாக வரவு வைக்கப்படுகிறது';
      case AppLanguage.en:
        return 'Allowance deposited directly via Co-operative Society payroll';
    }
  }

  String get privacyContactHiddenNotice {
    switch (language) {
      case AppLanguage.si:
        return 'පෞද්ගලිකත්ව ආරක්ෂාව වෙනුවෙන් සේවාලාභියාගේ දුරකථන අංක සඟවා ඇත.';
      case AppLanguage.ta:
        return 'தனியுரிமை பாதுகாப்பு காரணங்களுக்காக தொடர்பு விவரங்கள் மறைக்கப்பட்டுள்ளன.';
      case AppLanguage.en:
        return 'Contact numbers are hidden for customer & member privacy.';
    }
  }

  String get contactHiddenBadge {
    switch (language) {
      case AppLanguage.si:
        return 'දුරකථන අංක රහස්‍යයි';
      case AppLanguage.ta:
        return 'தொடர்பு மறைக்கப்பட்டது';
      case AppLanguage.en:
        return 'Contact Protected';
    }
  }

  String get cancellationReasonLabel {
    switch (language) {
      case AppLanguage.si:
        return 'අවලංගු වීමට හේතුව';
      case AppLanguage.ta:
        return 'ரத்து செய்யப்பட்டதற்கான காரணம்';
      case AppLanguage.en:
        return 'Reason for Cancellation';
    }
  }

  String get rateCustomerBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සේවාලාභියා ශ්‍රේණිගත කරන්න';
      case AppLanguage.ta:
        return 'வாடிக்கையாளரை மதிப்பிடுங்கள்';
      case AppLanguage.en:
        return 'Rate Customer';
    }
  }

  String get updateRatingBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ශ්‍රේණිගත කිරීම යාවත්කාලීන කරන්න';
      case AppLanguage.ta:
        return 'மதிப்பீட்டை புதுப்பிக்கவும்';
      case AppLanguage.en:
        return 'Update Rating';
    }
  }

  String get yourRatingLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබ ලබා දුන් ඇගයීම';
      case AppLanguage.ta:
        return 'உங்கள் மதிப்பீடு';
      case AppLanguage.en:
        return 'Your Rating';
    }
  }

  String get rateCustomerModalTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සේවාලාභියා හා සේවා පරිසරය ඇගයීම';
      case AppLanguage.ta:
        return 'வாடிக்கையாளர் மற்றும் சூழல் மதிப்பீடு';
      case AppLanguage.en:
        return 'Rate Customer & Environment';
    }
  }

  String get rateCustomerModalSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම රාජකාරියේදී සේවාලාභී පවුලෙන් ලැබුණු සහයෝගය සහ සේවා පරිසරය පිළිබඳව තරු සලකුණු ලබාදෙන්න.';
      case AppLanguage.ta:
        return 'இந்த பணியில் குடும்பத்தினர் வழங்கிய ஒத்துழைப்பு மற்றும் பணிச்சூழலை மதிப்பிடுங்கள்.';
      case AppLanguage.en:
        return 'Rate the family cooperation and bedside care environment for this completed duty.';
    }
  }

  String get ratingFeedbackHint {
    switch (language) {
      case AppLanguage.si:
        return 'සේවාලාභියා හෝ පරිසරය පිළිබඳ ඔබේ අදහස (විකල්පයි)...';
      case AppLanguage.ta:
        return 'உங்கள் கருத்து அல்லது அனுபவம் (விருப்பத்திற்குரியது)...';
      case AppLanguage.en:
        return 'Your feedback about the customer or care environment (optional)...';
    }
  }

  String get submitRatingBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ශ්‍රේණිගත කිරීම සුරකින්න';
      case AppLanguage.ta:
        return 'மதிப்பீட்டை சமர்ப்பிக்கவும்';
      case AppLanguage.en:
        return 'Save Rating';
    }
  }

  String get ratingSuccessSnackbar {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබේ ශ්‍රේණිගත කිරීම සාර්ථකව සටහන් විය!';
      case AppLanguage.ta:
        return 'மதிப்பீடு வெற்றிகரமாக பதிவு செய்யப்பட்டது!';
      case AppLanguage.en:
        return 'Rating submitted successfully!';
    }
  }

  String get upcomingLimitBanner {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජිකයෙකුට එකවර රඳවා ගත හැක්කේ ඉදිරි රාජකාරි 1ක් පමණි.';
      case AppLanguage.ta:
        return 'ஒரு உறுப்பினருக்கு ஒரே நேரத்தில் 1 எதிர்கால பணி மட்டுமே அனுமதிக்கப்படும்.';
      case AppLanguage.en:
        return 'Members can only queue at most 1 upcoming booking at a time.';
    }
  }

  String get noActiveShifts {
    switch (language) {
      case AppLanguage.si:
        return 'දැනට ක්‍රියාකාරී රාජකාරි කිසිවක් නැත.';
      case AppLanguage.ta:
        return 'தற்போது செயலில் உள்ள பணிகள் எதுவும் இல்லை.';
      case AppLanguage.en:
        return 'No active shifts currently.';
    }
  }

  String get noUpcomingShifts {
    switch (language) {
      case AppLanguage.si:
        return 'දැනට වෙන් කරගත් ඉදිරි රාජකාරි නැත.';
      case AppLanguage.ta:
        return 'எதிர்கால பணிகள் எதுவும் ஒதுக்கப்படவில்லை.';
      case AppLanguage.en:
        return 'No upcoming shifts queued.';
    }
  }

  String get noCanceledShifts {
    switch (language) {
      case AppLanguage.si:
        return 'අවලංගු කළ රාජකාරි කිසිවක් නැත.';
      case AppLanguage.ta:
        return 'ரத்து செய்யப்பட்ட பணிகள் எதுவும் இல்லை.';
      case AppLanguage.en:
        return 'No canceled shifts found.';
    }
  }

  String get noCompletedShifts {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ කළ රාජකාරි කිසිවක් නැත.';
      case AppLanguage.ta:
        return 'முடிக்கப்பட்ட பணிகள் எதுவும் இல்லை.';
      case AppLanguage.en:
        return 'No completed shifts yet.';
    }
  }

  String get browseDutiesBtn {
    switch (language) {
      case AppLanguage.si:
        return 'විවෘත ඇණවුම් සොයන්න';
      case AppLanguage.ta:
        return 'கோரிக்கைகளை தேடுங்கள்';
      case AppLanguage.en:
        return 'Browse Open Duties';
    }
  }

  String get mapRouteBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සිතියම';
      case AppLanguage.ta:
        return 'வரைபடம்';
      case AppLanguage.en:
        return 'Map Route';
    }
  }

  String get callFamilyBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ඇමතුමක්';
      case AppLanguage.ta:
        return 'அழைப்பு';
      case AppLanguage.en:
        return 'Call Family';
    }
  }

  String get confirmTaskBtn {
    switch (language) {
      case AppLanguage.si:
        return 'තහවුරු කර අගුළු ලන්න';
      case AppLanguage.ta:
        return 'உறுதிசெய்து பூட்டவும்';
      case AppLanguage.en:
        return 'Confirm & Lock';
    }
  }

  String get taskConfirmedLockedBadge {
    switch (language) {
      case AppLanguage.si:
        return 'තහවුරු කර අගුළු ලන ලදී';
      case AppLanguage.ta:
        return 'உறுதிசெய்யப்பட்டு பூட்டப்பட்டது';
      case AppLanguage.en:
        return 'Confirmed & Locked';
    }
  }

  String get confirmTaskDialogTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු රාජකාරිය තහවුරු කිරීම';
      case AppLanguage.ta:
        return 'பராமரிப்பு பணியை உறுதிப்படுத்துதல்';
      case AppLanguage.en:
        return 'Confirm Care Task';
    }
  }

  String get confirmTaskDialogDesc {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම සාත්තු කාර්යය සාර්ථකව අවසන් කළ බව තහවුරු කරන්න. තහවුරු කළ පසු මෙය ස්ථිරව අගුළු වැටෙන අතර නැවත සංශෝධනය කළ නොහැක.';
      case AppLanguage.ta:
        return 'இந்த பராமரிப்பு பணி வெற்றிகரமாக முடிந்தது என்பதை உறுதிப்படுத்தவும். உறுதிசெய்த பிறகு இது பூட்டப்படும், மீண்டும் மாற்ற முடியாது.';
      case AppLanguage.en:
        return 'Confirm that this care task has been successfully completed. Once confirmed, this record will be permanently locked and cannot be modified.';
    }
  }

  String get confirmAndLockAction {
    switch (language) {
      case AppLanguage.si:
        return 'තහවුරු කර අගුළු ලන්න';
      case AppLanguage.ta:
        return 'உறுதிசெய்து பூட்டவும்';
      case AppLanguage.en:
        return 'Confirm & Lock Task';
    }
  }

  String get taskAlreadyLockedNotice {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම සාත්තු කාර්යය තහවුරු කර අගුළු ලා ඇත. තවදුරටත් සංශෝධනය කළ නොහැක.';
      case AppLanguage.ta:
        return 'இந்த பராமரிப்பு பணி உறுதிசெய்யப்பட்டு பூட்டப்பட்டுள்ளது. இனி மாற்ற முடியாது.';
      case AppLanguage.en:
        return 'This care task is confirmed and locked. It cannot be altered.';
    }
  }

  String get optionalBedsideNotes {
    switch (language) {
      case AppLanguage.si:
        return 'ඇඳ අසල සාත්තු නිරීක්ෂණ සටහන් (විකල්ප)';
      case AppLanguage.ta:
        return 'படுக்கை அருகிலுள்ள மருத்துவ குறிப்புகள் (விருப்பத்தேர்வு)';
      case AppLanguage.en:
        return 'Bedside observation notes (Optional)';
    }
  }

  String get confirmedCareTasksFilter {
    switch (language) {
      case AppLanguage.si:
        return 'තහවුරු කළ';
      case AppLanguage.ta:
        return 'உறுதிப்படுத்தப்பட்டது';
      case AppLanguage.en:
        return 'Confirmed';
    }
  }

  String get carePlanSubtitle {
    switch (language) {
      case AppLanguage.si:
        return 'අද දින සාත්තු හා ඖෂධ කාලසටහන';
      case AppLanguage.ta:
        return 'இன்றைய பராமரிப்பு மற்றும் மருந்து அட்டவணை';
      case AppLanguage.en:
        return 'Today\'s Clinical Care & Medication Schedule';
    }
  }

  String get carePlanCompletionSummary {
    switch (language) {
      case AppLanguage.si:
        return 'සාත්තු සැලැස්මේ ප්‍රගතිය';
      case AppLanguage.ta:
        return 'பராமரிப்பு திட்ட முன்னேற்றம்';
      case AppLanguage.en:
        return 'Care Plan Progress';
    }
  }

  String get tapToConfirmTask {
    switch (language) {
      case AppLanguage.si:
        return 'අවසන් කළ බව තහවුරු කිරීමට ස්පර්ශ කරන්න';
      case AppLanguage.ta:
        return 'முடிந்ததை உறுதிப்படுத்த தட்டவும்';
      case AppLanguage.en:
        return 'Tap to Confirm & Lock';
    }
  }

  String get cancelBtn {
    switch (language) {
      case AppLanguage.si:
        return 'අවලංගු කරන්න';
      case AppLanguage.ta:
        return 'ரத்து செய்';
      case AppLanguage.en:
        return 'Cancel';
    }
  }

  String get addToScheduleBtn {
    switch (language) {
      case AppLanguage.si:
        return 'කාලසටහනට එක් කරන්න';
      case AppLanguage.ta:
        return 'அட்டவணையில் சேர்க்கவும்';
      case AppLanguage.en:
        return 'Add to Schedule';
    }
  }

  // --- Verification Pipeline & Member Status Strings ---

  String get verifiedMemberStatus {
    switch (language) {
      case AppLanguage.si:
        return 'සත්‍යාපිත සාමාජික තත්ත්වය';
      case AppLanguage.ta:
        return 'சரிபார்க்கப்பட்ட உறுப்பினர் நிலை';
      case AppLanguage.en:
        return 'Verified Member Status';
    }
  }

  String get memberVerificationTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සාමාජික සත්‍යාපනය';
      case AppLanguage.ta:
        return 'உறுப்பினர் சரிபார்ப்பு';
      case AppLanguage.en:
        return 'Member Verification';
    }
  }

  String verificationDocumentsApprovedCount(int approved, int percent) {
    switch (language) {
      case AppLanguage.si:
        return '$approved / 5 ලේඛන අනුමතයි ($percent%)';
      case AppLanguage.ta:
        return '$approved / 5 ஆவணங்கள் அங்கீகரிக்கப்பட்டன ($percent%)';
      case AppLanguage.en:
        return '$approved / 5 documents approved ($percent%)';
    }
  }

  String get personalDetailsAndNicTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පෞද්ගලික තොරතුරු සහ හැඳුනුම්පත';
      case AppLanguage.ta:
        return 'தனிப்பட்ட விவரங்கள் & அடையாள அட்டை';
      case AppLanguage.en:
        return 'Personal Details & National ID';
    }
  }

  String get hideDocumentsList {
    switch (language) {
      case AppLanguage.si:
        return 'ලේඛන ලැයිස්තුව සඟවන්න';
      case AppLanguage.ta:
        return 'ஆவணங்கள் பட்டியலை மறைக்கவும்';
      case AppLanguage.en:
        return 'Hide Documents List';
    }
  }

  String get viewAllDocumentsList {
    switch (language) {
      case AppLanguage.si:
        return 'සියලු ලේඛන 5 බලන්න';
      case AppLanguage.ta:
        return 'அனைத்து 5 ஆவணங்களையும் காண்க';
      case AppLanguage.en:
        return 'View All 5 Documents';
    }
  }

  String get personalDetailsLockedNotice {
    switch (language) {
      case AppLanguage.si:
        return 'ඔබගේ පෞද්ගලික තොරතුරු සහ හැඳුනුම්පත Admin විසින් පරීක්ෂා කර අනුමත කර ඇති බැවින් ආරක්ෂිතව අගුළු ලා ඇත. අවශ්‍ය නම් වෙනස් කළ හැක්කේ දුරකථන අංකය පමණි.';
      case AppLanguage.ta:
        return 'உங்கள் தனிப்பட்ட விவரங்கள் மற்றும் அடையாள அட்டை நிர்வாகியால் அங்கீகரிக்கப்பட்டு பூட்டப்பட்டுள்ளன. தேவைப்பட்டால் தொலைபேசி எண் மட்டுமே மாற்றப்படலாம்.';
      case AppLanguage.en:
        return 'Your personal details & National ID have been verified and approved by Admin. For security, only the contact phone number can be edited.';
    }
  }

  String get onlyPhoneEditableBadge {
    switch (language) {
      case AppLanguage.si:
        return 'දුරකථන අංකය පමණක් සංස්කරණය කළ හැක';
      case AppLanguage.ta:
        return 'தொலைபேசி எண் மட்டுமே திருத்தப்படலாம்';
      case AppLanguage.en:
        return 'Only phone number can be edited';
    }
  }

  String get verifiedBadgeText {
    switch (language) {
      case AppLanguage.si:
        return 'සත්‍යාපිතයි';
      case AppLanguage.ta:
        return 'சரிபார்க்கப்பட்டது';
      case AppLanguage.en:
        return 'VERIFIED';
    }
  }

  String get inactiveBadgeText {
    switch (language) {
      case AppLanguage.si:
        return 'අක්‍රියයි';
      case AppLanguage.ta:
        return 'செயலற்றது';
      case AppLanguage.en:
        return 'INACTIVE';
    }
  }

  String get nextRequiredStepLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ඊළඟට සම්පූර්ණ කළ යුතු පියවර:';
      case AppLanguage.ta:
        return 'அடுத்து முடிக்க வேண்டிய படி:';
      case AppLanguage.en:
        return 'Next required step:';
    }
  }

  String get submitDocumentBtn {
    switch (language) {
      case AppLanguage.si:
        return 'ඉදිරිපත් කරන්න';
      case AppLanguage.ta:
        return 'சமர்ப்பிக்கவும்';
      case AppLanguage.en:
        return 'Submit';
    }
  }

  String get allVerifiedComplete {
    switch (language) {
      case AppLanguage.si:
        return 'සියල්ල සම්පූර්ණයි';
      case AppLanguage.ta:
        return 'அனைத்தும் முடிந்தது';
      case AppLanguage.en:
        return 'All Verified';
    }
  }

  String get rejectionReasonLabel {
    switch (language) {
      case AppLanguage.si:
        return 'හේතුව: ';
      case AppLanguage.ta:
        return 'காரணம்: ';
      case AppLanguage.en:
        return 'Reason: ';
    }
  }

  String get sampleGuideTitle {
    switch (language) {
      case AppLanguage.si:
        return 'සම්මත නියැදි ඡායාරූපය';
      case AppLanguage.ta:
        return 'மாதிரி வழிகாட்டி புகைப்படம்';
      case AppLanguage.en:
        return 'Standard Sample Photo';
    }
  }

  String get sampleGuideDesc {
    switch (language) {
      case AppLanguage.si:
        return 'පැහැදිලි ආලෝකයක, සිනහමුසු මුහුණින් යුත් නිල ඇඳුමින් සැරසුණු සම්මත ඡායාරූපයක් එක් කරන්න.';
      case AppLanguage.ta:
        return 'நல்ல வெளிச்சத்தில், சிரித்த முகத்துடன் கூடிய தொழில்முறை புகைப்படத்தை சேர்க்கவும்.';
      case AppLanguage.en:
        return 'Upload a clear, well-lit, smiling professional photo in uniform.';
    }
  }

  String get photoReadyToSubmit {
    switch (language) {
      case AppLanguage.si:
        return 'ඡායාරූපය තෝරා ඇත (යොමු කිරීමට සූදානම්)';
      case AppLanguage.ta:
        return 'படம் தேர்ந்தெடுக்கப்பட்டது (சமர்ப்பிக்க தயார்)';
      case AppLanguage.en:
        return 'Photo Selected (Ready to Submit)';
    }
  }

  String get pleaseAddPhotoPrompt {
    switch (language) {
      case AppLanguage.si:
        return 'කරුණාකර පහතින් ඡායාරූපයක් එක් කරන්න';
      case AppLanguage.ta:
        return 'தயவுசெய்து கீழே ஒரு புகைப்படத்தைச் சேர்க்கவும்';
      case AppLanguage.en:
        return 'Please add a photo below';
    }
  }

  String get useStandardSamplePhoto {
    switch (language) {
      case AppLanguage.si:
        return 'සම්මත නියැදි ඡායාරූපය භාවිත කරන්න';
      case AppLanguage.ta:
        return 'மாதிரி தொழில்முறை படத்தை பயன்படுத்தவும்';
      case AppLanguage.en:
        return 'Use Standard Sample Photo';
    }
  }

  String get submitForAdminReview {
    switch (language) {
      case AppLanguage.si:
        return 'Admin වෙත යොමු කරන්න';
      case AppLanguage.ta:
        return 'நிர்வாகியின் பார்வைக்கு சமர்ப்பிக்கவும்';
      case AppLanguage.en:
        return 'Submit for Admin Review';
    }
  }

  String get profilePhotoSentSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'Profile ඡායාරූපය Admin අනුමැතිය සඳහා සාර්ථකව යොමු කරන ලදී!';
      case AppLanguage.ta:
        return 'சுயவிவரப் படம் நிர்வாகியின் ஒப்புதலுக்காக வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!';
      case AppLanguage.en:
        return 'Profile photo submitted for Admin review successfully!';
    }
  }

  String lockedApprovedNotice(String item) {
    switch (language) {
      case AppLanguage.si:
        return '$item අනුමත කර අගුළු ලා ඇත';
      case AppLanguage.ta:
        return '$item அங்கீகரிக்கப்பட்டு பூட்டப்பட்டுள்ளது';
      case AppLanguage.en:
        return '$item Verified & Locked';
    }
  }

  String get lockedApprovedDesc {
    switch (language) {
      case AppLanguage.si:
        return 'මෙම ලේඛනය/ඡායාරූපය Admin විසින් පරීක්ෂා කර අනුමත කර ඇති බැවින් ආරක්ෂිතව Lock කර ඇත. වෙනස් කිරීමට අවශ්‍ය නම් Admin කාර්යාලය අමතන්න.';
      case AppLanguage.ta:
        return 'இந்த ஆவணம்/புகைப்படம் நிர்வாகியால் சரிபார்க்கப்பட்டு அங்கீகரிக்கப்பட்டுள்ளதால் பாதுகாப்பாக பூட்டப்பட்டுள்ளது. மாற்ற தேவைப்பட்டால் நிர்வாகத்தை தொடர்பு கொள்ளவும்.';
      case AppLanguage.en:
        return 'This document/photo has been verified and approved by the Admin and is securely locked. To request changes, please contact the Admin office.';
    }
  }

  String get okBtn {
    switch (language) {
      case AppLanguage.si:
        return 'හරි';
      case AppLanguage.ta:
        return 'சரி';
      case AppLanguage.en:
        return 'OK';
    }
  }

  String get uploadPoliceClearanceTitle {
    switch (language) {
      case AppLanguage.si:
        return 'පොලිස් වාර්තාව යොමු කිරීම';
      case AppLanguage.ta:
        return 'காவல்துறை சான்றிதழ் சமர்ப்பித்தல்';
      case AppLanguage.en:
        return 'Upload Police Clearance';
    }
  }

  String get policeStationLabel {
    switch (language) {
      case AppLanguage.si:
        return 'පොලිස් ස්ථානය හෝ කොට්ඨාසය';
      case AppLanguage.ta:
        return 'காவல் நிலையம் அல்லது பிரிவு';
      case AppLanguage.en:
        return 'Police Station / Division';
    }
  }

  String get submitPoliceReportBtn {
    switch (language) {
      case AppLanguage.si:
        return 'පොලිස් වාර්තාව පරීක්ෂාවට යොමු කරන්න';
      case AppLanguage.ta:
        return 'காவல்துறை அறிக்கையை சமர்ப்பிக்கவும்';
      case AppLanguage.en:
        return 'Submit Police Report for Review';
    }
  }

  String get policeReportSentSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'පොලිස් වාර්තාව Admin පරීක්ෂාව සඳහා සාර්ථකව ලැබිණි!';
      case AppLanguage.ta:
        return 'காவல்துறை அறிக்கை நிர்வாகி ஆய்வுக்கு வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!';
      case AppLanguage.en:
        return 'Police clearance report submitted for Admin review successfully!';
    }
  }

  String get editProfileAndVerifyDocs {
    switch (language) {
      case AppLanguage.si:
        return 'තොරතුරු සංශෝධනය සහ ලේඛන සත්‍යාපනය';
      case AppLanguage.ta:
        return 'சுயவிவரம் திருத்தம் மற்றும் ஆவண சரிபார்ப்பு';
      case AppLanguage.en:
        return 'Edit Profile & Verify Documents';
    }
  }

  String get personalDetailsHeader {
    switch (language) {
      case AppLanguage.si:
        return 'ලියාපදිංචි පෞද්ගලික තොරතුරු';
      case AppLanguage.ta:
        return 'பதிவுசெய்யப்பட்ட தனிப்பட்ட விவரங்கள்';
      case AppLanguage.en:
        return 'Personal Details';
    }
  }

  String get fullNameFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'සම්පූර්ණ නම';
      case AppLanguage.ta:
        return 'முழு பெயர்';
      case AppLanguage.en:
        return 'Full Name';
    }
  }

  String get nicNumberFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ජාතික හැඳුනුම්පත් අංකය';
      case AppLanguage.ta:
        return 'தேசிய அடையாள அட்டை எண்';
      case AppLanguage.en:
        return 'NIC Number';
    }
  }

  String get phoneFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දුරකථන අංකය';
      case AppLanguage.ta:
        return 'தொலைபேசி எண்';
      case AppLanguage.en:
        return 'Phone Number';
    }
  }

  String get permanentAddressFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'ස්ථිර ලිපිනය';
      case AppLanguage.ta:
        return 'நிலையான முகவரி';
      case AppLanguage.en:
        return 'Permanent Address';
    }
  }

  String get districtZoneFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'දිස්ත්‍රික්කය හෝ නගරය';
      case AppLanguage.ta:
        return 'மாவட்டம் அல்லது நகரம்';
      case AppLanguage.en:
        return 'District / Zone';
    }
  }

  String get bioFieldLabel {
    switch (language) {
      case AppLanguage.si:
        return 'කෙටි විස්තරය';
      case AppLanguage.ta:
        return 'சுயவிவர குறிப்பு';
      case AppLanguage.en:
        return 'Bio';
    }
  }

  String get nicCopiesHeader {
    switch (language) {
      case AppLanguage.si:
        return 'ජාතික හැඳුනුම්පත් පිටපත්';
      case AppLanguage.ta:
        return 'தேசிய அடையாள அட்டை பிரதிகள்';
      case AppLanguage.en:
        return 'National Identity Card Copies';
    }
  }

  String get nicCopiesDesc {
    switch (language) {
      case AppLanguage.si:
        return 'හැඳුනුම්පතෙහි ඉදිරිපස සහ පසුපස පැහැදිලි ඡායාරූප ලබාගෙන මෙහි Upload කරන්න.';
      case AppLanguage.ta:
        return 'அடையாள அட்டையின் முன் மற்றும் பின் பக்கங்களின் தெளிவான புகைப்படங்களை பதிவேற்றவும்.';
      case AppLanguage.en:
        return 'Upload clear photos of both front and back sides of your National Identity Card.';
    }
  }

  String get saveChangesBtn {
    switch (language) {
      case AppLanguage.si:
        return 'වෙනස්කම් සුරකින්න';
      case AppLanguage.ta:
        return 'மாற்றங்களைச் சேமிக்கவும்';
      case AppLanguage.en:
        return 'Save Changes';
    }
  }

  String get saveAndSubmitDocsBtn {
    switch (language) {
      case AppLanguage.si:
        return 'තොරතුරු සුරැකීම සහ ලේඛන යොමු කිරීම';
      case AppLanguage.ta:
        return 'விவரங்களைச் சேமித்து ஆவணங்களைச் சமர்ப்பிக்கவும்';
      case AppLanguage.en:
        return 'Save Details & Submit Documents';
    }
  }

  String get profileAndDocsSavedSuccess {
    switch (language) {
      case AppLanguage.si:
        return 'තොරතුරු සහ හැඳුනුම්පත් පිටපත් සාර්ථකව යාවත්කාලීන විය!';
      case AppLanguage.ta:
        return 'விவரங்கள் மற்றும் அடையாள அட்டை பிரதிகள் வெற்றிகரமாக புதுப்பிக்கப்பட்டன!';
      case AppLanguage.en:
        return 'Details and identity documents updated successfully!';
    }
  }

  String get useSampleNicFrontBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සම්මත හැඳුනුම්පත් පෙරපස පිටපත යොදන්න';
      case AppLanguage.ta:
        return 'மாதிரி முன் பக்கத்தை இணைக்கவும்';
      case AppLanguage.en:
        return 'Attach Standard NIC Front Copy';
    }
  }

  String get useSampleNicBackBtn {
    switch (language) {
      case AppLanguage.si:
        return 'සම්මත හැඳුනුම්පත් පසුපස පිටපත යොදන්න';
      case AppLanguage.ta:
        return 'மாதிரி பின் பக்கத்தை இணைக்கவும்';
      case AppLanguage.en:
        return 'Attach Standard NIC Back Copy';
    }
  }

  String get readyStatus {
    switch (language) {
      case AppLanguage.si:
        return 'සූදානම්';
      case AppLanguage.ta:
        return 'தயார்';
      case AppLanguage.en:
        return 'Ready';
    }
  }

  // Face Verification Specific Strings
  String get alignFaceInOval {
    switch (language) {
      case AppLanguage.si:
        return 'මුහුණ ඉලිප්සාකාර රාමුව තුළ සමපාත කරන්න';
      case AppLanguage.ta:
        return 'முகத்தை நீள்வட்ட சட்டத்தில் சீரமைக்கவும்';
      case AppLanguage.en:
        return 'Align your face in the oval frame';
    }
  }

  String get centeringFaceAndLandmarks {
    switch (language) {
      case AppLanguage.si:
        return 'මුහුණ මධ්‍යගත කර ලක්ෂ්‍ය හඳුනාගනිමින් පවතී...';
      case AppLanguage.ta:
        return 'முகத்தை மையப்படுத்தி அடையாளங்களை கண்டறிகிறது...';
      case AppLanguage.en:
        return 'Centering face & detecting landmarks...';
    }
  }

  String get verifyingBiometricLiveness {
    switch (language) {
      case AppLanguage.si:
        return 'සජීවී බව පරීක්ෂා කෙරේ (ඇසිපිය ගසා නිශ්චලව සිටින්න)...';
      case AppLanguage.ta:
        return 'உயிருள்ள முக சரிபார்ப்பு (கண் சிமிட்டி அசையாமல் இருங்கள்)...';
      case AppLanguage.en:
        return 'Verifying biometric liveness (Blink & Hold Still)...';
    }
  }

  String get analyzingFacialSymmetry {
    switch (language) {
      case AppLanguage.si:
        return 'මුහුණේ සමමිතිකතාව සහ ගැඹුර විශ්ලේෂණය කෙරේ...';
      case AppLanguage.ta:
        return 'முக சமச்சீர் மற்றும் ஆழத்தை பகுப்பாய்வு செய்கிறது...';
      case AppLanguage.en:
        return 'Analyzing facial symmetry & contour depth...';
    }
  }

  String get biometricLivenessConfirmed {
    switch (language) {
      case AppLanguage.si:
        return 'සජීවී මුහුණු සත්‍යාපනය තහවුරු විය (99.8%)!';
      case AppLanguage.ta:
        return 'முக சரிபார்ப்பு உறுதிப்படுத்தப்பட்டது (99.8%)!';
      case AppLanguage.en:
        return 'Biometric Liveness Confirmed (99.8%)!';
    }
  }

  String get faceVerificationSuccessSent {
    switch (language) {
      case AppLanguage.si:
        return 'සජීවී මුහුණු සත්‍යාපනය සාර්ථකව Admin අනුමැතිය සඳහා යොමු කෙරිණි!';
      case AppLanguage.ta:
        return 'நேரடி முக சரிபார்ப்பு நிர்வாகி ஒப்புதலுக்கு வெற்றிகரமாக அனுப்பப்பட்டது!';
      case AppLanguage.en:
        return 'Live face verification submitted for Admin review successfully!';
    }
  }
}
