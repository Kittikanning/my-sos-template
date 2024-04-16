import 'package:flutter/material.dart';
import 'package:otp/screen/register_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Condition extends StatefulWidget {
  const Condition({Key? key}) : super(key: key);

  @override
  State<Condition> createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  late SharedPreferences _prefs;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _checkAccepted(); // เรียกตรวจสอบว่าผู้ใช้ยอมรับเงื่อนไขหรือไม่ทุกครั้งที่เปิดแอพ
  }

  Future<void> _checkAccepted() async {
    _prefs = await SharedPreferences.getInstance();
    bool? accepted = _prefs.getBool('ได้รับการยอมรับ');
    if (accepted == null || !accepted) {
      setState(() {
        _accepted = false;
      });
    } else {
      _goToNextScreen(); // หากผู้ใช้ยอมรับเงื่อนไขแล้วให้ไปยังหน้าถัดไป
    }
  }

  void _onAccept() async {
    await _prefs.setBool('ได้รับการยอมรับ', true);
    _goToNextScreen(); // หลังจากผู้ใช้ยอมรับเงื่อนไขแล้วให้ไปยังหน้าถัดไป
  }

  void _goToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เงื่อนไข'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "ข้อความข้อกำหนดและเงื่อนไขของคุณที่นี่...",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                if (!_accepted)
                  ElevatedButton(
                    onPressed: _onAccept,
                    child: Text('ยอมรับ'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
