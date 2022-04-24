import 'package:image_picker_demo/pages/saveinfo.dart';
import 'package:image_picker_demo/pages/testList.dart';

import 'homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

var redPar = "", greenPar = "", bluePar = "", intensityPar = "";
var predValue = "";
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
    if (index == 0)
      target = "Blue [0.00 - 0.25]";
    else if (index == 1)
      target = "Violet [0.25 - 0.50]";
    else if (index == 2)
      target = "Pink [0.50 - 0.75]";
    else
      target = "Red [0.75 - 1.00]";
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
