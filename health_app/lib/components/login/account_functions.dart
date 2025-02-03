import 'dart:convert';
import 'dart:io';

/// Checks whether an account with the provided email already exists.
/// Returns true if the account exists, false otherwise.
Future<bool> checkAccount(String email, String password) async {
  final file = File('lib/user_data/news.json');
  if (!await file.exists()) {
    return false;
  }
  final content = await file.readAsString();
  if (content.trim().isEmpty) {
    return false;
  }
  final Map<String, dynamic> data = json.decode(content);
  final List<dynamic> users = data['users'] ?? [];

  for (var user in users) {
    if (user['email'] == email) {
      return true;
    }
  }
  return false;
}

/// Creates an account by appending the new user (with email and password)
/// to the JSON file. If the account already exists, it prints an error message.
Future<void> createAccount(String email, String password) async {
  if (await checkAccount(email, password)) {
    print("Error: Account exists");
  } else {
    final file = File('lib/user_data/news.json');
    Map<String, dynamic> data;
    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        data = {'users': []};
      } else {
        data = json.decode(content);
      }
    } else {
      data = {'users': []};
    }
    final Map<String, dynamic> newUser = {
      'email': email,
      'password': password,
      // Optionally add more fields, e.g. 'profile_picture'
    };
    final List<dynamic> users = data['users'] ?? [];
    users.add(newUser);
    data['users'] = users;
    await file.writeAsString(json.encode(data), flush: true);
    print("Account created successfully");
  }
}
