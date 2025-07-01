class AuthService {
  Future<bool> authenticate(String username, String password) async {
    // TODO: replace with your real authentication logic
    await Future.delayed(Duration(seconds: 1));
    return username == 'doctor' && password == 'password';
  }
}
