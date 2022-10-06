import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final bool cancel;
  final bool? manual;
  final LatLng? position;
  final String? name;
  final String? description;

  //TODO name,description,latlong

  SearchResult({
    required this.cancel,
    this.manual = false,
    this.position,
    this.name,
    this.description,
  });

  @override
  String toString() {
    // TODO: implement toString
    return '{cancel: $cancel, manual: $manual}';
  }
}
