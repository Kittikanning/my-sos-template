import 'package:flutter/material.dart';
import 'package:otp/provider/auth_provider.dart';
import 'package:otp/screen/home_screen.dart';
import 'package:otp/screen/user_information_screen.dart';
import 'package:otp/utils/utils.dart';
import 'package:otp/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        body: SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade50),
                          child: Image.asset(
                            "assets/alert.png",
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "การยืนยัน",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "กรอก OTP ส่งไปยังหมายเลขโทรศัพท์ของคุณ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                            print(otpCode);
                          },
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: CustomButton(
                            text: "ตรวจสอบ",
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(context, otpCode!);
                              } else {
                                showSnackBar(context, "กรอกรหัส 6 หลัก");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "ไม่ได้รับรหัสใดๆ?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "ส่งรหัสใหม่อีกครั้ง",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ))));
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // ตรวจสอบว่าผู้ใช้มีอยู่ในฐานข้อมูลหรือไม่
        ap.checkExistingUser().then(
          (value) async {
            if (value == true) {
              // ผู้ใช้มีอยู่ในแอปของเราแล้ว
              ap.getDataFromFirestore().then(
                    (value) => ap.saveUserDataToSp().then(
                          (value) => ap.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                ),
                              ),
                        ),
                  );
            } else {
              // ผู้ใช้ใหม่
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInformationScreen(),
                ),
                (route) => false,
              );
            }
          },
        );
      },
      onInvalidVerificationId: () {},
      onExistingPhoneNumber: () {},
    );
  }
}
