import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Returns the path to the application's documents directory.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Returns a [File] for the users.json file in a user_data folder.
Future<File> get _localFile async {
  final path = await _localPath;
  final userDataDirectory = Directory('$path/user_data');
  // Ensure the directory exists.
  if (!await userDataDirectory.exists()) {
    await userDataDirectory.create(recursive: true);
  }
  return File('${userDataDirectory.path}/users.json');
}

/// Ensures that the given file exists.
Future<File> ensureFileExists(File file) async {
  if (!await file.exists()) {
    // Create an empty JSON file (initialized with an empty array).
    await file.writeAsString("[]", mode: FileMode.write);
  }
  return file;
}

/// Adds a new user to the users list and writes the updated list back to the file.
Future<void> addUser(
    File userFile, List<dynamic> users, String email, String password) async {
  users.add({
    "email": email,
    "password": password, // Ideally, hash the password before storing it.
  });
  await userFile.writeAsString(json.encode(users), mode: FileMode.write);
}

/// Checks if the users list already contains a user with the given email.
bool containsUser(List<dynamic> users, String email) {
  for (var user in users) {
    if (user["email"] == email) {
      return true;
    }
  }
  return false;
}

/// Creates an account by adding a new user only if the email does not already exist.
/// Shows confirmation messages using SnackBar.
Future<void> createAccount(
    BuildContext context, String email, String password) async {
  // Get the correct file using path_provider.
  File userFile = await _localFile;
  // Ensure the file exists.
  await ensureFileExists(userFile);

  List<dynamic> users = [];

  // Read the file contents.
  String fileContent = await userFile.readAsString();
  if (fileContent.isNotEmpty) {
    users = json.decode(fileContent) as List<dynamic>;
  }

  // Check if the user already exists.
  if (!containsUser(users, email)) {
    await addUser(userFile, users, email, password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User added successfully."),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User already exists."),
        backgroundColor: Colors.red,
      ),
    );
  }
}
