import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio dio;
  final String baseUrl;

  ApiClient({String? baseUrl})
      : baseUrl = baseUrl ??
      const String.fromEnvironment('API_BASE_URL',
          defaultValue: 'http://10.0.2.2:8000/api'),
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ??
                const String.fromEnvironment('API_BASE_URL',
                    defaultValue: 'http://10.0.2.2:8000/api'),
            headers: {'Accept': 'application/json'},
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            validateStatus: (status) => status != null && status < 500,
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Request: ${options.method} ${options.uri}');
        print('Request Headers: ${options.headers}');
        print('Request Data: ${options.data}');
        final token = await TokenStorage.getToken();
        if (token != null && options.path != '/login') { // Jangan kirim token untuk /login
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('Error: ${e.response?.statusCode} ${e.response?.data}');
        if (e.response?.statusCode == 401) {
          final refreshed = await TokenStorage.tryRefreshToken(dio);
          if (refreshed) {
            final token = await TokenStorage.getToken();
            final retryOptions = e.requestOptions
              ..headers['Authorization'] = 'Bearer $token';
            try {
              final retryResponse = await dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            } catch (retryError) {
              return handler.next(e);
            }
          } else {
            await TokenStorage.clear();
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil('/auth', (route) => false);
            }
          }
        }
        return handler.next(e);
      },
    ));
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final apiClient = ApiClient().dio;