class Profile{
  static String? username;
  static String? uid;
  static String? Email;

  static void setUsername(String newName) {
    username = newName;
  }
  static void setUid(String newUid) {
    uid = newUid;
  }
  static void setEmail(String newEmail) {
    Email = newEmail;
  }
}
class Review {
  final String text;
  final String userEmail;

  Review({required this.text, required this.userEmail});
}
