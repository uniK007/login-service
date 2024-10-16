class User {
  final String email;
  final String? displayName;

  const User({
    required this.email,
    this.displayName = '',
  });
}
