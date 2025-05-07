import 'package:portafirmas_app/domain/models/server_entity.dart';

abstract class ServerRemoteDataSourceContract {
  Future<bool> isAValidServer({required String url});
  Future<ServerEntity?> getEmmServer();
}
