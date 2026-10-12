class AppConfig {
  static const endpoint =
      String.fromEnvironment('APPWRITE_ENDPOINT');

  static const projectId =
      String.fromEnvironment('APPWRITE_PROJECT_ID');

  static const databaseId =
      String.fromEnvironment('APPWRITE_DATABASE_ID');

  static const tableId =
      String.fromEnvironment('APPWRITE_TABLE_ID');

  static void validate() {
    if (endpoint.isEmpty ||
        projectId.isEmpty ||
        databaseId.isEmpty ||
        tableId.isEmpty) {
      throw StateError(
        'Missing Appwrite configuration. '
        'Run with --dart-define-from-file=env.json',
      );
    }
  }
}