import 'package:get/get.dart';
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
                    shouldDisplay = true;
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
