import 'package:get/get.dart';
import 'dart:io';
import 'dart:core';
import 'dart:ui';
import 'package:image_picker_demo/pages/saveinfo.dart';
import 'package:image_picker_demo/pages/testList.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:gauges/gauges.dart';

var redPar = "", greenPar = "", bluePar = "", intensityPar = "";
var predValue = "";
var pointerValue = 0.00;
bool shouldDisplay = false;
var gaugeAno = "";

class MlPage extends StatefulWidget {
  final String red, green, blue, intensity;
  MlPage(
      {Key? key,
      required this.red,
      required this.green,
      required this.blue,
      required this.intensity})
      : super(key: key);

  @override
  _MlPageState createState() => _MlPageState();
}

class _MlPageState extends State<MlPage> {
  @override
  void initState() {
    shouldDisplay = false;
    pointerValue = 0.00;
    gaugeAno = "";
    super.initState();
    predValue = "click Predict button to predict the result";
  }

  Future<void> predData(var red, var green, var blue, var intensity) async {
    final interpreter = await Interpreter.fromAsset('trained_model.tflite');
    var input = [
      [
        double.parse(red),
        double.parse(green),
        double.parse(blue),
        double.parse(intensity)
      ]
    ];
    var output = List.filled(4, 0).reshape([1, 4]);
    interpreter.run(input, output);
    List<double> output_new = List<double>.from(output[0]);
    var maxValue = output_new.reduce((curr, next) => curr > next ? curr : next);
    print(maxValue);
    var index = output_new.indexOf(maxValue);
    print(index);
    print(output[0]);
    var target;
    if (index == 0) {
      pointerValue = 0.125;
      gaugeAno = "Blue";
      target = "Blue [0.00 - 0.25]";
    } else if (index == 1) {
      pointerValue = 0.375;
      gaugeAno = "Violet";
      target = "Violet [0.25 - 0.50]";
    } else if (index == 2) {
      gaugeAno = "Pink";
      pointerValue = 0.625;
      target = "Pink [0.50 - 0.75]";
    } else {
      pointerValue = 0.875;
      gaugeAno = "Red";
      target = "Red [0.75 - 1.00]";
    }
    this.setState(() {
      predValue = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    redPar = widget.red;
    greenPar = widget.green;
    bluePar = widget.blue;
    intensityPar = widget.intensity;

    return Scaffold(
      body: Stack(
          //padding: EdgeInsets.all(12.0),
          //alignment: Alignment.center,
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //left: 20,
              //right: 20,
              left: 130,
              top: Get.height * 0.17,
              child: Container(
                //height: MediaQuery.of(context).size.height,
                //width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/flask.png'),
                    //fit: BoxFit.fill,
                  ),
                  //shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 24.0,
                      spreadRadius: 16.0,
                      color: Colors.black.withOpacity(0.2))
                ]),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8.0,
                      sigmaY: 8.0,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white.withOpacity(0.3),
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text("Concentration Predictor",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Red: $redPar", style: TextStyle(fontSize: 16)),
                          Text("Green: $greenPar",
                              style: TextStyle(fontSize: 16)),
                          Text("Blue: $bluePar",
                              style: TextStyle(fontSize: 16)),
                          Text("Intensity: $intensityPar",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  shouldDisplay = true;
                                });
                                print(
                                    "Will call the predData Function now : $redPar");
                                predData(
                                    redPar, greenPar, bluePar, intensityPar);
                              },
                              child: Text(
                                "PREDICT",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "Predicted Value: ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Text(
                                predValue,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: 250,
                            width: 250,
                            child: SfRadialGauge(
                              enableLoadingAnimation: true,
                              animationDuration: 2500,
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 1,
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      animationType: AnimationType.easeOutBack,
                                      value: pointerValue,
                                      enableAnimation: true,
                                    )
                                  ],
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 0.25,
                                      color: Color.fromARGB(255, 1, 214, 214),
                                    ),
                                    GaugeRange(
                                      startValue: 0.25,
                                      endValue: 0.5,
                                      color: Color.fromARGB(255, 133, 2, 255),
                                    ),
                                    GaugeRange(
                                      startValue: 0.5,
                                      endValue: 0.75,
                                      color: Color.fromARGB(255, 234, 0, 255),
                                    ),
                                    GaugeRange(
                                      startValue: 0.75,
                                      endValue: 1,
                                      color: Color.fromARGB(255, 255, 59, 59),
                                    )
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Text(
                                        gaugeAno,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      positionFactor: 0.7,
                                      angle: 90,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          if (shouldDisplay == true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SaveInfo(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(fontSize: 18),
                                      )),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        redPar = "";
                                        greenPar = "";
                                        bluePar = "";
                                        intensityPar = "";
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, a, b) =>
                                                  TestList(),
                                              transitionDuration:
                                                  Duration(seconds: 0),
                                            ),
                                            (route) => false);
                                      },
                                      child: Text(
                                        'HOME',
                                        style: TextStyle(fontSize: 18),
                                      )),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
