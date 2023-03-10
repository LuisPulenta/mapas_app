import 'package:dio/dio.dart';

const accessToken2 =
    'pk.eyJ1IjoibHVpc2NiYTIiLCJhIjoiY2wxbmo5MXh5MGFrNjNrbzMwYjI0OG8ybiJ9.zmhmxxUvqmwRVyFRtUqpag';

class PlacesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'language': 'es', 'access_token': accessToken2});

    super.onRequest(options, handler);
  }
}
