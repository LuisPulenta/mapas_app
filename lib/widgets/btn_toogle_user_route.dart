import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';

class BtnToogleUserRoute extends StatelessWidget {
  const BtnToogleUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 18, 22, 240),
          maxRadius: 25,
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              mapBloc.add(OnToggleUserRoute());
            },
          )),
    );
  }
}
