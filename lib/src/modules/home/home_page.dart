import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hrtvirtual/src/modules/home/home_controller.dart';

import '../../base_widget/custom_button.dart';

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
  bool connected = false;

  @override
  void initState() {
    super.initState();
    controller.hrtComm.port = controller.hrtComm.availablePorts[0];
  }

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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                          value: controller.hrtComm.port,
                          onChanged:
                              controller.connectNotifier.value == "CONNECTED"
                                  ? null
                                  : (String? novoItemSelecionado) {
                                      if (novoItemSelecionado != null) {
                                        controller.hrtComm.port =
                                            novoItemSelecionado;
                                        setState(() {});
                                      }
                                    },
                          underline: Container(),
                          iconEnabledColor: Colors.black,
                          dropdownColor:
                              Theme.of(context).colorScheme.background,
                          focusColor: Theme.of(context).colorScheme.background,
                          selectedItemBuilder: (BuildContext context) {
                            return controller.hrtComm.availablePorts
                                .map((String value) {
                                  return Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  );
                                })
                                .toList()
                                .cast<Widget>();
                          },
                          items: controller.hrtComm.availablePorts
                              .map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              })
                              .toList()
                              .cast<DropdownMenuItem<String>>(),
                        ),
                      ),
                      CustomButton(
                        title: "CONNECTED",
                        titleOff: "DISCONNECTED",
                        initialValue: "DISCONNECTED",
                        groupValue: controller.connectNotifier,
                        onChanged: (e) {
                          if (e == 'CONNECTED') {
                            controller.hrtComm.connect();
                          } else {
                            controller.hrtComm.disconnect();
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Command: "),
                      SizedBox(
                        width: 100, //
                        height: 35,
                        child: TextField(
                          textAlign: TextAlign.justify,
                          controller: controller.commandController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      CustomButton(
                        title: "SEND",
                        initialValue: "",
                        groupValue: controller.sendNotifier,
                        onChanged: controller.connectNotifier.value ==
                                "CONNECTED"
                            ? (e) {
                                controller.masterMode(
                                    controller.commandController.text);
                                Future.delayed(const Duration(seconds: 1)).then(
                                  (value) {
                                    controller.sendNotifier.value =
                                        controller.sendNotifier.value == "SEND"
                                            ? ""
                                            : "SEND";
                                    controller.commandController.text = "";
                                  },
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
