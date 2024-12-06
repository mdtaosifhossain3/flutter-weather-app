import 'package:flutter/material.dart';

import '../../colors/colors.dart';
import '../../services/send_otp_service.dart';
import '../../widgets/button_widget.dart';

class OtpSendView extends StatelessWidget {
  OtpSendView({super.key});
  final controller = TextEditingController();
  final service = SendOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blueColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //-----------------------Logo-----------------------
            Column(
              children: [
                Image.asset(
                  "assets/images/weather_icon.png", // Replace with your image asset path
                  height: 150.0,
                ),
              ],
            ),

            Column(
              children: [
                //-----------------------Register-----------------------
                SizedBox(
                  height: 53,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        fillColor: MyColors.whiteColor,
                        filled: true,
                        hintText: "Enter your phone number...",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: MyColors.blackColor.withOpacity(0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                BorderSide(color: MyColors.whiteColor))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await service.sendOTP(context, controller);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        color: MyColors.blackColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: ButtonWidget(
                      label: "Submit",
                      bgcolor: MyColors.blackColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
