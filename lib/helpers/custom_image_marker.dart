import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker(String asset) async {
  return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 0.5), asset);
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final resp = await Dio().get(
      'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
      options: Options(responseType: ResponseType.bytes));

  //return BitmapDescriptor.fromBytes(resp.data);

  final imageCodec = await ui.instantiateImageCodec(resp.data,
      targetHeight: 70, targetWidth: 70);
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) {
    return await getAssetImageMarker('assets/pin2azul.png');
  }
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
