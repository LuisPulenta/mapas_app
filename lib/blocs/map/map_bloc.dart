import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/blocs/blocs.dart';
import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/models/models.dart';
import 'package:mapas_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;

  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartFollowingUserEvent>(_onStartFollowingUser);

    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);

    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }

      if (!state.isFollowingUser) return;
      if (locationState.lastKnownLocation == null) return;
      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(theme2Theme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: const Color.fromARGB(255, 18, 22, 240),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.purple,
      width: 4,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    // double tripDuration = (destination.duration / 60).floorToDouble();
    // final startMaker = await getAssetImageMarker('assets/pinazul.png');
    // final endMaker = await getNetworkImageMarker();

    int tripDuration = (destination.duration / 60).floorToDouble().toInt();
    final startMaker = await getStartCustomMarker(tripDuration, 'Mi ubicación');
    final endMaker =
        await getEndCustomMarker(kms.toInt(), destination.endPlace.text!);

    final startMarket = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMaker,
      // anchor: const Offset(0.4, 0.8),
      anchor: Offset(0.1, 1),
      // infoWindow: InfoWindow(
      //     title: 'Inicio', snippet: 'Kms: $kms - Duración: $tripDuration')
    );

    final endMarket = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMaker,
      // anchor: const Offset(0.60, 0.90),
      // infoWindow: InfoWindow(
      //     title: destination.endPlace.text,
      //     snippet: destination.endPlace.placeName)
    );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarket;
    currentMarkers['end'] = endMarket;

    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));
    // _mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
    emit(state.copyWith(isMapInitialized: true));
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
