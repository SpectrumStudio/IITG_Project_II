import 'homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MlPage extends StatefulWidget {
  final String red,green,blue,intensity;
  MlPage({Key key, @required this.red, @required this.green, @required this.blue, @required this.intensity}) : super(key: key);

  @override
  _MlPageState createState() => _MlPageState();
}

class _MlPageState extends State<MlPage> {

  var predValue = "";
  @override
  void initState() {
    super.initState();
    predValue = "click VERIFY button";
  }
  
  Future<void> predData(var red,var green, var blue, var intensity) async {
    final interpreter = await Interpreter.fromAsset('trained_model.tflite');
    var input = [
      [double.parse(red), double.parse(green), double.parse(blue), double.parse(intensity)]
    ];
    var output = List.filled(4, 0).reshape([1, 4]);
    interpreter.run(input, output);
    List<double> output_new = List<double>.from(output[0]);
    var maxValue=output_new.reduce((curr, next) => curr > next? curr: next);
    print(maxValue);
    var index=output_new.indexOf(maxValue);
    print(index);
    print(output[0]);
    var target;
    if (index==0)
      target="Blue [0.00 - 0.25]";
    else if(index==1)
      target="Violet [0.25 - 0.50]";
    else if (index==2)
      target="Pink [0.50 - 0.75]";
    else
      target="Red [0.75 - 1.00]";
    this.setState(() {
      predValue = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    String redPar=widget.red;
    String greenPar=widget.green;
    String bluePar=widget.blue;
    String intensityPar=widget.intensity;


    return Scaffold(
      appBar: AppBar(
        title: Text("Constructor — second page"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                height: 54.0,
                padding: EdgeInsets.all(12.0),
                child: Text("Data passed to this page:",
                    style: TextStyle(fontWeight: FontWeight.w700))),
            Text("Red: $redPar"),
            Text("Green: $greenPar"),
            Text("Blue: $bluePar"),
            Text("Intensity: $intensityPar"),
            ElevatedButton(
              onPressed: () {
                print("Will call the predData Function now : $redPar");
                predData(redPar,greenPar,bluePar,intensityPar);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellowAccent,
                  textStyle: TextStyle(fontSize:
                  18,)
              ),
              child: Text('Predict',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
            Text("Predicted Value: $predValue"),
          ],
        ),
      ),
    );
  }

}


