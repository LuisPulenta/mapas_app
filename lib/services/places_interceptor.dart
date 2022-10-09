import 'package:dio/dio.dart';

const accessToken2 =
    'pk.eyJ1IjoibHVpc2NiYTIiLCJhIjoiY2wxbmo5MXh5MGFrNjNrbzMwYjI0OG8ybiJ9.zmhmxxUvqmwRVyFRtUqpag';

class PlacesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'access_token': accessToken2, 'language': 'es'});

    super.onRequest(options, handler);
  }
}
