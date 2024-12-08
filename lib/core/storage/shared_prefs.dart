import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs =
      SharedPreferences as SharedPreferences;
  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<void> clear() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
  }

  String get studentContact => _sharedPrefs.getString("student_contact") ?? "";
  String get parentContact => _sharedPrefs.getString('parents_contact') ?? '';
  String get studentEmail => _sharedPrefs.getString('student_email_id') ?? '';
  String get className => _sharedPrefs.getString("class") ?? "";
  String get studentId => _sharedPrefs.getString("user_id") ?? "";
  String get studentName => _sharedPrefs.getString("student_name") ?? "";
  String get sectionName => _sharedPrefs.getString("section_name") ?? "";
  String get rowId => _sharedPrefs.getString("row_id") ?? "";
  bool get isLoggedIn => _sharedPrefs.getBool("isLoggedIn") ?? false;
  String get loginStatus => _sharedPrefs.getString("status") ?? '';
  String get hostelName => _sharedPrefs.getString("hostel_name") ?? '';
  String get applicationNo => _sharedPrefs.getString("application_no") ?? '';
  String get enrollmentNo => _sharedPrefs.getString("enrolment_no") ?? '';
  int get notifiCount => _sharedPrefs.getInt("notifi_count") ?? 0;
  String get institutionID =>
      _sharedPrefs.getString("selectedInstitutionId") ?? "";
  String get institutionName => _sharedPrefs.getString("institutionName") ?? "";
  String get institutionShortName =>
      _sharedPrefs.getString("institutionShortName") ?? "";

  String get institutionLogo => _sharedPrefs.getString("institutionLogo") ?? "";
  String get staffLink => _sharedPrefs.getString("staffLink") ?? "";
  String get imageLink => _sharedPrefs.getString("imageLink") ?? "";
  String get api => _sharedPrefs.getString("api") ?? "";

  set loginStatus(String value) {
    _sharedPrefs.setString('status', value);
  }

  set api(String value) {
    _sharedPrefs.setString('api', value);
  }

  set institutionID(String value) {
    _sharedPrefs.setString('selectedInstitutionId', value);
  }

  set imageLink(String value) {
    _sharedPrefs.setString('imageLink', value);
  }

  set staffLink(String value) {
    _sharedPrefs.setString('staffLink', value);
  }

  set institutionLogo(String value) {
    _sharedPrefs.setString('institutionLogo', value);
  }

  set institutionName(String value) {
    _sharedPrefs.setString('institutionName', value);
  }

  set institutionShortName(String value) {
    _sharedPrefs.setString('institutionShortName', value);
  }

  set studentContact(String value) {
    _sharedPrefs.setString('student_contact', value);
  }

  set applicationNo(String value) {
    _sharedPrefs.setString('application_no', value);
  }

  set enrollmentNo(String value) {
    _sharedPrefs.setString('enrollment_no', value);
  }

  set className(String value) {
    _sharedPrefs.setString('class', value);
  }

  set hostelName(String value) {
    _sharedPrefs.setString('hostel_name', value);
  }

  set parentContact(String value) {
    _sharedPrefs.setString('parentContact', value);
  }

  set studentEmail(String value) {
    _sharedPrefs.setString('student_email_id', value);
  }

  set termName(String value) {
    _sharedPrefs.setString('term_name', value);
  }

  set sectionName(String value) {
    _sharedPrefs.setString('section_name', value);
  }

  set setStudentId(String value) {
    _sharedPrefs.setString('user_id', value);
  }

  set studentName(String value) {
    _sharedPrefs.setString('student_name', value);
  }

  set rowId(String value) {
    _sharedPrefs.setString('row_id', value);
  }

  set isLoggedIn(bool value) {
    _sharedPrefs.setBool('isLoggedIn', value); // Corrected line
  }
}
