import 'package:portafirmas_app/data/datasources/remote_data_source/api/portafirma_api_base.dart';

abstract class ServerApiContract extends PortafirmaApiBase {
  ServerApiContract({required super.dio, required super.serverLocalDataSource});

  Future<bool> isAValidServer({required String url});
}
