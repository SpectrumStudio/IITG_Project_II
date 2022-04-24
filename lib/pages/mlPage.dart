import 'package:image_picker_demo/pages/saveinfo.dart';
import 'package:image_picker_demo/pages/testList.dart';

import 'homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:gauges/gauges.dart';

var redPar = "", greenPar = "", bluePar = "", intensityPar = "";
var predValue = "";
var pointerValue = 0.00;
bool shouldDisplay = false;

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
      target = "Blue [0.00 - 0.25]";
    } else if (index == 1) {
      pointerValue = 0.375;
      target = "Violet [0.25 - 0.50]";
    } else if (index == 2) {
      pointerValue = 0.625;
      target = "Pink [0.50 - 0.75]";
    } else {
      pointerValue = 0.875;
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
      // appBar: AppBar(
      //   title: Text("Constructor — second page"),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        //alignment: Alignment.center,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Data passed to this page:", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 30,
              ),
              Text("Red: $redPar"),
              Text("Green: $greenPar"),
              Text("Blue: $bluePar"),
              Text("Intensity: $intensityPar"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    shouldDisplay = !shouldDisplay;
                  });
                  print("Will call the predData Function now : $redPar");
                  predData(redPar, greenPar, bluePar, intensityPar);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.yellowAccent,
                    textStyle: TextStyle(
                      fontSize: 18,
                    )),
                child: Text(
                  'Predict',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "Predicted Value: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    predValue,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              RadialGauge(
                axes: [
                  RadialGaugeAxis(
                    pointers: [
                      RadialNeedlePointer(
                        value: pointerValue,
                        thicknessStart: 20,
                        thicknessEnd: 0,
                        length: 0.6,
                        knobRadiusAbsolute: 10,
                        //gradient: LinearGradient(...),
                      )
                    ],
                    color: Colors.transparent,
                    // ...
                    minValue: 0,
                    maxValue: 1,
                    minAngle: -90,
                    maxAngle: 90,
                    segments: [
                      RadialGaugeSegment(
                        minValue: 0,
                        maxValue: 0.25,
                        minAngle: -90,
                        maxAngle: -45,
                        color: Colors.blue,
                      ),
                      RadialGaugeSegment(
                        minValue: 0.25,
                        maxValue: 0.5,
                        minAngle: -45,
                        maxAngle: -0,
                        color: Color.fromARGB(255, 211, 98, 255),
                      ),
                      RadialGaugeSegment(
                        minValue: 0.5,
                        maxValue: 0.75,
                        minAngle: 0,
                        maxAngle: 45,
                        color: Color.fromARGB(255, 235, 1, 203),
                      ),
                      RadialGaugeSegment(
                        minValue: 0.75,
                        maxValue: 1,
                        minAngle: 45,
                        maxAngle: 90,
                        color: Color.fromARGB(255, 255, 3, 66),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: 50,
              // ),
              if (shouldDisplay == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaveInfo(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ),
                        child: Text(
                          'SAVE',
                          style: TextStyle(fontSize: 18),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          redPar = "";
                          greenPar = "";
                          bluePar = "";
                          intensityPar = "";
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) => TestList(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ),
                        child: Text(
                          'HOME',
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
