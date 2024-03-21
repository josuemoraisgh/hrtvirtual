import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hrtvirtual/src/modules/home/home_controller.dart';

double typeSpace(double maxWidth) {
  const tamDesejado = 500.0;
  return ((maxWidth - tamDesejado) > 0 ? (maxWidth - tamDesejado) / 2 : 0);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double tam = typeSpace(constraints.maxWidth);
          return Container(
            padding:
                EdgeInsets.only(left: tam, top: 10, right: tam, bottom: 10),
            width: constraints.maxWidth,
            color: Colors.white,
            //child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: 200, //     <-- TextField expands to this height.
                child: TextField(
                  readOnly: true,
                  controller: controller.textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Set this
                  expands: true, // and this
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Log de Eventos',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
