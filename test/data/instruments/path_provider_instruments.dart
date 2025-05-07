import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class PathProviderPlatformMock extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return './test/data/instruments/mock_app_documents/folder';
  }
}
