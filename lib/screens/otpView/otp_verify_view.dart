import 'package:flutter/material.dart';
import 'package:weather_app/screens/otpView/otp_send_view.dart';

import '../../colors/colors.dart';
import '../../services/verify_otp_service.dart';

class OtpVerificationView extends StatelessWidget {
  OtpVerificationView({super.key});

  final otpController = TextEditingController();
  final service = VerifyOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> OtpSendView()));
          }, icon: Icon(Icons.arrow_back_ios)),
        ),
        backgroundColor: MyColors.blueColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Enter the OTP to activate your account",
                  style: TextStyle(
                      color: MyColors.whiteColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Column(
                children: [
                  SizedBox(
                    height: 53,
                    child: TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your otp...",
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide:
                                  const BorderSide(color: Colors.white))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await service.verifyOTP(context, otpController);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        "Verify",
                        style:
                            TextStyle(color: MyColors.whiteColor, fontSize: 16),
                      )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
