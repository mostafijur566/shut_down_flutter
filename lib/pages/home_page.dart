import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'package:process_run/shell.dart';
import 'package:shut_down_flutter/style/size_config.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../components/clock.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var setTime = TimeOfDay.now();
  var totalSeconds = 0;
  var totalHour = 0;
  var totalMinute = 0;
  bool shutDown = false;

  TimeOfDay _timeOfDay = TimeOfDay.now();

  Future<void> _shutDownPc() async{
    var shell = Shell();

    await shell.run('shutdown -s -t 5');
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
      if(shutDown == true){
        if(_timeOfDay == setTime){
          _shutDownPc();
          shutDown = false;
        }
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }



  void _showTimePicker(){
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
      setState(() {
        setTime = value!;
        calculateDifference('${TimeOfDay.now().hour}:${TimeOfDay.now().minute}', '${value.hour}:${value.minute}');
        shutDown = true;
      });
    });
  }

  void calculateDifference(String time1, String time2){
    var minute = 0;
    var hour = 0;

    if(int.parse(time2.split(":")[0]) > int.parse(time1.split(":")[0])){
      if(int.parse(time2.split(":")[1]) < int.parse(time1.split(":")[1])){
        minute = (int.parse(time2.split(":")[1]) + 60) - int.parse(time1.split(":")[1]);
        hour = ((int.parse(time2.split(":")[0]) - 1)) - int.parse(time1.split(":")[0]);
      }
      else{
        minute = int.parse(time2.split(":")[1]) - int.parse(time1.split(":")[1]);
        hour = int.parse(time2.split(":")[0]) - int.parse(time1.split(":")[0]);
      }
    }

    else if(int.parse(time2.split(":")[0]) < int.parse(time1.split(":")[0])){
      if(int.parse(time1.split(":")[1]) < int.parse(time2.split(":")[1])){
        minute = (int.parse(time1.split(":")[1]) + 60) - int.parse(time2.split(":")[1]);
        hour = ((int.parse(time1.split(":")[0]) - 1)) - int.parse(time2.split(":")[0]);
      }
      else{
        minute = int.parse(time1.split(":")[1]) - int.parse(time2.split(":")[1]);
        hour = int.parse(time1.split(":")[0]) - int.parse(time2.split(":")[0]);
      }
    }

    else if(int.parse(time2.split(":")[0]) == int.parse(time1.split(":")[0])){

      if(int.parse(time2.split(":")[1]) < int.parse(time1.split(":")[1])){
        minute = int.parse(time1.split(":")[1]) - int.parse(time2.split(":")[1]);
      }
      else{
        minute = int.parse(time2.split(":")[1]) - int.parse(time1.split(":")[1]);
      }
    }

    setState(() {
      totalSeconds = (hour * 60 * 60) + minute * 60;
      totalHour = hour;
      totalMinute = minute;
    });
    print("$hour : $minute");
  }

  @override
  Widget build(BuildContext context) {

    String _period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    var minute = _timeOfDay.minute.toString();
    if(minute.length != 2){
      minute = "0${_timeOfDay.minute.toString()}";
    }

    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // if you use _timeOfDay.hour then it will show 20:10 like that
                  // But we want 8:10
                  "${_timeOfDay.hourOfPeriod}:${minute}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(width: 5),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    _period,
                    style: TextStyle(fontSize: getProportionateScreenWidth(18)),
                  ),
                ),
              ],
            ),
            Spacer(),
            Clock(),
            Spacer(),
            totalSeconds == 0 ? Container() : SlideCountdownSeparated(
              duration: Duration(seconds: totalSeconds),
              separatorType: SeparatorType.title,
              slideDirection: SlideDirection.up,
                textStyle: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold, fontSize: 25),
              height: 50,
              width: 50,
              separatorStyle: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Color(0xFF222225),
              ),
            ),
            Spacer(),
            // MaterialButton(onPressed: _showTimePicker,
            //   padding: EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 20),
            //   child: Text('Set Time', style: TextStyle(fontSize: 25),),
            //   color: Color(0xFF4e4e4e),
            // ),
            GestureDetector(
              onTap: _showTimePicker,
              child: Container(
                child: Text('Set Time', style: TextStyle(fontSize: 25),),
                padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF4e4e4e),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
