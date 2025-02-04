import 'dart:convert';
import 'dart:io';

/// Returns the path to the application's documents directory.
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Returns a [File] for the users.json file.
/// Adjust the folder path as needed.
Future<File> get _localFile async {
  final path = await _localPath;
  final userDataDirectory = Directory('$path/Github/FlutterApp/backend');
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

/// Checks if the password matches for the given email.
bool passwordCheck(List<dynamic> users, String email, String password) {
  for (var user in users) {
    if (user["email"] == email && user["password"] == password) {
      return true;
    }
  }
  return false;
}

/// Pure function to attempt a login using the provided credentials.
/// Returns `null` if login is successful, or an error message otherwise.
Future<String?> login(String email, String password) async {
  File userFile = await _localFile;
  // Ensure the file exists.
  await ensureFileExists(userFile);

  List<dynamic> users = [];
  // Read the file contents.
  String fileContent = await userFile.readAsString();
  if (fileContent.isNotEmpty) {
    users = json.decode(fileContent) as List<dynamic>;
  }
  if (!containsUser(users, email)) {
    return "No user associated with that email, create an account";
  } else if (!passwordCheck(users, email, password)) {
    return "Incorrect Password";
  } else {
    return null; // Login successful.
  }
}

/// Pure function to create an account using the provided credentials.
/// Returns a message indicating success or the reason for failure.
Future<String> createAccount(String email, String password) async {
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
    return "User added successfully";
  } else {
    return "User already exists";
  }
}
