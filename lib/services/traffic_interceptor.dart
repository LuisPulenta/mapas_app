import 'package:dio/dio.dart';

const accesToken =
    'pk.eyJ1IjoibHVpc2NiYTIiLCJhIjoiY2wxbmo5MXh5MGFrNjNrbzMwYjI0OG8ybiJ9.zmhmxxUvqmwRVyFRtUqpag';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accesToken,
    });

    super.onRequest(options, handler);
  }
}
