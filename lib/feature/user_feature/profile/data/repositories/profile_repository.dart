abstract class ProfileRepository {
  Future<void> updateName(String uid, String name);
  Future<void> updateLocation(String uid, String loc);
  Future<void> updatePhone(String uid, String phone);
  Future<void> updateEmail(String uid, String email);
  Future<void> changePassword(String uid, String oldP, String newP);
}
