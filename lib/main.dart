import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AudioPlayer emergencyAlarm = AudioPlayer();
  late SharedPreferences passwordUpdated;
  late Object logJson;
  bool isEmergencyAlarmOn = false;
  bool isAsteriskPressed = false;
  String password = '0000';
  String passwordInput = '';
  String notice = '';
  String wrongCount = '0';
  Color noticeColor = Colors.white;
  Map<String, dynamic> log = {
    '시간': '',
    '틀린 비밀번호': '',
  };

  @override
  void initState() {
    super.initState();
    passwordInitialization();
  }

  Future passwordInitialization() async {
    passwordUpdated = await SharedPreferences.getInstance();
    if (passwordUpdated.getString('새 비밀번호') != null) {
      password = '';
      password += passwordUpdated.getString('새 비밀번호')!;
    }
  }

  void saveNewPassword() async {
    passwordUpdated.setString('새 비밀번호', password);
    setState(() {});
  }

  void emergencyAlarmOn() async {
    isEmergencyAlarmOn = !isEmergencyAlarmOn;
    await emergencyAlarm.play(
      AssetSource('emergency_alarm.mp3'),
    );
    await emergencyAlarm.setReleaseMode(ReleaseMode.loop);
    setState(() {});
  }

  void updatePassword() {
    if (wrongCount == '0' && notice != '현재 비밀번호 입력' && notice != '새 비밀번호 입력') {
      notice = '현재 비밀번호 입력';
    }
    if (notice == '새 비밀번호 입력') {
      password = '';
      password += passwordInput;
      isAsteriskPressed = !isAsteriskPressed;
      passwordInput = '';
      notice = '';
      saveNewPassword();
    }
    if (notice == '현재 비밀번호 입력' && password == passwordInput) {
      notice = '새 비밀번호 입력';
      passwordInput = '';
    }
    if (notice == '현재 비밀번호 입력' &&
        password != passwordInput &&
        passwordInput != '') {
      asteriskPressed();
    }
    setState(() {});
  }

  void asteriskPressed() {
    isAsteriskPressed = !isAsteriskPressed;
    if (isAsteriskPressed == false && passwordInput != '') {
      if (password == passwordInput) {
        if (noticeColor == Colors.red) {
          noticeColor = Colors.white;
        }
        if (isEmergencyAlarmOn) {
          emergencyAlarm.stop();
          isEmergencyAlarmOn = !isEmergencyAlarmOn;
        }
        passwordInput = '';
        wrongCount = '0';
        notice = '';
      } else {
        if (int.parse(wrongCount) >= 3) {
          noticeColor = Colors.red;
        }
        wrongCount = (int.parse(wrongCount) + 1).toString();
        notice = '$wrongCount회 오류';
        if (int.parse(wrongCount) == 3) {
          emergencyAlarmOn();
        }
        log['시간'] = DateTime.now().toString().substring(0, 19);
        log['틀린 비밀번호'] = passwordInput;
        logJson = jsonEncode(log);
        passwordInput = '';
      }
      setState(() {});
    } else {
      setState(() {});
    }
  }

  void numberPressed(String number) {
    if (isAsteriskPressed) {
      passwordInput += number;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 24,
            top: 60,
          ),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  notice,
                  style: TextStyle(
                    fontSize: 32,
                    color: noticeColor,
                  ),
                ),
              ),
              const Flexible(
                flex: 1,
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('1');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('2');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('3');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('4');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '4',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('5');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '5',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('6');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '6',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('7');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '7',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('8');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '8',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('9');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '9',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          asteriskPressed();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '*',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          numberPressed('0');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '0',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          if (isAsteriskPressed) {
                            updatePassword();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            '#',
                            style: TextStyle(
                              color: isAsteriskPressed
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.3),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
