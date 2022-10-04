import 'package:flutter/material.dart';

class SearchResult {
  final bool cancel;
  final bool? manual;
  //TODO name,description,latlong

  SearchResult({required this.cancel, this.manual = false});

  @override
  String toString() {
    // TODO: implement toString
    return '{cancel: $cancel, manual: $manual}';
  }
}
