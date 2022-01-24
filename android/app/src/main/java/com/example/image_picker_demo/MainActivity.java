package com.example.image_picker_demo;

import android.content.SharedPreferences;
import android.os.Bundle;

import com.chaquo.python.PyObject;
import com.chaquo.python.Python;
import com.chaquo.python.android.AndroidPlatform;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL="com.flutter.epic/epic";



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());

        if(! Python.isStarted()){
            Python.start(new AndroidPlatform(this));
        }

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if(methodCall.method.equals("Printy")){
                    SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
                    String Path = prefs.getString("flutter."+"Path", null);
                    //Python Instance
                    Python py=Python.getInstance();
                    //Python Object
                    PyObject pyobj=py.getModule("myscript");
                    //Call Main Function
                    PyObject obj=pyobj.callAttr("main",Path);
                    //result.success(obj.toString());
                    result.success(obj.toString());
                    //result.success("Hi From Java");
                }
            }
        });
    }
}
