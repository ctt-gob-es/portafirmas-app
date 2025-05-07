import 'package:emm/emm.dart';
import 'package:portafirmas_app/data/datasources/remote_data_source/api/server_api_contract.dart';
import 'package:portafirmas_app/data/repositories/data_source_contracts/remote/server_remote_data_source_contract.dart';
import 'package:portafirmas_app/domain/models/server_entity.dart';

class ServerRemoteDataSource implements ServerRemoteDataSourceContract {
  final ServerApiContract _api;
  final Emm _emm;

  ServerRemoteDataSource(this._api, this._emm);

  @override
  Future<bool> isAValidServer({required String url}) async {
    final isValid = await _api.isAValidServer(url: url);

    return isValid;
  }

  @override
  Future<ServerEntity?> getEmmServer() async {
    final data = await _emm.getRestrictions();
    if (data.isEmpty) return null;

    try {
      return ServerEntity(
        alias: data['alias'] as String,
        url: data['proxy'] as String,
        isFixed: data['fixed'] as bool? ?? false,
        databaseIndex: 10000,
        isDefault: false,
        isFromEmm: true,
      );
    } catch (_) {
      return null;
    }
  }
}
