import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mapas_app/helpers/helpers.dart';

class ManualMarket extends StatelessWidget {
  const ManualMarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => state.displayManualMarker
            ? const _ManualMarketBody()
            : const SizedBox());
  }
}

//-----------------------------------------------------
//-------------------- _ManualMarketBody --------------
//-----------------------------------------------------

class _ManualMarketBody extends StatelessWidget {
  const _ManualMarketBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(
            top: 40,
            left: 20,
            child: _BtnBack(),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                  minWidth: size.width - 140,
                  child: const Text(
                    'Confirmar Destino',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  color: const Color.fromARGB(255, 18, 22, 240),
                  elevation: 0,
                  height: 40,
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    //TODO: loading

                    final start = locationBloc.state.lastKnownLocation;
                    if (start == null) return;

                    final end = mapBloc.mapCenter;
                    if (end == null) return;

                    showLoadingMessage(context);

                    final destination =
                        await searchBloc.getCoorsStartToEnd(start, end);
                    await mapBloc.drawRoutePolyline(destination);
                    searchBloc.add(OnDeActivateManualMarkerEvent());
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 20,
        backgroundColor: const Color.fromARGB(255, 18, 22, 240),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            BlocProvider.of<SearchBloc>(context)
                .add(OnDeActivateManualMarkerEvent());
          },
        ),
      ),
    );
  }
}
