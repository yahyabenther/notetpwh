import 'package:appwrite/appwrite.dart';
import '../config/app_config.dart';

final Client client = Client()
    .setEndpoint(AppConfig.endpoint)
    .setProject(AppConfig.projectId);

final Account account = Account(client); // needed by auth_service.dart
final TablesDB tablesDB = TablesDB(client);
