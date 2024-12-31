class UserModel {
  String fullName;
  String email;

  UserModel({
    required this.fullName,
    required this.email,
  });

  // Fungsi untuk mendapatkan nama depan
  String get firstName => fullName.split(' ').first;
}
