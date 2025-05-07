import 'package:portafirmas_app/data/datasources/remote_data_source/api/server_api_contract.dart';

class ServerApi extends ServerApiContract {
  ServerApi({required super.dio, required super.serverLocalDataSource});

  @override
  Future<bool> isAValidServer({required String url}) async {
    try {
      return Uri.tryParse(url) != null;
    } catch (e) {
      rethrow;
    }

    // TODO: Implement this change when URL format and comprobations are set
    // try {
    //   final response = await dio.get(
    //     '${url.split('pfmovil')[0]}pfmovil/version',
    //   );

    //   int statusCode = response.statusCode ?? 0;
    //   if (statusCode < 200 || statusCode > 299) {
    //     return false;
    //   }

    //   final isValidFormat =
    //       RegExp(r'^\d+(\.\d+)*$').hasMatch(response.data.toString().trim());

    //   return isValidFormat;
    // } on DioError catch (e) {
    //   if (e.type == DioErrorType.response) {
    //     if (e.response?.statusCode == 404) {
    //       return false;
    //     }
    //   }
    //   rethrow;
    // } catch (e) {
    //   rethrow;
    // }
  }
}
