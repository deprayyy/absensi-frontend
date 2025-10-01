import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api/v1",
      headers: {"Accept": "application/json"},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshed = await TokenStorage.tryRefreshToken(dio);
          if (refreshed) {
            final token = await TokenStorage.getToken();
            final retryOptions = e.requestOptions.copyWith(
              headers: {
                ...e.requestOptions.headers,
                "Authorization": "Bearer $token",
              },
            );
            final retryResponse = await dio.fetch(retryOptions);
            return handler.resolve(retryResponse);
          } else {
            await TokenStorage.clear();
            // TODO: redirect ke auth_screen kalau perlu
          }
        }
        return handler.next(e);
      },
    ));
  }
}

final apiClient = ApiClient().dio; // bisa dipanggil di mana saja
